-- ═════════════════════════════════════════════════════════════
-- 0009 — the keeper decides the order of the record
--
--   `position` has been filled in by an insert trigger since 0008, so facts
--   stand in the order they were written. That is not the order they are read
--   in: what the object shows first — year built, plot area — is rarely
--   what its keeper happened to type first.
--
--   Reordering is one call that rewrites the positions of the whole object,
--   not a row-by-row update. A drag moves one row but changes the place of
--   every row after it, and doing that as N updates from the client means N
--   round trips, a half-applied order if one of them fails, and two people
--   dragging at once interleaving into an order neither chose.
-- ═════════════════════════════════════════════════════════════

-- SECURITY DEFINER bypasses RLS, so the write rule is checked here by hand —
-- exactly the same predicate the policies use. Without this line the function
-- would be a way around the policies rather than an operation under them.
--
-- `p_ids` is the full list of the object's facts in their new order. Ids that
-- do not belong to this object are ignored rather than rejected: the `unit_id`
-- in the join is what makes passing a neighbour's row a no-op instead of a way
-- to reach into their record.
create or replace function public.reorder_unit_attributes(
  p_unit_id uuid,
  p_ids     uuid[]
)
returns void language plpgsql security definer set search_path = public as $$
begin
  if not public.is_unit_keeper(p_unit_id) then
    raise exception 'not allowed' using errcode = 'DV002';
  end if;

  update unit_attributes a
     set position = ordered.place - 1
    from unnest(p_ids) with ordinality as ordered(id, place)
   where a.id = ordered.id
     and a.unit_id = p_unit_id;
end $$;
