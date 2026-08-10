-- ═════════════════════════════════════════════════════════════
-- 0008 — an object keeps a record of itself
--
--   `units` describes an object the way the system needs it: a label, a type,
--   an address, an area it charges by. What the keeper of a house actually
--   wants written down is none of that — number of floors, year built, wall
--   material, plot area — and no fixed set of columns is going to be the right
--   one, because every household records something else.
--
--   So the facts get a table of their own rather than a json column on `units`,
--   for three reasons in order of weight:
--
--     1. Writing one fact into a blob rewrites all of them. Two people editing
--        different facts at the same time means the second silently erases the
--        first. A row is edited by itself.
--     2. Only an owner may update `units` (0002), so facts kept there would be
--        closed to a `family` member. A table of its own lets the rule be
--        chosen — see is_unit_keeper() below.
--     3. A row carries its own position; keys in a blob have no order.
-- ═════════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────────
-- Who keeps the record
--   is_unit_member() is everyone attached to the object, tenants included, and
--   that is the right rule for *reading* — a tenant should see what the house
--   is made of. Writing is narrower: a tenant keeps no records about property
--   that is not theirs, the same reasoning that denies them a vote (0002).
--
--   Deliberately not folded into is_unit_owner(): the whole point of a separate
--   table was that `family` writes too.
--
--   Loosening this later is one line here and no data migration, which is why
--   it starts closed — the reverse is not true.
-- ─────────────────────────────────────────────────────────────
create or replace function public.is_unit_keeper(uid uuid)
returns boolean language sql security definer stable set search_path = public as $$
  select exists (
    select 1 from unit_members m
    where m.unit_id = uid and m.user_id = auth.uid()
      and m.status = 'active' and m.role in ('owner', 'family')
  ) or exists (
    select 1 from units u
    where u.id = uid
      and u.community_id is not null
      and public.is_community_admin(u.community_id)
  );
$$;

-- ─────────────────────────────────────────────────────────────
-- unit_attributes
-- ─────────────────────────────────────────────────────────────
create table unit_attributes (
  id         uuid primary key default gen_random_uuid(),
  unit_id    uuid not null references units(id) on delete cascade,
  name       text not null,
  value      text not null,
  position   int  not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- One index for both jobs: the list is always read by object and always in the
-- keeper's order.
create index unit_attributes_unit_idx on unit_attributes(unit_id, position);

create trigger unit_attributes_set_updated_at
  before update on unit_attributes
  for each row execute function set_updated_at();

-- ─────────────────────────────────────────────────────────────
-- Order
--   The client never sends a position. Two devices adding a fact at the same
--   moment would both compute the same "max + 1" and one of them would be
--   wrong; computed here, the second insert sees the first.
--
--   There is no unique(unit_id, position) on purpose. Reordering violates it
--   halfway through the statement unless the constraint is deferred, which buys
--   nothing: a duplicate position breaks nothing as long as reads sort by
--   (position, created_at), which makes the order deterministic anyway.
-- ─────────────────────────────────────────────────────────────
create or replace function public.set_unit_attribute_position()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  select coalesce(max(position) + 1, 0) into new.position
  from unit_attributes where unit_id = new.unit_id;
  return new;
end $$;

create trigger unit_attributes_set_position
  before insert on unit_attributes
  for each row execute function public.set_unit_attribute_position();

-- ═════════════════════════════════════════════════════════════
-- Row Level Security
-- ═════════════════════════════════════════════════════════════
alter table unit_attributes enable row level security;

create policy "unit attributes select for members" on unit_attributes
  for select using (public.is_unit_member(unit_id));

create policy "unit attributes insert for keepers" on unit_attributes
  for insert with check (public.is_unit_keeper(unit_id));

-- The check covers the row as it will be, so moving a fact to another object
-- requires being a keeper of that one too.
create policy "unit attributes update for keepers" on unit_attributes
  for update using (public.is_unit_keeper(unit_id))
  with check (public.is_unit_keeper(unit_id));

create policy "unit attributes delete for keepers" on unit_attributes
  for delete using (public.is_unit_keeper(unit_id));
