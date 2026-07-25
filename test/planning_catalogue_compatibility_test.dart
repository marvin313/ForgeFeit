import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/core/database/app_database.dart';
import 'package:forgefit/features/planning/data/offline_first_planning_repository.dart';
import 'package:forgefit/features/planning/data/remote_planning_data_source.dart';
import 'package:forgefit/features/planning/domain/planning_models.dart';
import 'package:forgefit/features/planning/domain/system_exercise_catalog.dart';

import 'workout_planning_repository_test.dart' show StrictFakePlanningRemote;

const _userId = '50000000-0000-4000-8000-000000000001';

const _supabaseMuscleGroups = {
  'chest',
  'back',
  'shoulders',
  'biceps',
  'triceps',
  'forearms',
  'quadriceps',
  'hamstrings',
  'glutes',
  'calves',
  'core',
  'full_body',
  'cardio',
  'mobility',
  'rehabilitation',
  'other',
};

const _supabaseEquipment = {
  'barbell',
  'dumbbell',
  'cable',
  'machine',
  'plate_loaded_machine',
  'selectorised_machine',
  'smith_machine',
  'bodyweight',
  'resistance_band',
  'kettlebell',
  'medicine_ball',
  'cardio_equipment',
  'other',
};

void main() {
  test(
    'every built-in exercise creates a Supabase-compatible template payload and reaches the remote adapter',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final remote = _CapturingPlanningRemote();
      final repository = OfflineFirstPlanningRepository(
        database: database,
        remote: remote,
        idGenerator: _Ids().next,
        clock: _Clock().now,
      );
      final template = await repository.createTemplate(
        userId: _userId,
        name: 'Complete catalogue contract',
      );

      for (final exercise in SystemExerciseCatalog.all) {
        expect(
          _supabaseMuscleGroups,
          contains(exercise.primaryMuscleGroup.wireValue),
          reason:
              '${exercise.name} (${exercise.exerciseId}) has an unsupported primary muscle group: ${exercise.primaryMuscleGroup.wireValue}',
        );
        expect(
          _supabaseEquipment,
          contains(exercise.equipment.wireValue),
          reason:
              '${exercise.name} (${exercise.exerciseId}) has an unsupported equipment value: ${exercise.equipment.wireValue}',
        );
        for (final secondary in exercise.secondaryMuscleGroups) {
          expect(
            _supabaseMuscleGroups,
            contains(secondary.wireValue),
            reason:
                '${exercise.name} (${exercise.exerciseId}) has an unsupported secondary muscle group: ${secondary.wireValue}',
          );
        }
        await repository.addExerciseToTemplate(
          userId: _userId,
          templateId: template.id,
          exercise: exercise,
        );
      }

      await _flush(repository, _userId);

      expect(
        remote.templatePayloads,
        hasLength(SystemExerciseCatalog.all.length),
      );
      for (final exercise in SystemExerciseCatalog.all) {
        final payload = remote.templatePayloadsBySystemKey[exercise.exerciseId];
        expect(
          payload,
          isNotNull,
          reason:
              '${exercise.name} (${exercise.exerciseId}) never reached the template exercise remote adapter.',
        );
        expect(payload!['exercise_source'], 'system');
        expect(payload['system_exercise_key'], exercise.exerciseId);
        expect(
          _supabaseMuscleGroups,
          contains(payload['primary_muscle_group']),
          reason:
              '${exercise.name} payload has an invalid primary muscle group.',
        );
        expect(
          _supabaseEquipment,
          contains(payload['equipment']),
          reason: '${exercise.name} payload has an invalid equipment value.',
        );
      }
    },
  );

  test('legacy aliases normalize to canonical planning cloud values', () {
    expect(muscleGroupFromWire('abs'), MuscleGroup.core);
    expect(muscleGroupFromWire('quads'), MuscleGroup.quadriceps);
    expect(muscleGroupFromWire('shoulder'), MuscleGroup.shoulders);
    expect(muscleGroupFromWire('full body'), MuscleGroup.fullBody);
    expect(
      exerciseEquipmentFromWire('plate-loaded machine'),
      ExerciseEquipment.plateLoadedMachine,
    );
    expect(
      exerciseEquipmentFromWire('selectorized machine'),
      ExerciseEquipment.selectorisedMachine,
    );
    expect(
      exerciseEquipmentFromWire('smith machine'),
      ExerciseEquipment.smithMachine,
    );
    expect(
      exerciseEquipmentFromWire('resistance band'),
      ExerciseEquipment.resistanceBand,
    );
    expect(
      exerciseEquipmentFromWire('medicine ball'),
      ExerciseEquipment.medicineBall,
    );
    expect(
      exerciseEquipmentFromWire('cardio'),
      ExerciseEquipment.cardioEquipment,
    );
  });

  test(
    'custom and legacy local template exercises serialize canonically and retry safely',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final remote = _CapturingPlanningRemote();
      final repository = OfflineFirstPlanningRepository(
        database: database,
        remote: remote,
        idGenerator: _Ids().next,
        clock: _Clock().now,
      );
      final template = await repository.createTemplate(
        userId: _userId,
        name: 'Legacy recovery',
      );
      final custom = await repository.createCustomExercise(
        userId: _userId,
        name: 'Private medicine-ball rehabilitation drill',
        primaryMuscleGroup: MuscleGroup.rehabilitation,
        secondaryMuscleGroups: const [MuscleGroup.shoulders],
        equipment: ExerciseEquipment.medicineBall,
        aliases: const ['rehab ball'],
        keywords: const ['shoulder recovery'],
      );
      final customEntry = await repository.addExerciseToTemplate(
        userId: _userId,
        templateId: template.id,
        exercise: custom.selection,
      );
      final systemEntry = await repository.addExerciseToTemplate(
        userId: _userId,
        templateId: template.id,
        exercise: SystemExerciseCatalog.byKey('barbell_bench_press')!,
      );
      await _flush(repository, _userId);

      expect(
        remote.customPayloads[custom.id]!['primary_muscle_group'],
        'rehabilitation',
      );
      expect(remote.customPayloads[custom.id]!['equipment'], 'medicine_ball');
      expect(
        remote.templatePayloads[customEntry.id]!['exercise_source'],
        'custom',
      );
      expect(
        remote.templatePayloads[customEntry.id]!['custom_exercise_id'],
        custom.id,
      );

      await (database.update(
        database.templateExercises,
      )..where((row) => row.id.equals(systemEntry.id))).write(
        const TemplateExercisesCompanion(
          primaryMuscleGroup: Value('abs'),
          equipment: Value('selectorized_machine'),
          version: Value(2),
        ),
      );
      final now = DateTime.utc(2026, 7, 25, 12);
      await database
          .into(database.plannerSyncQueue)
          .insert(
            PlannerSyncQueueCompanion.insert(
              id: '50000000-0000-4000-8000-000000009999',
              userId: _userId,
              entityType: PlanningEntityType.templateExercise.wireValue,
              entityId: systemEntry.id,
              entityVersion: 2,
              createdAt: now,
              updatedAt: now,
            ),
          );

      final retry = (await repository.pendingUploads(
        _userId,
      )).singleWhere((upload) => upload.entityId == systemEntry.id);
      await repository.upload(retry);
      await repository.completeUpload(retry.queueId, retry.entityVersion);

      final payload = remote.templatePayloads[systemEntry.id]!;
      expect(payload['primary_muscle_group'], 'core');
      expect(payload['equipment'], 'selectorised_machine');
      final repaired = (await repository.getSnapshot(
        _userId,
      )).templateExercises.singleWhere((entry) => entry.id == systemEntry.id);
      expect(repaired.primaryMuscleGroup, MuscleGroup.core);
      expect(repaired.equipment, ExerciseEquipment.selectorisedMachine);
      expect(await repository.pendingCount(_userId), 0);
    },
  );

  test(
    'restore preserves expanded categories, order, and exercise identity',
    () async {
      final remote = _CapturingPlanningRemote();
      final sourceDatabase = AppDatabase(NativeDatabase.memory());
      var sourceClosed = false;
      addTearDown(() async {
        if (!sourceClosed) await sourceDatabase.close();
      });
      final source = OfflineFirstPlanningRepository(
        database: sourceDatabase,
        remote: remote,
        idGenerator: _Ids().next,
        clock: _Clock().now,
      );
      final template = await source.createTemplate(
        userId: _userId,
        name: 'Expanded categories',
      );
      final custom = await source.createCustomExercise(
        userId: _userId,
        name: 'Private rehabilitation movement',
        primaryMuscleGroup: MuscleGroup.rehabilitation,
        equipment: ExerciseEquipment.medicineBall,
      );
      final plateLoaded = await source.addExerciseToTemplate(
        userId: _userId,
        templateId: template.id,
        exercise: SystemExerciseCatalog.byKey('plate_loaded_chest_press')!,
      );
      final mobility = await source.addExerciseToTemplate(
        userId: _userId,
        templateId: template.id,
        exercise: SystemExerciseCatalog.byKey('worlds_greatest_stretch')!,
      );
      final customEntry = await source.addExerciseToTemplate(
        userId: _userId,
        templateId: template.id,
        exercise: custom.selection,
      );
      await _flush(source, _userId);
      await sourceDatabase.close();
      sourceClosed = true;

      final freshDatabase = AppDatabase(NativeDatabase.memory());
      addTearDown(freshDatabase.close);
      final restored = OfflineFirstPlanningRepository(
        database: freshDatabase,
        remote: remote,
        idGenerator: _Ids().next,
        clock: _Clock().now,
      );
      await restored.restore(_userId);
      await restored.restore(_userId);

      final entries = (await restored.getSnapshot(_userId)).templateExercises;
      expect(entries.map((entry) => entry.id), [
        plateLoaded.id,
        mobility.id,
        customEntry.id,
      ]);
      expect(entries[0].systemExerciseKey, 'plate_loaded_chest_press');
      expect(entries[0].equipment, ExerciseEquipment.plateLoadedMachine);
      expect(entries[1].systemExerciseKey, 'worlds_greatest_stretch');
      expect(entries[1].primaryMuscleGroup, MuscleGroup.mobility);
      expect(entries[2].customExerciseId, custom.id);
      expect(entries[2].primaryMuscleGroup, MuscleGroup.rehabilitation);
      expect(entries[2].equipment, ExerciseEquipment.medicineBall);
    },
  );
}

Future<void> _flush(
  OfflineFirstPlanningRepository repository,
  String userId,
) async {
  for (final upload in await repository.pendingUploads(userId)) {
    await repository.upload(upload);
    await repository.completeUpload(upload.queueId, upload.entityVersion);
  }
}

class _CapturingPlanningRemote extends StrictFakePlanningRemote {
  final Map<String, Map<String, dynamic>> customPayloads = {};
  final Map<String, Map<String, dynamic>> templatePayloads = {};
  final Map<String, Map<String, dynamic>> templatePayloadsBySystemKey = {};

  @override
  Future<CustomExercise> upsertCustomExercise(CustomExercise exercise) async {
    customPayloads[exercise.id] = customExerciseUpsertPayload(exercise);
    return super.upsertCustomExercise(exercise);
  }

  @override
  Future<TemplateExercise> upsertTemplateExercise(
    TemplateExercise exercise,
  ) async {
    final payload = templateExerciseUpsertPayload(exercise);
    templatePayloads[exercise.id] = payload;
    if (exercise.systemExerciseKey case final key?) {
      templatePayloadsBySystemKey[key] = payload;
    }
    return super.upsertTemplateExercise(exercise);
  }
}

class _Ids {
  var value = 1;

  String next() {
    final suffix = value.toRadixString(16).padLeft(12, '0');
    value++;
    return '50000000-0000-4000-8000-$suffix';
  }
}

class _Clock {
  var tick = 0;

  DateTime now() => DateTime.utc(2026, 7, 25).add(Duration(seconds: tick++));
}
