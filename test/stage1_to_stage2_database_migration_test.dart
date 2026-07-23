import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/core/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

void main() {
  test(
    'schema 1 upgrades through Stage 3 and preserves workout history',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'forgefit-stage1-upgrade-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File(
        '${directory.path}${Platform.pathSeparator}forgefit.db',
      );
      final raw = sqlite.sqlite3.open(file.path);
      try {
        raw.execute('''
        PRAGMA foreign_keys = ON;
        CREATE TABLE workouts (
          id TEXT NOT NULL PRIMARY KEY,
          user_id TEXT NOT NULL,
          exercise_name TEXT NOT NULL,
          performed_at INTEGER NOT NULL,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        );
        CREATE TABLE workout_sets (
          id TEXT NOT NULL PRIMARY KEY,
          workout_id TEXT NOT NULL REFERENCES workouts(id) ON DELETE CASCADE,
          user_id TEXT NOT NULL,
          weight REAL NOT NULL,
          reps INTEGER NOT NULL,
          set_order INTEGER NOT NULL DEFAULT 1,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL,
          UNIQUE (workout_id, set_order)
        );
        CREATE TABLE sync_queue (
          id TEXT NOT NULL PRIMARY KEY,
          workout_id TEXT NOT NULL REFERENCES workouts(id) ON DELETE CASCADE,
          user_id TEXT NOT NULL,
          attempt_count INTEGER NOT NULL DEFAULT 0,
          last_error TEXT,
          last_attempt_at INTEGER,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL,
          UNIQUE (workout_id)
        );
        INSERT INTO workouts VALUES (
          '20000000-0000-4000-8000-000000000090',
          '10000000-0000-4000-8000-000000000090',
          'Preserved bench press',
          1784685600,
          1784685600,
          1784685600
        );
        INSERT INTO workout_sets VALUES (
          '30000000-0000-4000-8000-000000000090',
          '20000000-0000-4000-8000-000000000090',
          '10000000-0000-4000-8000-000000000090',
          82.5,
          5,
          1,
          1784685600,
          1784685600
        );
        INSERT INTO sync_queue VALUES (
          '40000000-0000-4000-8000-000000000090',
          '20000000-0000-4000-8000-000000000090',
          '10000000-0000-4000-8000-000000000090',
          2,
          'offline',
          NULL,
          1784685600,
          1784685600
        );
        PRAGMA user_version = 1;
      ''');
      } finally {
        raw.close();
      }

      final database = AppDatabase(NativeDatabase(file));
      addTearDown(database.close);

      final workouts = await database.select(database.workouts).get();
      final sets = await database.select(database.workoutSets).get();
      final queue = await database.select(database.syncQueue).get();
      final version = await database
          .customSelect('PRAGMA user_version')
          .getSingle();

      expect(version.read<int>('user_version'), 3);
      expect(workouts, hasLength(1));
      expect(workouts.single.exerciseName, 'Preserved bench press');
      expect(sets, hasLength(1));
      expect(sets.single.weight, 82.5);
      expect(sets.single.reps, 5);
      expect(queue, hasLength(1));
      expect(queue.single.attemptCount, 2);
      expect(queue.single.lastError, 'offline');

      final stage2Tables = await database
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'table' "
            "AND name IN ('workout_splits', 'workout_templates', "
            "'custom_exercises', 'template_exercises', 'planner_sync_queue')",
          )
          .get();
      expect(stage2Tables.map((row) => row.read<String>('name')).toSet(), {
        'workout_splits',
        'workout_templates',
        'custom_exercises',
        'template_exercises',
        'planner_sync_queue',
      });

      final stage3Tables = await database
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'table' "
            "AND name IN ('active_workout_sessions', "
            "'active_workout_exercises', 'active_workout_sets', "
            "'completed_workout_sessions', 'completed_workout_exercises', "
            "'completed_workout_sets', 'personal_records', "
            "'personal_record_events', 'session_sync_queue')",
          )
          .get();
      expect(stage3Tables, hasLength(9));
    },
  );
}
