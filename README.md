# Dvir

Dvir is a mobile-first community management app for ОСББ, residential complexes,
garden cooperatives and local communities.

It helps admins publish announcements, manage member requests, store documents,
run polls, collect meter readings and track community charges in one place.

## Stack

Flutter · Riverpod (codegen) · GoRouter · Freezed · json_serializable ·
Supabase (Auth / Postgres / Storage). Localization: EN + UK. Flutter pinned via
FVM (`.fvmrc` → 3.44.4).

## Getting started

```bash
# 1. Use the pinned Flutter SDK
fvm install

# 2. Configure Supabase credentials
cp .env.example .env   # then fill SUPABASE_URL and SUPABASE_ANON_KEY

# 3. Install deps and generate code
fvm flutter pub get
fvm flutter gen-l10n
fvm dart run build_runner build

# 4. Run
fvm flutter run
```

## Project layout

- `lib/app/` — app wiring: `app.dart`, `router.dart`, `routes.dart`, `theme.dart`.
- `lib/core/` — cross-cutting helpers: `config/`, `error/`, `extensions/`, `utils/`.
- `lib/features/<Feature>/` — feature-first clean architecture
  (`application/` · `data/` · `domain/` · `presentation/`).
- `lib/l10n/` — EN + UK localization (`app_en.arb`, `app_uk.arb`).
- `docs/` — product roadmap and spec.

See `CLAUDE.md` for coding conventions and `docs/roadmap.md` for the build plan.
