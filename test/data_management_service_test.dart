import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/core/database/app_database.dart';
import 'package:forgefit/features/data_tools/data/data_management_service.dart';

void main() {
  late AppDatabase database;
  late DataManagementService service;
  final now = DateTime.utc(2026, 7, 25, 12);

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    service = DataManagementService(database: database, clock: () => now);
  });

  tearDown(() => database.close());

  test(
    'versioned JSON backup preserves all required relationships without secrets',
    () async {
      await _seed(database, now);

      final backup = await service.createJsonBackup('user-a');
      final document = jsonDecode(backup.text) as Map<String, dynamic>;
      final data = document['data'] as Map<String, dynamic>;

      expect(document['format'], DataManagementService.format);
      expect(document['version'], DataManagementService.version);
      expect(backup.filename, 'forgefit_backup_20260725_120000.json');
      expect(data['workoutSplits'], hasLength(1));
      expect(data['workoutTemplates'], hasLength(1));
      expect(data['templateExercises'], hasLength(1));
      expect(data['customExercises'], hasLength(1));
      expect(data['completedWorkoutSessions'], hasLength(1));
      expect(data['completedWorkoutExercises'], hasLength(1));
      expect(data['completedWorkoutSets'], hasLength(1));
      expect(backup.text, isNot(contains('access_token')));
      expect(backup.text, isNot(contains('refresh_token')));
    },
  );

  test(
    'restore replaces local data atomically, keeps ordering, and rebuilds outboxes',
    () async {
      await _seed(database, now);
      final backup = await service.createJsonBackup('user-a');
      await database
          .into(database.workoutSplits)
          .insert(
            WorkoutSplitsCompanion.insert(
              id: 'replace-me',
              userId: 'user-a',
              name: 'Old',
              icon: 'old',
              colorValue: 1,
              createdAt: now,
              updatedAt: now,
            ),
          );

      await service.restoreJsonBackup(userId: 'user-a', jsonText: backup.text);
      final restored =
          jsonDecode((await service.createJsonBackup('user-a')).text)
              as Map<String, dynamic>;
      final data = restored['data'] as Map<String, dynamic>;

      expect((data['workoutSplits'] as List).map((row) => row['id']), [
        'split-1',
      ]);
      expect(
        (data['templateExercises'] as List).single['templateId'],
        'template-1',
      );
      expect(
        (data['completedWorkoutSets'] as List).single['sessionExerciseId'],
        'completed-exercise-1',
      );
      expect(
        await (database.select(
          database.plannerSyncQueue,
        )..where((row) => row.userId.equals('user-a'))).get(),
        isNotEmpty,
      );
      expect(
        await (database.select(
          database.sessionSyncQueue,
        )..where((row) => row.userId.equals('user-a'))).get(),
        isNotEmpty,
      );
    },
  );

  test('invalid backups leave existing local data unchanged', () async {
    await _seed(database, now);
    final original = await service.createJsonBackup('user-a');
    final malformed = <String, dynamic>{
      'format': DataManagementService.format,
      'version': DataManagementService.version,
      'data': {'workouts': <Object>[]},
    };

    await expectLater(
      service.restoreJsonBackup(
        userId: 'user-a',
        jsonText: jsonEncode(malformed),
      ),
      throwsA(isA<DataManagementException>()),
    );
    await expectLater(
      service.restoreJsonBackup(userId: 'user-a', jsonText: '{'),
      throwsA(isA<DataManagementException>()),
    );
    final futureVersion = jsonDecode(original.text) as Map<String, dynamic>;
    futureVersion['version'] = 2;
    await expectLater(
      service.restoreJsonBackup(
        userId: 'user-a',
        jsonText: jsonEncode(futureVersion),
      ),
      throwsA(isA<DataManagementException>()),
    );
    final invalidReference = jsonDecode(original.text) as Map<String, dynamic>;
    ((invalidReference['data'] as Map<String, dynamic>)['templateExercises']
                as List<dynamic>)
            .single['templateId'] =
        'missing-template';
    await expectLater(
      service.restoreJsonBackup(
        userId: 'user-a',
        jsonText: jsonEncode(invalidReference),
      ),
      throwsA(isA<DataManagementException>()),
    );
    expect((await service.createJsonBackup('user-a')).text, original.text);
  });

  test(
    'CSV has one completed-set row, ordering, and standard escaping',
    () async {
      await _seed(database, now);
      final csv = await service.createWorkoutCsv('user-a');

      expect(csv.filename, 'forgefit_workouts_20260725_120000.csv');
      expect(csv.text.split('\r\n').first, contains('workout_id'));
      expect(csv.text, contains('completed-1'));
      expect(csv.text, contains('"Finished, ""great""\nnotes"'));
      expect(csv.text, isNot(contains('access_token')));
    },
  );
}

Future<void> _seed(AppDatabase database, DateTime now) async {
  await database
      .into(database.workoutSplits)
      .insert(
        WorkoutSplitsCompanion.insert(
          id: 'split-1',
          userId: 'user-a',
          name: 'Strength',
          icon: 'bolt',
          colorValue: 1,
          sortOrder: const Value(2),
          createdAt: now,
          updatedAt: now,
        ),
      );
  await database
      .into(database.customExercises)
      .insert(
        CustomExercisesCompanion.insert(
          id: 'custom-1',
          userId: 'user-a',
          name: 'Cable, "Press"',
          primaryMuscleGroup: 'chest',
          equipment: 'cable',
          createdAt: now,
          updatedAt: now,
        ),
      );
  await database
      .into(database.workoutTemplates)
      .insert(
        WorkoutTemplatesCompanion.insert(
          id: 'template-1',
          userId: 'user-a',
          splitId: const Value('split-1'),
          name: 'Upper',
          icon: 'up',
          colorValue: 2,
          createdAt: now,
          updatedAt: now,
        ),
      );
  await database
      .into(database.templateExercises)
      .insert(
        TemplateExercisesCompanion.insert(
          id: 'template-exercise-1',
          userId: 'user-a',
          templateId: 'template-1',
          customExerciseId: const Value('custom-1'),
          exerciseName: 'Cable, "Press"',
          primaryMuscleGroup: 'chest',
          equipment: 'cable',
          createdAt: now,
          updatedAt: now,
        ),
      );
  await database
      .into(database.completedWorkoutSessions)
      .insert(
        CompletedWorkoutSessionsCompanion.insert(
          id: 'completed-1',
          userId: 'user-a',
          sourceTemplateId: const Value('template-1'),
          name: 'Upper',
          notes: const Value('Finished, "great"\nnotes'),
          weightUnit: const Value('kg'),
          startedAt: now.subtract(const Duration(hours: 1)),
          endedAt: now,
          durationSeconds: 3600,
          exerciseCount: 1,
          workingSetCount: 1,
          totalCompletedSets: 1,
          totalRepetitions: 8,
          totalVolumeKg: 400,
          createdAt: now,
          updatedAt: now,
        ),
      );
  await database
      .into(database.completedWorkoutExercises)
      .insert(
        CompletedWorkoutExercisesCompanion.insert(
          id: 'completed-exercise-1',
          userId: 'user-a',
          sessionId: 'completed-1',
          exerciseSource: 'custom',
          exerciseKey: 'custom:custom-1',
          customExerciseId: const Value('custom-1'),
          exerciseName: 'Cable, "Press"',
          primaryMuscleGroup: 'chest',
          equipment: 'cable',
          trackingType: 'weight_and_repetitions',
          weightRelevant: true,
          repetitionsRelevant: true,
          distanceRelevant: false,
          durationRelevant: false,
          bodyweightRelevant: false,
          sortOrder: const Value(1),
          completedSetCount: 1,
          workingSetCount: 1,
          totalRepetitions: 8,
          totalVolumeKg: 400,
          createdAt: now,
          updatedAt: now,
        ),
      );
  await database
      .into(database.completedWorkoutSets)
      .insert(
        CompletedWorkoutSetsCompanion.insert(
          id: 'completed-set-1',
          userId: 'user-a',
          sessionId: 'completed-1',
          sessionExerciseId: 'completed-exercise-1',
          setType: 'working',
          weightKg: const Value(50),
          repetitions: const Value(8),
          sortOrder: const Value(1),
          setVolumeKg: 400,
          completedAt: now,
          createdAt: now,
          updatedAt: now,
        ),
      );
}
