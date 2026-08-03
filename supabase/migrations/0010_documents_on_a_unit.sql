-- ═════════════════════════════════════════════════════════════
-- 0010 — a document belongs to a scope, and a house is a scope
--
--   `documents` was written in 0001 for a community and only a community:
--   community_id is not null, so a house standing outside any ОСББ has
--   nowhere to put the scan of its техпаспорт. The record an object keeps of
--   itself (0008) is text; this is the paper that proves it.
--
--   The shape is the one Phase 4 predicted for every table that has to serve
--   both scopes: community_id stays, unit_id joins it, and a check makes
--   exactly one of them the answer. Two nullable columns left to trust would
--   admit a row belonging to both scopes or to neither — a row whose RLS
--   answer is undefined. The database refuses it instead.
--
--   Nothing in the app reads this table yet: it has no repository and no
--   screen, which is why the column rename below costs nothing.
-- ═════════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────────
-- Scope
-- ─────────────────────────────────────────────────────────────
alter table documents alter column community_id drop not null;

alter table documents
  add column unit_id uuid references units(id) on delete cascade;

alter table documents add constraint documents_one_scope
  check (num_nonnulls(community_id, unit_id) = 1);

-- The community index from 0001 stays as it is; this is its counterpart for
-- the other scope. Both lists are read the same way — one scope, newest first.
create index documents_unit_idx on documents(unit_id, created_at desc);

-- ─────────────────────────────────────────────────────────────
-- What the row says about its file
--
--   `file_url` is the wrong name for what is stored. A URL is a provider's
--   answer, not a fact about the file, and a private bucket has no permanent
--   URL at all — every read is a signed link that expires within the hour.
--
--   The path is derivable from the ids, so keeping it looks redundant. It is
--   kept anyway: the day the layout changes — a year folder, a move off
--   Supabase — a derived path makes every old row unreadable, while a stored
--   one makes it a data migration. The row knows where its file is; nothing
--   else has to know the convention.
--
--   original_name because the storage key is a uuid and "Договір_газ_2019.pdf"
--   is what a person recognises. mime_type and size_bytes so a list can render
--   "PDF · 2,4 МБ" without touching Storage at all.
-- ─────────────────────────────────────────────────────────────
alter table documents rename column file_url to storage_path;

alter table documents add column mime_type     text;
alter table documents add column size_bytes    bigint;
alter table documents add column original_name text;

-- ═════════════════════════════════════════════════════════════
-- Row Level Security
--
--   The two policies from 0001 are replaced by four, split the way 0008 split
--   the record: reading is wide, writing is narrow. A tenant sees the house's
--   papers; a tenant does not file them.
--
--   is_community_member(null) and is_unit_member(null) both return false — the
--   predicates are `exists(...)`, not comparisons — so `or` behaves for a row
--   that carries only one scope, which the check constraint guarantees is
--   every row.
-- ═════════════════════════════════════════════════════════════
drop policy if exists "documents select for members" on documents;
drop policy if exists "documents write for admins"   on documents;

create policy "documents select for members" on documents
  for select using (
    public.is_community_member(community_id) or public.is_unit_member(unit_id)
  );

create policy "documents insert for writers" on documents
  for insert with check (
    public.is_community_admin(community_id) or public.is_unit_keeper(unit_id)
  );

-- The check covers the row as it will be, so moving a document to another
-- scope requires the right to write in that one too.
create policy "documents update for writers" on documents
  for update using (
    public.is_community_admin(community_id) or public.is_unit_keeper(unit_id)
  )
  with check (
    public.is_community_admin(community_id) or public.is_unit_keeper(unit_id)
  );

create policy "documents delete for writers" on documents
  for delete using (
    public.is_community_admin(community_id) or public.is_unit_keeper(unit_id)
  );

-- ═════════════════════════════════════════════════════════════
-- Storage
--
--   Path convention, unchanged in shape from 0001:
--
--     documents/<scope_id>/<document_id>.<ext>
--
--   The obvious move — prefixing paths with `c/` and `u/` to tell the scopes
--   apart — would break these policies loudly rather than quietly: `'u'::uuid`
--   raises, and a raise inside a policy is an error, not a `false`, so every
--   read of the bucket would start failing for everyone. It is not needed
--   either: community ids and unit ids are both uuids and never collide, so
--   the first segment is simply whichever scope owns the file.
--
--   One bucket rather than a parallel `unit-documents`: two buckets means
--   every later change to how files are stored has to be made twice, and a
--   rule that drifts between them is a leak.
--
--   Known and accepted: deleting a unit cascades these rows but not the
--   objects in the bucket — Storage has no foreign key. The repository deletes
--   both halves on a normal delete; a sweeper for the rest is its own task.
-- ═════════════════════════════════════════════════════════════
drop policy if exists "storage documents read for members"   on storage.objects;
drop policy if exists "storage documents write for admins"   on storage.objects;
drop policy if exists "storage documents update for admins"  on storage.objects;
drop policy if exists "storage documents delete for admins"  on storage.objects;

create policy "storage documents read for members" on storage.objects
  for select using (
    bucket_id = 'documents'
    and (
      public.is_community_member(((storage.foldername(name))[1])::uuid)
      or public.is_unit_member(((storage.foldername(name))[1])::uuid)
    )
  );

create policy "storage documents write for writers" on storage.objects
  for insert with check (
    bucket_id = 'documents'
    and (
      public.is_community_admin(((storage.foldername(name))[1])::uuid)
      or public.is_unit_keeper(((storage.foldername(name))[1])::uuid)
    )
  );

create policy "storage documents update for writers" on storage.objects
  for update using (
    bucket_id = 'documents'
    and (
      public.is_community_admin(((storage.foldername(name))[1])::uuid)
      or public.is_unit_keeper(((storage.foldername(name))[1])::uuid)
    )
  );

create policy "storage documents delete for writers" on storage.objects
  for delete using (
    bucket_id = 'documents'
    and (
      public.is_community_admin(((storage.foldername(name))[1])::uuid)
      or public.is_unit_keeper(((storage.foldername(name))[1])::uuid)
    )
  );

-- ─────────────────────────────────────────────────────────────
-- What the bucket accepts
--
--   Both limits belong here rather than in the picker: a client-side check is
--   a courtesy message, the bucket is the rule. 20 MB fits a multi-page scan
--   and keeps one careless file from taking 2% of the free tier's gigabyte.
--
--   Images arrive compressed from the device (1600 px / JPEG 80, ~400 KB
--   instead of ~4 MB), which is the difference between a few hundred photos in
--   that gigabyte and a few thousand.
-- ─────────────────────────────────────────────────────────────
update storage.buckets set
  file_size_limit    = 20971520,  -- 20 MB
  allowed_mime_types = array[
    'application/pdf',
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/heic'
  ]
where id = 'documents';
