import 'dart:async';
import 'dart:io';

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
  test('retry policy increases exponentially and caps deterministically', () {
    const policy = SyncRetryPolicy(
      initialDelay: Duration(seconds: 1),
      maximumDelay: Duration(seconds: 8),
    );

    expect(policy.delayForFailure(1), const Duration(seconds: 1));
    expect(policy.delayForFailure(2), const Duration(seconds: 2));
    expect(policy.delayForFailure(3), const Duration(seconds: 4));
    expect(policy.delayForFailure(4), const Duration(seconds: 8));
    expect(policy.delayForFailure(20), const Duration(seconds: 8));
    expect(() => policy.delayForFailure(0), throwsArgumentError);
  });

  test(
    'delayed retries preserve pending data, cap, succeed, and stay idempotent',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final remote = _RetryRemote()..failuresRemaining = 4;
      final repository = OfflineFirstWorkoutRepository(
        database: database,
        remote: remote,
        idGenerator: _IdSequence().next,
      );
      await _save(repository, 'Bench press');
      final scheduler = _ManualRetryScheduler();
      final coordinator = SyncCoordinator(
        repository: repository,
        connectivityChanges: const Stream.empty(),
        retryPolicy: const SyncRetryPolicy(
          initialDelay: Duration(seconds: 1),
          maximumDelay: Duration(seconds: 4),
        ),
        retryScheduler: scheduler,
      );
      addTearDown(coordinator.dispose);

      await coordinator.sync(_userId);
      expect(await repository.pendingCount(_userId), 1);
      expect(scheduler.activeDelay, const Duration(seconds: 1));

      scheduler.fireActive();
      await _waitFor(() => scheduler.activeDelay == const Duration(seconds: 2));
      expect(await repository.pendingCount(_userId), 1);

      scheduler.fireActive();
      await _waitFor(() => scheduler.activeDelay == const Duration(seconds: 4));
      expect(await repository.pendingCount(_userId), 1);

      scheduler.fireActive();
      await _waitFor(
        () =>
            coordinator.consecutiveFailures == 4 &&
            scheduler.activeDelay == const Duration(seconds: 4),
      );
      expect(await repository.pendingCount(_userId), 1);

      remote.failuresRemaining = 0;
      scheduler.fireActive();
      await _waitFor(
        () => coordinator.currentStatus.state == SyncState.everythingSynced,
      );

      expect(await repository.pendingCount(_userId), 0);
      expect(coordinator.consecutiveFailures, 0);
      expect(coordinator.scheduledRetryDelay, isNull);
      expect(remote.workouts, hasLength(1));
      expect(remote.workoutSets, hasLength(1));
      expect(
        remote.workoutUpsertCalls,
        5,
        reason:
            'Every retry reused the same UUID rather than inserting copies.',
      );
    },
  );

  test(
    'connectivity and a new local mutation supersede a delayed retry',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final remote = _RetryRemote()..failuresRemaining = 1;
      final repository = OfflineFirstWorkoutRepository(
        database: database,
        remote: remote,
        idGenerator: _IdSequence().next,
      );
      await _save(repository, 'Squat');
      final connectivity =
          StreamController<List<ConnectivityResult>>.broadcast();
      addTearDown(connectivity.close);
      final scheduler = _ManualRetryScheduler();
      final coordinator = SyncCoordinator(
        repository: repository,
        connectivityChanges: connectivity.stream,
        retryScheduler: scheduler,
      );
      addTearDown(coordinator.dispose);

      await coordinator.sync(_userId);
      expect(scheduler.activeDelay, isNotNull);
      expect(await repository.pendingCount(_userId), 1);

      remote.failuresRemaining = 0;
      connectivity.add(const [ConnectivityResult.wifi]);
      await _waitFor(
        () => coordinator.currentStatus.state == SyncState.everythingSynced,
      );
      expect(scheduler.activeDelay, isNull);

      // A newly queued mutation uses the same immediate, force-after-current
      // trigger used by the production forms.
      await _save(repository, 'Deadlift');
      await coordinator.sync(_userId, forceAfterCurrent: true);
      expect(await repository.pendingCount(_userId), 0);
      expect(remote.workouts, hasLength(2));
      expect(remote.workoutSets, hasLength(2));
    },
  );
}

Future<void> _save(
  OfflineFirstWorkoutRepository repository,
  String exercise,
) async {
  await repository.saveWorkout(
    userId: _userId,
    exerciseName: exercise,
    weight: 80,
    reps: 5,
    performedAt: DateTime.utc(2026, 7, 22, 10),
  );
}

Future<void> _waitFor(bool Function() condition) async {
  for (var attempt = 0; attempt < 100; attempt++) {
    if (condition()) return;
    await Future<void>.delayed(Duration.zero);
  }
  fail('Timed out waiting for the deterministic async operation.');
}

class _ManualRetryScheduler implements SyncRetryScheduler {
  _ManualScheduledRetry? _active;

  Duration? get activeDelay =>
      _active?.isCancelled == false ? _active?.delay : null;

  @override
  ScheduledSyncRetry schedule(Duration delay, void Function() callback) {
    final retry = _ManualScheduledRetry(delay, callback);
    _active = retry;
    return retry;
  }

  void fireActive() {
    final active = _active;
    if (active == null || active.isCancelled) {
      fail('No retry was scheduled.');
    }
    _active = null;
    active.fire();
  }
}

class _ManualScheduledRetry implements ScheduledSyncRetry {
  _ManualScheduledRetry(this.delay, this._callback);

  final Duration delay;
  final void Function() _callback;
  bool isCancelled = false;

  void fire() {
    if (!isCancelled) _callback();
  }

  @override
  void cancel() => isCancelled = true;
}

class _RetryRemote implements RemoteWorkoutDataSource {
  final Map<String, WorkoutEntry> workouts = {};
  final Map<String, WorkoutSetEntry> workoutSets = {};
  int failuresRemaining = 0;
  int workoutUpsertCalls = 0;

  @override
  Future<List<WorkoutEntry>> fetchWorkouts(String userId) async => const [];

  @override
  Future<void> upsertWorkout(WorkoutEntry workout) async {
    workoutUpsertCalls++;
    workouts[workout.id] = workout;
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw const SocketException('offline');
    }
  }

  @override
  Future<void> upsertWorkoutSet(WorkoutSetEntry workoutSet) async {
    workoutSets[workoutSet.id] = workoutSet;
  }
}

class _IdSequence {
  var _value = 1;

  String next() {
    final value = _value++;
    return '90000000-0000-4000-8000-${value.toString().padLeft(12, '0')}';
  }
}
