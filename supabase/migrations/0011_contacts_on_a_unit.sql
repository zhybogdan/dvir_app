-- ═════════════════════════════════════════════════════════════
-- 0011 — a household keeps its own telephone numbers
--
--   `contacts` was written in 0001 for a community: the chairperson, the
--   accountant, the emergency line an OSBB publishes to its residents. A house
--   standing on its own has a list too, and it is a different list — "my
--   electrician", "my plumber", the gas service — kept beside the house they
--   serve rather than in one person's phone, where nobody else in the family
--   can reach it.
--
--   The shape is the one 0010 gave `documents`, deliberately unchanged:
--   community_id stays, unit_id joins it, and a check makes exactly one of them
--   the answer. Every table that has to serve both scopes now looks the same,
--   which is what keeps the two products one codebase.
--
--   Nothing in the app reads this table yet — no repository, no screen.
-- ═════════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────────
-- Scope
-- ─────────────────────────────────────────────────────────────
alter table contacts alter column community_id drop not null;

alter table contacts
  add column unit_id uuid references units(id) on delete cascade;

alter table contacts add constraint contacts_one_scope
  check (num_nonnulls(community_id, unit_id) = 1);

-- The community index from 0001 stays; this is its counterpart. Sorted by name
-- rather than by time, because that is how the list is read: a person looks for
-- "electrician", not for whoever was added last.
create index contacts_unit_idx on contacts(unit_id, name);

-- ═════════════════════════════════════════════════════════════
-- Row Level Security
--
--   The two policies from 0001 become four, split the way 0008 and 0010 split
--   theirs: reading is wide, writing is narrow. A tenant needs the plumber's
--   number as much as anyone; a tenant does not curate the household's list.
--
--   Both predicates answer false for a null id — they are `exists(...)`, not
--   comparisons — so `or` behaves for a row carrying only one scope, which the
--   check constraint guarantees is every row.
-- ═════════════════════════════════════════════════════════════
drop policy if exists "contacts select for members" on contacts;
drop policy if exists "contacts write for admins"   on contacts;

create policy "contacts select for members" on contacts
  for select using (
    public.is_community_member(community_id) or public.is_unit_member(unit_id)
  );

create policy "contacts insert for writers" on contacts
  for insert with check (
    public.is_community_admin(community_id) or public.is_unit_keeper(unit_id)
  );

-- The check covers the row as it will be, so moving a contact to another scope
-- requires the right to write in that one too.
create policy "contacts update for writers" on contacts
  for update using (
    public.is_community_admin(community_id) or public.is_unit_keeper(unit_id)
  )
  with check (
    public.is_community_admin(community_id) or public.is_unit_keeper(unit_id)
  );

create policy "contacts delete for writers" on contacts
  for delete using (
    public.is_community_admin(community_id) or public.is_unit_keeper(unit_id)
  );
