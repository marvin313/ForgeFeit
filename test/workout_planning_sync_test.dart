import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/core/database/app_database.dart';
import 'package:forgefit/core/sync/sync_coordinator.dart';
import 'package:forgefit/features/planning/data/offline_first_planning_repository.dart';
import 'package:forgefit/features/planning/domain/planning_models.dart';
import 'package:forgefit/features/planning/domain/system_exercise_catalog.dart';
import 'package:forgefit/features/workouts/data/offline_first_workout_repository.dart';
import 'package:forgefit/features/workouts/data/remote_workout_data_source.dart';
import 'package:forgefit/features/workouts/domain/workout_entry.dart';

import 'workout_planning_repository_test.dart' show StrictFakePlanningRemote;

const _userA = '10000000-0000-4000-8000-000000000011';
const _userB = '10000000-0000-4000-8000-000000000012';

void main() {
  test(
    'durable outbox survives repository recreation and version guard keeps a newer edit',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final remote = _RetryingPlanningRemote();
      final ids = _UuidSequence(1);
      final firstRepository = OfflineFirstPlanningRepository(
        database: database,
        remote: remote,
        idGenerator: ids.next,
        clock: _TestClock().now,
      );
      final split = await firstRepository.createSplit(
        userId: _userA,
        name: 'Offline program',
      );
      final oldUpload = (await firstRepository.pendingUploads(_userA)).single;
      expect(oldUpload.entityVersion, 1);
      expect(remote.splits, isEmpty);

      final recreatedRepository = OfflineFirstPlanningRepository(
        database: database,
        remote: remote,
        idGenerator: ids.next,
        clock: _TestClock(startSecond: 100).now,
      );
      expect(await recreatedRepository.pendingCount(_userA), 1);
      final edited = await recreatedRepository.updateSplit(
        userId: _userA,
        splitId: split.id,
        name: 'Edited while upload runs',
        description: 'The newer local value must stay queued.',
        icon: split.icon,
        colorValue: split.colorValue,
      );
      expect(edited.version, 2);

      final removed = await recreatedRepository.completeUpload(
        oldUpload.queueId,
        oldUpload.entityVersion,
      );
      expect(removed, isFalse);
      final remaining = (await recreatedRepository.pendingUploads(
        _userA,
      )).single;
      expect(remaining.entityId, split.id);
      expect(remaining.entityVersion, 2);
      expect(
        (remaining.entity as WorkoutSplit).name,
        'Edited while upload runs',
      );
    },
  );

  test(
    'combined coordinator retries on reconnect and stable UUID upserts prevent duplicates',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final planningRemote = _RetryingPlanningRemote()
        ..failAfterNextSplitUpsert = true;
      final workoutRemote = _FakeWorkoutRemote();
      final planningRepository = OfflineFirstPlanningRepository(
        database: database,
        remote: planningRemote,
        idGenerator: _UuidSequence(100).next,
        clock: _TestClock().now,
      );
      final workoutRepository = OfflineFirstWorkoutRepository(
        database: database,
        remote: workoutRemote,
        idGenerator: _UuidSequence(500).next,
      );
      final connectivity = StreamController<List<ConnectivityResult>>();
      addTearDown(connectivity.close);
      final coordinator = SyncCoordinator(
        repository: workoutRepository,
        planningRepository: planningRepository,
        connectivityChanges: connectivity.stream,
      );
      addTearDown(coordinator.dispose);

      await workoutRepository.saveWorkout(
        userId: _userA,
        exerciseName: 'Bench press',
        weight: 80,
        reps: 5,
        performedAt: DateTime.utc(2026, 7, 22, 10),
      );
      final split = await planningRepository.createSplit(
        userId: _userA,
        name: 'Reconnect routine',
      );
      final template = await planningRepository.createTemplate(
        userId: _userA,
        splitId: split.id,
        name: 'Mixed day',
      );
      await planningRepository.addExerciseToTemplate(
        userId: _userA,
        templateId: template.id,
        exercise: SystemExerciseCatalog.byKey('stationary_bike')!,
      );

      await coordinator.sync(_userA);
      expect(coordinator.currentStatus.state, SyncState.changesWaiting);
      expect(coordinator.currentStatus.errorMessage, contains('offline'));
      expect(workoutRemote.workouts, hasLength(1));
      expect(workoutRemote.workoutSets, hasLength(1));
      expect(planningRemote.splits, hasLength(1));
      expect(planningRemote.splitUpsertCalls, 1);
      expect(await planningRepository.pendingCount(_userA), 3);

      final fullySynced = coordinator.statuses.firstWhere(
        (status) => status.state == SyncState.everythingSynced,
      );
      connectivity.add(const [ConnectivityResult.wifi]);
      await fullySynced.timeout(const Duration(seconds: 5));

      expect(await workoutRepository.pendingCount(_userA), 0);
      expect(await planningRepository.pendingCount(_userA), 0);
      expect(planningRemote.splits, hasLength(1));
      expect(planningRemote.templates, hasLength(1));
      expect(planningRemote.templateExercises, hasLength(1));
      expect(planningRemote.splitUpsertCalls, 2);
      expect(
        planningRemote.splits.keys.single,
        split.id,
        reason: 'retry updates the stable UUID instead of inserting a copy',
      );

      await coordinator.sync(_userA);
      expect(planningRemote.splitUpsertCalls, 2);
      expect(workoutRemote.workoutUpsertCalls, 1);
      expect(workoutRemote.setUpsertCalls, 1);
    },
  );

  test(
    'restore rebuilds a fresh database, is idempotent, and remains user isolated',
    () async {
      final remote = _RetryingPlanningRemote();
      final sourceDatabase = AppDatabase(NativeDatabase.memory());
      var sourceClosed = false;
      addTearDown(() async {
        if (!sourceClosed) await sourceDatabase.close();
      });
      final sourceRepository = OfflineFirstPlanningRepository(
        database: sourceDatabase,
        remote: remote,
        idGenerator: _UuidSequence(1000).next,
        clock: _TestClock().now,
      );
      final split = await sourceRepository.createSplit(
        userId: _userA,
        name: 'Cloud program',
      );
      final custom = await sourceRepository.createCustomExercise(
        userId: _userA,
        name: 'Private cable rotation',
        primaryMuscleGroup: MuscleGroup.core,
        secondaryMuscleGroups: const [MuscleGroup.shoulders],
        equipment: ExerciseEquipment.cable,
        aliases: const ['cable anti-rotation', 'Pallof variation'],
        keywords: const ['obliques', 'trunk stability'],
        isFavourite: true,
      );
      final template = await sourceRepository.createTemplate(
        userId: _userA,
        splitId: split.id,
        name: 'Restorable day',
      );
      final entry = await sourceRepository.addExerciseToTemplate(
        userId: _userA,
        templateId: template.id,
        exercise: custom.selection,
        configuration: const TemplateExerciseConfiguration(
          workingSets: 4,
          warmupSets: 1,
          targetRepsMin: 10,
          targetRepsMax: 15,
          targetWeight: 22.5,
          restSeconds: 75,
          rpeTarget: 8,
          rirTarget: 2,
          notes: 'Control the return',
        ),
      );
      await _flush(sourceRepository, _userA);
      await sourceDatabase.close();
      sourceClosed = true;

      await remote.upsertWorkoutSplit(
        WorkoutSplit(
          id: '30000000-0000-4000-8000-000000000099',
          userId: _userB,
          name: 'Other user private split',
          icon: 'folder',
          colorValue: 0xFF169BFF,
          sortOrder: 0,
          createdAt: DateTime.utc(2026, 7, 22),
          updatedAt: DateTime.utc(2026, 7, 22),
          version: 1,
        ),
      );

      final freshDatabase = AppDatabase(NativeDatabase.memory());
      addTearDown(freshDatabase.close);
      final restoredRepository = OfflineFirstPlanningRepository(
        database: freshDatabase,
        remote: remote,
        idGenerator: _UuidSequence(2000).next,
        clock: _TestClock(startSecond: 500).now,
      );
      await restoredRepository.restore(_userA);
      await restoredRepository.restore(_userA);

      final restored = await restoredRepository.getSnapshot(_userA);
      expect(restored.splits.map((item) => item.id), [split.id]);
      expect(restored.templates.map((item) => item.id), [template.id]);
      expect(restored.customExercises.map((item) => item.id), [custom.id]);
      expect(restored.customExercises.single.aliases, custom.aliases);
      expect(restored.customExercises.single.keywords, custom.keywords);
      expect(
        restored.customExercises.single.selection.matchesSearch(
          'PALLOF variation',
        ),
        isTrue,
      );
      expect(restored.templateExercises.map((item) => item.id), [entry.id]);
      expect(restored.templateExercises.single.workingSets, 4);
      expect(restored.templateExercises.single.targetWeight, 22.5);
      expect(await restoredRepository.pendingCount(_userA), 0);
      expect(
        restored.splits.map((item) => item.name),
        isNot(contains('Other user private split')),
      );
    },
  );

  test(
    'restore never overwrites an entity with a pending local edit',
    () async {
      final remote = _RetryingPlanningRemote();
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = OfflineFirstPlanningRepository(
        database: database,
        remote: remote,
        idGenerator: _UuidSequence(3000).next,
        clock: _TestClock().now,
      );
      final split = await repository.createSplit(
        userId: _userA,
        name: 'Initial cloud name',
      );
      await _flush(repository, _userA);

      final locallyEdited = await repository.updateSplit(
        userId: _userA,
        splitId: split.id,
        name: 'Pending local name',
        description: 'Offline edit',
        icon: split.icon,
        colorValue: split.colorValue,
      );
      await remote.upsertWorkoutSplit(
        WorkoutSplit(
          id: split.id,
          userId: _userA,
          name: 'Conflicting cloud name',
          description: null,
          icon: split.icon,
          colorValue: split.colorValue,
          sortOrder: split.sortOrder,
          createdAt: split.createdAt,
          updatedAt: locallyEdited.updatedAt.add(const Duration(minutes: 1)),
          version: locallyEdited.version + 10,
        ),
      );

      await repository.restore(_userA);
      await repository.restore(_userA);
      final local = (await repository.getSnapshot(_userA)).splits.single;
      expect(local.name, 'Pending local name');
      expect(local.description, 'Offline edit');
      expect(local.version, locallyEdited.version);
      expect(await repository.pendingCount(_userA), 1);

      await _flush(repository, _userA);
      final resolved = (await repository.getSnapshot(_userA)).splits.single;
      expect(resolved.name, 'Conflicting cloud name');
      expect(resolved.version, locallyEdited.version + 10);
      expect(await repository.pendingCount(_userA), 0);
    },
  );

  test(
    'a stale restore response cannot regress a cleared local edit',
    () async {
      final remote = _RetryingPlanningRemote();
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final repository = OfflineFirstPlanningRepository(
        database: database,
        remote: remote,
        idGenerator: _UuidSequence(4000).next,
        clock: _TestClock().now,
      );
      final split = await repository.createSplit(
        userId: _userA,
        name: 'Cloud version one',
      );
      await _flush(repository, _userA);
      remote.snapshotOverride = await remote.fetchSnapshot(_userA);

      final edited = await repository.updateSplit(
        userId: _userA,
        splitId: split.id,
        name: 'Local version two',
        description: null,
        icon: split.icon,
        colorValue: split.colorValue,
      );
      final upload = (await repository.pendingUploads(_userA)).single;
      await repository.upload(upload);
      await repository.completeUpload(upload.queueId, upload.entityVersion);
      expect(await repository.pendingCount(_userA), 0);

      await repository.restore(_userA);
      final afterStaleRestore = (await repository.getSnapshot(
        _userA,
      )).splits.single;
      expect(afterStaleRestore.name, 'Local version two');
      expect(afterStaleRestore.version, edited.version);
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

class _RetryingPlanningRemote extends StrictFakePlanningRemote {
  bool failAfterNextSplitUpsert = false;
  int splitUpsertCalls = 0;
  PlanningSnapshot? snapshotOverride;

  @override
  Future<WorkoutSplit> upsertWorkoutSplit(WorkoutSplit split) async {
    splitUpsertCalls++;
    final accepted = await super.upsertWorkoutSplit(split);
    if (failAfterNextSplitUpsert) {
      failAfterNextSplitUpsert = false;
      throw StateError('Device is offline');
    }
    return accepted;
  }

  @override
  Future<PlanningSnapshot> fetchSnapshot(String userId) async {
    return snapshotOverride ?? super.fetchSnapshot(userId);
  }
}

class _FakeWorkoutRemote implements RemoteWorkoutDataSource {
  final Map<String, WorkoutEntry> workouts = {};
  final Map<String, WorkoutSetEntry> workoutSets = {};
  int workoutUpsertCalls = 0;
  int setUpsertCalls = 0;

  @override
  Future<void> upsertWorkout(WorkoutEntry workout) async {
    workoutUpsertCalls++;
    workouts[workout.id] = WorkoutEntry(
      id: workout.id,
      userId: workout.userId,
      exerciseName: workout.exerciseName,
      performedAt: workout.performedAt,
      createdAt: workout.createdAt,
      updatedAt: workout.updatedAt,
      sets: const [],
    );
  }

  @override
  Future<void> upsertWorkoutSet(WorkoutSetEntry workoutSet) async {
    setUpsertCalls++;
    workoutSets[workoutSet.id] = workoutSet;
  }

  @override
  Future<List<WorkoutEntry>> fetchWorkouts(String userId) async {
    return workouts.values
        .where((workout) => workout.userId == userId)
        .map(
          (workout) => WorkoutEntry(
            id: workout.id,
            userId: workout.userId,
            exerciseName: workout.exerciseName,
            performedAt: workout.performedAt,
            createdAt: workout.createdAt,
            updatedAt: workout.updatedAt,
            sets: workoutSets.values
                .where(
                  (set) => set.userId == userId && set.workoutId == workout.id,
                )
                .toList(growable: false),
          ),
        )
        .toList(growable: false);
  }
}

class _UuidSequence {
  _UuidSequence(this._value);

  int _value;

  String next() {
    final suffix = _value.toRadixString(16).padLeft(12, '0');
    _value++;
    return '40000000-0000-4000-8000-$suffix';
  }
}

class _TestClock {
  _TestClock({this.startSecond = 0});

  final int startSecond;
  var _tick = 0;

  DateTime now() => DateTime.utc(
    2026,
    7,
    22,
    12,
  ).add(Duration(seconds: startSecond + _tick++));
}
