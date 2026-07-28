-- ═════════════════════════════════════════════════════════════
-- 0007 — a request can be taken back
--
--   Deleting a membership row was for the people who run the scope: an admin
--   or an owner, and never their own row. That left the applicant with no way
--   out of a request at all — a code typed one character wrong put them on the
--   waiting screen for good, with nothing to do but sign out.
--
--   Delete policies are permissive and OR together, so this adds the case
--   without touching the moderators' one.
--
--   Only `pending` is withdrawable. `rejected` and `blocked` stay exactly where
--   they are: letting someone clear their own row would turn a block into an
--   inconvenience, since the next thing they can do is apply again.
-- ═════════════════════════════════════════════════════════════

create policy "members withdraw own request" on community_members
  for delete using (user_id = auth.uid() and status = 'pending');

create policy "unit members withdraw own request" on unit_members
  for delete using (user_id = auth.uid() and status = 'pending');
