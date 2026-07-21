-- 0003 — invite codes without pgcrypto
--
--   generate_invite_code() called gen_random_bytes(), which lives in the
--   pgcrypto extension. On Supabase that extension is in the `extensions`
--   schema, but the function runs with search_path = public, so the call
--   failed with 42883 (function does not exist).
--
--   gen_random_uuid() is built into Postgres itself (already used for every
--   table's default id), so deriving the code from it removes the dependency
--   entirely. Eight hex chars, uppercased, e.g. "A3F9C1B2".

create or replace function public.generate_invite_code()
returns text language plpgsql security definer set search_path = public as $$
declare
  v_code text;
begin
  loop
    v_code := upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 8));
    exit when not exists (select 1 from communities where invite_code = v_code)
      and not exists (select 1 from units where invite_code = v_code);
  end loop;
  return v_code;
end $$;
