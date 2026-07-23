import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late String migration;

  setUpAll(() {
    migration = File(
      'supabase/migrations/0002_stage_2_workout_planning.sql',
    ).readAsStringSync().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  });

  const tables = [
    'workout_splits',
    'workout_templates',
    'custom_exercises',
    'template_exercises',
  ];

  test('Stage 2 migration creates every user-owned planning table', () {
    for (final table in tables) {
      expect(
        migration,
        contains('create table if not exists public.$table'),
        reason: '$table must be created by the Stage 2 migration.',
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
    }
  });

  test('every planning table has explicit own-user CRUD policies', () {
    for (final table in tables) {
      for (final operation in const ['select', 'insert', 'update', 'delete']) {
        expect(
          migration,
          contains('create policy "${table}_${operation}_own"'),
          reason: '$table needs an explicit $operation policy.',
        );
      }
    }
    expect(migration.split('(select auth.uid()) = user_id'), hasLength(21));
  });

  test('child relationships enforce matching ownership without split cascade', () {
    expect(
      migration,
      contains(
        'foreign key (split_id, user_id) references public.workout_splits (id, user_id) on delete no action deferrable initially deferred',
      ),
    );
    expect(
      migration,
      contains(
        'foreign key (template_id, user_id) references public.workout_templates (id, user_id) on delete cascade',
      ),
    );
    expect(
      migration,
      contains(
        'foreign key (custom_exercise_id, user_id) references public.custom_exercises (id, user_id) on delete no action deferrable initially deferred',
      ),
    );
    expect(migration, contains('template_exercises_exactly_one_source_check'));
  });

  test('cloud updates atomically reject stale or duplicate versions', () {
    expect(migration, contains('function public.guard_planning_version()'));
    expect(migration, contains('if new.version <= old.version then'));
    for (final table in tables) {
      expect(
        migration,
        contains(
          'before update on public.$table for each row execute function public.guard_planning_version()',
        ),
      );
    }
  });

  test('mobile-only migration contains no privileged credentials', () {
    expect(migration, isNot(contains('service_role')));
    expect(migration, isNot(contains('database password')));
    expect(migration, isNot(contains('secret key')));
  });
}
