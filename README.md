# Dvir

Dvir keeps the record of a place you own — a house, a flat, a garage, a plot —
and of everything nested inside it.

What an object knows about itself is free-form: the year it was built, the wall
material, the plot area, whatever its keeper thinks is worth writing down. Beside
that record sit the papers that prove it — the property passport, contracts,
photos of hidden work behind a wall — and the telephone numbers a household
looks for when something breaks and there is no time to look.

It runs **on the device, without an account**. What a household writes down about
itself does not need a server to be useful, and the scans it keeps are exactly
the sort that must not depend on one.

## Two products, one codebase

The same code carries a second product for **communities** — ОСББ, residential
complexes, dacha and garage cooperatives — because an apartment inside an ОСББ
*is* an object inside a community, and documents, contacts and residents serve a
building as they serve a household.

That half has its database, its row-level security and its roles, and **no
screens yet**. Announcements, polls, meter readings and charges are in
`docs/roadmap.md`, not in the app.

## Stack

Flutter · Riverpod (codegen) · GoRouter · Freezed · json_serializable · drift
(local SQLite) · Supabase (Auth / Postgres / Storage). Localization: UK.
Flutter pinned via FVM (`.fvmrc` → 3.44.4).

The app builds as **flavors**. `unit` is one household's own object and runs
entirely on the device — no account, no network. Supabase serves the community
half, which has no screens yet.

## Getting started

```bash
# 1. Use the pinned Flutter SDK
fvm install

# 2. Allow native assets — once per machine, see below
fvm flutter config --enable-native-assets
fvm flutter clean

# 3. Supabase credentials — for the cloud half; the unit flavor never reads them
cp .env.example .env   # then fill SUPABASE_URL and SUPABASE_ANON_KEY

# 4. Install deps and generate code
fvm flutter pub get
fvm flutter gen-l10n
fvm dart run build_runner build

# 5. Run — both the flavor and the entry point are required
fvm flutter run --flavor unit -t lib/main_unit.dart
```

### Native assets

Step 2 is not optional and is easy to skip, because skipping it looks like
success: the app **builds, installs and starts**, then dies the moment it opens
the database.

```
dlopen failed: library "libsqlite3.so" not found
```

drift uses `sqlite3` 3.x, which arrives as a native asset — `hook/build.dart`
compiles SQLite during the Android build, and that hook does not run unless the
flag is set. The `flutter clean` matters too: the first build after enabling the
flag reuses a cached result and silently produces nothing.

Neither `flutter analyze` nor the test suite catches this, because tests compile
SQLite for the host. Verify with `fvm flutter config --list`, which should show
`enable-native-assets: true` — it is a per-user setting, so git does not carry
it and every machine and CI runner needs it set once.

## Project layout

- `lib/app/` — app wiring: `app.dart`, `router.dart`, `routes.dart`, `theme.dart`.
- `lib/core/` — cross-cutting helpers: `config/`, `error/`, `extensions/`, `utils/`.
- `lib/features/<Feature>/` — feature-first clean architecture
  (`application/` · `data/` · `domain/` · `presentation/`).
- `lib/l10n/` — UK localization (`app_uk.arb`, which is also the template).
- `docs/` — product roadmap and spec.

See `CLAUDE.md` for coding conventions and `docs/roadmap.md` for the build plan.
