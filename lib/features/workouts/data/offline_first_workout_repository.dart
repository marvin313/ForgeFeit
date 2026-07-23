import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../domain/workout_entry.dart';
import 'remote_workout_data_source.dart';

typedef IdGenerator = String Function();

class PendingWorkoutUpload {
  const PendingWorkoutUpload({
    required this.queueId,
    required this.workout,
    required this.attemptCount,
    this.lastError,
  });

  final String queueId;
  final WorkoutEntry workout;
  final int attemptCount;
  final String? lastError;
}

class OfflineFirstWorkoutRepository {
  factory OfflineFirstWorkoutRepository({
    required AppDatabase database,
    required RemoteWorkoutDataSource remote,
    IdGenerator? idGenerator,
  }) => OfflineFirstWorkoutRepository._(
    database,
    remote,
    idGenerator ?? _generateUuid,
  );

  OfflineFirstWorkoutRepository._(
    this._database,
    this._remote,
    this._idGenerator,
  );

  final AppDatabase _database;
  final RemoteWorkoutDataSource _remote;
  final IdGenerator _idGenerator;

  Future<WorkoutEntry> saveWorkout({
    required String userId,
    required String exerciseName,
    required double weight,
    required int reps,
    required DateTime performedAt,
  }) async {
    final validatedUserId = userId.trim();
    final validatedName = exerciseName.trim();
    if (validatedUserId.isEmpty) {
      throw ArgumentError.value(userId, 'userId', 'User ID is required.');
    }
    if (validatedName.isEmpty || validatedName.length > 120) {
      throw ArgumentError.value(
        exerciseName,
        'exerciseName',
        'Exercise name must be between 1 and 120 characters.',
      );
    }
    if (!weight.isFinite || weight < 0) {
      throw ArgumentError.value(
        weight,
        'weight',
        'Weight must be a non-negative number.',
      );
    }
    if (reps <= 0) {
      throw ArgumentError.value(
        reps,
        'reps',
        'Reps must be greater than zero.',
      );
    }

    final workoutId = _idGenerator();
    final setId = _idGenerator();
    final queueId = _idGenerator();
    final now = DateTime.now().toUtc();
    final workout = WorkoutEntry(
      id: workoutId,
      userId: validatedUserId,
      exerciseName: validatedName,
      performedAt: performedAt.toUtc(),
      createdAt: now,
      updatedAt: now,
      sets: [
        WorkoutSetEntry(
          id: setId,
          workoutId: workoutId,
          userId: validatedUserId,
          weight: weight,
          reps: reps,
          createdAt: now,
          updatedAt: now,
        ),
      ],
    );

    await _database.transaction(() async {
      await _database
          .into(_database.workouts)
          .insert(
            WorkoutsCompanion.insert(
              id: workout.id,
              userId: workout.userId,
              exerciseName: workout.exerciseName,
              performedAt: workout.performedAt,
              createdAt: workout.createdAt,
              updatedAt: workout.updatedAt,
            ),
          );
      final workoutSet = workout.sets.single;
      await _database
          .into(_database.workoutSets)
          .insert(
            WorkoutSetsCompanion.insert(
              id: workoutSet.id,
              workoutId: workoutSet.workoutId,
              userId: workoutSet.userId,
              weight: workoutSet.weight,
              reps: workoutSet.reps,
              setOrder: Value(workoutSet.setOrder),
              createdAt: workoutSet.createdAt,
              updatedAt: workoutSet.updatedAt,
            ),
          );
      await _database
          .into(_database.syncQueue)
          .insert(
            SyncQueueCompanion.insert(
              id: queueId,
              workoutId: workout.id,
              userId: workout.userId,
              createdAt: now,
              updatedAt: now,
            ),
          );
    });

    return workout;
  }

  Stream<List<WorkoutEntry>> watchWorkouts(String userId) {
    final query = _database.select(_database.workouts).join([
      leftOuterJoin(
        _database.workoutSets,
        _database.workoutSets.workoutId.equalsExp(_database.workouts.id) &
            _database.workoutSets.userId.equalsExp(_database.workouts.userId),
      ),
    ]);
    query
      ..where(_database.workouts.userId.equals(userId))
      ..orderBy([
        OrderingTerm.desc(_database.workouts.performedAt),
        OrderingTerm.asc(_database.workoutSets.setOrder),
      ]);
    return query.watch().map(_entriesFromJoinedRows);
  }

  Future<List<WorkoutEntry>> getWorkouts(String userId) async {
    final query = _database.select(_database.workouts).join([
      leftOuterJoin(
        _database.workoutSets,
        _database.workoutSets.workoutId.equalsExp(_database.workouts.id) &
            _database.workoutSets.userId.equalsExp(_database.workouts.userId),
      ),
    ]);
    query
      ..where(_database.workouts.userId.equals(userId))
      ..orderBy([
        OrderingTerm.desc(_database.workouts.performedAt),
        OrderingTerm.asc(_database.workoutSets.setOrder),
      ]);
    return _entriesFromJoinedRows(await query.get());
  }

  Future<void> restore(String userId) async {
    final remoteWorkouts = await _remote.fetchWorkouts(userId);

    await _database.transaction(() async {
      final pendingRows = await (_database.select(
        _database.syncQueue,
      )..where((row) => row.userId.equals(userId))).get();
      final pendingWorkoutIds = {
        for (final pending in pendingRows) pending.workoutId,
      };
      final localWorkouts = {
        for (final workout in await (_database.select(
          _database.workouts,
        )..where((row) => row.userId.equals(userId))).get())
          workout.id: workout,
      };

      for (final workout in remoteWorkouts) {
        _validateRemoteOwnership(workout, userId);
        final local = localWorkouts[workout.id];
        if (pendingWorkoutIds.contains(workout.id) ||
            (local != null && local.updatedAt.isAfter(workout.updatedAt))) {
          continue;
        }

        await _database
            .into(_database.workouts)
            .insertOnConflictUpdate(
              WorkoutsCompanion.insert(
                id: workout.id,
                userId: workout.userId,
                exerciseName: workout.exerciseName,
                performedAt: workout.performedAt,
                createdAt: workout.createdAt,
                updatedAt: workout.updatedAt,
              ),
            );

        await (_database.delete(_database.workoutSets)..where(
              (row) =>
                  row.workoutId.equals(workout.id) & row.userId.equals(userId),
            ))
            .go();
        for (final workoutSet in workout.sets) {
          await _database
              .into(_database.workoutSets)
              .insertOnConflictUpdate(
                WorkoutSetsCompanion.insert(
                  id: workoutSet.id,
                  workoutId: workoutSet.workoutId,
                  userId: workoutSet.userId,
                  weight: workoutSet.weight,
                  reps: workoutSet.reps,
                  setOrder: Value(workoutSet.setOrder),
                  createdAt: workoutSet.createdAt,
                  updatedAt: workoutSet.updatedAt,
                ),
              );
        }
      }
    });
  }

  Future<int> pendingCount(String userId) async {
    final countExpression = _database.syncQueue.id.count();
    final query = _database.selectOnly(_database.syncQueue)
      ..addColumns([countExpression])
      ..where(_database.syncQueue.userId.equals(userId));
    final row = await query.getSingle();
    return row.read(countExpression) ?? 0;
  }

  /// Sync-facing API: returns durable queue items and their local aggregates.
  Future<List<PendingWorkoutUpload>> pendingUploads(String userId) async {
    final pendingRows =
        await (_database.select(_database.syncQueue)
              ..where((row) => row.userId.equals(userId))
              ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
            .get();
    if (pendingRows.isEmpty) {
      return const [];
    }

    final localWorkouts = await getWorkouts(userId);
    final workoutsById = {
      for (final workout in localWorkouts) workout.id: workout,
    };
    return [
      for (final pending in pendingRows)
        if (workoutsById[pending.workoutId] case final workout?)
          PendingWorkoutUpload(
            queueId: pending.id,
            workout: workout,
            attemptCount: pending.attemptCount,
            lastError: pending.lastError,
          ),
    ];
  }

  /// Uploads the parent before its children, using stable primary-key upserts.
  /// The queue row is deliberately left intact until [completeUpload].
  Future<void> upload(PendingWorkoutUpload pending) async {
    await _remote.upsertWorkout(pending.workout);
    final orderedSets = [...pending.workout.sets]
      ..sort((a, b) => a.setOrder.compareTo(b.setOrder));
    for (final workoutSet in orderedSets) {
      await _remote.upsertWorkoutSet(workoutSet);
    }
  }

  Future<void> completeUpload(String queueId) async {
    await (_database.delete(
      _database.syncQueue,
    )..where((row) => row.id.equals(queueId))).go();
  }

  Future<void> recordUploadFailure(String queueId, String error) async {
    final queueRow = await (_database.select(
      _database.syncQueue,
    )..where((row) => row.id.equals(queueId))).getSingleOrNull();
    if (queueRow == null) {
      return;
    }
    final now = DateTime.now().toUtc();
    await (_database.update(
      _database.syncQueue,
    )..where((row) => row.id.equals(queueId))).write(
      SyncQueueCompanion(
        attemptCount: Value(queueRow.attemptCount + 1),
        lastError: Value(error),
        lastAttemptAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  List<WorkoutEntry> _entriesFromJoinedRows(List<TypedResult> rows) {
    final bundles = <String, _WorkoutBundleBuilder>{};
    for (final result in rows) {
      final workout = result.readTable(_database.workouts);
      final builder = bundles.putIfAbsent(
        workout.id,
        () => _WorkoutBundleBuilder(workout),
      );
      final workoutSet = result.readTableOrNull(_database.workoutSets);
      if (workoutSet != null) {
        builder.sets.add(workoutSet);
      }
    }
    return bundles.values
        .map((builder) => builder.build())
        .toList(growable: false);
  }
}

class _WorkoutBundleBuilder {
  _WorkoutBundleBuilder(this.workout);

  final WorkoutRow workout;
  final List<WorkoutSetRow> sets = [];

  WorkoutEntry build() {
    return WorkoutEntry(
      id: workout.id,
      userId: workout.userId,
      exerciseName: workout.exerciseName,
      performedAt: workout.performedAt,
      createdAt: workout.createdAt,
      updatedAt: workout.updatedAt,
      sets: List.unmodifiable(
        sets.map(
          (workoutSet) => WorkoutSetEntry(
            id: workoutSet.id,
            workoutId: workoutSet.workoutId,
            userId: workoutSet.userId,
            weight: workoutSet.weight,
            reps: workoutSet.reps,
            setOrder: workoutSet.setOrder,
            createdAt: workoutSet.createdAt,
            updatedAt: workoutSet.updatedAt,
          ),
        ),
      ),
    );
  }
}

void _validateRemoteOwnership(WorkoutEntry workout, String expectedUserId) {
  if (workout.userId != expectedUserId) {
    throw StateError(
      'Remote workout ownership did not match the signed-in user.',
    );
  }
  for (final workoutSet in workout.sets) {
    if (workoutSet.userId != expectedUserId ||
        workoutSet.workoutId != workout.id) {
      throw StateError('Remote workout set ownership was inconsistent.');
    }
  }
}

String _generateUuid() => const Uuid().v4();
