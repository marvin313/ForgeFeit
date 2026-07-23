import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

String _tableDefinition(String migration, String table) {
  final marker = 'create table if not exists public.$table';
  final start = migration.indexOf(marker);
  if (start < 0) {
    return '';
  }
  final next = migration.indexOf(
    'create table if not exists public.',
    start + marker.length,
  );
  return migration.substring(start, next < 0 ? migration.length : next);
}

String _sha256(String path) {
  final result = Platform.isWindows
      ? Process.runSync('certutil', ['-hashfile', path, 'SHA256'])
      : Platform.isMacOS
      ? Process.runSync('shasum', ['-a', '256', path])
      : Process.runSync('sha256sum', [path]);
  if (result.exitCode != 0) {
    throw StateError('Unable to hash $path: ${result.stderr}');
  }
  final match = RegExp(
    r'\b[a-fA-F0-9]{64}\b',
  ).firstMatch(result.stdout.toString());
  if (match == null) {
    throw StateError('No SHA-256 digest returned for $path.');
  }
  return match.group(0)!.toUpperCase();
}

void main() {
  late String migration;

  setUpAll(() {
    migration = File(
      'supabase/migrations/0003_stage_3_active_workouts.sql',
    ).readAsStringSync().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  });

  const tables = [
    'active_workout_sessions',
    'active_workout_exercises',
    'active_workout_sets',
    'completed_workout_sessions',
    'completed_workout_exercises',
    'completed_workout_sets',
    'personal_records',
    'personal_record_events',
  ];

  test('Stage 3 creates exactly the required owner-scoped cloud tables', () {
    for (final table in tables) {
      expect(
        migration,
        contains('create table if not exists public.$table'),
        reason: '$table must be created by the Stage 3 migration.',
      );
      expect(
        migration,
        contains('alter table public.$table enable row level security'),
      );
      expect(
        migration,
        contains('alter table public.$table force row level security'),
      );
      expect(
        migration,
        contains('revoke all on table public.$table from public, anon'),
      );
      expect(
        migration,
        contains(
          'grant select, insert, update, delete on table public.$table to authenticated',
        ),
      );
    }

    expect(migration, isNot(contains('create table public.sync_queue')));
    expect(
      migration,
      isNot(contains('create table if not exists public.sync_queue')),
    );
  });

  test('every Stage 3 row has UUID ownership and sync metadata', () {
    for (final table in tables) {
      final definition = _tableDefinition(migration, table);
      expect(definition, contains('id uuid primary key'));
      expect(
        definition,
        contains(
          'user_id uuid not null references auth.users (id) on delete cascade',
        ),
      );
      expect(definition, contains('created_at timestamptz not null'));
      expect(definition, contains('updated_at timestamptz not null'));
      expect(definition, contains('deleted_at timestamptz'));
      expect(definition, contains('version bigint not null default 1'));
      expect(definition, contains('unique (id, user_id)'));
    }
  });

  test('every Stage 3 table has explicit own-user CRUD policies', () {
    for (final table in tables) {
      for (final operation in const ['select', 'insert', 'update', 'delete']) {
        expect(
          migration,
          contains('create policy "${table}_${operation}_own"'),
          reason: '$table needs an explicit $operation policy.',
        );
      }
    }
    expect(migration.split('(select auth.uid()) = user_id'), hasLength(41));
  });

  test('all actual parent-child relationships enforce matching ownership', () {
    expect(
      migration,
      contains(
        'foreign key (active_session_id, user_id) references public.active_workout_sessions (id, user_id) on delete cascade',
      ),
    );
    expect(
      migration,
      contains(
        'foreign key (active_exercise_id, user_id) references public.active_workout_exercises (id, user_id) on delete cascade',
      ),
    );
    expect(
      migration,
      contains(
        'foreign key (completed_session_id, user_id) references public.completed_workout_sessions (id, user_id) on delete cascade',
      ),
    );
    expect(
      migration,
      contains(
        'foreign key (completed_exercise_id, user_id) references public.completed_workout_exercises (id, user_id) on delete cascade',
      ),
    );
    expect(
      migration,
      contains('personal_records_completed_exercise_owner_fkey'),
    );
    expect(migration, contains('personal_record_events_record_owner_fkey'));
  });

  test('history snapshots do not depend on mutable templates or exercises', () {
    expect(migration, isNot(contains('references public.workout_templates')));
    expect(migration, isNot(contains('references public.custom_exercises')));
    expect(migration, contains('source_template_id uuid'));
    expect(migration, contains('custom_exercise_id uuid'));
    expect(migration, contains('exercise_name text not null'));
    expect(migration, contains('exercise_key text not null'));
  });

  test('set, timer, totals, and Epley fields are constrained', () {
    expect(
      migration,
      contains("set_type in ('warm_up', 'working', 'drop_set', 'failure_set')"),
    );
    expect(
      migration,
      contains("rest_timer_state in ('idle', 'running', 'paused', 'expired')"),
    );
    expect(migration, contains('active_workout_sessions_timer_state_check'));
    expect(migration, contains('total_repetitions bigint not null default 0'));
    expect(
      migration,
      contains('total_volume_kg numeric(18, 3) not null default 0'),
    );
    expect(migration, contains('estimated_one_rep_max_kg numeric(18, 3)'));
    expect(migration, contains("'epley: weight_kg * (1 + repetitions / 30)'"));
    expect(
      migration,
      contains('is_personal_record boolean not null default false'),
    );
  });

  test('personal records have deterministic current and event identities', () {
    for (final kind in const [
      'heaviest_weight',
      'most_reps_at_weight',
      'estimated_1rm',
      'set_volume',
      'exercise_workout_volume',
    ]) {
      expect(migration, contains("'$kind'"));
    }
    expect(
      migration,
      contains('unique (user_id, exercise_key, record_kind, record_scope)'),
    );
    expect(migration, contains('unique (user_id, event_key)'));
    expect(
      migration.split("record_scope text not null default 'overall'"),
      hasLength(3),
    );
    expect(
      migration,
      contains("record_scope = 'weight_kg:' || weight_kg::text"),
    );
    expect(migration, contains('personal_record_events_scope_check'));
    expect(migration, contains('source_active_session_id uuid'));
    expect(migration, contains('source_active_exercise_id uuid'));
    expect(migration, contains('source_active_set_id uuid'));
  });

  test('custom exercise alias fields are additive, indexed, and private', () {
    expect(
      migration,
      contains(
        "add column if not exists aliases text[] not null default '{}'::text[]",
      ),
    );
    expect(
      migration,
      contains(
        "add column if not exists search_keywords text[] not null default '{}'::text[]",
      ),
    );
    expect(migration, contains('custom_exercises_aliases_gin_idx'));
    expect(migration, contains('custom_exercises_search_keywords_gin_idx'));
  });

  test('all Stage 3 rows reject stale or duplicate versions', () {
    expect(migration, contains('function public.guard_stage_3_version()'));
    expect(migration, contains('if new.version <= old.version then'));
    for (final table in tables) {
      expect(
        migration,
        contains(
          'before update on public.$table for each row execute function public.guard_stage_3_version()',
        ),
      );
    }
  });

  test('frozen Stage 1 and Stage 2 migrations contain no Stage 3 schema', () {
    final stage1 = File(
      'supabase/migrations/0001_initial_schema.sql',
    ).readAsStringSync();
    final stage2 = File(
      'supabase/migrations/0002_stage_2_workout_planning.sql',
    ).readAsStringSync();

    expect(
      _sha256('supabase/migrations/0001_initial_schema.sql'),
      '3CA7F180B64C2B0AA649EA8B32AAA3D274242AF6D355D7504BFB1C1009F50A33',
    );
    expect(
      _sha256('supabase/migrations/0002_stage_2_workout_planning.sql'),
      'E30FA7C0871E7531A300F7B2382A71F7976C14E00B54EB2EAEE277E77D35BA81',
    );
    for (final table in tables) {
      expect(stage1, isNot(contains(table)));
      expect(stage2, isNot(contains(table)));
    }
  });

  test('migration contains no privileged credential material', () {
    expect(migration, isNot(contains('service_role')));
    expect(migration, isNot(contains('database password')));
    expect(migration, isNot(contains('private signing key')));
  });
}
