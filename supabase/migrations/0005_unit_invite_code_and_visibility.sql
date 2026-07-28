-- ═════════════════════════════════════════════════════════════
-- 0005 — an object's invite code belongs to its owner
--
--   Two holes in who can see what inside `units`, both left by 0002.
--
--   1. `invite_code` is a column of the row, and every SELECT policy returns
--      whole rows. So anyone who can see an object can read the code that lets
--      people ask to join it — a tenant, a grandchild, and (before the change
--      below) every neighbour in the same community. The code is meant to be
--      something the owner hands out.
--   2. `units select for members` let *any* active member of a community read
--      *every* object in it. A resident has no use for the roster of flats,
--      and the app is being built around a single object first, so the rule
--      would only have sat there waiting to leak something.
--
--   The first needs column privileges rather than a policy: RLS filters rows,
--   and this is a column.
-- ═════════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────────
-- invite_code is no longer readable off the row
--   A table-level grant covers every column, including ones added later, so it
--   has to be revoked and re-granted column by column.
--
--   The cost of that is a maintenance rule: **a column added to `units` from
--   now on must be added to this grant**, or it will silently not be readable.
--   That is the trade for keeping the code out of an ordinary read.
-- ─────────────────────────────────────────────────────────────
revoke select on public.units from anon, authenticated;

grant select (
  id, community_id, parent_id, type, label,
  address, city, entrance, floor, area_m2,
  created_by, created_at, updated_at
) on public.units to anon, authenticated;

-- The owner's way back to the code. SECURITY DEFINER, so the function reads a
-- column its caller cannot — which is the whole point.
--
-- is_unit_owner() also answers true for an admin of the owning community; an
-- object inside a community is theirs to manage, invite code included.
create or replace function public.unit_invite_code(p_unit_id uuid)
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

  select invite_code into v_code from units where id = p_unit_id;

  return v_code;
end $$;

-- ─────────────────────────────────────────────────────────────
-- Who sees an object at all
--   Three ways in, and no fourth:
--     · I belong to it                      — my flat, my house
--     · I belong to its parent              — my house, so the flats inside it
--     · I am an admin of its community      — folded into is_unit_member()
--
--   The middle one is not optional: an owner is a member of their house, not
--   of the flats they created inside it, so without it their own objects would
--   disappear from the hub.
-- ─────────────────────────────────────────────────────────────
drop policy "units select for members" on units;

create policy "units select for members" on units
  for select using (
    public.is_unit_member(id)
    or (parent_id is not null and public.is_unit_member(parent_id))
  );

-- Grants changed, so PostgREST has to re-read the schema before it will serve
-- the new column list.
notify pgrst, 'reload schema';
