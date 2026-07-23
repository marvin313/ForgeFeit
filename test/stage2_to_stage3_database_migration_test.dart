import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/core/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

void main() {
  test(
    'schema 2 upgrades on disk without changing Stage 1 or 2 rows',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'forgefit-stage2-upgrade-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = File(
        '${directory.path}${Platform.pathSeparator}forgefit.db',
      );

      final created = AppDatabase(NativeDatabase(file));
      await created.customSelect('SELECT 1').getSingle();
      await created.close();

      final raw = sqlite.sqlite3.open(file.path);
      try {
        raw.execute('''
        PRAGMA foreign_keys = ON;
        INSERT INTO workouts (
          id, user_id, exercise_name, performed_at, created_at, updated_at
        ) VALUES (
          '20000000-0000-4000-8000-000000000093',
          '10000000-0000-4000-8000-000000000093',
          'Legacy quick log', 1784685600, 1784685600, 1784685600
        );
        INSERT INTO workout_splits (
          id, user_id, name, description, icon, color_value, sort_order,
          created_at, updated_at, version
        ) VALUES (
          '30000000-0000-4000-8000-000000000093',
          '10000000-0000-4000-8000-000000000093',
          'Preserved split', 'Stage 2 data', 'S', 4279708159, 0,
          1784685600, 1784685600, 1
        );
        INSERT INTO custom_exercises (
          id, user_id, name, primary_muscle_group,
          secondary_muscle_groups_json, equipment, instructions,
          personal_notes, is_favourite, created_at, updated_at, version
        ) VALUES (
          '40000000-0000-4000-8000-000000000093',
          '10000000-0000-4000-8000-000000000093',
          'Preserved custom press', 'chest', '["triceps"]', 'dumbbell',
          'Press safely', 'Keep the snapshot', 1,
          1784685600, 1784685600, 1
        );
        INSERT INTO workout_templates (
          id, user_id, split_id, name, icon, color_value, notes, sort_order,
          created_at, updated_at, version
        ) VALUES (
          '50000000-0000-4000-8000-000000000093',
          '10000000-0000-4000-8000-000000000093',
          '30000000-0000-4000-8000-000000000093',
          'Preserved template', 'T', 4279708159, 'Do not alter', 0,
          1784685600, 1784685600, 1
        );
        INSERT INTO template_exercises (
          id, user_id, template_id, custom_exercise_id, exercise_name,
          primary_muscle_group, equipment, working_sets, warmup_sets,
          target_reps_min, target_reps_max, rest_seconds, sort_order,
          created_at, updated_at, version
        ) VALUES (
          '60000000-0000-4000-8000-000000000093',
          '10000000-0000-4000-8000-000000000093',
          '50000000-0000-4000-8000-000000000093',
          '40000000-0000-4000-8000-000000000093',
          'Preserved custom press', 'chest', 'dumbbell', 3, 1, 8, 12, 90,
          0, 1784685600, 1784685600, 1
        );

        DROP TABLE personal_record_events;
        DROP TABLE personal_records;
        DROP TABLE completed_workout_sets;
        DROP TABLE completed_workout_exercises;
        DROP TABLE completed_workout_sessions;
        DROP TABLE active_workout_sets;
        DROP TABLE active_workout_exercises;
        DROP TABLE active_workout_sessions;
        DROP TABLE session_sync_queue;
        ALTER TABLE custom_exercises DROP COLUMN aliases_json;
        ALTER TABLE custom_exercises DROP COLUMN search_keywords_json;
        PRAGMA user_version = 2;
      ''');
      } finally {
        raw.close();
      }

      final upgraded = AppDatabase(NativeDatabase(file));
      addTearDown(upgraded.close);

      expect(
        (await upgraded.select(upgraded.workouts).get()).single.exerciseName,
        'Legacy quick log',
      );
      expect(
        (await upgraded.select(upgraded.workoutSplits).get()).single.name,
        'Preserved split',
      );
      final custom =
          (await upgraded.select(upgraded.customExercises).get()).single;
      expect(custom.name, 'Preserved custom press');
      expect(custom.aliasesJson, '[]');
      expect(custom.searchKeywordsJson, '[]');
      expect(
        (await upgraded.select(upgraded.workoutTemplates).get()).single.name,
        'Preserved template',
      );
      expect(
        (await upgraded.select(upgraded.templateExercises).get())
            .single
            .exerciseName,
        'Preserved custom press',
      );
      expect(
        await upgraded.select(upgraded.activeWorkoutSessions).get(),
        isEmpty,
      );
      expect(
        await upgraded.select(upgraded.completedWorkoutSessions).get(),
        isEmpty,
      );
      expect(await upgraded.select(upgraded.personalRecords).get(), isEmpty);
      final version = await upgraded
          .customSelect('PRAGMA user_version')
          .getSingle();
      expect(version.read<int>('user_version'), 3);
    },
  );
}
