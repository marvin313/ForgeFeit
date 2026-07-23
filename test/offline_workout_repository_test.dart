import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/core/database/app_database.dart';
import 'package:forgefit/core/sync/sync_coordinator.dart';
import 'package:forgefit/features/workouts/data/offline_first_workout_repository.dart';
import 'package:forgefit/features/workouts/data/remote_workout_data_source.dart';
import 'package:forgefit/features/workouts/domain/workout_entry.dart';

const _userId = '10000000-0000-4000-8000-000000000001';

void main() {
  late AppDatabase database;
  late _FakeRemoteWorkoutDataSource remote;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    remote = _FakeRemoteWorkoutDataSource();
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'save is atomic, local-first, and creates one durable outbox row',
    () async {
      final ids = _IdSequence([
        '20000000-0000-4000-8000-000000000001',
        '30000000-0000-4000-8000-000000000001',
        '40000000-0000-4000-8000-000000000001',
      ]);
      final repository = OfflineFirstWorkoutRepository(
        database: database,
        remote: remote,
        idGenerator: ids.next,
      );

      final saved = await repository.saveWorkout(
        userId: _userId,
        exerciseName: '  Back squat  ',
        weight: 82.5,
        reps: 5,
        performedAt: DateTime.utc(2026, 7, 21, 9, 30),
      );

      expect(saved.id, '20000000-0000-4000-8000-000000000001');
      expect(saved.sets.single.id, '30000000-0000-4000-8000-000000000001');
      expect(saved.exerciseName, 'Back squat');
      expect(await repository.pendingCount(_userId), 1);
      expect(remote.workouts, isEmpty);

      final history = await repository.getWorkouts(_userId);
      expect(history, hasLength(1));
      expect(history.single.weight, 82.5);
      expect(history.single.reps, 5);

      final watched = await repository
          .watchWorkouts(_userId)
          .firstWhere((entries) => entries.isNotEmpty);
      expect(watched.single.id, saved.id);
    },
  );

  test(
    'sync is single-flight and UUID upserts make a retry idempotent',
    () async {
      final ids = _IdSequence([
        '20000000-0000-4000-8000-000000000002',
        '30000000-0000-4000-8000-000000000002',
        '40000000-0000-4000-8000-000000000002',
      ]);
      final repository = OfflineFirstWorkoutRepository(
        database: database,
        remote: remote,
        idGenerator: ids.next,
      );
      await repository.saveWorkout(
        userId: _userId,
        exerciseName: 'Bench press',
        weight: 60,
        reps: 8,
        performedAt: DateTime.utc(2026, 7, 21, 10),
      );
      remote.failNextSetUpload = true;
      final coordinator = SyncCoordinator(
        repository: repository,
        connectivityChanges: const Stream<List<ConnectivityResult>>.empty(),
      );
      addTearDown(coordinator.dispose);

      await Future.wait([coordinator.sync(_userId), coordinator.sync(_userId)]);

      expect(coordinator.currentStatus.state, SyncState.changesWaiting);
      expect(coordinator.currentStatus.errorMessage, contains('offline'));
      expect(await repository.pendingCount(_userId), 1);
      expect(remote.workouts, hasLength(1));
      expect(remote.workoutSets, isEmpty);
      expect(remote.workoutUpsertCalls, 1);

      await coordinator.sync(_userId);

      expect(coordinator.currentStatus.state, SyncState.everythingSynced);
      expect(await repository.pendingCount(_userId), 0);
      expect(remote.workouts, hasLength(1));
      expect(remote.workoutSets, hasLength(1));
      expect(remote.workoutUpsertCalls, 2);
      expect(remote.setUpsertCalls, 2);

      await coordinator.sync(_userId);
      expect(remote.workoutUpsertCalls, 2);
      expect(remote.setUpsertCalls, 2);
    },
  );

  test(
    'restore is idempotent and never overwrites a locally pending bundle',
    () async {
      final cloudWorkout = _workout(
        id: '20000000-0000-4000-8000-000000000003',
        setId: '30000000-0000-4000-8000-000000000003',
        exerciseName: 'Deadlift',
        weight: 120,
        reps: 3,
      );
      remote.seed(cloudWorkout);
      final repository = OfflineFirstWorkoutRepository(
        database: database,
        remote: remote,
      );

      await repository.restore(_userId);
      await repository.restore(_userId);

      var history = await repository.getWorkouts(_userId);
      expect(history, hasLength(1));
      expect(history.single.id, cloudWorkout.id);
      expect(history.single.sets, hasLength(1));
      expect(await repository.pendingCount(_userId), 0);

      const localWorkoutId = '20000000-0000-4000-8000-000000000004';
      final localRepository = OfflineFirstWorkoutRepository(
        database: database,
        remote: remote,
        idGenerator: _IdSequence([
          localWorkoutId,
          '30000000-0000-4000-8000-000000000004',
          '40000000-0000-4000-8000-000000000004',
        ]).next,
      );
      await localRepository.saveWorkout(
        userId: _userId,
        exerciseName: 'Local pending name',
        weight: 70,
        reps: 10,
        performedAt: DateTime.utc(2026, 7, 21, 12),
      );
      remote.seed(
        _workout(
          id: localWorkoutId,
          setId: '30000000-0000-4000-8000-000000000099',
          exerciseName: 'Stale cloud name',
          weight: 1,
          reps: 1,
        ),
      );

      await localRepository.restore(_userId);
      await localRepository.restore(_userId);

      history = await localRepository.getWorkouts(_userId);
      final pending = history.singleWhere(
        (entry) => entry.id == localWorkoutId,
      );
      expect(history, hasLength(2));
      expect(pending.exerciseName, 'Local pending name');
      expect(pending.weight, 70);
      expect(pending.sets.single.id, '30000000-0000-4000-8000-000000000004');
      expect(await localRepository.pendingCount(_userId), 1);

      // Simulate a restore response captured just before an upload cleared its
      // outbox row. The old response must not regress the newer local bundle.
      final upload = (await localRepository.pendingUploads(_userId)).single;
      await localRepository.completeUpload(upload.queueId);
      await localRepository.restore(_userId);
      final afterRace = (await localRepository.getWorkouts(
        _userId,
      )).singleWhere((entry) => entry.id == localWorkoutId);
      expect(afterRace.exerciseName, 'Local pending name');
      expect(afterRace.weight, 70);
      expect(await localRepository.pendingCount(_userId), 0);
    },
  );
}

WorkoutEntry _workout({
  required String id,
  required String setId,
  required String exerciseName,
  required double weight,
  required int reps,
}) {
  final timestamp = DateTime.utc(2026, 7, 20, 8);
  return WorkoutEntry(
    id: id,
    userId: _userId,
    exerciseName: exerciseName,
    performedAt: timestamp,
    createdAt: timestamp,
    updatedAt: timestamp,
    sets: [
      WorkoutSetEntry(
        id: setId,
        workoutId: id,
        userId: _userId,
        weight: weight,
        reps: reps,
        createdAt: timestamp,
        updatedAt: timestamp,
      ),
    ],
  );
}

class _IdSequence {
  _IdSequence(this._ids);

  final List<String> _ids;
  var _index = 0;

  String next() => _ids[_index++];
}

class _FakeRemoteWorkoutDataSource implements RemoteWorkoutDataSource {
  final Map<String, WorkoutEntry> workouts = {};
  final Map<String, WorkoutSetEntry> workoutSets = {};

  bool failNextSetUpload = false;
  int workoutUpsertCalls = 0;
  int setUpsertCalls = 0;

  void seed(WorkoutEntry workout) {
    workouts[workout.id] = _withoutSets(workout);
    for (final workoutSet in workout.sets) {
      workoutSets[workoutSet.id] = workoutSet;
    }
  }

  @override
  Future<List<WorkoutEntry>> fetchWorkouts(String userId) async {
    final result = workouts.values
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
                  (workoutSet) =>
                      workoutSet.userId == userId &&
                      workoutSet.workoutId == workout.id,
                )
                .toList(),
          ),
        )
        .toList();
    result.sort((a, b) => b.performedAt.compareTo(a.performedAt));
    return result;
  }

  @override
  Future<void> upsertWorkout(WorkoutEntry workout) async {
    workoutUpsertCalls++;
    workouts[workout.id] = _withoutSets(workout);
  }

  @override
  Future<void> upsertWorkoutSet(WorkoutSetEntry workoutSet) async {
    setUpsertCalls++;
    if (failNextSetUpload) {
      failNextSetUpload = false;
      throw StateError('Device is offline');
    }
    workoutSets[workoutSet.id] = workoutSet;
  }
}

WorkoutEntry _withoutSets(WorkoutEntry workout) {
  return WorkoutEntry(
    id: workout.id,
    userId: workout.userId,
    exerciseName: workout.exerciseName,
    performedAt: workout.performedAt,
    createdAt: workout.createdAt,
    updatedAt: workout.updatedAt,
    sets: const [],
  );
}
