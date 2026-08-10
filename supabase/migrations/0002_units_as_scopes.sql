-- ═════════════════════════════════════════════════════════════
-- 0002 — units become scopes of their own
--
--   0001 modelled a unit as a row inside a community: it needed a community,
--   it had a single owner, and a "house" was a text column on the apartment.
--   That cannot express the product: a family runs "House 223" with no OSBB
--   around it, adds relatives to it, and those relatives are full users.
--
--   So a unit gets what a community already has — an invite code, its own
--   member table, its own admin — and gains a parent, so a house can own the
--   apartments inside it.
-- ═════════════════════════════════════════════════════════════

-- A standalone object is most often a private house. Added first and left
-- unused in this migration on purpose: Postgres forbids using a new enum value
-- in the same transaction that introduces it.
alter type unit_type add value if not exists 'house';

-- Who may live in an object. A tenant reads everything but does not vote at the
-- assembly — that right follows ownership, so the distinction is structural.
create type unit_role as enum ('owner', 'family', 'tenant');

-- ─────────────────────────────────────────────────────────────
-- Invite codes
--   One generator for both scopes: join_by_invite() takes a single code and
--   works out what it opens, which only holds if codes never collide across
--   communities and units.
-- ─────────────────────────────────────────────────────────────
create or replace function public.generate_invite_code()
returns text language plpgsql security definer set search_path = public as $$
declare
  v_code text;
begin
  loop
    v_code := substr(
      upper(translate(encode(gen_random_bytes(9), 'base64'), '+/=', '')), 1, 8
    );
    exit when length(v_code) >= 6
      and not exists (select 1 from communities where invite_code = v_code)
      and not exists (select 1 from units       where invite_code = v_code);
  end loop;
  return v_code;
end $$;

-- ─────────────────────────────────────────────────────────────
-- units — reshaped
-- ─────────────────────────────────────────────────────────────
alter table units alter column community_id drop not null;

-- A child inherits its parent's community, so membership checks never have to
-- walk the tree: create_unit() copies it down on insert.
alter table units add column parent_id uuid references units(id) on delete cascade;

alter table units add column address    text;
alter table units add column city       text;
alter table units add column area_m2    numeric(10, 2);
alter table units add column created_by uuid references auth.users(id) on delete restrict;

-- `building` described the house in text; the house is now an object with a
-- parent. `owner_member_id` pointed at community_members, which a standalone
-- object has none of — ownership lives in unit_members now.
alter table units drop column building;
alter table units drop column owner_member_id;

alter table units add column invite_code text;
update units set invite_code = public.generate_invite_code() where invite_code is null;
alter table units alter column invite_code set not null;
create unique index units_invite_code_key on units(invite_code);

create index units_parent_idx on units(parent_id);

-- ─────────────────────────────────────────────────────────────
-- unit_members
--   Deliberately mirrors community_members — same statuses, same pending flow,
--   same "no direct INSERT policy" rule — so both scopes behave identically.
-- ─────────────────────────────────────────────────────────────
create table unit_members (
  id         uuid primary key default gen_random_uuid(),
  unit_id    uuid not null references units(id) on delete cascade,
  user_id    uuid not null references auth.users(id) on delete cascade,
  role       unit_role     not null default 'family',
  status     member_status not null default 'pending',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (unit_id, user_id)
);
create index unit_members_unit_idx on unit_members(unit_id);
create index unit_members_user_idx on unit_members(user_id);
create trigger unit_members_set_updated_at
  before update on unit_members
  for each row execute function set_updated_at();

-- ─────────────────────────────────────────────────────────────
-- Membership predicates (SECURITY DEFINER → bypass RLS, no recursion)
--   An admin of the owning community always counts: they manage the objects in
--   their community without being a resident of any of them.
-- ─────────────────────────────────────────────────────────────
create or replace function public.is_unit_member(uid uuid)
returns boolean language sql security definer stable set search_path = public as $$
  select exists (
    select 1 from unit_members m
    where m.unit_id = uid and m.user_id = auth.uid() and m.status = 'active'
  ) or exists (
    select 1 from units u
    where u.id = uid
      and u.community_id is not null
      and public.is_community_admin(u.community_id)
  );
$$;

create or replace function public.is_unit_owner(uid uuid)
returns boolean language sql security definer stable set search_path = public as $$
  select exists (
    select 1 from unit_members m
    where m.unit_id = uid and m.user_id = auth.uid()
      and m.status = 'active' and m.role = 'owner'
  ) or exists (
    select 1 from units u
    where u.id = uid
      and u.community_id is not null
      and public.is_community_admin(u.community_id)
  );
$$;

-- ═════════════════════════════════════════════════════════════
-- Bootstrap RPCs
--   Error codes are custom SQLSTATEs rather than message text: the Dart mapper
--   matches on the code, so rewording a message never breaks the UI.
--     DV001 — invite code does not exist
--     DV002 — caller may not do this
--     DV003 — not authenticated
-- ═════════════════════════════════════════════════════════════
create or replace function public.create_community(
  p_name    text,
  p_type    community_type default 'osbb',
  p_address text default null,
  p_city    text default null
) returns communities
language plpgsql security definer set search_path = public as $$
declare
  v_community communities;
begin
  if auth.uid() is null then
    raise exception 'not authenticated' using errcode = 'DV003';
  end if;

  insert into communities (name, type, address, city, invite_code, created_by)
  values (p_name, p_type, p_address, p_city,
          public.generate_invite_code(), auth.uid())
  returning * into v_community;

  insert into community_members (community_id, user_id, role, status)
  values (v_community.id, auth.uid(), 'admin', 'active');

  return v_community;
end $$;

-- Creates a house, apartment, plot or garage and makes the caller its owner.
--
-- Three shapes, decided by what the caller passes:
--   parent given     → a unit inside another unit; inherits its community
--   community given  → a top-level unit in a community (admins only)
--   neither          → a standalone object belonging to nobody but the caller
create or replace function public.create_unit(
  p_label        text,
  p_type         unit_type default 'apartment',
  p_parent_id    uuid    default null,
  p_community_id uuid    default null,
  p_address      text    default null,
  p_city         text    default null,
  p_area_m2      numeric default null
) returns units
language plpgsql security definer set search_path = public as $$
declare
  v_parent       units;
  v_community_id uuid;
  v_unit         units;
begin
  if auth.uid() is null then
    raise exception 'not authenticated' using errcode = 'DV003';
  end if;

  if p_parent_id is not null then
    select * into v_parent from units where id = p_parent_id;
    if v_parent.id is null then
      raise exception 'parent unit not found' using errcode = 'DV001';
    end if;
    if not public.is_unit_owner(v_parent.id) then
      raise exception 'not allowed to add to this unit' using errcode = 'DV002';
    end if;
    -- Copied down rather than looked up later: see units.parent_id.
    v_community_id := v_parent.community_id;

  elsif p_community_id is not null then
    if not public.is_community_admin(p_community_id) then
      raise exception 'not a community admin' using errcode = 'DV002';
    end if;
    v_community_id := p_community_id;
  end if;

  insert into units (
    community_id, parent_id, type, label,
    address, city, area_m2, invite_code, created_by
  )
  values (
    v_community_id, p_parent_id, p_type, p_label,
    p_address, p_city, p_area_m2, public.generate_invite_code(), auth.uid()
  )
  returning * into v_unit;

  insert into unit_members (unit_id, user_id, role, status)
  values (v_unit.id, auth.uid(), 'owner', 'active');

  return v_unit;
end $$;

-- One code, one field, either scope. The caller never says which kind of code
-- they hold — the app cannot know, and asking would leak what the code opens.
--
-- Returns jsonb because the two branches return different row types:
--   {"scope": "community" | "unit", "membership": {...}}
drop function if exists public.join_by_invite(text);

create or replace function public.join_by_invite(p_invite_code text)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  -- Codes are stored uppercase; people type them off a screenshot.
  v_code         text := upper(btrim(p_invite_code));
  v_community_id uuid;
  v_unit_id      uuid;
  v_member       community_members;
  v_resident     unit_members;
begin
  if auth.uid() is null then
    raise exception 'not authenticated' using errcode = 'DV003';
  end if;

  select id into v_community_id from communities where invite_code = v_code;
  if v_community_id is not null then
    -- Idempotent: re-joining returns the existing row without resetting status,
    -- so a second tap cannot undo a rejection.
    insert into community_members (community_id, user_id, role, status)
    values (v_community_id, auth.uid(), 'member', 'pending')
    on conflict (community_id, user_id)
      do update set updated_at = community_members.updated_at
    returning * into v_member;

    return jsonb_build_object(
      'scope', 'community', 'membership', to_jsonb(v_member)
    );
  end if;

  select id into v_unit_id from units where invite_code = v_code;
  if v_unit_id is not null then
    insert into unit_members (unit_id, user_id, role, status)
    values (v_unit_id, auth.uid(), 'family', 'pending')
    on conflict (unit_id, user_id)
      do update set updated_at = unit_members.updated_at
    returning * into v_resident;

    return jsonb_build_object(
      'scope', 'unit', 'membership', to_jsonb(v_resident)
    );
  end if;

  raise exception 'invalid invite code' using errcode = 'DV001';
end $$;

-- ═════════════════════════════════════════════════════════════
-- Row Level Security
-- ═════════════════════════════════════════════════════════════
alter table unit_members enable row level security;

-- units — the 0001 policies assumed a community; a standalone object has none.
drop policy "units select for members" on units;
drop policy "units write for admins"  on units;

create policy "units select for members" on units
  for select using (
    public.is_unit_member(id)
    or (community_id is not null and public.is_community_member(community_id))
  );
create policy "units insert via rpc only" on units
  for insert with check (false);
create policy "units update for owners" on units
  for update using (public.is_unit_owner(id))
  with check (public.is_unit_owner(id));
create policy "units delete for owners" on units
  for delete using (public.is_unit_owner(id));

-- unit_members — INSERT is intentionally absent, mirroring community_members:
-- only the SECURITY DEFINER RPCs may add rows, or anyone could self-appoint as
-- owner of someone else's house.
create policy "unit members select own or same unit" on unit_members
  for select using (user_id = auth.uid() or public.is_unit_member(unit_id));
create policy "unit members manage by owner" on unit_members
  for update using (public.is_unit_owner(unit_id))
  with check (public.is_unit_owner(unit_id));
create policy "unit members delete by owner" on unit_members
  for delete using (public.is_unit_owner(unit_id));
