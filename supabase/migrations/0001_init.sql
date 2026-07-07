-- Dvir — initial schema (MVP)
-- Multi-tenant: every row is scoped by community_id; RLS isolates each community.
-- A user's relation to a community lives in community_members (role + status),
-- so RLS resolves membership through SECURITY DEFINER helper functions to avoid
-- policies that recurse into the table they guard.
-- Timestamps are timestamptz (UTC); the app renders them in local time.

-- ─────────────────────────────────────────────────────────────
-- Extensions
-- ─────────────────────────────────────────────────────────────
create extension if not exists "pgcrypto";   -- gen_random_uuid(), gen_random_bytes()

-- ─────────────────────────────────────────────────────────────
-- Enums
-- ─────────────────────────────────────────────────────────────
create type community_type as enum (
  'osbb', 'residential_complex', 'dacha_cooperative',
  'garage_cooperative', 'cottage_town', 'dormitory', 'custom'
);
create type unit_type as enum (
  'apartment', 'plot', 'garage', 'office', 'custom'
);
create type member_role   as enum ('admin', 'member', 'accountant', 'worker');
create type member_status as enum ('pending', 'active', 'rejected', 'blocked');
create type announcement_category as enum (
  'general', 'emergency', 'repair', 'meeting', 'finance', 'utilities', 'security'
);
create type request_category as enum (
  'plumbing', 'electricity', 'cleaning', 'security', 'yard', 'building', 'other'
);
create type request_status as enum (
  'new', 'in_progress', 'waiting', 'completed', 'rejected'
);

-- ─────────────────────────────────────────────────────────────
-- Shared updated_at trigger
-- ─────────────────────────────────────────────────────────────
create or replace function set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

-- ─────────────────────────────────────────────────────────────
-- profiles  (one row per auth user)
-- ─────────────────────────────────────────────────────────────
create table profiles (
  id         uuid primary key references auth.users(id) on delete cascade,
  full_name  text,
  phone      text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Auto-create a profile row whenever a new auth user signs up.
create or replace function handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id) values (new.id)
  on conflict (id) do nothing;
  return new;
end $$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function handle_new_user();

create trigger profiles_set_updated_at
  before update on profiles
  for each row execute function set_updated_at();

-- ─────────────────────────────────────────────────────────────
-- communities
-- ─────────────────────────────────────────────────────────────
create table communities (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  type        community_type not null default 'osbb',
  address     text,
  city        text,
  invite_code text not null unique,
  created_by  uuid not null references auth.users(id) on delete restrict,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);
create trigger communities_set_updated_at
  before update on communities
  for each row execute function set_updated_at();

-- ─────────────────────────────────────────────────────────────
-- community_members  (pivot: which user belongs to which community)
-- ─────────────────────────────────────────────────────────────
create table community_members (
  id           uuid primary key default gen_random_uuid(),
  community_id uuid not null references communities(id) on delete cascade,
  user_id      uuid not null references auth.users(id) on delete cascade,
  role         member_role   not null default 'member',
  status       member_status not null default 'pending',
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  unique (community_id, user_id)   -- a user joins a community once
);
create index community_members_community_idx on community_members(community_id);
create index community_members_user_idx on community_members(user_id);
create trigger community_members_set_updated_at
  before update on community_members
  for each row execute function set_updated_at();

-- ─────────────────────────────────────────────────────────────
-- Membership helper predicates (SECURITY DEFINER → bypass RLS, no recursion)
-- ─────────────────────────────────────────────────────────────
create or replace function public.is_community_member(cid uuid)
returns boolean language sql security definer stable set search_path = public as $$
  select exists (
    select 1 from community_members m
    where m.community_id = cid
      and m.user_id = auth.uid()
      and m.status = 'active'
  );
$$;

create or replace function public.is_community_admin(cid uuid)
returns boolean language sql security definer stable set search_path = public as $$
  select exists (
    select 1 from community_members m
    where m.community_id = cid
      and m.user_id = auth.uid()
      and m.status = 'active'
      and m.role = 'admin'
  );
$$;

-- True if the caller shares any active community with `other` — lets co-members
-- read each other's basic profile (member lists, request authors).
create or replace function public.shares_community_with(other uuid)
returns boolean language sql security definer stable set search_path = public as $$
  select exists (
    select 1
    from community_members me
    join community_members them on them.community_id = me.community_id
    where me.user_id = auth.uid() and me.status = 'active'
      and them.user_id = other   and them.status = 'active'
  );
$$;

-- ─────────────────────────────────────────────────────────────
-- units
-- ─────────────────────────────────────────────────────────────
create table units (
  id              uuid primary key default gen_random_uuid(),
  community_id    uuid not null references communities(id) on delete cascade,
  type            unit_type not null default 'apartment',
  label           text not null,          -- "Apartment 24", "Plot 118", "Garage B-17"
  building        text,
  entrance        text,
  floor           int,
  owner_member_id uuid references community_members(id) on delete set null,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);
create index units_community_idx on units(community_id);
create trigger units_set_updated_at
  before update on units
  for each row execute function set_updated_at();

-- ─────────────────────────────────────────────────────────────
-- announcements
-- ─────────────────────────────────────────────────────────────
create table announcements (
  id           uuid primary key default gen_random_uuid(),
  community_id uuid not null references communities(id) on delete cascade,
  author_id    uuid references auth.users(id) on delete set null,
  title        text not null,
  body         text not null,
  category     announcement_category not null default 'general',
  is_important boolean not null default false,
  is_pinned    boolean not null default false,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create index announcements_community_idx on announcements(community_id, created_at desc);
create trigger announcements_set_updated_at
  before update on announcements
  for each row execute function set_updated_at();

-- ─────────────────────────────────────────────────────────────
-- requests / tickets
-- ─────────────────────────────────────────────────────────────
create table requests (
  id           uuid primary key default gen_random_uuid(),
  community_id uuid not null references communities(id) on delete cascade,
  author_id    uuid not null references auth.users(id) on delete cascade,
  unit_id      uuid references units(id) on delete set null,
  title        text not null,
  description  text not null,
  category     request_category not null default 'other',
  status       request_status   not null default 'new',
  photo_url    text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create index requests_community_idx on requests(community_id, created_at desc);
create index requests_author_idx on requests(author_id);
create trigger requests_set_updated_at
  before update on requests
  for each row execute function set_updated_at();

-- ─────────────────────────────────────────────────────────────
-- request_comments
-- ─────────────────────────────────────────────────────────────
create table request_comments (
  id         uuid primary key default gen_random_uuid(),
  request_id uuid not null references requests(id) on delete cascade,
  author_id  uuid not null references auth.users(id) on delete cascade,
  body       text not null,
  created_at timestamptz not null default now()
);
create index request_comments_request_idx on request_comments(request_id, created_at);

-- ─────────────────────────────────────────────────────────────
-- documents
-- ─────────────────────────────────────────────────────────────
create table documents (
  id           uuid primary key default gen_random_uuid(),
  community_id uuid not null references communities(id) on delete cascade,
  uploaded_by  uuid references auth.users(id) on delete set null,
  title        text not null,
  category     text,
  file_url     text not null,
  file_type    text,
  created_at   timestamptz not null default now()
);
create index documents_community_idx on documents(community_id, created_at desc);

-- ─────────────────────────────────────────────────────────────
-- contacts
-- ─────────────────────────────────────────────────────────────
create table contacts (
  id           uuid primary key default gen_random_uuid(),
  community_id uuid not null references communities(id) on delete cascade,
  name         text not null,
  role         text,
  phone        text,
  email        text,
  category     text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create index contacts_community_idx on contacts(community_id);
create trigger contacts_set_updated_at
  before update on contacts
  for each row execute function set_updated_at();

-- ─────────────────────────────────────────────────────────────
-- notifications  (in-app; created server-side / by triggers)
-- ─────────────────────────────────────────────────────────────
create table notifications (
  id                uuid primary key default gen_random_uuid(),
  community_id      uuid not null references communities(id) on delete cascade,
  user_id           uuid not null references auth.users(id) on delete cascade,
  type              text not null,
  title             text not null,
  body              text,
  related_entity_id uuid,
  is_read           boolean not null default false,
  created_at        timestamptz not null default now()
);
create index notifications_user_idx on notifications(user_id, is_read, created_at desc);

-- ═════════════════════════════════════════════════════════════
-- Bootstrap RPCs
--   Community creation and joining need to write community_members with elevated
--   rights (an unprivileged user must not be able to self-insert an admin row).
--   Both run SECURITY DEFINER, so community_members has NO direct INSERT policy.
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
  v_code      text;
begin
  if auth.uid() is null then
    raise exception 'not authenticated';
  end if;

  -- Short, unique, human-typeable invite code (8 alphanumeric chars).
  loop
    v_code := substr(
      upper(translate(encode(gen_random_bytes(9), 'base64'), '+/=', '')), 1, 8
    );
    exit when length(v_code) >= 6
      and not exists (select 1 from communities where invite_code = v_code);
  end loop;

  insert into communities (name, type, address, city, invite_code, created_by)
  values (p_name, p_type, p_address, p_city, v_code, auth.uid())
  returning * into v_community;

  insert into community_members (community_id, user_id, role, status)
  values (v_community.id, auth.uid(), 'admin', 'active');

  return v_community;
end $$;

create or replace function public.join_by_invite(p_invite_code text)
returns community_members
language plpgsql security definer set search_path = public as $$
declare
  v_community_id uuid;
  v_member       community_members;
begin
  if auth.uid() is null then
    raise exception 'not authenticated';
  end if;

  select id into v_community_id
  from communities where invite_code = p_invite_code;
  if v_community_id is null then
    raise exception 'invalid invite code';
  end if;

  -- Idempotent: re-joining returns the existing row without resetting status.
  insert into community_members (community_id, user_id, role, status)
  values (v_community_id, auth.uid(), 'member', 'pending')
  on conflict (community_id, user_id)
    do update set updated_at = community_members.updated_at
  returning * into v_member;

  return v_member;
end $$;

-- ═════════════════════════════════════════════════════════════
-- Row Level Security
--   Reads: active members of the community (units, announcements, docs, …).
--   Writes: admins of the community, except member-authored rows (requests,
--   comments) and the caller's own profile / notifications.
-- ═════════════════════════════════════════════════════════════
alter table profiles          enable row level security;
alter table communities       enable row level security;
alter table community_members enable row level security;
alter table units             enable row level security;
alter table announcements     enable row level security;
alter table requests          enable row level security;
alter table request_comments  enable row level security;
alter table documents         enable row level security;
alter table contacts          enable row level security;
alter table notifications     enable row level security;

-- profiles ----------------------------------------------------
create policy "profiles select self or co-member" on profiles
  for select using (id = auth.uid() or public.shares_community_with(id));
create policy "profiles update self" on profiles
  for update using (id = auth.uid()) with check (id = auth.uid());

-- communities -------------------------------------------------
-- Creation goes through create_community(); joining looks the community up by
-- code inside join_by_invite(), so no public SELECT of arbitrary communities.
create policy "communities select for members" on communities
  for select using (public.is_community_member(id) or created_by = auth.uid());
create policy "communities update for admins" on communities
  for update using (public.is_community_admin(id))
  with check (public.is_community_admin(id));
create policy "communities delete for admins" on communities
  for delete using (public.is_community_admin(id));

-- community_members -------------------------------------------
-- INSERT is intentionally absent — only the SECURITY DEFINER RPCs may add rows.
create policy "members select own or same community" on community_members
  for select using (user_id = auth.uid() or public.is_community_member(community_id));
create policy "members manage by admin" on community_members
  for update using (public.is_community_admin(community_id))
  with check (public.is_community_admin(community_id));
create policy "members delete by admin" on community_members
  for delete using (public.is_community_admin(community_id));

-- units -------------------------------------------------------
create policy "units select for members" on units
  for select using (public.is_community_member(community_id));
create policy "units write for admins" on units
  for all using (public.is_community_admin(community_id))
  with check (public.is_community_admin(community_id));

-- announcements -----------------------------------------------
create policy "announcements select for members" on announcements
  for select using (public.is_community_member(community_id));
create policy "announcements write for admins" on announcements
  for all using (public.is_community_admin(community_id))
  with check (public.is_community_admin(community_id));

-- requests ----------------------------------------------------
create policy "requests select author or admin" on requests
  for select using (
    public.is_community_admin(community_id)
    or (author_id = auth.uid() and public.is_community_member(community_id))
  );
create policy "requests insert own" on requests
  for insert with check (
    author_id = auth.uid() and public.is_community_member(community_id)
  );
create policy "requests update author or admin" on requests
  for update using (
    public.is_community_admin(community_id) or author_id = auth.uid()
  )
  with check (
    public.is_community_admin(community_id) or author_id = auth.uid()
  );
create policy "requests delete author or admin" on requests
  for delete using (
    public.is_community_admin(community_id) or author_id = auth.uid()
  );

-- request_comments --------------------------------------------
-- Visible / writable if the caller can see the parent request.
create policy "comments select on visible request" on request_comments
  for select using (
    exists (
      select 1 from requests r
      where r.id = request_id
        and (public.is_community_admin(r.community_id) or r.author_id = auth.uid())
    )
  );
create policy "comments insert on visible request" on request_comments
  for insert with check (
    author_id = auth.uid()
    and exists (
      select 1 from requests r
      where r.id = request_id
        and (public.is_community_admin(r.community_id) or r.author_id = auth.uid())
    )
  );

-- documents ---------------------------------------------------
create policy "documents select for members" on documents
  for select using (public.is_community_member(community_id));
create policy "documents write for admins" on documents
  for all using (public.is_community_admin(community_id))
  with check (public.is_community_admin(community_id));

-- contacts ----------------------------------------------------
create policy "contacts select for members" on contacts
  for select using (public.is_community_member(community_id));
create policy "contacts write for admins" on contacts
  for all using (public.is_community_admin(community_id))
  with check (public.is_community_admin(community_id));

-- notifications -----------------------------------------------
-- INSERT is absent — notifications are written server-side (triggers / RPCs).
create policy "notifications select own" on notifications
  for select using (user_id = auth.uid());
create policy "notifications update own" on notifications
  for update using (user_id = auth.uid()) with check (user_id = auth.uid());

-- ═════════════════════════════════════════════════════════════
-- Storage buckets (private) + per-community policies
--   Path convention: <community_id>/<path...>. The first folder segment is the
--   community id; RLS derives membership from it.
-- ═════════════════════════════════════════════════════════════
insert into storage.buckets (id, name, public) values
  ('documents',      'documents',      false),
  ('request-photos', 'request-photos', false)
on conflict (id) do nothing;

-- documents: members read, admins write.
create policy "storage documents read for members" on storage.objects
  for select using (
    bucket_id = 'documents'
    and public.is_community_member(((storage.foldername(name))[1])::uuid)
  );
create policy "storage documents write for admins" on storage.objects
  for insert with check (
    bucket_id = 'documents'
    and public.is_community_admin(((storage.foldername(name))[1])::uuid)
  );
create policy "storage documents update for admins" on storage.objects
  for update using (
    bucket_id = 'documents'
    and public.is_community_admin(((storage.foldername(name))[1])::uuid)
  );
create policy "storage documents delete for admins" on storage.objects
  for delete using (
    bucket_id = 'documents'
    and public.is_community_admin(((storage.foldername(name))[1])::uuid)
  );

-- request photos: any active member of the community may read and upload.
create policy "storage request-photos read for members" on storage.objects
  for select using (
    bucket_id = 'request-photos'
    and public.is_community_member(((storage.foldername(name))[1])::uuid)
  );
create policy "storage request-photos write for members" on storage.objects
  for insert with check (
    bucket_id = 'request-photos'
    and public.is_community_member(((storage.foldername(name))[1])::uuid)
  );
