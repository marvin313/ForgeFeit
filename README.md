# ForgeFit

ForgeFit is an iPhone-focused Flutter gym tracker with private Supabase accounts,
offline-first workout storage, cloud recovery, and fully customisable workout
planning. Stage 3 builds a multi-exercise active-workout, completed-history,
rest-timer, and personal-record foundation on the Stage 1 and Stage 2 app.

- App name: **ForgeFit**
- iOS bundle identifier: `com.marvin.forgefit`
- Default weight unit: kilograms (`kg`)
- State management: Riverpod
- Local database: Drift with SQLite
- Authentication and cloud database: Supabase
- Visual style: near-black with an electric-blue accent

The generated Android project remains in the repository because this is a
standard Flutter project. Development, setup, testing, and documentation are
focused on iPhone and iOS.

## Stage 3 features

Stage 3 adds the following offline-first domain and storage capabilities:

- Start one active workout from a template or start an empty workout
- Copy a template's name, notes, exercises, planned sets, targets, order, and
  rest settings into independent session snapshots with new UUIDs
- Recover the active workout after navigation, process termination, or restart
- Add, replace, remove, and reorder built-in or private custom exercises without
  changing the source template
- Add, edit, delete, duplicate, copy, complete, uncomplete, and reorder sets
- Warm-up, working, drop-set, and failure-set types, with optional weight,
  repetitions, duration, distance, RPE, RIR, and notes
- Previous-performance lookup from the latest non-deleted completed session,
  with a clearly marked Stage 1 quick-log fallback
- A timestamp-based rest timer with start, pause, resume, reset, skip, duration
  adjustment, and optional automatic start after completing a set
- Transactional completion into immutable exercise and set snapshots before the
  active graph is tombstoned
- Completed-workout totals, summary data, newest-first search, note editing,
  soft deletion, and deterministic personal-record recomputation
- Current personal records plus immutable achievement events for heaviest
  weight, most repetitions at a weight, estimated 1RM, set volume, and exercise
  workout volume
- A third durable, version-aware outbox for active workouts, completed history,
  and personal records
- Paginated cloud restoration of all Stage 3 entity types

Only completed, non-deleted sets contribute to completed-workout totals. Warm-up
sets remain visible in history but are excluded from personal records. Active
workout creation enforces one non-deleted active session per user; attempting to
start another returns the existing session so the interface can offer continue,
finish, discard, or cancel instead of silently replacing it.

### Stage 3 workout flow

The iPhone-focused flow is **Home → Start Workout → choose a template or Start
Empty Workout → Active Workout → Finish Workout → Workout Summary → History**.
Home keeps the primary start action prominent and, while an active session
exists, exposes a prominent continue action backed by Drift. It also links to
templates, the three most recent completed sessions, workout history, and the
Personal Records screen without removing the Stage 1 quick-log path. The
History tab is the integrated Stage 3 `SessionHistoryScreen`: it shows completed
sessions newest first and embeds clearly labelled legacy quick-log entries in
the same searchable experience.

The Start Workout screen implements both real paths: a template preview creates
an independent session snapshot, while **Start Empty Workout** collects an
editable name and optional note before opening a blank session. If a session is
already active, it shows explicit continue, finish, discard, and cancel choices
instead of replacing it. Template search can be grouped by All Templates, No
Split, or a split; those choices organise the list and never restrict
active-workout exercise selection.

The active screen presents elapsed time, workout and exercise notes, planned
targets, previous performance, editable set rows, exercise/set ordering, the
rest timer, and finish controls. Finish review makes the completed-only totals
visible before the transaction runs. The resulting summary identifies newly
achieved records, while completed history provides newest-first search, detail,
note editing, and confirmed soft deletion. Completed weights and repetitions
remain read-only so derived totals and records cannot become inconsistent.

### Expanded exercise catalogue and search

ForgeFit includes **283** read-only built-in exercises. Stable IDs preserve
existing Stage 2 template references. The catalogue spans chest, back,
shoulders, arms, forearms, quadriceps, hamstrings, glutes, calves, core, full
body, cardio, mobility, rehabilitation, and other movements, with barbell,
dumbbell, cable, plate-loaded, selectorised, Smith-machine, bodyweight, band,
kettlebell, medicine-ball, cardio, and other equipment.

Each built-in movement carries aliases, keywords, primary and secondary muscle
groups, equipment, tracking type, and relevance flags for weight, repetitions,
distance, duration, and bodyweight. Search is case-insensitive, collapses extra
spaces, ignores punctuation, accepts useful partial words, and searches all of
that metadata without creating duplicate visible exercises. For example, `RDL`,
`OHP`, `rear delt`, `side delt`, `ham curl`, `bench`, `abs`, and `bike` resolve
to their canonical movements.

Custom exercises remain separate, private user-owned records. Optional aliases
and keywords save to Drift, use the same search engine, sync through the Stage 2
planning outbox, and restore from the owner-restricted Supabase row.

## Preserved Stage 1 and Stage 2 features

Stage 1 remains available:

- Name and weight-unit onboarding
- Email registration, login, password reset, persistent login, and logout
- Local-first workout saving and history
- Automatic Supabase sync with durable retry handling
- Sync status for synced, syncing, waiting, and failed changes
- Recovery of synced workout history after reinstall and login

Stage 2 remains available:

- Unlimited custom workout splits with a name, description, icon or emoji,
  colour, and order
- Split editing, renaming, reordering, duplication, and safe deletion
- Unlimited custom workout templates, with or without a split
- Template editing, moving, reordering, duplication, and soft deletion
- A permanent virtual **No Split** section and an **All Templates** view
- A searchable exercise picker with muscle and equipment filters, favourites,
  recently used movements, built-in movements, and private custom exercises
- Custom exercise creation, editing, favourites, notes, instructions, and soft
  deletion
- Per-template exercise configuration for working sets, warm-up sets, target rep
  range, optional target weight, rest, optional RPE, optional RIR, notes, and
  order
- Exercise replacement, removal, duplication, and drag-and-drop reordering
- Offline-first planning changes with a version-aware durable outbox
- Cloud restore of splits, templates, custom exercises, and template exercises

A split is only an optional organisational folder. It never chooses, limits, or
filters the exercises in a template. A template in a split named `Push Pull
Legs`, for example, can still contain a leg, back, chest, arm, cardio, or custom
movement. Users are not required to create a split or use a predefined routine.

Stage 3 intentionally excludes progress photos, body measurements, bodyweight
or exercise-progress charts, AI coaching, generated workouts, Apple Health,
HealthKit, social features, public profiles, friends, leaderboards,
subscriptions, payments, advertising, home-screen widgets, Live Activities,
push notifications, and cloud notifications. Core rest-timer operation does not
depend on notification permission.

## Architecture

ForgeFit keeps presentation, local persistence, cloud access, and coordination
separate:

| Layer | Responsibility |
| --- | --- |
| Flutter UI | iPhone-sized screens, validation, loading, empty, error, and confirmation states |
| Riverpod | Authenticated user, database, repositories, sync coordinators, and reactive screen state |
| Drift repositories | Immediate transactional writes, user-scoped reads, session snapshots, metrics, records, tombstones, and restore merging |
| Supabase data sources | Authenticated upserts and user-scoped cloud snapshots using the client-safe publishable key |
| Sync coordinator | Three durable outboxes, single-flight uploads, bounded retry scheduling, connectivity recovery, stable UUID upserts, and status reporting |

The Drift database is schema version 3. It retains the Stage 1 quick-log tables
and Stage 2 planning tables without recreating them. Stage 2 added:

- `workout_splits`
- `workout_templates`
- `custom_exercises`
- `template_exercises`
- `planner_sync_queue`

Stage 3 adds:

- `active_workout_sessions`
- `active_workout_exercises`
- `active_workout_sets`
- `completed_workout_sessions`
- `completed_workout_exercises`
- `completed_workout_sets`
- `personal_records`
- `personal_record_events`
- `session_sync_queue`

It also adds local `aliases_json` and `search_keywords_json` columns to
`custom_exercises`. The additive v2-to-v3 Drift upgrade creates only new tables
and columns; existing workouts, sets, splits, templates, configured exercises,
custom exercises, and pending Stage 1/2 outbox rows remain intact.

The Supabase migrations create these public tables:

| Migration | Tables |
| --- | --- |
| `0001_initial_schema.sql` | `profiles`, `workouts`, `workout_sets` |
| `0002_stage_2_workout_planning.sql` | `workout_splits`, `workout_templates`, `custom_exercises`, `template_exercises` |
| `0003_stage_3_active_workouts.sql` | `active_workout_sessions`, `active_workout_exercises`, `active_workout_sets`, `completed_workout_sessions`, `completed_workout_exercises`, `completed_workout_sets`, `personal_records`, `personal_record_events`; also extends `custom_exercises` |

Every Stage 2 and Stage 3 user-owned cloud row has a UUID primary key, `user_id`,
`created_at`, `updated_at`, an optional `deleted_at` tombstone where
appropriate, and a version for conflict-aware syncing. Stage 1 records retain
their existing ownership and timestamp fields. Composite owner foreign keys
prevent a template or template exercise from referencing another user's record.
Physically deleting a split or referenced custom exercise is restricted; the
app uses soft deletion. Physically purging a template may cascade only to that
template's configured entries.

Built-in exercise definitions are shared read-only app data with stable keys.
Private custom exercises are stored locally and in the user-owned
`custom_exercises` table. Template entries keep a movement snapshot so their
name and configuration remain understandable if a custom movement is later
soft-deleted.

`All Templates` and `No Split` are views in the interface, not database rows.
`No Split` means a template's `split_id` is null.

### Active and completed workout snapshots

An active session owns active exercise and set rows. Starting from a template
copies the plan into new session-owned UUIDs; only the optional source template
ID is retained for provenance. Later template edits or deletion cannot alter an
active or completed workout. Exercise names, muscles, equipment, tracking flags,
notes, order, and set values are copied again when finishing, so completed
history remains understandable after a built-in catalogue update or custom
exercise soft deletion.

Finishing is one local Drift transaction. ForgeFit first writes the completed
session, exercise snapshots, completed-set snapshots, derived totals, current
personal records, and personal-record events. Only after those writes succeed
does it tombstone the active sets, exercises, and session and queue every cloud
operation. A failed transaction therefore leaves the recoverable active workout
intact.

Completed performance is read-only apart from workout notes. Soft-deleting a
completed workout tombstones its session, exercises, and sets, excludes it from
normal history and previous performance, and recomputes affected current records
from the remaining completed history. Personal-record events preserve the
achievement trail even when a later performance becomes the current best.

### Metrics and personal records

ForgeFit stores canonical weights internally in kilograms. When a user prefers
pounds, active-set entry and every Stage 3 weight display convert between pounds
and canonical kilograms at the UI boundary; the stored history and PR maths do
not change. Training volume is always calculated from canonical kilograms and
is labelled as kilogram volume (`kg volume`) in the interface. Set volume is:

```text
set_volume_kg = weight_kg × repetitions
```

Estimated one-repetition maximum uses the Epley formula:

```text
estimated_1rm_kg = weight_kg × (1 + repetitions / 30)
```

Set volume, workout volume, and estimated 1RM are rounded to three decimal
places using Dart's half-away-from-zero `round` behaviour. Estimated 1RM is not
created for a missing, zero, or negative weight or repetition count. Record
candidates exclude warm-ups, incomplete sets, deleted sets, and deleted
workouts. Most-reps records are scoped to the exact three-decimal kilogram
weight; the other record types use an overall scope for the exercise's stable
ID.

### Rest timer and elapsed time

Workout elapsed time is derived from the persisted UTC `started_at` timestamp,
not an in-memory counter. A running rest timer stores an absolute UTC target-end
timestamp, so navigation and background time do not pause it. A paused timer
stores remaining seconds and clears the target timestamp. Idle and expired
states clear both transient values. Resume creates a new target from the saved
remaining duration; reset restores the configured duration in a paused state;
skip returns to idle; adjustments are clamped between zero and 24 hours.

Completing a set can automatically start the exercise's snapshotted rest
duration. Automatic start can be disabled per active workout, and the workout
flow remains functional without local-notification permission.

## Offline-first, retry, and restoration behaviour

Every Stage 1, Stage 2, and Stage 3 mutation follows the same core sequence:

1. Write the entity changes and an outbox operation in one Drift transaction.
2. Refresh the interface from SQLite immediately.
3. Add the operation to its corresponding durable `sync_queue`,
   `planner_sync_queue`, or `session_sync_queue`. The Stage 2 and Stage 3
   queues coalesce repeated changes to the same user, entity type, and UUID.
4. Use stable-key upserts when a connection and signed-in session are
   available. Stage 2 and Stage 3 conditionally upload the latest local
   version, so an older or equal version cannot overwrite a newer cloud row.
5. Retain failures with attempt metadata and retry later.
6. Remove the queued operation only after the pending mutation is confirmed
   uploaded; if a newer coalesced version exists, keep that newer work queued.

Client-generated UUID primary keys make retries idempotent and prevent duplicate
cloud records. Split and template duplication generates new UUIDs for every
copied split, template, and template-exercise entry, so copies are independent.
Soft deletions sync as tombstones rather than destructive remote deletes.

The Stage 1 quick-log outbox, Stage 2 planning outbox, and Stage 3 session
outbox remain independent durable Drift tables. Logging or editing never waits
for Supabase. The coordinator drains parents before children, preserves a newer
coalesced version while an older request is in flight, and reports the combined
pending count.

Sync is attempted when the authenticated app starts, returns to the foreground,
receives a positive connectivity signal, queues a new local mutation, reaches a
scheduled retry, or receives a manual refresh/sync request. Calls are
single-flight. A failed pass keeps every outbox row and its attempt/error
metadata, then schedules deterministic exponential backoff starting at 2
seconds, doubling after each consecutive failure, and capped at 5 minutes. Only
one delayed retry is scheduled at a time. A successful empty outbox resets the
failure counter; connectivity, a new mutation, or a manual request can supersede
the timer with an immediate pass.

When cloud data is restored, parent records are merged before child records.
Rows that still have a local queued version are not overwritten by an older
cloud snapshot. Restore merging is also version-monotonic, so a stale response
captured while an upload was finishing cannot regress SQLite after the queue
row clears. Only changes that reached Supabase can return after uninstall;
uninstalling removes SQLite and therefore also removes changes that were still
waiting locally.

Supabase restoration never relies on one unlimited response. Stage 1
`workouts` and `workout_sets` are downloaded independently in deterministic
500-row UUID-ordered pages. Stage 2 planning tables and every Stage 3 active,
completed, and personal-record table use the same 500-row deterministic paging
pattern. Requests continue until a short or empty page is returned. Local
upserts preserve UUIDs, owner IDs, timestamps, versions, and tombstones, so
repeating restoration is idempotent and does not duplicate history.

### Legacy Stage 1 quick logs

Stage 1 `workouts` and `workout_sets` remain their original one-exercise
quick-log records. The v3 migration does not delete, merge, reinterpret, or
invent session times for them. They remain visible through the legacy history
path and can be used as a clearly labelled previous-performance fallback when
the normalized exercise name matches. They do not become Stage 3 sessions, do
not create false durations, and never feed Stage 3 personal records.

### Onboarding persistence

Onboarding completion, display name, and preferred unit are stored locally with
`SharedPreferencesAsync`. First launch waits for that local value before
choosing onboarding or authentication. Completing onboarding or choosing an
existing account writes the value before navigating. An already authenticated
Stage 2 installation backfills the marker, and logout awaits that write before
Supabase emits `signedOut`. Consequently logout returns to authentication and a
later restart/login does not force a completed user through onboarding again.

## Prerequisites

Install:

- Flutter on the stable channel
- Xcode and the iOS Simulator on macOS for local iOS runs and builds
- CocoaPods if a dependency generates an iOS `Podfile`
- A free Supabase project
- The Supabase CLI for the recommended migration workflow

The GitHub Actions workflow pins Flutter `3.44.6`. Check the local toolchain:

```sh
flutter channel stable
flutter doctor -v
```

A Mac is required for a local iOS build. Windows and Linux can run Dart/Flutter
analysis and tests when their Flutter and native SQLite test dependencies are
available, but they cannot build the iOS application.

## Install dependencies and generate Drift code

From the ForgeFit project root:

```sh
flutter pub get
```

Generated Drift code is committed. After changing a Drift table, regenerate it:

```sh
dart run build_runner build --delete-conflicting-outputs
```

If `ios/Podfile` exists after dependency resolution, install its dependencies on
macOS:

```sh
cd ios
pod install --repo-update
cd ..
```

Current Flutter projects may use Swift Package Manager and therefore have no
`Podfile`; no CocoaPods command is needed in that case.

## Configure Supabase authentication

1. Create a Supabase project and wait for its database to become available.
2. Enable the Email provider and email/password sign-ins.
3. Choose whether development registrations require email confirmation. When
   confirmation is enabled, confirm the email before the first login.
4. Copy the project URL and its publishable client key. An older project may
   label the client-safe key `anon`.
5. In **Authentication > URL Configuration**, add
   `com.marvin.forgefit://reset-password` for password recovery.

The Stage 1 registration trigger creates the user's profile from trusted sign-up
metadata, including the display name and preferred unit, even when email
confirmation delays the first session.

Never place a privileged server key, database password, Apple certificate, or
provisioning profile in this app, `.env`, an IPA, the repository, or the GitHub
Actions workflow. The mobile app requires only the project URL and client-safe
publishable key; Row Level Security is the security boundary.

## Run the Supabase migrations

The migration files are immutable and must remain in order:

1. `supabase/migrations/0001_initial_schema.sql`
2. `supabase/migrations/0002_stage_2_workout_planning.sql`
3. `supabase/migrations/0003_stage_3_active_workouts.sql`

Do not rename, replace, or edit `0001` or `0002`. Stage 3 is additive and must
run only after both earlier migrations have succeeded.

### Run only Stage 3 in Supabase SQL Editor

Use these exact steps for an existing ForgeFit Stage 2 Supabase project:

1. In Supabase, open the project that already has both `0001` and `0002`.
2. Confirm the public schema already contains `profiles`, `workouts`,
   `workout_sets`, `workout_splits`, `workout_templates`, `custom_exercises`,
   and `template_exercises`.
3. Locally open
   `supabase/migrations/0003_stage_3_active_workouts.sql`.
4. Copy the entire file, beginning with its Stage 3 comment and ending with the
   final authenticated grant.
5. Open **SQL Editor > New query**, paste that SQL without modification, and
   choose **Run** once.
6. Wait for a successful result. Do not paste or run `0001` or `0002` again.
7. In **Table Editor**, verify the eight new Stage 3 cloud tables exist:
   `active_workout_sessions`, `active_workout_exercises`,
   `active_workout_sets`, `completed_workout_sessions`,
   `completed_workout_exercises`, `completed_workout_sets`,
   `personal_records`, and `personal_record_events`.
8. Verify `custom_exercises` now has `aliases` and `search_keywords` columns.
9. Run the RLS audit below before using a real account.

If the query fails, preserve the complete error and resolve it before running
the app. Do not mark `0003` applied and do not run only a fragment of the file.

### Supabase CLI: existing Stage 2 project

For a project whose first two migrations were already applied and tracked by
the Supabase CLI:

```sh
supabase login
supabase link --project-ref YOUR_PROJECT_REF
supabase migration list
supabase db push
```

Read the pending migration list before approving it. It should show
`0003_stage_3_active_workouts.sql` as the only pending migration. If `0001` or
`0002` is unexpectedly pending, stop and reconcile migration history rather
than applying old schema again.

If the earlier migrations were run manually and are not represented in CLI
history, use the SQL Editor instructions above or reconcile history according
to the installed CLI's `supabase migration repair --help`. Never mark a
migration applied unless its full SQL has actually succeeded.

### Supabase CLI: fresh project

From the ForgeFit root:

```sh
supabase login
supabase init
supabase link --project-ref YOUR_PROJECT_REF
supabase migration list
supabase db push
```

Skip `supabase init` if `supabase/config.toml` already exists. Confirm that the
fresh project will apply `0001`, then `0002`, then `0003`, and approve only that
ordered plan.

### Supabase SQL Editor: existing Stage 1 project

1. Open `supabase/migrations/0002_stage_2_workout_planning.sql` locally.
2. Copy the entire file into a new Supabase SQL Editor query.
3. Run it once.
4. Confirm the four Stage 2 tables appear in the public schema.
5. Follow **Run only Stage 3 in Supabase SQL Editor** above for `0003`.

### Supabase SQL Editor: fresh project

1. Run the entire `0001_initial_schema.sql` file and wait for success.
2. Run the entire `0002_stage_2_workout_planning.sql` file and wait for success.
3. Run the entire `0003_stage_3_active_workouts.sql` file and wait for success.
4. Confirm all fifteen user-owned application tables appear in the public
   schema.

## Audit Row Level Security

The migrations enable and force RLS, revoke anonymous/public table access, and
grant authenticated CRUD privileges that are limited by own-user policies.
Run this in the SQL Editor:

```sql
select tablename, rowsecurity
from pg_tables
where schemaname = 'public'
  and tablename in (
    'profiles',
    'workouts',
    'workout_sets',
    'workout_splits',
    'workout_templates',
    'custom_exercises',
    'template_exercises',
    'active_workout_sessions',
    'active_workout_exercises',
    'active_workout_sets',
    'completed_workout_sessions',
    'completed_workout_exercises',
    'completed_workout_sets',
    'personal_records',
    'personal_record_events'
  )
order by tablename;

select tablename, policyname, cmd
from pg_policies
where schemaname = 'public'
  and tablename in (
    'profiles',
    'workouts',
    'workout_sets',
    'workout_splits',
    'workout_templates',
    'custom_exercises',
    'template_exercises',
    'active_workout_sessions',
    'active_workout_exercises',
    'active_workout_sets',
    'completed_workout_sessions',
    'completed_workout_exercises',
    'completed_workout_sets',
    'personal_records',
    'personal_record_events'
  )
order by tablename, policyname;
```

Every table must report `rowsecurity = true`. Each table must have select,
insert, update, and delete policies whose ownership check matches
`auth.uid()` to `user_id`. Stage 2's composite foreign keys additionally bind a
split, template, configured exercise, and custom exercise to the same owner.
Stage 3 repeats owner-bound foreign keys through each active and completed graph,
forces RLS, grants only authenticated access, and revokes all table privileges
from `anon` and `public`. Never test owner isolation with the Supabase dashboard's
privileged SQL role; use two real authenticated client sessions.

## Configure the app without committing credentials

ForgeFit does not load a runtime `.env` file or bundle one into an iOS app.
Instead, pass the project URL and client-safe publishable key with
`--dart-define` whenever you run or build the app. This prevents an IPA from
depending on a generated asset that could be missing or stale.

The URL and publishable key are necessarily visible to a mobile client. They
are not Supabase secrets: Row Level Security is the security boundary. Never
provide a `service_role` key, secret key, database password, or Apple signing
material through a Dart define.

The tracked `.env.example` is only a safe reference template. `.env` and
`.env.*` remain ignored by Git and are never used by ForgeFit at runtime.

For a local run, use your actual Supabase project values:

```sh
flutter run -d DEVICE_ID \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLISHABLE_CLIENT_KEY
```

On PowerShell, use the same arguments on one line. Do not commit the real
values, even though the publishable key is client-safe. Before sharing or
committing the project, verify that `.env` is not staged:

```sh
git status --short
```

## Run on an iPhone Simulator or device

On macOS, list devices and launch ForgeFit:

```sh
flutter devices
flutter run -d DEVICE_ID \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLISHABLE_CLIENT_KEY
```

The first launch shows onboarding. Enter a non-empty name, choose `kg` or `lb`,
and register. Confirm the email first if the Supabase project requires it.
Completing onboarding is remembered on the device. Later restarts go directly
to the current authenticated or authentication state, and logout returns to
login rather than showing onboarding again.

## Formatting, analysis, and automated tests

Run these from the ForgeFit root after changes:

```sh
dart run build_runner build
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

These commands must complete before a change is described as passing. The
first command verifies that generated Drift code matches the tables; the
format command is a read-only CI check. Use `dart format lib test` first when
you intentionally need to apply formatting.

## Build an unsigned iOS app locally

On macOS:

```sh
flutter build ios --release --no-codesign \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT_REF.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLISHABLE_CLIENT_KEY
```

The result is `build/ios/iphoneos/Runner.app`. An unsigned app cannot be
installed directly on a normal iPhone; it must be signed later with an
appropriate Apple development, ad hoc, or distribution identity.

## Build the unsigned IPA with GitHub Actions

The manual workflow is `.github/workflows/ios-ipa-build.yml`. It uses a
GitHub-hosted `macos-latest` runner, installs Flutter stable and project
dependencies, regenerates Drift/Dart sources, performs a read-only Dart format
check, prepares CocoaPods when a `Podfile` exists, runs all tests and static
analysis, builds Release without code signing, places `Runner.app` inside
`Payload`, creates `ForgeFit-unsigned.ipa`, and uploads it as the
`ForgeFit-unsigned` artifact.

For a cloud-aware build, add these repository Actions secrets:

- `SUPABASE_URL`
- `SUPABASE_PUBLISHABLE_KEY`

Use the same client-safe values as local configuration. The workflow fails
before its Release build when either secret is missing, then passes both values
only to `flutter build ios` as compile-time Dart defines. It does not create or
bundle `.env`. Do not add privileged server credentials.

To run the workflow:

1. Push the repository to GitHub.
2. Open **Actions** and select **Build unsigned iOS IPA**.
3. Choose **Run workflow**, select the branch, and confirm.
4. Wait for every workflow step to complete.
5. Download the `ForgeFit-unsigned` artifact from the completed run.
6. Extract it to obtain `ForgeFit-unsigned.ipa`.

The iOS compile is not verified until the workflow completes successfully. A
Windows development machine cannot perform this Xcode build, so a local
Windows test run is not evidence that the iOS step passed.

When either Actions secret is absent, the workflow deliberately stops before
building an IPA. Add both client-safe repository secrets before dispatching it.

## Manual Stage 1 verification

Use a unique test email against a migrated Supabase project:

1. Complete onboarding, register, and confirm the email when required.
2. Log in, force-close ForgeFit, reopen it, and confirm the session persists.
3. Request a password-reset email and verify Supabase accepts the request and
   opens the configured ForgeFit recovery link.
4. Save a valid workout. Confirm it appears in history immediately and the sync
   status eventually becomes **Everything synced**.
5. In Supabase, confirm exactly one `workouts` row and its `workout_sets` row use
   the signed-in user's UUID.
6. Try a blank exercise, negative weight, zero reps, malformed email, and short
   password. Confirm validation prevents invalid writes and shows a useful
   message.
7. Log out and confirm authenticated screens are unavailable. Log back in and
   confirm workout history loads.

## Manual Stage 2 verification

### Splits and templates

1. Open Templates and verify the All Templates, No Split, loading, empty, and
   search states are understandable on an iPhone-sized screen.
2. Create splits named `Push Pull Legs`, `Strength`, and `Home Workouts`, each
   with different descriptions, icons, and colours.
3. Rename and reorder the splits. Force-close and reopen ForgeFit; confirm the
   updated values and order remain.
4. Create one template in a split and one in No Split. Edit their names, icons,
   colours, notes, and order.
5. Move a template between two splits, then move it to No Split. Confirm All
   Templates continues to show it once.
6. Duplicate a template. Confirm its name indicates a copy, all configured
   exercises and targets are copied, and later edits do not affect the original.
7. Duplicate a split. Confirm its templates and every configured exercise are
   copied with new independent records.

### Exercise freedom and configuration

1. Open the exercise picker and test text search, every muscle filter, and every
   equipment filter.
2. View favourites and recently used movements.
3. In a template inside `Push Pull Legs`, add movements from unrelated groups,
   such as a chest press, back row, squat, arm isolation, and cardio exercise.
   Confirm the split never filters or rejects any selection.
4. Create a private custom exercise with primary and secondary muscles,
   equipment, instructions, personal notes, and favourite status.
5. Edit that exercise and confirm existing template entries remain readable.
6. Add built-in and custom exercises to a template. For each entry, test working
   sets, warm-up sets, minimum and maximum reps, optional weight, rest seconds,
   optional RPE, optional RIR, and notes.
7. Reorder entries by dragging, replace one exercise, duplicate another, and
   remove one. Force-close and reopen to confirm the resulting order and values.
8. Soft-delete the custom exercise and verify another user's account cannot see
   it. Confirm any retained template snapshot remains understandable.

### Safe split deletion

Test all three choices separately:

1. Start deleting a split and choose Cancel. Confirm nothing changes.
2. Delete a split and move its templates to No Split. Confirm the templates
   remain intact and the split disappears.
3. Delete another split and move its templates to a different split. Confirm all
   templates and configured entries remain intact in the destination.

### Offline queue, reconnect, and duplicate prevention

1. While signed in and online, wait for all existing data to sync.
2. Disable the simulator or device network connection.
3. Create and rename a split; create, move, and duplicate a template; create a
   custom exercise; add and reorder template exercises; and delete or move a
   template.
4. Confirm every change appears immediately and survives an app restart while
   offline.
5. Confirm the interface reports changes waiting to sync rather than discarding
   them.
6. Restore the network. Confirm the status progresses through syncing to
   everything synced.
7. Interrupt connectivity during an upload, reconnect again, and confirm retry
   completes.
8. In Supabase, verify each client UUID exists only once despite retries and all
   versions, tombstones, parent links, and exercise order values are correct.

### Reinstall recovery

Only perform this after the status is **Everything synced**:

1. Record identifiable split, template, custom-exercise, configured-exercise,
   and workout-history values.
2. Remove ForgeFit from the simulator or device, which deletes its local SQLite
   database.
3. Reinstall or rerun ForgeFit and log in with the same Supabase account.
4. Keep the app online while it restores the account's cloud snapshot.
5. Confirm workout history, splits, No Split templates, assigned templates,
   custom exercises, configuration, and ordering reappear.
6. Restart offline and confirm the restored information remains available from
   SQLite.

### Two-user isolation

1. Register a second account with a different email.
2. Confirm it cannot see the first account's profile, workouts, splits,
   templates, template exercises, or custom exercises.
3. Create similarly named records in both accounts and confirm they remain
   independent.
4. Log back into the first account and confirm its data is unchanged.
5. Repeat the RLS audit query and inspect the tables from each authenticated
   client session if investigating any unexpected visibility.

If reinstall recovery is empty, confirm the same account UUID was used, all
expected changes had synced before removal, all three SQL migrations were applied,
RLS policies exist, and the device can reach the configured Supabase project.

## Manual Stage 3 verification

Use a disposable Supabase project or test accounts. Run `0003` first, configure
only the publishable client values, and begin with ForgeFit reporting
**Everything synced**. Keep the default unit at kilograms for the metric checks
below.

### Onboarding, catalogue, and search

1. On a clean installation, complete onboarding with a name and unit. Restart
   before registration and confirm the choices remain; then register or choose
   login and restart again to confirm onboarding does not return.
2. Log out and confirm ForgeFit shows authentication, not onboarding. Log back
   in and confirm the authenticated home screen returns.
3. Open an exercise picker and search separately for `RDL`, `OHP`, `rear delt`,
   `side delt`, `ham curl`, `bench`, `abs`, and `bike`. Confirm each query finds
   appropriate canonical exercises, regardless of case or extra punctuation,
   and never shows the same exercise twice.
4. Exercise the muscle, equipment, favourite, and recently-used filters. Confirm
   built-ins cannot be edited or deleted.
5. Create a private custom exercise with aliases and keywords, find it by an
   alias, edit the terms, and find it by the new keyword. Wait for sync before
   the reinstall and account-isolation checks below.

### Start and recover an active workout

1. Create a template with at least two exercises and planned warm-up and working
   sets, rep targets, target weight, rest seconds, RPE or RIR, and notes.
2. From Home choose **Start Workout**, preview that template, and start it.
   Confirm the workout name, start time, exercise order, planned targets, notes,
   and copied sets match the template.
3. Edit the source template from another navigation path. Return to the active
   workout and confirm its independent snapshot did not change.
4. Navigate away, background and foreground ForgeFit, force-close it, and
   reopen it. Confirm Home offers **Continue Workout**, the same active workout
   opens, and elapsed time reflects the persisted start timestamp.
5. While it is active, try to start an empty workout or another template.
   Verify the dialog offers **Continue Current Workout**, **Finish Current
   Workout**, **Discard Current Workout**, and **Cancel**. Cancel and confirm the
   original was not replaced.
6. After finishing or discarding that test session, choose **Start Empty
   Workout**, enter a custom name and optional note, add any built-in or custom
   exercise, and confirm no template is required.

### Exercises, sets, and previous performance

1. In the active workout add, replace, remove, and reorder exercises. Edit an
   exercise note and confirm none of these actions modifies a source template.
2. Add multiple sets and exercise every supported type: warm-up, working, drop
   set, and failure set. Enter decimal kilogram weights, repetitions, optional
   RPE, optional RIR, and an optional note.
3. Edit, delete, duplicate, and reorder sets. Duplicate the previous set and
   separately copy its weight, repetitions, and both values.
4. Mark a set complete, mark it incomplete, then complete it again. Confirm only
   completed sets contribute to the visible totals.
5. Try negative weight, repetitions, RPE, and RIR, as well as values above their
   sensible bounds. Confirm validation rejects them without losing valid data.
6. Finish a workout containing this exercise, start another workout containing
   it, and confirm previous performance shows the latest completed date and set
   values. Confirm incomplete sets and a soft-deleted workout do not become the
   previous performance.
7. For an exercise that exists only in Stage 1 quick-log history, confirm any
   fallback is clearly identified as legacy and is not shown as a fabricated
   multi-exercise session.

### Rest timer and timestamp recovery

1. Set an exercise rest duration, enable automatic start, and complete a set.
   Confirm the rest timer starts with that snapshotted duration.
2. Test pause, resume, reset, skip, **+15 seconds**, **-15 seconds**, and a
   custom duration. Confirm subtraction cannot make the duration negative.
3. Start the timer, navigate away, then return. Confirm remaining time was
   calculated from the stored target timestamp rather than restarting.
4. Start it again, background the app beyond the target time, and return.
   Confirm it is expired rather than paused at a stale in-memory value.
5. Pause the timer, restart ForgeFit, continue the workout, and confirm the
   persisted paused remainder can be resumed. Disable automatic start and
   confirm completing the next set does not start it.

### Finish, summary, history, and personal records

1. Complete a mixture of warm-up and working sets, leave at least one set
   incomplete, add workout notes, and press **Finish Workout**.
2. On the review screen verify name, date, start/end time, duration, completed
   exercise count, working-set count, total completed sets, repetitions,
   training volume, notes, and PR preview. Use **Return to Workout** once and
   confirm the active session is still intact.
3. Reopen review and choose **Save and Finish**. Confirm the active workout
   clears only after the completed snapshot is stored, then inspect the workout
   summary and any achieved records.
4. Confirm totals exclude the incomplete set and personal records exclude both
   the incomplete set and every warm-up set.
5. Open completed workout history. Confirm newest-first ordering, search by
   workout or exercise name, duration, exercise/set counts, and volume.
6. Open the completed workout and inspect exercise and set snapshots, set type,
   weight, repetitions, RPE/RIR, notes, totals, and personal-record markers.
   Edit only the workout note and confirm performance values remain read-only.
7. Produce each record type with controlled sets: heaviest weight, most reps at
   one exact weight, highest estimated 1RM, highest set volume, and highest
   exercise workout volume. Confirm current records and achievement events
   appear without duplicates.
8. Soft-delete a completed workout, accepting the confirmation. Confirm it
   leaves normal history and previous performance, and any affected current PR
   is recomputed from the remaining completed workouts.
9. Begin another active workout and choose **Discard Workout** from finish
   review. Cancel once, then confirm the discard and verify no completed workout
   was created.

### Offline queue, retry, and duplicate prevention

1. Wait for **Everything synced**, then disable all network access.
2. Start a workout, add and reorder exercises, add/edit/complete sets, edit
   notes, operate the timer, finish the workout, and create at least one PR.
3. Confirm every result appears immediately from SQLite, the sync indicator
   reports waiting changes, and the complete state survives a force-close while
   still offline.
4. Restore connectivity. Confirm the status changes through syncing to
   **Everything synced**. If a request is interrupted, leave the app open and
   confirm bounded retry eventually resumes; manual refresh should request an
   immediate pass.
5. Interrupt another upload and reconnect repeatedly. In Supabase, confirm each
   stable UUID exists only once and that the newest version, parent links,
   order, timestamps, and tombstones are retained.
6. Leave a change deliberately unsynced and remember it is device-only. Do not
   uninstall until the status is **Everything synced**, because removing the
   app also removes its SQLite database and durable queues.

### Reinstall and cloud restoration

1. While online and fully synced, record identifiable legacy quick logs,
   splits, templates, custom aliases, an active session if testing active cloud
   recovery, completed sessions, set snapshots, and personal records.
2. Remove ForgeFit from the simulator or device, reinstall it, complete the
   local onboarding gate if this is a truly clean device, and log in with the
   same Supabase account.
3. Keep it online while restoration reads every table. Confirm all synced
   Stage 1, Stage 2, and Stage 3 records return with the same UUIDs, order,
   timestamps, snapshots, tombstones, and no duplicates.
4. Force-close, disable networking, and reopen. Confirm the restored data is now
   usable from local SQLite.
5. For a pagination stress check, seed more than 500 owner-visible records in a
   supported test environment, restore onto an empty local database, and verify
   every page is present exactly once. Do this for Stage 1 workouts and sets and
   for each Stage 2/3 family under test.

### Live two-account RLS checklist

This check must use the app or two real authenticated Supabase client sessions;
the dashboard SQL editor's privileged role cannot prove Row Level Security.

1. Account A creates a split, a template, a custom exercise, a completed
   workout, and a personal record. Wait for **Everything synced**.
2. Log out of Account A.
3. Log into Account B.
4. Confirm Account B cannot see any of Account A's profile data, quick logs,
   splits, templates, template exercises, custom exercises or aliases, active
   sessions, completed sessions/exercises/sets, personal records, or record
   events.
5. Account B creates its own split, template, custom exercise, completed
   workout, and personal record, then waits for **Everything synced**.
6. Log out of Account B and log back into Account A.
7. Confirm Account A still sees its own records and cannot see any records
   created by Account B.

Repeat select, insert, update, and delete attempts against every Stage 3 table
from the wrong authenticated account when performing a security acceptance
test. Each attempt must return no foreign rows or an RLS rejection. This live
two-account test is required before release and must not be reported as passed
until it has actually run against the configured Supabase project.

## Known limitations and verification boundaries

- The rest timer persists timestamp state and works without notification
  permission, but Stage 3 does not add push notifications, Live Activities, or
  a background notification service. Reopen ForgeFit to see the recalculated
  state after backgrounding.
- Completed weights, repetitions, and set structure are intentionally read-only.
  Only workout notes can be edited; this keeps volume and PR history
  deterministic.
- Stage 1 quick logs remain a separate legacy model. They can support a labelled
  previous-performance fallback but do not generate Stage 3 session totals,
  durations, or personal records.
- Cloud reinstall recovery covers only records that reached Supabase. Pending
  offline operations live in SQLite and are lost when the app is uninstalled.
- An unsigned IPA is a packaging artifact, not a directly installable App Store
  build. It still requires valid Apple signing before installation on a normal
  iPhone.
- A Windows host cannot run Xcode or the GitHub-hosted macOS job locally. The
  iOS Release compile and IPA packaging remain unverified until a manual
  **Build unsigned iOS IPA** workflow run succeeds.
- SQL structure and automated repository tests are not substitutes for a live
  Supabase acceptance test. Migration execution, email delivery, cloud restore,
  and the two-account RLS checklist remain unverified until they are performed
  against the target project with real authenticated sessions.
