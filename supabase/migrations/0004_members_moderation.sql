-- ═════════════════════════════════════════════════════════════
-- 0004 — moderating who belongs where
--
--   Phase 4 turns a membership row into something a human acts on: an admin
--   approves a join request, an owner attaches a relative to their house.
--   Three things stand in the way of that, and the last one is a hole.
--
--   1. A member row points at auth.users, so there is no relationship
--      PostgREST can follow to the profile — a members list cannot show a
--      single name without a second round trip and a manual join in Dart.
--   2. Profiles are visible to active co-members of a community and to nobody
--      else. The two people that rule excludes are exactly the ones Phase 4 is
--      about: an applicant who is still `pending`, and a housemate in a
--      standalone object, which has no community to share.
--   3. `units update for owners` checks who owns the row, not which columns
--      are being written.
--
--   Error codes continue the list from 0002 — the Dart mapper matches on the
--   code, so rewording an exception never changes what the user is told:
--     DV001 — invite code does not exist
--     DV002 — caller may not do this (also stands in for "no such row")
--     DV003 — not authenticated
--     DV004 — the scope would be left with no admin / no owner
--     DV005 — a moderator may not change their own status
-- ═════════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────────
-- Member rows point at profiles as well
--   profiles.id *is* auth.users.id, so this constraint adds no new value —
--   it adds the relationship PostgREST needs to embed `profiles(...)` in a
--   member query.
-- ─────────────────────────────────────────────────────────────
alter table community_members
  add constraint community_members_profile_fkey
  foreign key (user_id) references profiles(id) on delete cascade;

alter table unit_members
  add constraint unit_members_profile_fkey
  foreign key (user_id) references profiles(id) on delete cascade;

-- ─────────────────────────────────────────────────────────────
-- Who may read whose profile
-- ─────────────────────────────────────────────────────────────

-- The unit counterpart of shares_community_with(): residents of one object see
-- each other. A standalone house has no community, so without this the owner
-- cannot read the name of anyone they let in — including their own family.
create or replace function public.shares_unit_with(other uuid)
returns boolean language sql security definer stable set search_path = public as $$
  select exists (
    select 1
    from unit_members me
    join unit_members them on them.unit_id = me.unit_id
    where me.user_id = auth.uid() and me.status = 'active'
      and them.user_id = other   and them.status = 'active'
  );
$$;

-- True if the caller runs a scope this user has a row in — a community they
-- admin, or an object they own. Deciding on a join request means reading who
-- is asking, and the shares_* predicates deliberately refuse that: both sides
-- must be active, which an applicant is not.
create or replace function public.can_moderate_user(other uuid)
returns boolean language sql security definer stable set search_path = public as $$
  select exists (
    select 1 from community_members m
    where m.user_id = other and public.is_community_admin(m.community_id)
  ) or exists (
    select 1 from unit_members m
    where m.user_id = other and public.is_unit_owner(m.unit_id)
  );
$$;

drop policy "profiles select self or co-member" on profiles;

create policy "profiles select self, co-member or applicant" on profiles
  for select using (
    id = auth.uid()
    or public.shares_community_with(id)
    or public.shares_unit_with(id)
    or public.can_moderate_user(id)
  );

-- ─────────────────────────────────────────────────────────────
-- A scope always keeps someone who can run it
--   Enforced on the table rather than inside the moderation RPCs below: a
--   policy-level UPDATE reaches the row without passing through them.
--
--   DELETE needs no trigger. The policy already admits only an active
--   admin/owner, and now refuses their own row — so whoever ran the delete is
--   still there afterwards. A trigger would additionally have to tell a real
--   deletion apart from the cascade that fires when a whole community is
--   dropped, which turns on visibility rules too subtle to rest an invariant
--   on.
--
--   SECURITY DEFINER on both guards: they count the *other* admins, and a
--   count taken under RLS could come back short and refuse a legitimate
--   change.
-- ─────────────────────────────────────────────────────────────
create or replace function public.guard_last_community_admin()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  if old.role = 'admin' and old.status = 'active'
     and not (new.role = 'admin' and new.status = 'active')
     and not exists (
       select 1 from community_members m
       where m.community_id = old.community_id
         and m.id <> old.id
         and m.role = 'admin'
         and m.status = 'active'
     )
  then
    raise exception 'community would be left without an admin'
      using errcode = 'DV004';
  end if;

  return new;
end $$;

create trigger community_members_guard_last_admin
  before update on community_members
  for each row execute function public.guard_last_community_admin();

create or replace function public.guard_last_unit_owner()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  if old.role = 'owner' and old.status = 'active'
     and not (new.role = 'owner' and new.status = 'active')
     and not exists (
       select 1 from unit_members m
       where m.unit_id = old.unit_id
         and m.id <> old.id
         and m.role = 'owner'
         and m.status = 'active'
     )
  then
    raise exception 'object would be left without an owner'
      using errcode = 'DV004';
  end if;

  return new;
end $$;

create trigger unit_members_guard_last_owner
  before update on unit_members
  for each row execute function public.guard_last_unit_owner();

drop policy "members delete by admin" on community_members;
create policy "members delete by admin" on community_members
  for delete using (
    public.is_community_admin(community_id) and user_id <> auth.uid()
  );

-- The community-admin half of is_unit_owner() is not excluded here: an admin
-- with no row in the object can still remove its last owner. That is the power
-- model 0002 already granted them — they manage every object in their
-- community — and the object stays manageable through them afterwards.
drop policy "unit members delete by owner" on unit_members;
create policy "unit members delete by owner" on unit_members
  for delete using (
    public.is_unit_owner(unit_id) and user_id <> auth.uid()
  );

-- ═════════════════════════════════════════════════════════════
-- Moderation RPCs
--   Status and role move through functions rather than a direct UPDATE, so the
--   rules live next to each other instead of being spread over a policy, and
--   so the app gets a code it can turn into a sentence.
-- ═════════════════════════════════════════════════════════════
create or replace function public.set_community_member_status(
  p_member_id uuid,
  p_status    member_status
) returns community_members
language plpgsql security definer set search_path = public as $$
declare
  v_member community_members;
begin
  if auth.uid() is null then
    raise exception 'not authenticated' using errcode = 'DV003';
  end if;

  select * into v_member from community_members where id = p_member_id;

  -- One code for "no such row" and "not yours" on purpose: telling them apart
  -- confirms that a membership exists to someone with no right to know.
  if v_member.id is null
     or not public.is_community_admin(v_member.community_id) then
    raise exception 'not allowed to moderate this member' using errcode = 'DV002';
  end if;

  if v_member.user_id = auth.uid() then
    raise exception 'cannot change your own status' using errcode = 'DV005';
  end if;

  update community_members set status = p_status
   where id = p_member_id
  returning * into v_member;

  return v_member;
end $$;

-- Unlike status, a role may be changed on yourself: a chairperson handing the
-- community over stops being an admin. guard_last_community_admin() is what
-- stops the last one from doing it.
create or replace function public.set_community_member_role(
  p_member_id uuid,
  p_role      member_role
) returns community_members
language plpgsql security definer set search_path = public as $$
declare
  v_member community_members;
begin
  if auth.uid() is null then
    raise exception 'not authenticated' using errcode = 'DV003';
  end if;

  select * into v_member from community_members where id = p_member_id;

  if v_member.id is null
     or not public.is_community_admin(v_member.community_id) then
    raise exception 'not allowed to moderate this member' using errcode = 'DV002';
  end if;

  update community_members set role = p_role
   where id = p_member_id
  returning * into v_member;

  return v_member;
end $$;

create or replace function public.set_unit_member_status(
  p_member_id uuid,
  p_status    member_status
) returns unit_members
language plpgsql security definer set search_path = public as $$
declare
  v_member unit_members;
begin
  if auth.uid() is null then
    raise exception 'not authenticated' using errcode = 'DV003';
  end if;

  select * into v_member from unit_members where id = p_member_id;

  if v_member.id is null or not public.is_unit_owner(v_member.unit_id) then
    raise exception 'not allowed to moderate this resident' using errcode = 'DV002';
  end if;

  if v_member.user_id = auth.uid() then
    raise exception 'cannot change your own status' using errcode = 'DV005';
  end if;

  update unit_members set status = p_status
   where id = p_member_id
  returning * into v_member;

  return v_member;
end $$;

create or replace function public.set_unit_member_role(
  p_member_id uuid,
  p_role      unit_role
) returns unit_members
language plpgsql security definer set search_path = public as $$
declare
  v_member unit_members;
begin
  if auth.uid() is null then
    raise exception 'not authenticated' using errcode = 'DV003';
  end if;

  select * into v_member from unit_members where id = p_member_id;

  if v_member.id is null or not public.is_unit_owner(v_member.unit_id) then
    raise exception 'not allowed to moderate this resident' using errcode = 'DV002';
  end if;

  update unit_members set role = p_role
   where id = p_member_id
  returning * into v_member;

  return v_member;
end $$;

-- ═════════════════════════════════════════════════════════════
-- units — structural columns are not editable
--   `units update for owners` asks who owns the row, never what is being
--   written, so an owner could set community_id to any community and have
--   their object appear inside it uninvited, or reparent it under someone
--   else's house. Ownership of the *target* is what should be checked, and a
--   policy on this row cannot see it.
--
--   Editing what an object actually is — label, address, city, area, floor,
--   entrance — stays a plain UPDATE under the existing policy.
--
--   The escape hatch is a transaction-local setting rather than a second
--   privileged path: rotate_unit_invite_code() opens it below, and the
--   deferred attach-to-community flow will reuse it.
-- ═════════════════════════════════════════════════════════════
create or replace function public.guard_unit_structure()
returns trigger language plpgsql set search_path = public as $$
begin
  if current_setting('dvir.allow_structural_change', true) = 'on' then
    return new;
  end if;

  if new.community_id is distinct from old.community_id
     or new.parent_id   is distinct from old.parent_id
     or new.invite_code is distinct from old.invite_code
     or new.created_by  is distinct from old.created_by
  then
    raise exception 'structural columns are managed by RPCs'
      using errcode = 'DV002';
  end if;

  return new;
end $$;

create trigger units_guard_structure
  before update on units
  for each row execute function public.guard_unit_structure();

-- ─────────────────────────────────────────────────────────────
-- Rotating an invite code
--   A code generated once and never changed cannot be taken back: it lands in
--   a Viber chat, the chat outlives the people in it, and the code still
--   admits whoever kept it.
-- ─────────────────────────────────────────────────────────────
create or replace function public.rotate_community_invite_code(p_community_id uuid)
returns text
language plpgsql security definer set search_path = public as $$
declare
  v_code text;
begin
  if auth.uid() is null then
    raise exception 'not authenticated' using errcode = 'DV003';
  end if;
  if not public.is_community_admin(p_community_id) then
    raise exception 'not a community admin' using errcode = 'DV002';
  end if;

  update communities set invite_code = public.generate_invite_code()
   where id = p_community_id
  returning invite_code into v_code;

  return v_code;
end $$;

create or replace function public.rotate_unit_invite_code(p_unit_id uuid)
returns text
language plpgsql security definer set search_path = public as $$
declare
  v_code text;
begin
  if auth.uid() is null then
    raise exception 'not authenticated' using errcode = 'DV003';
  end if;
  if not public.is_unit_owner(p_unit_id) then
    raise exception 'not an object owner' using errcode = 'DV002';
  end if;

  -- Local to this transaction, so the freeze is back on the moment the RPC
  -- returns.
  perform set_config('dvir.allow_structural_change', 'on', true);

  update units set invite_code = public.generate_invite_code()
   where id = p_unit_id
  returning invite_code into v_code;

  return v_code;
end $$;
