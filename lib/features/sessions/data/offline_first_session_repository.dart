import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../planning/domain/planning_models.dart';
import '../../planning/domain/system_exercise_catalog.dart';
import '../domain/workout_session_models.dart';
import 'remote_session_data_source.dart';

typedef SessionIdGenerator = String Function();
typedef SessionClock = DateTime Function();

class PendingSessionUpload {
  const PendingSessionUpload({
    required this.queueId,
    required this.userId,
    required this.entityType,
    required this.entityId,
    required this.entityVersion,
    required this.entity,
    required this.attemptCount,
    this.lastError,
  });

  final String queueId;
  final String userId;
  final SessionEntityType entityType;
  final String entityId;
  final int entityVersion;
  final Object entity;
  final int attemptCount;
  final String? lastError;
}

/// Local-first owner-scoped repository for Stage 3 workout sessions.
///
/// Every mutation updates SQLite and its coalescing outbox atomically. Active
/// rows are snapshots, so template or custom-exercise edits never rewrite an
/// in-progress or completed workout.
class OfflineFirstSessionRepository {
  factory OfflineFirstSessionRepository({
    required AppDatabase database,
    required RemoteSessionDataSource remote,
    SessionIdGenerator? idGenerator,
    SessionClock? clock,
  }) => OfflineFirstSessionRepository._(
    database,
    remote,
    idGenerator ?? const Uuid().v4,
    clock ?? DateTime.now,
  );

  OfflineFirstSessionRepository._(
    this._database,
    this._remote,
    this._newId,
    this._clock,
  );

  final AppDatabase _database;
  final RemoteSessionDataSource _remote;
  final SessionIdGenerator _newId;
  final SessionClock _clock;

  DateTime _now() => _clock().toUtc();

  Stream<ActiveWorkoutBundle?> watchActiveWorkout(String userId) {
    final owner = _requiredId(userId, 'userId');
    final query = _database.select(_database.activeWorkoutSessions)
      ..where((row) => row.userId.equals(owner) & row.deletedAt.isNull())
      ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)])
      ..limit(1);
    return query.watch().asyncMap((rows) async {
      if (rows.isEmpty) return null;
      return _activeBundle(rows.single);
    });
  }

  Stream<List<CompletedWorkoutSession>> watchCompletedSessions(String userId) {
    final owner = _requiredId(userId, 'userId');
    final query = _database.select(_database.completedWorkoutSessions)
      ..where((row) => row.userId.equals(owner) & row.deletedAt.isNull())
      ..orderBy([(row) => OrderingTerm.desc(row.endedAt)]);
    return query.watch().map(
      (rows) => List.unmodifiable(rows.map(_completedSessionFromRow)),
    );
  }

  Stream<List<PersonalRecord>> watchPersonalRecords(String userId) {
    final owner = _requiredId(userId, 'userId');
    final query = _database.select(_database.personalRecords)
      ..where((row) => row.userId.equals(owner) & row.deletedAt.isNull())
      ..orderBy([
        (row) => OrderingTerm.asc(row.exerciseName),
        (row) => OrderingTerm.asc(row.recordKind),
      ]);
    return query.watch().map(
      (rows) => List.unmodifiable(rows.map(_personalRecordFromRow)),
    );
  }

  Future<ActiveWorkoutBundle?> getActiveWorkout(String userId) async {
    final owner = _requiredId(userId, 'userId');
    final row =
        await (_database.select(_database.activeWorkoutSessions)
              ..where(
                (candidate) =>
                    candidate.userId.equals(owner) &
                    candidate.deletedAt.isNull(),
              )
              ..orderBy([(candidate) => OrderingTerm.desc(candidate.updatedAt)])
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : _activeBundle(row);
  }

  Future<CompletedWorkoutBundle> getCompletedWorkout({
    required String userId,
    required String sessionId,
  }) async {
    final owner = _requiredId(userId, 'userId');
    final id = _requiredId(sessionId, 'sessionId');
    final row =
        await (_database.select(_database.completedWorkoutSessions)..where(
              (candidate) =>
                  candidate.id.equals(id) & candidate.userId.equals(owner),
            ))
            .getSingleOrNull();
    if (row == null) throw StateError('Completed workout was not found.');
    return _completedBundle(row);
  }

  Future<ActiveWorkoutBundle> startEmptyWorkout({
    required String userId,
    String name = 'Empty Workout',
    String weightUnit = 'kg',
    String? notes,
  }) async {
    return _startWorkout(
      userId: userId,
      name: name,
      weightUnit: weightUnit,
      notes: notes,
      templateId: null,
      templateExercises: const [],
    );
  }

  Future<ActiveWorkoutBundle> startWorkoutFromTemplate({
    required String userId,
    required String templateId,
    String weightUnit = 'kg',
    String? notes,
  }) async {
    final owner = _requiredId(userId, 'userId');
    final id = _requiredId(templateId, 'templateId');
    final template =
        await (_database.select(_database.workoutTemplates)..where(
              (row) =>
                  row.id.equals(id) &
                  row.userId.equals(owner) &
                  row.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    if (template == null) throw StateError('Workout template was not found.');
    final entries =
        await (_database.select(_database.templateExercises)
              ..where(
                (row) =>
                    row.templateId.equals(id) &
                    row.userId.equals(owner) &
                    row.deletedAt.isNull(),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
            .get();
    return _startWorkout(
      userId: owner,
      name: template.name,
      weightUnit: weightUnit,
      notes: notes ?? template.notes,
      templateId: id,
      templateExercises: entries,
    );
  }

  Future<ActiveWorkoutBundle> _startWorkout({
    required String userId,
    required String name,
    required String weightUnit,
    required String? notes,
    required String? templateId,
    required List<TemplateExerciseRow> templateExercises,
  }) async {
    final owner = _requiredId(userId, 'userId');
    final existing = await getActiveWorkout(owner);
    if (existing != null) throw ActiveWorkoutAlreadyExists(existing);
    final now = _now();
    final session = ActiveWorkoutSession(
      id: _newId(),
      userId: owner,
      name: _requiredText(name, 'Workout name', 120),
      sourceTemplateId: templateId,
      startedAt: now,
      notes: _optionalText(notes, 4000),
      weightUnit: weightUnit == 'lb' ? 'lb' : 'kg',
      restTimerState: RestTimerState.idle,
      restTimerDurationSeconds: 0,
      restTimerRemainingSeconds: 0,
      autoStartRestTimer: true,
      createdAt: now,
      updatedAt: now,
      version: 1,
    );
    await _database.transaction(() async {
      await _insertActiveSession(session);
      await _enqueue(
        userId: owner,
        type: SessionEntityType.activeSession,
        entityId: session.id,
        entityVersion: 1,
        now: now,
      );
      for (var index = 0; index < templateExercises.length; index++) {
        final templateExercise = templateExercises[index];
        final selection = await _selectionForTemplateExercise(templateExercise);
        await _insertExerciseWithPlannedSets(
          session: session,
          selection: selection,
          configuration: TemplateExerciseConfiguration(
            workingSets: templateExercise.workingSets,
            warmupSets: templateExercise.warmupSets,
            targetRepsMin: templateExercise.targetRepsMin,
            targetRepsMax: templateExercise.targetRepsMax,
            targetWeight: templateExercise.targetWeight,
            restSeconds: templateExercise.restSeconds,
            rpeTarget: templateExercise.rpeTarget,
            rirTarget: templateExercise.rirTarget,
            notes: templateExercise.notes,
          ),
          sortOrder: index,
          now: now,
        );
      }
    });
    return (await getActiveWorkout(owner))!;
  }

  Future<ActiveWorkoutExercise> addExercise({
    required String userId,
    required String sessionId,
    required ExerciseSelection exercise,
    TemplateExerciseConfiguration configuration =
        const TemplateExerciseConfiguration(),
  }) async {
    final session = await _requireActiveSession(userId, sessionId);
    final rows = await (_database.select(
      _database.activeWorkoutExercises,
    )..where((row) => row.sessionId.equals(session.id))).get();
    final now = _now();
    late ActiveWorkoutExercise created;
    await _database.transaction(() async {
      created = await _insertExerciseWithPlannedSets(
        session: session,
        selection: exercise,
        configuration: configuration,
        sortOrder: rows.where((row) => row.deletedAt == null).length,
        now: now,
      );
      await _touchActiveSession(session, now);
    });
    return created;
  }

  Future<ActiveWorkoutExercise> replaceExercise({
    required String userId,
    required String exerciseId,
    required ExerciseSelection replacement,
  }) async {
    final current = await _requireActiveExercise(userId, exerciseId);
    final now = _now();
    final updated = ActiveWorkoutExercise(
      id: current.id,
      userId: current.userId,
      sessionId: current.sessionId,
      exerciseSource: replacement.source,
      exerciseKey: replacement.exerciseId,
      systemExerciseKey: replacement.systemExerciseKey,
      customExerciseId: replacement.customExerciseId,
      exerciseName: replacement.name,
      primaryMuscleGroup: replacement.primaryMuscleGroup,
      secondaryMuscleGroups: replacement.secondaryMuscleGroups,
      equipment: replacement.equipment,
      trackingType: replacement.trackingType,
      weightRelevant: replacement.weightRelevant,
      repetitionsRelevant: replacement.repetitionsRelevant,
      distanceRelevant: replacement.distanceRelevant,
      durationRelevant: replacement.durationRelevant,
      bodyweightRelevant: replacement.bodyweightRelevant,
      plannedWorkingSets: current.plannedWorkingSets,
      plannedWarmupSets: current.plannedWarmupSets,
      minTargetReps: current.minTargetReps,
      maxTargetReps: current.maxTargetReps,
      targetWeightKg: current.targetWeightKg,
      restSeconds: current.restSeconds,
      rpeTarget: current.rpeTarget,
      rirTarget: current.rirTarget,
      notes: current.notes,
      sortOrder: current.sortOrder,
      createdAt: current.createdAt,
      updatedAt: now,
      version: current.version + 1,
    );
    await _database.transaction(() async {
      await _upsertActiveExercise(updated);
      await _enqueueEntity(updated, SessionEntityType.activeExercise, now);
      await _touchSessionById(updated.userId, updated.sessionId, now);
    });
    return updated;
  }

  Future<void> removeExercise({
    required String userId,
    required String exerciseId,
  }) async {
    final exercise = await _requireActiveExercise(userId, exerciseId);
    final now = _now();
    await _database.transaction(() async {
      final sets = await (_database.select(
        _database.activeWorkoutSets,
      )..where((row) => row.sessionExerciseId.equals(exercise.id))).get();
      for (final row in sets.where((row) => row.deletedAt == null)) {
        final deleted = _activeSetFromRow(row, deletedAt: now);
        await _upsertActiveSet(deleted);
        await _enqueueEntity(deleted, SessionEntityType.activeSet, now);
      }
      final deleted = _copyActiveExercise(
        exercise,
        updatedAt: now,
        deletedAt: now,
        version: exercise.version + 1,
      );
      await _upsertActiveExercise(deleted);
      await _enqueueEntity(deleted, SessionEntityType.activeExercise, now);
      await _touchSessionById(exercise.userId, exercise.sessionId, now);
    });
  }

  Future<void> reorderExercises({
    required String userId,
    required String sessionId,
    required List<String> orderedExerciseIds,
  }) async {
    final session = await _requireActiveSession(userId, sessionId);
    final rows =
        await (_database.select(_database.activeWorkoutExercises)..where(
              (row) =>
                  row.sessionId.equals(session.id) & row.deletedAt.isNull(),
            ))
            .get();
    if (rows.length != orderedExerciseIds.length ||
        rows
            .map((row) => row.id)
            .toSet()
            .difference(orderedExerciseIds.toSet())
            .isNotEmpty) {
      throw ArgumentError(
        'Exercise order must contain every active exercise once.',
      );
    }
    final byId = {for (final row in rows) row.id: _activeExerciseFromRow(row)};
    final now = _now();
    await _database.transaction(() async {
      for (var index = 0; index < orderedExerciseIds.length; index++) {
        final current = byId[orderedExerciseIds[index]]!;
        if (current.sortOrder == index) continue;
        final updated = _copyActiveExercise(
          current,
          sortOrder: index,
          updatedAt: now,
          version: current.version + 1,
        );
        await _upsertActiveExercise(updated);
        await _enqueueEntity(updated, SessionEntityType.activeExercise, now);
      }
      await _touchActiveSession(session, now);
    });
  }

  Future<ActiveWorkoutSet> addSet({
    required String userId,
    required String exerciseId,
    WorkoutSetType setType = WorkoutSetType.working,
    double? weightKg,
    int? repetitions,
    int? durationSeconds,
    double? distanceMeters,
    double? rpe,
    double? rir,
    String? notes,
  }) async {
    final exercise = await _requireActiveExercise(userId, exerciseId);
    _validateSetValues(
      weightKg: weightKg,
      repetitions: repetitions,
      durationSeconds: durationSeconds,
      distanceMeters: distanceMeters,
      rpe: rpe,
      rir: rir,
    );
    final existing =
        await (_database.select(_database.activeWorkoutSets)..where(
              (row) =>
                  row.sessionExerciseId.equals(exercise.id) &
                  row.deletedAt.isNull(),
            ))
            .get();
    final now = _now();
    final set = ActiveWorkoutSet(
      id: _newId(),
      userId: exercise.userId,
      sessionId: exercise.sessionId,
      sessionExerciseId: exercise.id,
      setType: setType,
      weightKg: weightKg,
      repetitions: repetitions,
      durationSeconds: durationSeconds,
      distanceMeters: distanceMeters,
      rpe: rpe,
      rir: rir,
      isCompleted: false,
      notes: _optionalText(notes, 2000),
      sortOrder: existing.length,
      createdAt: now,
      updatedAt: now,
      version: 1,
    );
    await _database.transaction(() async {
      await _upsertActiveSet(set);
      await _enqueueEntity(set, SessionEntityType.activeSet, now);
      await _touchSessionById(set.userId, set.sessionId, now);
    });
    return set;
  }

  /// Replaces all editable values on a set. Passing null deliberately clears
  /// an optional value, which keeps form-to-database behaviour unambiguous.
  Future<ActiveWorkoutSet> editSet({
    required String userId,
    required String setId,
    required WorkoutSetType setType,
    required double? weightKg,
    required int? repetitions,
    required int? durationSeconds,
    required double? distanceMeters,
    required double? rpe,
    required double? rir,
    required String? notes,
  }) async {
    final current = await _requireActiveSet(userId, setId);
    _validateSetValues(
      weightKg: weightKg,
      repetitions: repetitions,
      durationSeconds: durationSeconds,
      distanceMeters: distanceMeters,
      rpe: rpe,
      rir: rir,
    );
    final now = _now();
    final updated = _copyActiveSet(
      current,
      setType: setType,
      weightKg: weightKg,
      repetitions: repetitions,
      durationSeconds: durationSeconds,
      distanceMeters: distanceMeters,
      rpe: rpe,
      rir: rir,
      notes: _optionalText(notes, 2000),
      updatedAt: now,
      version: current.version + 1,
    );
    await _database.transaction(() async {
      await _upsertActiveSet(updated);
      await _enqueueEntity(updated, SessionEntityType.activeSet, now);
      await _touchSessionById(updated.userId, updated.sessionId, now);
    });
    return updated;
  }

  Future<void> removeSet({
    required String userId,
    required String setId,
  }) async {
    final current = await _requireActiveSet(userId, setId);
    final now = _now();
    final deleted = _copyActiveSet(
      current,
      deletedAt: now,
      updatedAt: now,
      version: current.version + 1,
    );
    await _database.transaction(() async {
      await _upsertActiveSet(deleted);
      await _enqueueEntity(deleted, SessionEntityType.activeSet, now);
      await _touchSessionById(deleted.userId, deleted.sessionId, now);
    });
  }

  Future<ActiveWorkoutSet> duplicateSet({
    required String userId,
    required String setId,
  }) async {
    final source = await _requireActiveSet(userId, setId);
    return addSet(
      userId: source.userId,
      exerciseId: source.sessionExerciseId,
      setType: source.setType,
      weightKg: source.weightKg,
      repetitions: source.repetitions,
      durationSeconds: source.durationSeconds,
      distanceMeters: source.distanceMeters,
      rpe: source.rpe,
      rir: source.rir,
      notes: source.notes,
    );
  }

  Future<ActiveWorkoutSet> duplicatePreviousSet({
    required String userId,
    required String exerciseId,
  }) async {
    final exercise = await _requireActiveExercise(userId, exerciseId);
    final row =
        await (_database.select(_database.activeWorkoutSets)
              ..where(
                (candidate) =>
                    candidate.sessionExerciseId.equals(exercise.id) &
                    candidate.deletedAt.isNull(),
              )
              ..orderBy([(candidate) => OrderingTerm.desc(candidate.sortOrder)])
              ..limit(1))
            .getSingleOrNull();
    if (row == null) {
      return addSet(userId: userId, exerciseId: exercise.id);
    }
    return duplicateSet(userId: userId, setId: row.id);
  }

  /// Copies values from the immediately preceding active set into [setId].
  Future<ActiveWorkoutSet> copyPreviousSetValues({
    required String userId,
    required String setId,
    bool copyWeight = true,
    bool copyRepetitions = true,
  }) async {
    final target = await _requireActiveSet(userId, setId);
    final previous =
        await (_database.select(_database.activeWorkoutSets)
              ..where(
                (row) =>
                    row.sessionExerciseId.equals(target.sessionExerciseId) &
                    row.deletedAt.isNull() &
                    row.sortOrder.isSmallerThanValue(target.sortOrder),
              )
              ..orderBy([(row) => OrderingTerm.desc(row.sortOrder)])
              ..limit(1))
            .getSingleOrNull();
    if (previous == null) throw StateError('There is no previous set to copy.');
    final source = _activeSetFromRow(previous);
    return editSet(
      userId: target.userId,
      setId: target.id,
      setType: target.setType,
      weightKg: copyWeight ? source.weightKg : target.weightKg,
      repetitions: copyRepetitions ? source.repetitions : target.repetitions,
      durationSeconds: target.durationSeconds,
      distanceMeters: target.distanceMeters,
      rpe: target.rpe,
      rir: target.rir,
      notes: target.notes,
    );
  }

  Future<void> reorderSets({
    required String userId,
    required String exerciseId,
    required List<String> orderedSetIds,
  }) async {
    final exercise = await _requireActiveExercise(userId, exerciseId);
    final rows =
        await (_database.select(_database.activeWorkoutSets)..where(
              (row) =>
                  row.sessionExerciseId.equals(exercise.id) &
                  row.deletedAt.isNull(),
            ))
            .get();
    final actualIds = rows.map((row) => row.id).toSet();
    if (rows.length != orderedSetIds.length ||
        actualIds.length != orderedSetIds.toSet().length ||
        actualIds.difference(orderedSetIds.toSet()).isNotEmpty) {
      throw ArgumentError('Set order must contain every active set once.');
    }
    final now = _now();
    await _database.transaction(() async {
      for (var index = 0; index < orderedSetIds.length; index++) {
        final row = rows.firstWhere(
          (candidate) => candidate.id == orderedSetIds[index],
        );
        if (row.sortOrder == index) continue;
        final current = _activeSetFromRow(row);
        final updated = _copyActiveSet(
          current,
          sortOrder: index,
          updatedAt: now,
          version: current.version + 1,
        );
        await _upsertActiveSet(updated);
        await _enqueueEntity(updated, SessionEntityType.activeSet, now);
      }
      await _touchSessionById(exercise.userId, exercise.sessionId, now);
    });
  }

  Future<ActiveWorkoutSet> completeSet({
    required String userId,
    required String setId,
    bool startAutomaticRestTimer = true,
  }) async {
    final current = await _requireActiveSet(userId, setId);
    if (current.isCompleted) return current;
    _validateSetValues(
      weightKg: current.weightKg,
      repetitions: current.repetitions,
      durationSeconds: current.durationSeconds,
      distanceMeters: current.distanceMeters,
      rpe: current.rpe,
      rir: current.rir,
    );
    final session = await _requireActiveSession(
      current.userId,
      current.sessionId,
    );
    final exercise = await _requireActiveExercise(
      current.userId,
      current.sessionExerciseId,
    );
    final now = _now();
    final updated = _copyActiveSet(
      current,
      isCompleted: true,
      completedAt: now,
      updatedAt: now,
      version: current.version + 1,
    );
    await _database.transaction(() async {
      await _upsertActiveSet(updated);
      await _enqueueEntity(updated, SessionEntityType.activeSet, now);
      if (startAutomaticRestTimer &&
          session.autoStartRestTimer &&
          exercise.restSeconds > 0) {
        await _saveActiveSession(
          _copyActiveSession(
            session,
            restTimerState: RestTimerState.running,
            restTimerDurationSeconds: exercise.restSeconds,
            restTimerRemainingSeconds: exercise.restSeconds,
            restTimerTargetEndAt: now.add(
              Duration(seconds: exercise.restSeconds),
            ),
            updatedAt: now,
            version: session.version + 1,
          ),
          now,
        );
      } else {
        await _touchActiveSession(session, now);
      }
    });
    return updated;
  }

  Future<ActiveWorkoutSet> uncompleteSet({
    required String userId,
    required String setId,
  }) async {
    final current = await _requireActiveSet(userId, setId);
    if (!current.isCompleted) return current;
    final now = _now();
    final updated = _copyActiveSet(
      current,
      isCompleted: false,
      clearCompletedAt: true,
      updatedAt: now,
      version: current.version + 1,
    );
    await _database.transaction(() async {
      await _upsertActiveSet(updated);
      await _enqueueEntity(updated, SessionEntityType.activeSet, now);
      await _touchSessionById(updated.userId, updated.sessionId, now);
    });
    return updated;
  }

  Future<ActiveWorkoutSession> editActiveWorkout({
    required String userId,
    required String sessionId,
    required String name,
    String? notes,
  }) async {
    final current = await _requireActiveSession(userId, sessionId);
    final now = _now();
    final updated = _copyActiveSession(
      current,
      name: _requiredText(name, 'Workout name', 120),
      notes: _optionalText(notes, 4000),
      updatedAt: now,
      version: current.version + 1,
    );
    await _database.transaction(() => _saveActiveSession(updated, now));
    return updated;
  }

  Future<ActiveWorkoutExercise> editExerciseNotes({
    required String userId,
    required String exerciseId,
    String? notes,
  }) async {
    final current = await _requireActiveExercise(userId, exerciseId);
    final now = _now();
    final updated = _copyActiveExercise(
      current,
      notes: _optionalText(notes, 2000),
      updatedAt: now,
      version: current.version + 1,
    );
    await _database.transaction(() async {
      await _upsertActiveExercise(updated);
      await _enqueueEntity(updated, SessionEntityType.activeExercise, now);
      await _touchSessionById(updated.userId, updated.sessionId, now);
    });
    return updated;
  }

  Future<ActiveWorkoutSession> startRestTimer({
    required String userId,
    required String sessionId,
    required int durationSeconds,
  }) => _changeTimer(
    userId: userId,
    sessionId: sessionId,
    action: (session, now) {
      if (durationSeconds < 1 || durationSeconds > 24 * 60 * 60) {
        throw ArgumentError.value(durationSeconds, 'durationSeconds');
      }
      return _copyActiveSession(
        session,
        restTimerState: RestTimerState.running,
        restTimerDurationSeconds: durationSeconds,
        restTimerRemainingSeconds: durationSeconds,
        restTimerTargetEndAt: now.add(Duration(seconds: durationSeconds)),
      );
    },
  );

  Future<ActiveWorkoutSession> pauseRestTimer({
    required String userId,
    required String sessionId,
  }) => _changeTimer(
    userId: userId,
    sessionId: sessionId,
    action: (session, now) {
      final remaining = session.restSecondsAt(now);
      return _copyActiveSession(
        session,
        restTimerState: remaining == 0
            ? RestTimerState.expired
            : RestTimerState.paused,
        restTimerRemainingSeconds: remaining,
        clearRestTimerTargetEndAt: true,
      );
    },
  );

  Future<ActiveWorkoutSession> resumeRestTimer({
    required String userId,
    required String sessionId,
  }) => _changeTimer(
    userId: userId,
    sessionId: sessionId,
    action: (session, now) {
      final remaining = session.restSecondsAt(now);
      if (remaining < 1) {
        return _copyActiveSession(
          session,
          restTimerState: RestTimerState.expired,
          restTimerRemainingSeconds: 0,
          clearRestTimerTargetEndAt: true,
        );
      }
      return _copyActiveSession(
        session,
        restTimerState: RestTimerState.running,
        restTimerRemainingSeconds: remaining,
        restTimerTargetEndAt: now.add(Duration(seconds: remaining)),
      );
    },
  );

  Future<ActiveWorkoutSession> resetRestTimer({
    required String userId,
    required String sessionId,
  }) => _changeTimer(
    userId: userId,
    sessionId: sessionId,
    action: (session, _) => _copyActiveSession(
      session,
      restTimerState: RestTimerState.paused,
      restTimerRemainingSeconds: session.restTimerDurationSeconds,
      clearRestTimerTargetEndAt: true,
    ),
  );

  Future<ActiveWorkoutSession> skipRestTimer({
    required String userId,
    required String sessionId,
  }) => _changeTimer(
    userId: userId,
    sessionId: sessionId,
    action: (session, _) => _copyActiveSession(
      session,
      restTimerState: RestTimerState.idle,
      restTimerRemainingSeconds: 0,
      clearRestTimerTargetEndAt: true,
    ),
  );

  Future<ActiveWorkoutSession> adjustRestTimer({
    required String userId,
    required String sessionId,
    required int seconds,
  }) => _changeTimer(
    userId: userId,
    sessionId: sessionId,
    action: (session, now) {
      final remaining = (session.restSecondsAt(now) + seconds).clamp(
        0,
        24 * 60 * 60,
      );
      final running =
          session.restTimerState == RestTimerState.running && remaining > 0;
      return _copyActiveSession(
        session,
        restTimerState: remaining == 0
            ? RestTimerState.expired
            : session.restTimerState,
        restTimerDurationSeconds: (session.restTimerDurationSeconds + seconds)
            .clamp(0, 24 * 60 * 60),
        restTimerRemainingSeconds: remaining,
        restTimerTargetEndAt: running
            ? now.add(Duration(seconds: remaining))
            : session.restTimerTargetEndAt,
        clearRestTimerTargetEndAt: remaining == 0,
      );
    },
  );

  Future<ActiveWorkoutSession> setAutomaticRestTimer({
    required String userId,
    required String sessionId,
    required bool enabled,
  }) => _changeTimer(
    userId: userId,
    sessionId: sessionId,
    action: (session, _) =>
        _copyActiveSession(session, autoStartRestTimer: enabled),
  );

  Future<ActiveWorkoutSession> _changeTimer({
    required String userId,
    required String sessionId,
    required ActiveWorkoutSession Function(
      ActiveWorkoutSession session,
      DateTime now,
    )
    action,
  }) async {
    final current = await _requireActiveSession(userId, sessionId);
    final now = _now();
    final changed = action(current, now);
    final updated = _copyActiveSession(
      changed,
      updatedAt: now,
      version: current.version + 1,
    );
    await _database.transaction(() => _saveActiveSession(updated, now));
    return updated;
  }

  Future<void> discardActiveWorkout({
    required String userId,
    required String sessionId,
  }) async {
    final session = await _requireActiveSession(userId, sessionId);
    final bundle = await _activeBundleFromSession(session);
    final now = _now();
    await _database.transaction(() async {
      for (final set in bundle.sets.where((value) => !value.isDeleted)) {
        final deleted = _copyActiveSet(
          set,
          deletedAt: now,
          updatedAt: now,
          version: set.version + 1,
        );
        await _upsertActiveSet(deleted);
        await _enqueueEntity(deleted, SessionEntityType.activeSet, now);
      }
      for (final exercise in bundle.exercises.where(
        (value) => !value.isDeleted,
      )) {
        final deleted = _copyActiveExercise(
          exercise,
          deletedAt: now,
          updatedAt: now,
          version: exercise.version + 1,
        );
        await _upsertActiveExercise(deleted);
        await _enqueueEntity(deleted, SessionEntityType.activeExercise, now);
      }
      final deleted = _copyActiveSession(
        session,
        deletedAt: now,
        updatedAt: now,
        version: session.version + 1,
      );
      await _saveActiveSession(deleted, now);
    });
  }

  Future<PreviousPerformance?> getPreviousPerformance({
    required String userId,
    required String exerciseKey,
    required String exerciseName,
  }) async {
    final owner = _requiredId(userId, 'userId');
    final key = _requiredId(exerciseKey, 'exerciseKey');
    final exerciseRows =
        await (_database.select(_database.completedWorkoutExercises)
              ..where(
                (row) =>
                    row.userId.equals(owner) &
                    row.exerciseKey.equals(key) &
                    row.deletedAt.isNull(),
              )
              ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)]))
            .get();
    CompletedWorkoutExerciseRow? mostRecentExercise;
    CompletedWorkoutSessionRow? mostRecentSession;
    for (final exercise in exerciseRows) {
      final session =
          await (_database.select(_database.completedWorkoutSessions)..where(
                (row) =>
                    row.id.equals(exercise.sessionId) &
                    row.userId.equals(owner) &
                    row.deletedAt.isNull(),
              ))
              .getSingleOrNull();
      if (session == null) continue;
      if (mostRecentSession == null ||
          session.endedAt.isAfter(mostRecentSession.endedAt)) {
        mostRecentExercise = exercise;
        mostRecentSession = session;
      }
    }
    if (mostRecentExercise != null && mostRecentSession != null) {
      final setRows =
          await (_database.select(_database.completedWorkoutSets)
                ..where(
                  (row) =>
                      row.userId.equals(owner) &
                      row.sessionExerciseId.equals(mostRecentExercise!.id) &
                      row.deletedAt.isNull(),
                )
                ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
              .get();
      return PreviousPerformance(
        performedAt: mostRecentSession.endedAt,
        exerciseName: mostRecentExercise.exerciseName,
        sets: List.unmodifiable(setRows.map(_completedSetFromRow)),
      );
    }

    // Stage 1 quick logs have names rather than stable exercise keys. They are
    // used only as a clearly labelled fallback and never feed Stage 3 PRs.
    final normalizedName = normalizeExerciseSearchText(exerciseName);
    final legacyRows =
        await (_database.select(_database.workouts)
              ..where((row) => row.userId.equals(owner))
              ..orderBy([(row) => OrderingTerm.desc(row.performedAt)]))
            .get();
    WorkoutRow? legacy;
    for (final row in legacyRows) {
      if (normalizeExerciseSearchText(row.exerciseName) == normalizedName) {
        legacy = row;
        break;
      }
    }
    if (legacy == null) return null;
    final legacyWorkout = legacy;
    final legacySetRows =
        await (_database.select(_database.workoutSets)
              ..where(
                (row) =>
                    row.workoutId.equals(legacyWorkout.id) &
                    row.userId.equals(owner),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.setOrder)]))
            .get();
    return PreviousPerformance(
      performedAt: legacyWorkout.performedAt,
      exerciseName: legacyWorkout.exerciseName,
      isLegacyQuickLog: true,
      sets: List.unmodifiable(
        legacySetRows.map(
          (set) => CompletedWorkoutSet(
            id: 'legacy:${set.id}',
            userId: owner,
            sessionId: 'legacy:${legacyWorkout.id}',
            sessionExerciseId: 'legacy:${legacyWorkout.id}:exercise',
            sourceActiveSetId: null,
            setType: WorkoutSetType.working,
            weightKg: set.weight,
            repetitions: set.reps,
            sortOrder: set.setOrder,
            setVolumeKg: roundSessionMetric(set.weight * set.reps),
            estimatedOneRepMaxKg: estimateEpleyOneRepMax(
              weightKg: set.weight,
              repetitions: set.reps,
            ),
            isPersonalRecord: false,
            completedAt: legacyWorkout.performedAt,
            createdAt: set.createdAt,
            updatedAt: set.updatedAt,
            version: 1,
          ),
        ),
      ),
    );
  }

  Future<CompletedWorkoutBundle> finishWorkout({
    required String userId,
    required String sessionId,
    DateTime? endedAt,
  }) async {
    final activeSession = await _requireActiveSession(userId, sessionId);
    final active = await _activeBundleFromSession(activeSession);
    final finishedAt = (endedAt ?? _now()).toUtc();
    if (finishedAt.isBefore(activeSession.startedAt)) {
      throw ArgumentError('Workout end time cannot precede its start time.');
    }
    final completedActiveSets = active.sets
        .where((set) => set.isCompleted && !set.isDeleted)
        .toList(growable: false);
    final completedSetIds = completedActiveSets
        .map((set) => set.sessionExerciseId)
        .toSet();
    final completedId = _newId();
    final completedExerciseByActiveId = <String, CompletedWorkoutExercise>{};
    final completedSets = <CompletedWorkoutSet>[];

    for (final activeExercise in active.exercises.where(
      (row) => !row.isDeleted,
    )) {
      final sourceSets = completedActiveSets
          .where((set) => set.sessionExerciseId == activeExercise.id)
          .toList(growable: false);
      final completedExerciseId = _newId();
      final nonWarmup = sourceSets
          .where((set) => set.setType != WorkoutSetType.warmUp)
          .toList(growable: false);
      final volumes = sourceSets
          .map(
            (set) => roundSessionMetric(
              (set.weightKg ?? 0) * (set.repetitions ?? 0),
            ),
          )
          .toList();
      final estimates = nonWarmup
          .map((set) => set.estimatedOneRepMaxKg)
          .whereType<double>()
          .toList();
      final weights = nonWarmup
          .map((set) => set.weightKg)
          .whereType<double>()
          .toList();
      final completedExercise = CompletedWorkoutExercise(
        id: completedExerciseId,
        userId: activeSession.userId,
        sessionId: completedId,
        sourceActiveExerciseId: activeExercise.id,
        exerciseSource: activeExercise.exerciseSource,
        exerciseKey: activeExercise.exerciseKey,
        systemExerciseKey: activeExercise.systemExerciseKey,
        customExerciseId: activeExercise.customExerciseId,
        exerciseName: activeExercise.exerciseName,
        primaryMuscleGroup: activeExercise.primaryMuscleGroup,
        secondaryMuscleGroups: activeExercise.secondaryMuscleGroups,
        equipment: activeExercise.equipment,
        trackingType: activeExercise.trackingType,
        weightRelevant: activeExercise.weightRelevant,
        repetitionsRelevant: activeExercise.repetitionsRelevant,
        distanceRelevant: activeExercise.distanceRelevant,
        durationRelevant: activeExercise.durationRelevant,
        bodyweightRelevant: activeExercise.bodyweightRelevant,
        notes: activeExercise.notes,
        sortOrder: activeExercise.sortOrder,
        completedSetCount: sourceSets.length,
        workingSetCount: nonWarmup.length,
        totalRepetitions: sourceSets.fold(
          0,
          (total, set) => total + (set.repetitions ?? 0),
        ),
        totalVolumeKg: roundSessionMetric(
          volumes.fold(0.0, (total, value) => total + value),
        ),
        bestWeightKg: weights.isEmpty ? null : weights.reduce(_maxDouble),
        bestEstimatedOneRepMaxKg: estimates.isEmpty
            ? null
            : estimates.reduce(_maxDouble),
        createdAt: finishedAt,
        updatedAt: finishedAt,
        version: 1,
      );
      completedExerciseByActiveId[activeExercise.id] = completedExercise;
      for (final sourceSet in sourceSets) {
        completedSets.add(
          CompletedWorkoutSet(
            id: _newId(),
            userId: activeSession.userId,
            sessionId: completedId,
            sessionExerciseId: completedExerciseId,
            sourceActiveSetId: sourceSet.id,
            setType: sourceSet.setType,
            weightKg: sourceSet.weightKg,
            repetitions: sourceSet.repetitions,
            durationSeconds: sourceSet.durationSeconds,
            distanceMeters: sourceSet.distanceMeters,
            rpe: sourceSet.rpe,
            rir: sourceSet.rir,
            notes: sourceSet.notes,
            sortOrder: sourceSet.sortOrder,
            setVolumeKg: roundSessionMetric(
              (sourceSet.weightKg ?? 0) * (sourceSet.repetitions ?? 0),
            ),
            estimatedOneRepMaxKg: sourceSet.setType == WorkoutSetType.warmUp
                ? null
                : estimateEpleyOneRepMax(
                    weightKg: sourceSet.weightKg,
                    repetitions: sourceSet.repetitions,
                  ),
            isPersonalRecord: false,
            completedAt: sourceSet.completedAt ?? finishedAt,
            createdAt: finishedAt,
            updatedAt: finishedAt,
            version: 1,
          ),
        );
      }
    }
    final nonWarmupSets = completedActiveSets
        .where((set) => set.setType != WorkoutSetType.warmUp)
        .toList(growable: false);
    var completedSession = CompletedWorkoutSession(
      id: completedId,
      userId: activeSession.userId,
      sourceActiveSessionId: activeSession.id,
      sourceTemplateId: activeSession.sourceTemplateId,
      name: activeSession.name,
      notes: activeSession.notes,
      weightUnit: activeSession.weightUnit,
      startedAt: activeSession.startedAt,
      endedAt: finishedAt,
      durationSeconds: finishedAt.difference(activeSession.startedAt).inSeconds,
      exerciseCount: completedSetIds.length,
      workingSetCount: nonWarmupSets.length,
      totalCompletedSets: completedActiveSets.length,
      totalRepetitions: completedActiveSets.fold(
        0,
        (total, set) => total + (set.repetitions ?? 0),
      ),
      totalVolumeKg: roundSessionMetric(
        completedActiveSets.fold(
          0.0,
          (total, set) => total + (set.weightKg ?? 0) * (set.repetitions ?? 0),
        ),
      ),
      personalRecordCount: 0,
      createdAt: finishedAt,
      updatedAt: finishedAt,
      version: 1,
    );

    await _database.transaction(() async {
      await _upsertCompletedSession(completedSession);
      await _enqueueEntity(
        completedSession,
        SessionEntityType.completedSession,
        finishedAt,
      );
      for (final exercise in completedExerciseByActiveId.values) {
        await _upsertCompletedExercise(exercise);
        await _enqueueEntity(
          exercise,
          SessionEntityType.completedExercise,
          finishedAt,
        );
      }
      for (final set in completedSets) {
        await _upsertCompletedSet(set);
        await _enqueueEntity(set, SessionEntityType.completedSet, finishedAt);
      }

      final newEvents = <PersonalRecordEvent>[];
      final personalRecordSetIds = <String>{};
      for (final exercise in completedExerciseByActiveId.values) {
        final result = await _applyPersonalRecords(
          exercise: exercise,
          sets: completedSets
              .where((set) => set.sessionExerciseId == exercise.id)
              .toList(growable: false),
          achievedAt: finishedAt,
        );
        newEvents.addAll(result.events);
        personalRecordSetIds.addAll(result.completedSetIds);
      }
      for (final set in completedSets.where(
        (candidate) => personalRecordSetIds.contains(candidate.id),
      )) {
        final marked = _copyCompletedSet(
          set,
          isPersonalRecord: true,
          updatedAt: finishedAt,
          version: set.version + 1,
        );
        await _upsertCompletedSet(marked);
        await _enqueueEntity(
          marked,
          SessionEntityType.completedSet,
          finishedAt,
        );
      }
      if (newEvents.isNotEmpty) {
        completedSession = _copyCompletedSession(
          completedSession,
          personalRecordCount: newEvents.length,
          version: completedSession.version + 1,
        );
        await _upsertCompletedSession(completedSession);
        await _enqueueEntity(
          completedSession,
          SessionEntityType.completedSession,
          finishedAt,
        );
      }

      // Tombstones are queued only after the completed graph and its PRs have
      // been written. A transaction failure therefore leaves recovery intact.
      for (final set in active.sets.where((value) => !value.isDeleted)) {
        final deleted = _copyActiveSet(
          set,
          deletedAt: finishedAt,
          updatedAt: finishedAt,
          version: set.version + 1,
        );
        await _upsertActiveSet(deleted);
        await _enqueueEntity(deleted, SessionEntityType.activeSet, finishedAt);
      }
      for (final exercise in active.exercises.where(
        (value) => !value.isDeleted,
      )) {
        final deleted = _copyActiveExercise(
          exercise,
          deletedAt: finishedAt,
          updatedAt: finishedAt,
          version: exercise.version + 1,
        );
        await _upsertActiveExercise(deleted);
        await _enqueueEntity(
          deleted,
          SessionEntityType.activeExercise,
          finishedAt,
        );
      }
      final deletedSession = _copyActiveSession(
        activeSession,
        deletedAt: finishedAt,
        updatedAt: finishedAt,
        version: activeSession.version + 1,
      );
      await _saveActiveSession(deletedSession, finishedAt);
    });
    return getCompletedWorkout(
      userId: activeSession.userId,
      sessionId: completedId,
    );
  }

  Future<WorkoutSummary> getWorkoutSummary({
    required String userId,
    required String sessionId,
  }) async {
    final completed = await getCompletedWorkout(
      userId: userId,
      sessionId: sessionId,
    );
    final rows =
        await (_database.select(_database.personalRecordEvents)
              ..where(
                (row) =>
                    row.userId.equals(completed.session.userId) &
                    row.completedSessionId.equals(completed.session.id) &
                    row.deletedAt.isNull(),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.achievedAt)]))
            .get();
    return WorkoutSummary(
      session: completed.session,
      personalRecords: rows.map(_personalRecordEventFromRow),
    );
  }

  Future<List<CompletedWorkoutSession>> searchCompletedWorkouts({
    required String userId,
    String query = '',
  }) async {
    final owner = _requiredId(userId, 'userId');
    final rows =
        await (_database.select(_database.completedWorkoutSessions)
              ..where(
                (row) => row.userId.equals(owner) & row.deletedAt.isNull(),
              )
              ..orderBy([(row) => OrderingTerm.desc(row.endedAt)]))
            .get();
    final normalized = normalizeExerciseSearchText(query);
    if (normalized.isEmpty) {
      return List.unmodifiable(rows.map(_completedSessionFromRow));
    }
    return List.unmodifiable(
      rows
          .where(
            (row) => normalizeExerciseSearchText(
              '${row.name} ${row.notes ?? ''}',
            ).contains(normalized),
          )
          .map(_completedSessionFromRow),
    );
  }

  Future<CompletedWorkoutSession> editCompletedWorkoutNotes({
    required String userId,
    required String sessionId,
    String? notes,
  }) async {
    final bundle = await getCompletedWorkout(
      userId: userId,
      sessionId: sessionId,
    );
    if (bundle.session.isDeleted) {
      throw StateError('A deleted workout cannot be edited.');
    }
    final now = _now();
    final updated = _copyCompletedSession(
      bundle.session,
      notes: _optionalText(notes, 4000),
      updatedAt: now,
      version: bundle.session.version + 1,
    );
    await _database.transaction(() async {
      await _upsertCompletedSession(updated);
      await _enqueueEntity(updated, SessionEntityType.completedSession, now);
    });
    return updated;
  }

  Future<void> softDeleteCompletedWorkout({
    required String userId,
    required String sessionId,
  }) async {
    final completed = await getCompletedWorkout(
      userId: userId,
      sessionId: sessionId,
    );
    if (completed.session.isDeleted) return;
    final now = _now();
    final affectedExerciseKeys = completed.exercises
        .where((exercise) => !exercise.isDeleted)
        .map((exercise) => exercise.exerciseKey)
        .toSet();
    await _database.transaction(() async {
      for (final set in completed.sets.where((value) => !value.isDeleted)) {
        final deleted = _copyCompletedSet(
          set,
          deletedAt: now,
          updatedAt: now,
          version: set.version + 1,
        );
        await _upsertCompletedSet(deleted);
        await _enqueueEntity(deleted, SessionEntityType.completedSet, now);
      }
      for (final exercise in completed.exercises.where(
        (value) => !value.isDeleted,
      )) {
        final deleted = _copyCompletedExercise(
          exercise,
          deletedAt: now,
          updatedAt: now,
          version: exercise.version + 1,
        );
        await _upsertCompletedExercise(deleted);
        await _enqueueEntity(deleted, SessionEntityType.completedExercise, now);
      }
      final deleted = _copyCompletedSession(
        completed.session,
        deletedAt: now,
        updatedAt: now,
        version: completed.session.version + 1,
      );
      await _upsertCompletedSession(deleted);
      await _enqueueEntity(deleted, SessionEntityType.completedSession, now);
      for (final exerciseKey in affectedExerciseKeys) {
        await _recomputeCurrentRecords(
          userId: completed.session.userId,
          exerciseKey: exerciseKey,
          now: now,
        );
      }
    });
  }

  Future<int> pendingUploadCount(String userId) async {
    final owner = _requiredId(userId, 'userId');
    final count = _database.sessionSyncQueue.id.count();
    final query = _database.selectOnly(_database.sessionSyncQueue)
      ..addColumns([count])
      ..where(_database.sessionSyncQueue.userId.equals(owner));
    return (await query.map((row) => row.read(count) ?? 0).getSingle());
  }

  Future<List<PendingSessionUpload>> pendingUploads(
    String userId, {
    int limit = 100,
  }) async {
    final owner = _requiredId(userId, 'userId');
    if (limit < 1) return const [];
    final rows =
        await (_database.select(_database.sessionSyncQueue)
              ..where((row) => row.userId.equals(owner))
              ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
            .get();
    final pending = <PendingSessionUpload>[];
    for (final row in rows) {
      final type = sessionEntityTypeFromWire(row.entityType);
      final entity = await _loadQueuedEntity(owner, type, row.entityId);
      if (entity == null) {
        await (_database.delete(
          _database.sessionSyncQueue,
        )..where((candidate) => candidate.id.equals(row.id))).go();
        continue;
      }
      final localVersion = _entityCoordinates(entity).$3;
      if (localVersion < row.entityVersion) {
        // Never upload an entity snapshot older than the durable queue's
        // promised version. Leaving it pending makes the inconsistency visible
        // and prevents an unsafe acknowledgement.
        continue;
      }
      if (localVersion > row.entityVersion) {
        await (_database.update(
          _database.sessionSyncQueue,
        )..where((candidate) => candidate.id.equals(row.id))).write(
          SessionSyncQueueCompanion(
            entityVersion: Value(localVersion),
            attemptCount: const Value(0),
            lastError: const Value(null),
            lastAttemptAt: const Value(null),
            updatedAt: Value(_now()),
          ),
        );
      }
      pending.add(
        PendingSessionUpload(
          queueId: row.id,
          userId: row.userId,
          entityType: type,
          entityId: row.entityId,
          entityVersion: localVersion,
          entity: entity,
          attemptCount: localVersion == row.entityVersion
              ? row.attemptCount
              : 0,
          lastError: localVersion == row.entityVersion ? row.lastError : null,
        ),
      );
    }
    pending.sort((a, b) {
      final priority = a.entityType.uploadPriority.compareTo(
        b.entityType.uploadPriority,
      );
      if (priority != 0) return priority;
      if (a.entityType == SessionEntityType.activeSession &&
          b.entityType == SessionEntityType.activeSession) {
        final aDeleted = (a.entity as ActiveWorkoutSession).isDeleted;
        final bDeleted = (b.entity as ActiveWorkoutSession).isDeleted;
        if (aDeleted != bDeleted) return aDeleted ? -1 : 1;
      }
      return a.queueId.compareTo(b.queueId);
    });
    return List.unmodifiable(pending.take(limit));
  }

  /// Uploads a bounded outbox batch. Stable local IDs plus Supabase upserts
  /// make retries idempotent. A newer coalesced version is never cleared by an
  /// older in-flight upload result.
  Future<int> uploadPendingChanges(String userId, {int limit = 100}) async {
    final pending = await pendingUploads(userId, limit: limit);
    var uploaded = 0;
    for (final item in pending) {
      try {
        await _upload(item);
        await markUploadSucceeded(item);
        uploaded++;
      } catch (error) {
        await markUploadFailed(item, error);
      }
    }
    return uploaded;
  }

  /// Uploads exactly the immutable queue snapshot supplied by the coordinator.
  /// Queue removal remains a separate version-checked acknowledgement step.
  Future<void> uploadPending(PendingSessionUpload upload) => _upload(upload);

  Future<void> markUploadSucceeded(PendingSessionUpload upload) async {
    await (_database.delete(_database.sessionSyncQueue)..where(
          (row) =>
              row.id.equals(upload.queueId) &
              row.userId.equals(upload.userId) &
              row.entityVersion.equals(upload.entityVersion),
        ))
        .go();
  }

  Future<void> markUploadFailed(
    PendingSessionUpload upload,
    Object error,
  ) async {
    final now = _now();
    final current =
        await (_database.select(_database.sessionSyncQueue)..where(
              (row) =>
                  row.id.equals(upload.queueId) &
                  row.userId.equals(upload.userId),
            ))
            .getSingleOrNull();
    if (current == null || current.entityVersion != upload.entityVersion) {
      return;
    }
    await (_database.update(
      _database.sessionSyncQueue,
    )..where((row) => row.id.equals(current.id))).write(
      SessionSyncQueueCompanion(
        attemptCount: Value(current.attemptCount + 1),
        lastError: Value(_safeError(error)),
        lastAttemptAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> restoreFromCloud(String userId) async {
    final owner = _requiredId(userId, 'userId');
    final snapshot = await _remote.fetchSnapshot(owner);
    final ownerActive = snapshot.activeSessions
        .where((entity) => entity.userId == owner)
        .toList(growable: false);
    final localActive = await getActiveWorkout(owner);
    ActiveWorkoutSession? chosenActive;
    if (localActive != null) {
      for (final candidate in ownerActive) {
        if (candidate.id == localActive.session.id) chosenActive = candidate;
      }
    } else {
      final candidates =
          ownerActive.where((entity) => !entity.isDeleted).toList()
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      chosenActive = candidates.isEmpty ? null : candidates.first;
    }

    await _database.transaction(() async {
      if (chosenActive != null) {
        final activeToRestore = chosenActive;
        await _restoreEntityIfNewer(
          owner,
          SessionEntityType.activeSession,
          activeToRestore.id,
          activeToRestore.version,
          () => _upsertActiveSession(activeToRestore),
        );
        final exerciseIds = <String>{};
        for (final exercise in snapshot.activeExercises.where(
          (entity) =>
              entity.userId == owner && entity.sessionId == activeToRestore.id,
        )) {
          exerciseIds.add(exercise.id);
          await _restoreEntityIfNewer(
            owner,
            SessionEntityType.activeExercise,
            exercise.id,
            exercise.version,
            () => _upsertActiveExercise(exercise),
          );
        }
        for (final set in snapshot.activeSets.where(
          (entity) =>
              entity.userId == owner &&
              entity.sessionId == activeToRestore.id &&
              exerciseIds.contains(entity.sessionExerciseId),
        )) {
          await _restoreEntityIfNewer(
            owner,
            SessionEntityType.activeSet,
            set.id,
            set.version,
            () => _upsertActiveSet(set),
          );
        }
      }

      final completedSessionIds = <String>{};
      for (final session in snapshot.completedSessions.where(
        (entity) => entity.userId == owner,
      )) {
        completedSessionIds.add(session.id);
        await _restoreEntityIfNewer(
          owner,
          SessionEntityType.completedSession,
          session.id,
          session.version,
          () => _upsertCompletedSession(session),
        );
      }
      final completedExerciseIds = <String>{};
      for (final exercise in snapshot.completedExercises.where(
        (entity) =>
            entity.userId == owner &&
            completedSessionIds.contains(entity.sessionId),
      )) {
        completedExerciseIds.add(exercise.id);
        await _restoreEntityIfNewer(
          owner,
          SessionEntityType.completedExercise,
          exercise.id,
          exercise.version,
          () => _upsertCompletedExercise(exercise),
        );
      }
      for (final set in snapshot.completedSets.where(
        (entity) =>
            entity.userId == owner &&
            completedSessionIds.contains(entity.sessionId) &&
            completedExerciseIds.contains(entity.sessionExerciseId),
      )) {
        await _restoreEntityIfNewer(
          owner,
          SessionEntityType.completedSet,
          set.id,
          set.version,
          () => _upsertCompletedSet(set),
        );
      }
      for (final record in snapshot.personalRecords.where(
        (entity) =>
            entity.userId == owner &&
            completedSessionIds.contains(entity.completedSessionId) &&
            completedExerciseIds.contains(entity.completedExerciseId),
      )) {
        await _restoreEntityIfNewer(
          owner,
          SessionEntityType.personalRecord,
          record.id,
          record.version,
          () => _upsertPersonalRecord(record),
        );
      }
      for (final event in snapshot.personalRecordEvents.where(
        (entity) =>
            entity.userId == owner &&
            completedSessionIds.contains(entity.completedSessionId) &&
            completedExerciseIds.contains(entity.completedExerciseId),
      )) {
        await _restoreEntityIfNewer(
          owner,
          SessionEntityType.personalRecordEvent,
          event.id,
          event.version,
          () => _upsertPersonalRecordEvent(event),
        );
      }
    });
  }

  Future<_NewRecordResult> _applyPersonalRecords({
    required CompletedWorkoutExercise exercise,
    required List<CompletedWorkoutSet> sets,
    required DateTime achievedAt,
  }) async {
    final candidates = _recordCandidates(
      exercise: exercise,
      sets: sets,
      achievedAt: achievedAt,
    );
    final events = <PersonalRecordEvent>[];
    final completedSetIds = <String>{};
    for (final candidate in candidates) {
      final currentRow =
          await (_database.select(_database.personalRecords)..where(
                (row) =>
                    row.userId.equals(exercise.userId) &
                    row.exerciseKey.equals(exercise.exerciseKey) &
                    row.recordKind.equals(candidate.kind.wireValue) &
                    row.recordScope.equals(candidate.scope),
              ))
              .getSingleOrNull();
      final current = currentRow == null
          ? null
          : _personalRecordFromRow(currentRow);
      if (current != null &&
          !current.isDeleted &&
          candidate.value <= current.recordValue) {
        continue;
      }
      final record = PersonalRecord(
        id: current?.id ?? _newId(),
        userId: exercise.userId,
        exerciseSource: exercise.exerciseSource,
        exerciseKey: exercise.exerciseKey,
        systemExerciseKey: exercise.systemExerciseKey,
        customExerciseId: exercise.customExerciseId,
        exerciseName: exercise.exerciseName,
        recordKind: candidate.kind,
        recordScope: candidate.scope,
        recordValue: candidate.value,
        weightKg: candidate.weightKg,
        repetitions: candidate.repetitions,
        estimatedOneRepMaxKg: candidate.estimatedOneRepMaxKg,
        completedSessionId: exercise.sessionId,
        completedExerciseId: exercise.id,
        completedSetId: candidate.completedSetId,
        achievedAt: candidate.achievedAt,
        createdAt: current?.createdAt ?? achievedAt,
        updatedAt: achievedAt,
        version: (current?.version ?? 0) + 1,
      );
      await _upsertPersonalRecord(record);
      await _enqueueEntity(
        record,
        SessionEntityType.personalRecord,
        achievedAt,
      );
      final eventKey = _personalRecordEventKey(record);
      final existingEvent = await (_database.select(
        _database.personalRecordEvents,
      )..where((row) => row.eventKey.equals(eventKey))).getSingleOrNull();
      if (existingEvent == null) {
        final event = PersonalRecordEvent(
          id: _newId(),
          userId: record.userId,
          personalRecordId: record.id,
          eventKey: eventKey,
          exerciseSource: record.exerciseSource,
          exerciseKey: record.exerciseKey,
          exerciseName: record.exerciseName,
          recordKind: record.recordKind,
          recordScope: record.recordScope,
          previousRecordValue: current != null && !current.isDeleted
              ? current.recordValue
              : null,
          recordValue: record.recordValue,
          weightKg: record.weightKg,
          repetitions: record.repetitions,
          estimatedOneRepMaxKg: record.estimatedOneRepMaxKg,
          completedSessionId: record.completedSessionId,
          completedExerciseId: record.completedExerciseId,
          completedSetId: record.completedSetId,
          achievedAt: record.achievedAt,
          createdAt: achievedAt,
          updatedAt: achievedAt,
          version: 1,
        );
        await _upsertPersonalRecordEvent(event);
        await _enqueueEntity(
          event,
          SessionEntityType.personalRecordEvent,
          achievedAt,
        );
        events.add(event);
        if (event.completedSetId != null) {
          completedSetIds.add(event.completedSetId!);
        }
      }
    }
    return _NewRecordResult(events, completedSetIds);
  }

  List<_RecordCandidate> _recordCandidates({
    required CompletedWorkoutExercise exercise,
    required List<CompletedWorkoutSet> sets,
    required DateTime achievedAt,
  }) {
    final candidates = <_RecordCandidate>[];
    final eligible = sets
        .where((set) => !set.isDeleted && set.setType != WorkoutSetType.warmUp)
        .toList(growable: false);
    for (final set in eligible) {
      final weight = set.weightKg;
      final repetitions = set.repetitions;
      if (weight != null && weight > 0) {
        candidates.add(
          _RecordCandidate(
            exercise: exercise,
            kind: PersonalRecordKind.heaviestWeight,
            scope: 'overall',
            value: roundSessionMetric(weight),
            weightKg: weight,
            repetitions: repetitions,
            completedSetId: set.id,
            achievedAt: set.completedAt,
          ),
        );
        if (repetitions != null && repetitions > 0) {
          candidates.add(
            _RecordCandidate(
              exercise: exercise,
              kind: PersonalRecordKind.mostRepsAtWeight,
              scope: 'weight_kg:${weight.toStringAsFixed(3)}',
              value: repetitions.toDouble(),
              weightKg: weight,
              repetitions: repetitions,
              completedSetId: set.id,
              achievedAt: set.completedAt,
            ),
          );
          final estimate = estimateEpleyOneRepMax(
            weightKg: weight,
            repetitions: repetitions,
          );
          if (estimate != null) {
            candidates.add(
              _RecordCandidate(
                exercise: exercise,
                kind: PersonalRecordKind.estimatedOneRepMax,
                scope: 'overall',
                value: estimate,
                weightKg: weight,
                repetitions: repetitions,
                estimatedOneRepMaxKg: estimate,
                completedSetId: set.id,
                achievedAt: set.completedAt,
              ),
            );
          }
          final volume = roundSessionMetric(weight * repetitions);
          if (volume > 0) {
            candidates.add(
              _RecordCandidate(
                exercise: exercise,
                kind: PersonalRecordKind.setVolume,
                scope: 'overall',
                value: volume,
                weightKg: weight,
                repetitions: repetitions,
                completedSetId: set.id,
                achievedAt: set.completedAt,
              ),
            );
          }
        }
      }
    }
    final workoutVolume = roundSessionMetric(
      eligible.fold(0.0, (total, set) => total + set.setVolumeKg),
    );
    if (workoutVolume > 0) {
      candidates.add(
        _RecordCandidate(
          exercise: exercise,
          kind: PersonalRecordKind.exerciseWorkoutVolume,
          scope: 'overall',
          value: workoutVolume,
          achievedAt: achievedAt,
        ),
      );
    }
    final bestByKey = <String, _RecordCandidate>{};
    for (final candidate in candidates) {
      final key = '${candidate.kind.wireValue}|${candidate.scope}';
      final existing = bestByKey[key];
      if (existing == null || candidate.isBetterThan(existing)) {
        bestByKey[key] = candidate;
      }
    }
    final result = bestByKey.values.toList()
      ..sort((a, b) {
        final kind = a.kind.index.compareTo(b.kind.index);
        return kind != 0 ? kind : a.scope.compareTo(b.scope);
      });
    return result;
  }

  Future<void> _recomputeCurrentRecords({
    required String userId,
    required String exerciseKey,
    required DateTime now,
  }) async {
    final exerciseRows =
        await (_database.select(_database.completedWorkoutExercises)..where(
              (row) =>
                  row.userId.equals(userId) &
                  row.exerciseKey.equals(exerciseKey) &
                  row.deletedAt.isNull(),
            ))
            .get();
    final candidates = <_RecordCandidate>[];
    for (final row in exerciseRows) {
      final session =
          await (_database.select(_database.completedWorkoutSessions)..where(
                (candidate) =>
                    candidate.id.equals(row.sessionId) &
                    candidate.userId.equals(userId) &
                    candidate.deletedAt.isNull(),
              ))
              .getSingleOrNull();
      if (session == null) continue;
      final setRows =
          await (_database.select(_database.completedWorkoutSets)..where(
                (candidate) =>
                    candidate.userId.equals(userId) &
                    candidate.sessionExerciseId.equals(row.id) &
                    candidate.deletedAt.isNull(),
              ))
              .get();
      candidates.addAll(
        _recordCandidates(
          exercise: _completedExerciseFromRow(row),
          sets: setRows.map(_completedSetFromRow).toList(),
          achievedAt: session.endedAt,
        ),
      );
    }
    final best = <String, _RecordCandidate>{};
    for (final candidate in candidates) {
      final key = '${candidate.kind.wireValue}|${candidate.scope}';
      final existing = best[key];
      if (existing == null || candidate.isBetterThan(existing)) {
        best[key] = candidate;
      }
    }
    final currentRows =
        await (_database.select(_database.personalRecords)..where(
              (row) =>
                  row.userId.equals(userId) &
                  row.exerciseKey.equals(exerciseKey),
            ))
            .get();
    final currentByKey = {
      for (final row in currentRows)
        '${row.recordKind}|${row.recordScope}': _personalRecordFromRow(row),
    };
    final keys = {...currentByKey.keys, ...best.keys};
    for (final key in keys) {
      final current = currentByKey[key];
      final candidate = best[key];
      if (candidate == null) {
        if (current == null || current.isDeleted) continue;
        final deleted = _copyPersonalRecord(
          current,
          deletedAt: now,
          updatedAt: now,
          version: current.version + 1,
        );
        await _upsertPersonalRecord(deleted);
        await _enqueueEntity(deleted, SessionEntityType.personalRecord, now);
        continue;
      }
      final replacement = PersonalRecord(
        id: current?.id ?? _newId(),
        userId: userId,
        exerciseSource: candidate.exercise.exerciseSource,
        exerciseKey: candidate.exercise.exerciseKey,
        systemExerciseKey: candidate.exercise.systemExerciseKey,
        customExerciseId: candidate.exercise.customExerciseId,
        exerciseName: candidate.exercise.exerciseName,
        recordKind: candidate.kind,
        recordScope: candidate.scope,
        recordValue: candidate.value,
        weightKg: candidate.weightKg,
        repetitions: candidate.repetitions,
        estimatedOneRepMaxKg: candidate.estimatedOneRepMaxKg,
        completedSessionId: candidate.exercise.sessionId,
        completedExerciseId: candidate.exercise.id,
        completedSetId: candidate.completedSetId,
        achievedAt: candidate.achievedAt,
        createdAt: current?.createdAt ?? now,
        updatedAt: now,
        version: (current?.version ?? 0) + 1,
      );
      if (current != null &&
          !current.isDeleted &&
          _sameCurrentRecord(current, replacement)) {
        continue;
      }
      await _upsertPersonalRecord(replacement);
      await _enqueueEntity(replacement, SessionEntityType.personalRecord, now);
    }
  }

  Future<ActiveWorkoutSession> _requireActiveSession(
    String userId,
    String sessionId,
  ) async {
    final owner = _requiredId(userId, 'userId');
    final id = _requiredId(sessionId, 'sessionId');
    final row =
        await (_database.select(_database.activeWorkoutSessions)..where(
              (candidate) =>
                  candidate.id.equals(id) &
                  candidate.userId.equals(owner) &
                  candidate.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    if (row == null) throw StateError('Active workout was not found.');
    return _activeSessionFromRow(row);
  }

  Future<ActiveWorkoutExercise> _requireActiveExercise(
    String userId,
    String exerciseId,
  ) async {
    final owner = _requiredId(userId, 'userId');
    final id = _requiredId(exerciseId, 'exerciseId');
    final row =
        await (_database.select(_database.activeWorkoutExercises)..where(
              (candidate) =>
                  candidate.id.equals(id) &
                  candidate.userId.equals(owner) &
                  candidate.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    if (row == null) throw StateError('Active workout exercise was not found.');
    await _requireActiveSession(owner, row.sessionId);
    return _activeExerciseFromRow(row);
  }

  Future<ActiveWorkoutSet> _requireActiveSet(
    String userId,
    String setId,
  ) async {
    final owner = _requiredId(userId, 'userId');
    final id = _requiredId(setId, 'setId');
    final row =
        await (_database.select(_database.activeWorkoutSets)..where(
              (candidate) =>
                  candidate.id.equals(id) &
                  candidate.userId.equals(owner) &
                  candidate.deletedAt.isNull(),
            ))
            .getSingleOrNull();
    if (row == null) throw StateError('Active workout set was not found.');
    await _requireActiveSession(owner, row.sessionId);
    return _activeSetFromRow(row);
  }

  Future<ActiveWorkoutBundle> _activeBundle(ActiveWorkoutSessionRow row) =>
      _activeBundleFromSession(_activeSessionFromRow(row));

  Future<ActiveWorkoutBundle> _activeBundleFromSession(
    ActiveWorkoutSession session,
  ) async {
    final exerciseRows =
        await (_database.select(_database.activeWorkoutExercises)
              ..where(
                (row) =>
                    row.sessionId.equals(session.id) &
                    row.userId.equals(session.userId) &
                    row.deletedAt.isNull(),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
            .get();
    final setRows =
        await (_database.select(_database.activeWorkoutSets)
              ..where(
                (row) =>
                    row.sessionId.equals(session.id) &
                    row.userId.equals(session.userId) &
                    row.deletedAt.isNull(),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
            .get();
    return ActiveWorkoutBundle(
      session: session,
      exercises: exerciseRows.map(_activeExerciseFromRow),
      sets: setRows.map(_activeSetFromRow),
    );
  }

  Future<CompletedWorkoutBundle> _completedBundle(
    CompletedWorkoutSessionRow row,
  ) async {
    final exerciseRows =
        await (_database.select(_database.completedWorkoutExercises)
              ..where(
                (candidate) =>
                    candidate.sessionId.equals(row.id) &
                    candidate.userId.equals(row.userId) &
                    candidate.deletedAt.isNull(),
              )
              ..orderBy([(candidate) => OrderingTerm.asc(candidate.sortOrder)]))
            .get();
    final setRows =
        await (_database.select(_database.completedWorkoutSets)
              ..where(
                (candidate) =>
                    candidate.sessionId.equals(row.id) &
                    candidate.userId.equals(row.userId) &
                    candidate.deletedAt.isNull(),
              )
              ..orderBy([(candidate) => OrderingTerm.asc(candidate.sortOrder)]))
            .get();
    return CompletedWorkoutBundle(
      session: _completedSessionFromRow(row),
      exercises: exerciseRows.map(_completedExerciseFromRow),
      sets: setRows.map(_completedSetFromRow),
    );
  }

  Future<ExerciseSelection> _selectionForTemplateExercise(
    TemplateExerciseRow row,
  ) async {
    if (row.customExerciseId != null) {
      final custom =
          await (_database.select(_database.customExercises)..where(
                (candidate) =>
                    candidate.id.equals(row.customExerciseId!) &
                    candidate.userId.equals(row.userId),
              ))
              .getSingleOrNull();
      if (custom != null) {
        return ExerciseSelection.custom(
          CustomExercise(
            id: custom.id,
            userId: custom.userId,
            name: custom.name,
            primaryMuscleGroup: muscleGroupFromWire(custom.primaryMuscleGroup),
            secondaryMuscleGroups: _muscleGroupsFromJson(
              custom.secondaryMuscleGroupsJson,
            ),
            equipment: exerciseEquipmentFromWire(custom.equipment),
            aliases: _stringsFromJson(custom.aliasesJson),
            keywords: _stringsFromJson(custom.searchKeywordsJson),
            instructions: custom.instructions,
            personalNotes: custom.personalNotes,
            isFavourite: custom.isFavourite,
            lastUsedAt: custom.lastUsedAt,
            createdAt: custom.createdAt,
            updatedAt: custom.updatedAt,
            deletedAt: custom.deletedAt,
            version: custom.version,
          ),
        );
      }
    }
    final systemKey = row.systemExerciseKey ?? row.id;
    return SystemExerciseCatalog.byKey(systemKey) ??
        ExerciseSelection.system(
          key: systemKey,
          name: row.exerciseName,
          primaryMuscleGroup: muscleGroupFromWire(row.primaryMuscleGroup),
          equipment: exerciseEquipmentFromWire(row.equipment),
        );
  }

  Future<ActiveWorkoutExercise> _insertExerciseWithPlannedSets({
    required ActiveWorkoutSession session,
    required ExerciseSelection selection,
    required TemplateExerciseConfiguration configuration,
    required int sortOrder,
    required DateTime now,
  }) async {
    _validateConfiguration(configuration);
    final exercise = ActiveWorkoutExercise(
      id: _newId(),
      userId: session.userId,
      sessionId: session.id,
      exerciseSource: selection.source,
      exerciseKey: selection.exerciseId,
      systemExerciseKey: selection.systemExerciseKey,
      customExerciseId: selection.customExerciseId,
      exerciseName: _requiredText(selection.name, 'Exercise name', 120),
      primaryMuscleGroup: selection.primaryMuscleGroup,
      secondaryMuscleGroups: selection.secondaryMuscleGroups,
      equipment: selection.equipment,
      trackingType: selection.trackingType,
      weightRelevant: selection.weightRelevant,
      repetitionsRelevant: selection.repetitionsRelevant,
      distanceRelevant: selection.distanceRelevant,
      durationRelevant: selection.durationRelevant,
      bodyweightRelevant: selection.bodyweightRelevant,
      plannedWorkingSets: configuration.workingSets,
      plannedWarmupSets: configuration.warmupSets,
      minTargetReps: configuration.targetRepsMin,
      maxTargetReps: configuration.targetRepsMax,
      targetWeightKg: configuration.targetWeight,
      restSeconds: configuration.restSeconds,
      rpeTarget: configuration.rpeTarget,
      rirTarget: configuration.rirTarget,
      notes: _optionalText(configuration.notes, 2000),
      sortOrder: sortOrder,
      createdAt: now,
      updatedAt: now,
      version: 1,
    );
    await _upsertActiveExercise(exercise);
    await _enqueueEntity(exercise, SessionEntityType.activeExercise, now);
    final setTypes = <WorkoutSetType>[
      ...List.filled(configuration.warmupSets, WorkoutSetType.warmUp),
      ...List.filled(configuration.workingSets, WorkoutSetType.working),
    ];
    for (var index = 0; index < setTypes.length; index++) {
      final set = ActiveWorkoutSet(
        id: _newId(),
        userId: session.userId,
        sessionId: session.id,
        sessionExerciseId: exercise.id,
        setType: setTypes[index],
        weightKg: setTypes[index] == WorkoutSetType.warmUp
            ? null
            : configuration.targetWeight,
        repetitions: configuration.targetRepsMin,
        rpe: configuration.rpeTarget,
        rir: configuration.rirTarget,
        isCompleted: false,
        sortOrder: index,
        createdAt: now,
        updatedAt: now,
        version: 1,
      );
      await _upsertActiveSet(set);
      await _enqueueEntity(set, SessionEntityType.activeSet, now);
    }
    return exercise;
  }

  Future<void> _touchActiveSession(
    ActiveWorkoutSession session,
    DateTime now,
  ) => _saveActiveSession(
    _copyActiveSession(session, updatedAt: now, version: session.version + 1),
    now,
  );

  Future<void> _touchSessionById(
    String userId,
    String sessionId,
    DateTime now,
  ) async {
    final session = await _requireActiveSession(userId, sessionId);
    await _touchActiveSession(session, now);
  }

  Future<void> _saveActiveSession(
    ActiveWorkoutSession session,
    DateTime now,
  ) async {
    await _upsertActiveSession(session);
    await _enqueueEntity(session, SessionEntityType.activeSession, now);
  }

  Future<void> _insertActiveSession(ActiveWorkoutSession session) =>
      _upsertActiveSession(session);

  Future<void> _upsertActiveSession(ActiveWorkoutSession value) async {
    await _database
        .into(_database.activeWorkoutSessions)
        .insertOnConflictUpdate(
          ActiveWorkoutSessionsCompanion(
            id: Value(value.id),
            userId: Value(value.userId),
            name: Value(value.name),
            sourceTemplateId: Value(value.sourceTemplateId),
            startedAt: Value(value.startedAt),
            notes: Value(value.notes),
            weightUnit: Value(value.weightUnit),
            restTimerState: Value(value.restTimerState.name),
            restTimerDurationSeconds: Value(value.restTimerDurationSeconds),
            restTimerTargetEndAt: Value(value.restTimerTargetEndAt),
            restTimerRemainingSeconds: Value(value.restTimerRemainingSeconds),
            autoStartRestTimer: Value(value.autoStartRestTimer),
            createdAt: Value(value.createdAt),
            updatedAt: Value(value.updatedAt),
            deletedAt: Value(value.deletedAt),
            version: Value(value.version),
          ),
        );
  }

  Future<void> _upsertActiveExercise(ActiveWorkoutExercise value) async {
    await _database
        .into(_database.activeWorkoutExercises)
        .insertOnConflictUpdate(
          ActiveWorkoutExercisesCompanion(
            id: Value(value.id),
            userId: Value(value.userId),
            sessionId: Value(value.sessionId),
            exerciseSource: Value(value.exerciseSource.name),
            exerciseKey: Value(value.exerciseKey),
            systemExerciseKey: Value(value.systemExerciseKey),
            customExerciseId: Value(value.customExerciseId),
            exerciseName: Value(value.exerciseName),
            primaryMuscleGroup: Value(value.primaryMuscleGroup.wireValue),
            secondaryMuscleGroupsJson: Value(
              jsonEncode(
                value.secondaryMuscleGroups
                    .map((group) => group.wireValue)
                    .toList(),
              ),
            ),
            equipment: Value(value.equipment.wireValue),
            trackingType: Value(value.trackingType.wireValue),
            weightRelevant: Value(value.weightRelevant),
            repetitionsRelevant: Value(value.repetitionsRelevant),
            distanceRelevant: Value(value.distanceRelevant),
            durationRelevant: Value(value.durationRelevant),
            bodyweightRelevant: Value(value.bodyweightRelevant),
            plannedWorkingSets: Value(value.plannedWorkingSets),
            plannedWarmupSets: Value(value.plannedWarmupSets),
            minTargetReps: Value(value.minTargetReps),
            maxTargetReps: Value(value.maxTargetReps),
            targetWeightKg: Value(value.targetWeightKg),
            restSeconds: Value(value.restSeconds),
            rpeTarget: Value(value.rpeTarget),
            rirTarget: Value(value.rirTarget),
            notes: Value(value.notes),
            sortOrder: Value(value.sortOrder),
            createdAt: Value(value.createdAt),
            updatedAt: Value(value.updatedAt),
            deletedAt: Value(value.deletedAt),
            version: Value(value.version),
          ),
        );
  }

  Future<void> _upsertActiveSet(ActiveWorkoutSet value) async {
    await _database
        .into(_database.activeWorkoutSets)
        .insertOnConflictUpdate(
          ActiveWorkoutSetsCompanion(
            id: Value(value.id),
            userId: Value(value.userId),
            sessionId: Value(value.sessionId),
            sessionExerciseId: Value(value.sessionExerciseId),
            setType: Value(value.setType.wireValue),
            weightKg: Value(value.weightKg),
            repetitions: Value(value.repetitions),
            durationSeconds: Value(value.durationSeconds),
            distanceMeters: Value(value.distanceMeters),
            rpe: Value(value.rpe),
            rir: Value(value.rir),
            isCompleted: Value(value.isCompleted),
            notes: Value(value.notes),
            sortOrder: Value(value.sortOrder),
            completedAt: Value(value.completedAt),
            createdAt: Value(value.createdAt),
            updatedAt: Value(value.updatedAt),
            deletedAt: Value(value.deletedAt),
            version: Value(value.version),
          ),
        );
  }

  Future<void> _upsertCompletedSession(CompletedWorkoutSession value) async {
    await _database
        .into(_database.completedWorkoutSessions)
        .insertOnConflictUpdate(
          CompletedWorkoutSessionsCompanion(
            id: Value(value.id),
            userId: Value(value.userId),
            sourceActiveSessionId: Value(value.sourceActiveSessionId),
            sourceTemplateId: Value(value.sourceTemplateId),
            name: Value(value.name),
            notes: Value(value.notes),
            weightUnit: Value(value.weightUnit),
            startedAt: Value(value.startedAt),
            endedAt: Value(value.endedAt),
            durationSeconds: Value(value.durationSeconds),
            exerciseCount: Value(value.exerciseCount),
            workingSetCount: Value(value.workingSetCount),
            totalCompletedSets: Value(value.totalCompletedSets),
            totalRepetitions: Value(value.totalRepetitions),
            totalVolumeKg: Value(value.totalVolumeKg),
            personalRecordCount: Value(value.personalRecordCount),
            createdAt: Value(value.createdAt),
            updatedAt: Value(value.updatedAt),
            deletedAt: Value(value.deletedAt),
            version: Value(value.version),
          ),
        );
  }

  Future<void> _upsertCompletedExercise(CompletedWorkoutExercise value) async {
    await _database
        .into(_database.completedWorkoutExercises)
        .insertOnConflictUpdate(
          CompletedWorkoutExercisesCompanion(
            id: Value(value.id),
            userId: Value(value.userId),
            sessionId: Value(value.sessionId),
            sourceActiveExerciseId: Value(value.sourceActiveExerciseId),
            exerciseSource: Value(value.exerciseSource.name),
            exerciseKey: Value(value.exerciseKey),
            systemExerciseKey: Value(value.systemExerciseKey),
            customExerciseId: Value(value.customExerciseId),
            exerciseName: Value(value.exerciseName),
            primaryMuscleGroup: Value(value.primaryMuscleGroup.wireValue),
            secondaryMuscleGroupsJson: Value(
              jsonEncode(
                value.secondaryMuscleGroups
                    .map((group) => group.wireValue)
                    .toList(),
              ),
            ),
            equipment: Value(value.equipment.wireValue),
            trackingType: Value(value.trackingType.wireValue),
            weightRelevant: Value(value.weightRelevant),
            repetitionsRelevant: Value(value.repetitionsRelevant),
            distanceRelevant: Value(value.distanceRelevant),
            durationRelevant: Value(value.durationRelevant),
            bodyweightRelevant: Value(value.bodyweightRelevant),
            notes: Value(value.notes),
            sortOrder: Value(value.sortOrder),
            completedSetCount: Value(value.completedSetCount),
            workingSetCount: Value(value.workingSetCount),
            totalRepetitions: Value(value.totalRepetitions),
            totalVolumeKg: Value(value.totalVolumeKg),
            bestWeightKg: Value(value.bestWeightKg),
            bestEstimatedOneRepMaxKg: Value(value.bestEstimatedOneRepMaxKg),
            createdAt: Value(value.createdAt),
            updatedAt: Value(value.updatedAt),
            deletedAt: Value(value.deletedAt),
            version: Value(value.version),
          ),
        );
  }

  Future<void> _upsertCompletedSet(CompletedWorkoutSet value) async {
    await _database
        .into(_database.completedWorkoutSets)
        .insertOnConflictUpdate(
          CompletedWorkoutSetsCompanion(
            id: Value(value.id),
            userId: Value(value.userId),
            sessionId: Value(value.sessionId),
            sessionExerciseId: Value(value.sessionExerciseId),
            sourceActiveSetId: Value(value.sourceActiveSetId),
            setType: Value(value.setType.wireValue),
            weightKg: Value(value.weightKg),
            repetitions: Value(value.repetitions),
            durationSeconds: Value(value.durationSeconds),
            distanceMeters: Value(value.distanceMeters),
            rpe: Value(value.rpe),
            rir: Value(value.rir),
            notes: Value(value.notes),
            sortOrder: Value(value.sortOrder),
            setVolumeKg: Value(value.setVolumeKg),
            estimatedOneRepMaxKg: Value(value.estimatedOneRepMaxKg),
            isPersonalRecord: Value(value.isPersonalRecord),
            completedAt: Value(value.completedAt),
            createdAt: Value(value.createdAt),
            updatedAt: Value(value.updatedAt),
            deletedAt: Value(value.deletedAt),
            version: Value(value.version),
          ),
        );
  }

  Future<void> _upsertPersonalRecord(PersonalRecord value) async {
    await _database
        .into(_database.personalRecords)
        .insertOnConflictUpdate(
          PersonalRecordsCompanion(
            id: Value(value.id),
            userId: Value(value.userId),
            exerciseSource: Value(value.exerciseSource.name),
            exerciseKey: Value(value.exerciseKey),
            systemExerciseKey: Value(value.systemExerciseKey),
            customExerciseId: Value(value.customExerciseId),
            exerciseName: Value(value.exerciseName),
            recordKind: Value(value.recordKind.wireValue),
            recordScope: Value(value.recordScope),
            recordValue: Value(value.recordValue),
            weightKg: Value(value.weightKg),
            repetitions: Value(value.repetitions),
            estimatedOneRepMaxKg: Value(value.estimatedOneRepMaxKg),
            completedSessionId: Value(value.completedSessionId),
            completedExerciseId: Value(value.completedExerciseId),
            completedSetId: Value(value.completedSetId),
            achievedAt: Value(value.achievedAt),
            createdAt: Value(value.createdAt),
            updatedAt: Value(value.updatedAt),
            deletedAt: Value(value.deletedAt),
            version: Value(value.version),
          ),
        );
  }

  Future<void> _upsertPersonalRecordEvent(PersonalRecordEvent value) async {
    await _database
        .into(_database.personalRecordEvents)
        .insertOnConflictUpdate(
          PersonalRecordEventsCompanion(
            id: Value(value.id),
            userId: Value(value.userId),
            personalRecordId: Value(value.personalRecordId),
            eventKey: Value(value.eventKey),
            exerciseSource: Value(value.exerciseSource.name),
            exerciseKey: Value(value.exerciseKey),
            exerciseName: Value(value.exerciseName),
            recordKind: Value(value.recordKind.wireValue),
            recordScope: Value(value.recordScope),
            previousRecordValue: Value(value.previousRecordValue),
            recordValue: Value(value.recordValue),
            weightKg: Value(value.weightKg),
            repetitions: Value(value.repetitions),
            estimatedOneRepMaxKg: Value(value.estimatedOneRepMaxKg),
            completedSessionId: Value(value.completedSessionId),
            completedExerciseId: Value(value.completedExerciseId),
            completedSetId: Value(value.completedSetId),
            achievedAt: Value(value.achievedAt),
            createdAt: Value(value.createdAt),
            updatedAt: Value(value.updatedAt),
            deletedAt: Value(value.deletedAt),
            version: Value(value.version),
          ),
        );
  }

  ActiveWorkoutSession _activeSessionFromRow(ActiveWorkoutSessionRow row) =>
      ActiveWorkoutSession(
        id: row.id,
        userId: row.userId,
        name: row.name,
        sourceTemplateId: row.sourceTemplateId,
        startedAt: row.startedAt,
        notes: row.notes,
        weightUnit: row.weightUnit,
        restTimerState: restTimerStateFromWire(row.restTimerState),
        restTimerDurationSeconds: row.restTimerDurationSeconds,
        restTimerTargetEndAt: row.restTimerTargetEndAt,
        restTimerRemainingSeconds: row.restTimerRemainingSeconds,
        autoStartRestTimer: row.autoStartRestTimer,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
        version: row.version,
      );

  ActiveWorkoutExercise _activeExerciseFromRow(ActiveWorkoutExerciseRow row) =>
      ActiveWorkoutExercise(
        id: row.id,
        userId: row.userId,
        sessionId: row.sessionId,
        exerciseSource: _exerciseSourceFromWire(row.exerciseSource),
        exerciseKey: row.exerciseKey,
        systemExerciseKey: row.systemExerciseKey,
        customExerciseId: row.customExerciseId,
        exerciseName: row.exerciseName,
        primaryMuscleGroup: muscleGroupFromWire(row.primaryMuscleGroup),
        secondaryMuscleGroups: _muscleGroupsFromJson(
          row.secondaryMuscleGroupsJson,
        ),
        equipment: exerciseEquipmentFromWire(row.equipment),
        trackingType: exerciseTrackingTypeFromWire(row.trackingType),
        weightRelevant: row.weightRelevant,
        repetitionsRelevant: row.repetitionsRelevant,
        distanceRelevant: row.distanceRelevant,
        durationRelevant: row.durationRelevant,
        bodyweightRelevant: row.bodyweightRelevant,
        plannedWorkingSets: row.plannedWorkingSets,
        plannedWarmupSets: row.plannedWarmupSets,
        minTargetReps: row.minTargetReps,
        maxTargetReps: row.maxTargetReps,
        targetWeightKg: row.targetWeightKg,
        restSeconds: row.restSeconds,
        rpeTarget: row.rpeTarget,
        rirTarget: row.rirTarget,
        notes: row.notes,
        sortOrder: row.sortOrder,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
        version: row.version,
      );

  ActiveWorkoutSet _activeSetFromRow(
    ActiveWorkoutSetRow row, {
    DateTime? deletedAt,
  }) => ActiveWorkoutSet(
    id: row.id,
    userId: row.userId,
    sessionId: row.sessionId,
    sessionExerciseId: row.sessionExerciseId,
    setType: workoutSetTypeFromWire(row.setType),
    weightKg: row.weightKg,
    repetitions: row.repetitions,
    durationSeconds: row.durationSeconds,
    distanceMeters: row.distanceMeters,
    rpe: row.rpe,
    rir: row.rir,
    isCompleted: row.isCompleted,
    notes: row.notes,
    sortOrder: row.sortOrder,
    completedAt: row.completedAt,
    createdAt: row.createdAt,
    updatedAt: deletedAt ?? row.updatedAt,
    deletedAt: deletedAt ?? row.deletedAt,
    version: deletedAt == null ? row.version : row.version + 1,
  );

  CompletedWorkoutSession _completedSessionFromRow(
    CompletedWorkoutSessionRow row,
  ) => CompletedWorkoutSession(
    id: row.id,
    userId: row.userId,
    sourceActiveSessionId: row.sourceActiveSessionId,
    sourceTemplateId: row.sourceTemplateId,
    name: row.name,
    notes: row.notes,
    weightUnit: row.weightUnit,
    startedAt: row.startedAt,
    endedAt: row.endedAt,
    durationSeconds: row.durationSeconds,
    exerciseCount: row.exerciseCount,
    workingSetCount: row.workingSetCount,
    totalCompletedSets: row.totalCompletedSets,
    totalRepetitions: row.totalRepetitions,
    totalVolumeKg: row.totalVolumeKg,
    personalRecordCount: row.personalRecordCount,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    deletedAt: row.deletedAt,
    version: row.version,
  );

  CompletedWorkoutExercise _completedExerciseFromRow(
    CompletedWorkoutExerciseRow row,
  ) => CompletedWorkoutExercise(
    id: row.id,
    userId: row.userId,
    sessionId: row.sessionId,
    sourceActiveExerciseId: row.sourceActiveExerciseId,
    exerciseSource: _exerciseSourceFromWire(row.exerciseSource),
    exerciseKey: row.exerciseKey,
    systemExerciseKey: row.systemExerciseKey,
    customExerciseId: row.customExerciseId,
    exerciseName: row.exerciseName,
    primaryMuscleGroup: muscleGroupFromWire(row.primaryMuscleGroup),
    secondaryMuscleGroups: _muscleGroupsFromJson(row.secondaryMuscleGroupsJson),
    equipment: exerciseEquipmentFromWire(row.equipment),
    trackingType: exerciseTrackingTypeFromWire(row.trackingType),
    weightRelevant: row.weightRelevant,
    repetitionsRelevant: row.repetitionsRelevant,
    distanceRelevant: row.distanceRelevant,
    durationRelevant: row.durationRelevant,
    bodyweightRelevant: row.bodyweightRelevant,
    notes: row.notes,
    sortOrder: row.sortOrder,
    completedSetCount: row.completedSetCount,
    workingSetCount: row.workingSetCount,
    totalRepetitions: row.totalRepetitions,
    totalVolumeKg: row.totalVolumeKg,
    bestWeightKg: row.bestWeightKg,
    bestEstimatedOneRepMaxKg: row.bestEstimatedOneRepMaxKg,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    deletedAt: row.deletedAt,
    version: row.version,
  );

  CompletedWorkoutSet _completedSetFromRow(CompletedWorkoutSetRow row) =>
      CompletedWorkoutSet(
        id: row.id,
        userId: row.userId,
        sessionId: row.sessionId,
        sessionExerciseId: row.sessionExerciseId,
        sourceActiveSetId: row.sourceActiveSetId,
        setType: workoutSetTypeFromWire(row.setType),
        weightKg: row.weightKg,
        repetitions: row.repetitions,
        durationSeconds: row.durationSeconds,
        distanceMeters: row.distanceMeters,
        rpe: row.rpe,
        rir: row.rir,
        notes: row.notes,
        sortOrder: row.sortOrder,
        setVolumeKg: row.setVolumeKg,
        estimatedOneRepMaxKg: row.estimatedOneRepMaxKg,
        isPersonalRecord: row.isPersonalRecord,
        completedAt: row.completedAt,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
        version: row.version,
      );

  PersonalRecord _personalRecordFromRow(PersonalRecordRow row) =>
      PersonalRecord(
        id: row.id,
        userId: row.userId,
        exerciseSource: _exerciseSourceFromWire(row.exerciseSource),
        exerciseKey: row.exerciseKey,
        systemExerciseKey: row.systemExerciseKey,
        customExerciseId: row.customExerciseId,
        exerciseName: row.exerciseName,
        recordKind: personalRecordKindFromWire(row.recordKind),
        recordScope: row.recordScope,
        recordValue: row.recordValue,
        weightKg: row.weightKg,
        repetitions: row.repetitions,
        estimatedOneRepMaxKg: row.estimatedOneRepMaxKg,
        completedSessionId: row.completedSessionId,
        completedExerciseId: row.completedExerciseId,
        completedSetId: row.completedSetId,
        achievedAt: row.achievedAt,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
        version: row.version,
      );

  PersonalRecordEvent _personalRecordEventFromRow(PersonalRecordEventRow row) =>
      PersonalRecordEvent(
        id: row.id,
        userId: row.userId,
        personalRecordId: row.personalRecordId,
        eventKey: row.eventKey,
        exerciseSource: _exerciseSourceFromWire(row.exerciseSource),
        exerciseKey: row.exerciseKey,
        exerciseName: row.exerciseName,
        recordKind: personalRecordKindFromWire(row.recordKind),
        recordScope: row.recordScope,
        previousRecordValue: row.previousRecordValue,
        recordValue: row.recordValue,
        weightKg: row.weightKg,
        repetitions: row.repetitions,
        estimatedOneRepMaxKg: row.estimatedOneRepMaxKg,
        completedSessionId: row.completedSessionId,
        completedExerciseId: row.completedExerciseId,
        completedSetId: row.completedSetId,
        achievedAt: row.achievedAt,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        deletedAt: row.deletedAt,
        version: row.version,
      );

  ActiveWorkoutSession _copyActiveSession(
    ActiveWorkoutSession value, {
    String? name,
    Object? notes = _notProvided,
    RestTimerState? restTimerState,
    int? restTimerDurationSeconds,
    Object? restTimerTargetEndAt = _notProvided,
    bool clearRestTimerTargetEndAt = false,
    int? restTimerRemainingSeconds,
    bool? autoStartRestTimer,
    DateTime? updatedAt,
    Object? deletedAt = _notProvided,
    int? version,
  }) => ActiveWorkoutSession(
    id: value.id,
    userId: value.userId,
    name: name ?? value.name,
    sourceTemplateId: value.sourceTemplateId,
    startedAt: value.startedAt,
    notes: identical(notes, _notProvided) ? value.notes : notes as String?,
    weightUnit: value.weightUnit,
    restTimerState: restTimerState ?? value.restTimerState,
    restTimerDurationSeconds:
        restTimerDurationSeconds ?? value.restTimerDurationSeconds,
    restTimerTargetEndAt: clearRestTimerTargetEndAt
        ? null
        : identical(restTimerTargetEndAt, _notProvided)
        ? value.restTimerTargetEndAt
        : restTimerTargetEndAt as DateTime?,
    restTimerRemainingSeconds:
        restTimerRemainingSeconds ?? value.restTimerRemainingSeconds,
    autoStartRestTimer: autoStartRestTimer ?? value.autoStartRestTimer,
    createdAt: value.createdAt,
    updatedAt: updatedAt ?? value.updatedAt,
    deletedAt: identical(deletedAt, _notProvided)
        ? value.deletedAt
        : deletedAt as DateTime?,
    version: version ?? value.version,
  );

  ActiveWorkoutExercise _copyActiveExercise(
    ActiveWorkoutExercise value, {
    Object? notes = _notProvided,
    int? sortOrder,
    DateTime? updatedAt,
    Object? deletedAt = _notProvided,
    int? version,
  }) => ActiveWorkoutExercise(
    id: value.id,
    userId: value.userId,
    sessionId: value.sessionId,
    exerciseSource: value.exerciseSource,
    exerciseKey: value.exerciseKey,
    systemExerciseKey: value.systemExerciseKey,
    customExerciseId: value.customExerciseId,
    exerciseName: value.exerciseName,
    primaryMuscleGroup: value.primaryMuscleGroup,
    secondaryMuscleGroups: value.secondaryMuscleGroups,
    equipment: value.equipment,
    trackingType: value.trackingType,
    weightRelevant: value.weightRelevant,
    repetitionsRelevant: value.repetitionsRelevant,
    distanceRelevant: value.distanceRelevant,
    durationRelevant: value.durationRelevant,
    bodyweightRelevant: value.bodyweightRelevant,
    plannedWorkingSets: value.plannedWorkingSets,
    plannedWarmupSets: value.plannedWarmupSets,
    minTargetReps: value.minTargetReps,
    maxTargetReps: value.maxTargetReps,
    targetWeightKg: value.targetWeightKg,
    restSeconds: value.restSeconds,
    rpeTarget: value.rpeTarget,
    rirTarget: value.rirTarget,
    notes: identical(notes, _notProvided) ? value.notes : notes as String?,
    sortOrder: sortOrder ?? value.sortOrder,
    createdAt: value.createdAt,
    updatedAt: updatedAt ?? value.updatedAt,
    deletedAt: identical(deletedAt, _notProvided)
        ? value.deletedAt
        : deletedAt as DateTime?,
    version: version ?? value.version,
  );

  ActiveWorkoutSet _copyActiveSet(
    ActiveWorkoutSet value, {
    WorkoutSetType? setType,
    Object? weightKg = _notProvided,
    Object? repetitions = _notProvided,
    Object? durationSeconds = _notProvided,
    Object? distanceMeters = _notProvided,
    Object? rpe = _notProvided,
    Object? rir = _notProvided,
    bool? isCompleted,
    Object? notes = _notProvided,
    int? sortOrder,
    Object? completedAt = _notProvided,
    bool clearCompletedAt = false,
    DateTime? updatedAt,
    Object? deletedAt = _notProvided,
    int? version,
  }) => ActiveWorkoutSet(
    id: value.id,
    userId: value.userId,
    sessionId: value.sessionId,
    sessionExerciseId: value.sessionExerciseId,
    setType: setType ?? value.setType,
    weightKg: identical(weightKg, _notProvided)
        ? value.weightKg
        : weightKg as double?,
    repetitions: identical(repetitions, _notProvided)
        ? value.repetitions
        : repetitions as int?,
    durationSeconds: identical(durationSeconds, _notProvided)
        ? value.durationSeconds
        : durationSeconds as int?,
    distanceMeters: identical(distanceMeters, _notProvided)
        ? value.distanceMeters
        : distanceMeters as double?,
    rpe: identical(rpe, _notProvided) ? value.rpe : rpe as double?,
    rir: identical(rir, _notProvided) ? value.rir : rir as double?,
    isCompleted: isCompleted ?? value.isCompleted,
    notes: identical(notes, _notProvided) ? value.notes : notes as String?,
    sortOrder: sortOrder ?? value.sortOrder,
    completedAt: clearCompletedAt
        ? null
        : identical(completedAt, _notProvided)
        ? value.completedAt
        : completedAt as DateTime?,
    createdAt: value.createdAt,
    updatedAt: updatedAt ?? value.updatedAt,
    deletedAt: identical(deletedAt, _notProvided)
        ? value.deletedAt
        : deletedAt as DateTime?,
    version: version ?? value.version,
  );

  CompletedWorkoutSession _copyCompletedSession(
    CompletedWorkoutSession value, {
    Object? notes = _notProvided,
    int? personalRecordCount,
    DateTime? updatedAt,
    Object? deletedAt = _notProvided,
    int? version,
  }) => CompletedWorkoutSession(
    id: value.id,
    userId: value.userId,
    sourceActiveSessionId: value.sourceActiveSessionId,
    sourceTemplateId: value.sourceTemplateId,
    name: value.name,
    notes: identical(notes, _notProvided) ? value.notes : notes as String?,
    weightUnit: value.weightUnit,
    startedAt: value.startedAt,
    endedAt: value.endedAt,
    durationSeconds: value.durationSeconds,
    exerciseCount: value.exerciseCount,
    workingSetCount: value.workingSetCount,
    totalCompletedSets: value.totalCompletedSets,
    totalRepetitions: value.totalRepetitions,
    totalVolumeKg: value.totalVolumeKg,
    personalRecordCount: personalRecordCount ?? value.personalRecordCount,
    createdAt: value.createdAt,
    updatedAt: updatedAt ?? value.updatedAt,
    deletedAt: identical(deletedAt, _notProvided)
        ? value.deletedAt
        : deletedAt as DateTime?,
    version: version ?? value.version,
  );

  CompletedWorkoutExercise _copyCompletedExercise(
    CompletedWorkoutExercise value, {
    DateTime? updatedAt,
    Object? deletedAt = _notProvided,
    int? version,
  }) => CompletedWorkoutExercise(
    id: value.id,
    userId: value.userId,
    sessionId: value.sessionId,
    sourceActiveExerciseId: value.sourceActiveExerciseId,
    exerciseSource: value.exerciseSource,
    exerciseKey: value.exerciseKey,
    systemExerciseKey: value.systemExerciseKey,
    customExerciseId: value.customExerciseId,
    exerciseName: value.exerciseName,
    primaryMuscleGroup: value.primaryMuscleGroup,
    secondaryMuscleGroups: value.secondaryMuscleGroups,
    equipment: value.equipment,
    trackingType: value.trackingType,
    weightRelevant: value.weightRelevant,
    repetitionsRelevant: value.repetitionsRelevant,
    distanceRelevant: value.distanceRelevant,
    durationRelevant: value.durationRelevant,
    bodyweightRelevant: value.bodyweightRelevant,
    notes: value.notes,
    sortOrder: value.sortOrder,
    completedSetCount: value.completedSetCount,
    workingSetCount: value.workingSetCount,
    totalRepetitions: value.totalRepetitions,
    totalVolumeKg: value.totalVolumeKg,
    bestWeightKg: value.bestWeightKg,
    bestEstimatedOneRepMaxKg: value.bestEstimatedOneRepMaxKg,
    createdAt: value.createdAt,
    updatedAt: updatedAt ?? value.updatedAt,
    deletedAt: identical(deletedAt, _notProvided)
        ? value.deletedAt
        : deletedAt as DateTime?,
    version: version ?? value.version,
  );

  CompletedWorkoutSet _copyCompletedSet(
    CompletedWorkoutSet value, {
    bool? isPersonalRecord,
    DateTime? updatedAt,
    Object? deletedAt = _notProvided,
    int? version,
  }) => CompletedWorkoutSet(
    id: value.id,
    userId: value.userId,
    sessionId: value.sessionId,
    sessionExerciseId: value.sessionExerciseId,
    sourceActiveSetId: value.sourceActiveSetId,
    setType: value.setType,
    weightKg: value.weightKg,
    repetitions: value.repetitions,
    durationSeconds: value.durationSeconds,
    distanceMeters: value.distanceMeters,
    rpe: value.rpe,
    rir: value.rir,
    notes: value.notes,
    sortOrder: value.sortOrder,
    setVolumeKg: value.setVolumeKg,
    estimatedOneRepMaxKg: value.estimatedOneRepMaxKg,
    isPersonalRecord: isPersonalRecord ?? value.isPersonalRecord,
    completedAt: value.completedAt,
    createdAt: value.createdAt,
    updatedAt: updatedAt ?? value.updatedAt,
    deletedAt: identical(deletedAt, _notProvided)
        ? value.deletedAt
        : deletedAt as DateTime?,
    version: version ?? value.version,
  );

  PersonalRecord _copyPersonalRecord(
    PersonalRecord value, {
    DateTime? updatedAt,
    Object? deletedAt = _notProvided,
    int? version,
  }) => PersonalRecord(
    id: value.id,
    userId: value.userId,
    exerciseSource: value.exerciseSource,
    exerciseKey: value.exerciseKey,
    systemExerciseKey: value.systemExerciseKey,
    customExerciseId: value.customExerciseId,
    exerciseName: value.exerciseName,
    recordKind: value.recordKind,
    recordScope: value.recordScope,
    recordValue: value.recordValue,
    weightKg: value.weightKg,
    repetitions: value.repetitions,
    estimatedOneRepMaxKg: value.estimatedOneRepMaxKg,
    completedSessionId: value.completedSessionId,
    completedExerciseId: value.completedExerciseId,
    completedSetId: value.completedSetId,
    achievedAt: value.achievedAt,
    createdAt: value.createdAt,
    updatedAt: updatedAt ?? value.updatedAt,
    deletedAt: identical(deletedAt, _notProvided)
        ? value.deletedAt
        : deletedAt as DateTime?,
    version: version ?? value.version,
  );

  Future<void> _enqueueEntity(
    Object entity,
    SessionEntityType type,
    DateTime now,
  ) async {
    final (String userId, String id, int version) = switch (entity) {
      ActiveWorkoutSession value => (value.userId, value.id, value.version),
      ActiveWorkoutExercise value => (value.userId, value.id, value.version),
      ActiveWorkoutSet value => (value.userId, value.id, value.version),
      CompletedWorkoutSession value => (value.userId, value.id, value.version),
      CompletedWorkoutExercise value => (value.userId, value.id, value.version),
      CompletedWorkoutSet value => (value.userId, value.id, value.version),
      PersonalRecord value => (value.userId, value.id, value.version),
      PersonalRecordEvent value => (value.userId, value.id, value.version),
      _ => throw ArgumentError(
        'Unsupported session entity: ${entity.runtimeType}',
      ),
    };
    await _enqueue(
      userId: userId,
      type: type,
      entityId: id,
      entityVersion: version,
      now: now,
    );
  }

  Future<void> _enqueue({
    required String userId,
    required SessionEntityType type,
    required String entityId,
    required int entityVersion,
    required DateTime now,
  }) async {
    final existing =
        await (_database.select(_database.sessionSyncQueue)..where(
              (row) =>
                  row.userId.equals(userId) &
                  row.entityType.equals(type.wireValue) &
                  row.entityId.equals(entityId),
            ))
            .getSingleOrNull();
    if (existing != null && existing.entityVersion > entityVersion) return;
    await _database
        .into(_database.sessionSyncQueue)
        .insertOnConflictUpdate(
          SessionSyncQueueCompanion(
            id: Value(existing?.id ?? _newId()),
            userId: Value(userId),
            entityType: Value(type.wireValue),
            entityId: Value(entityId),
            entityVersion: Value(entityVersion),
            attemptCount: Value(
              existing?.entityVersion == entityVersion
                  ? existing!.attemptCount
                  : 0,
            ),
            lastError: Value(
              existing?.entityVersion == entityVersion
                  ? existing!.lastError
                  : null,
            ),
            lastAttemptAt: Value(
              existing?.entityVersion == entityVersion
                  ? existing!.lastAttemptAt
                  : null,
            ),
            createdAt: Value(existing?.createdAt ?? now),
            updatedAt: Value(now),
          ),
        );
  }

  Future<Object?> _loadQueuedEntity(
    String userId,
    SessionEntityType type,
    String entityId,
  ) async {
    switch (type) {
      case SessionEntityType.activeSession:
        final row =
            await (_database.select(_database.activeWorkoutSessions)..where(
                  (row) => row.id.equals(entityId) & row.userId.equals(userId),
                ))
                .getSingleOrNull();
        return row == null ? null : _activeSessionFromRow(row);
      case SessionEntityType.activeExercise:
        final row =
            await (_database.select(_database.activeWorkoutExercises)..where(
                  (row) => row.id.equals(entityId) & row.userId.equals(userId),
                ))
                .getSingleOrNull();
        return row == null ? null : _activeExerciseFromRow(row);
      case SessionEntityType.activeSet:
        final row =
            await (_database.select(_database.activeWorkoutSets)..where(
                  (row) => row.id.equals(entityId) & row.userId.equals(userId),
                ))
                .getSingleOrNull();
        return row == null ? null : _activeSetFromRow(row);
      case SessionEntityType.completedSession:
        final row =
            await (_database.select(_database.completedWorkoutSessions)..where(
                  (row) => row.id.equals(entityId) & row.userId.equals(userId),
                ))
                .getSingleOrNull();
        return row == null ? null : _completedSessionFromRow(row);
      case SessionEntityType.completedExercise:
        final row =
            await (_database.select(_database.completedWorkoutExercises)..where(
                  (row) => row.id.equals(entityId) & row.userId.equals(userId),
                ))
                .getSingleOrNull();
        return row == null ? null : _completedExerciseFromRow(row);
      case SessionEntityType.completedSet:
        final row =
            await (_database.select(_database.completedWorkoutSets)..where(
                  (row) => row.id.equals(entityId) & row.userId.equals(userId),
                ))
                .getSingleOrNull();
        return row == null ? null : _completedSetFromRow(row);
      case SessionEntityType.personalRecord:
        final row =
            await (_database.select(_database.personalRecords)..where(
                  (row) => row.id.equals(entityId) & row.userId.equals(userId),
                ))
                .getSingleOrNull();
        return row == null ? null : _personalRecordFromRow(row);
      case SessionEntityType.personalRecordEvent:
        final row =
            await (_database.select(_database.personalRecordEvents)..where(
                  (row) => row.id.equals(entityId) & row.userId.equals(userId),
                ))
                .getSingleOrNull();
        return row == null ? null : _personalRecordEventFromRow(row);
    }
  }

  Future<void> _upload(PendingSessionUpload item) async {
    final Object winner = switch (item.entityType) {
      SessionEntityType.activeSession => await _remote.upsertActiveSession(
        item.entity as ActiveWorkoutSession,
      ),
      SessionEntityType.activeExercise => await _remote.upsertActiveExercise(
        item.entity as ActiveWorkoutExercise,
      ),
      SessionEntityType.activeSet => await _remote.upsertActiveSet(
        item.entity as ActiveWorkoutSet,
      ),
      SessionEntityType.completedSession =>
        await _remote.upsertCompletedSession(
          item.entity as CompletedWorkoutSession,
        ),
      SessionEntityType.completedExercise =>
        await _remote.upsertCompletedExercise(
          item.entity as CompletedWorkoutExercise,
        ),
      SessionEntityType.completedSet => await _remote.upsertCompletedSet(
        item.entity as CompletedWorkoutSet,
      ),
      SessionEntityType.personalRecord => await _remote.upsertPersonalRecord(
        item.entity as PersonalRecord,
      ),
      SessionEntityType.personalRecordEvent =>
        await _remote.upsertPersonalRecordEvent(
          item.entity as PersonalRecordEvent,
        ),
    };
    await _adoptUploadedWinner(item, winner);
  }

  Future<void> _adoptUploadedWinner(
    PendingSessionUpload pending,
    Object winner,
  ) async {
    final coordinates = _entityCoordinates(winner);
    if (coordinates.$1 != pending.userId ||
        coordinates.$2 != pending.entityId ||
        coordinates.$3 < pending.entityVersion ||
        !_winnerMatchesType(pending.entityType, winner)) {
      throw StateError('Supabase returned an invalid session sync winner.');
    }
    await _database.transaction(() async {
      final queue =
          await (_database.select(_database.sessionSyncQueue)..where(
                (row) =>
                    row.id.equals(pending.queueId) &
                    row.userId.equals(pending.userId) &
                    row.entityType.equals(pending.entityType.wireValue) &
                    row.entityId.equals(pending.entityId) &
                    row.entityVersion.equals(pending.entityVersion),
              ))
              .getSingleOrNull();
      if (queue == null) return;
      switch (winner) {
        case ActiveWorkoutSession value:
          await _upsertActiveSession(value);
        case ActiveWorkoutExercise value:
          await _upsertActiveExercise(value);
        case ActiveWorkoutSet value:
          await _upsertActiveSet(value);
        case CompletedWorkoutSession value:
          await _upsertCompletedSession(value);
        case CompletedWorkoutExercise value:
          await _upsertCompletedExercise(value);
        case CompletedWorkoutSet value:
          await _upsertCompletedSet(value);
        case PersonalRecord value:
          await _upsertPersonalRecord(value);
        case PersonalRecordEvent value:
          await _upsertPersonalRecordEvent(value);
        default:
          throw StateError('Unsupported session sync winner type.');
      }
    });
  }

  Future<void> _restoreEntityIfNewer(
    String userId,
    SessionEntityType type,
    String entityId,
    int remoteVersion,
    Future<void> Function() upsert,
  ) async {
    final pending =
        await (_database.select(_database.sessionSyncQueue)..where(
              (row) =>
                  row.userId.equals(userId) &
                  row.entityType.equals(type.wireValue) &
                  row.entityId.equals(entityId),
            ))
            .getSingleOrNull();
    if (pending != null) return;
    final localVersion = await _localEntityVersion(userId, type, entityId);
    if (localVersion == null || remoteVersion > localVersion) await upsert();
  }

  Future<int?> _localEntityVersion(
    String userId,
    SessionEntityType type,
    String entityId,
  ) async {
    final entity = await _loadQueuedEntity(userId, type, entityId);
    return switch (entity) {
      ActiveWorkoutSession value => value.version,
      ActiveWorkoutExercise value => value.version,
      ActiveWorkoutSet value => value.version,
      CompletedWorkoutSession value => value.version,
      CompletedWorkoutExercise value => value.version,
      CompletedWorkoutSet value => value.version,
      PersonalRecord value => value.version,
      PersonalRecordEvent value => value.version,
      _ => null,
    };
  }

  (String, String, int) _entityCoordinates(Object entity) => switch (entity) {
    ActiveWorkoutSession value => (value.userId, value.id, value.version),
    ActiveWorkoutExercise value => (value.userId, value.id, value.version),
    ActiveWorkoutSet value => (value.userId, value.id, value.version),
    CompletedWorkoutSession value => (value.userId, value.id, value.version),
    CompletedWorkoutExercise value => (value.userId, value.id, value.version),
    CompletedWorkoutSet value => (value.userId, value.id, value.version),
    PersonalRecord value => (value.userId, value.id, value.version),
    PersonalRecordEvent value => (value.userId, value.id, value.version),
    _ => throw ArgumentError(
      'Unsupported session entity: ${entity.runtimeType}',
    ),
  };

  bool _winnerMatchesType(SessionEntityType type, Object winner) =>
      switch (type) {
        SessionEntityType.activeSession => winner is ActiveWorkoutSession,
        SessionEntityType.activeExercise => winner is ActiveWorkoutExercise,
        SessionEntityType.activeSet => winner is ActiveWorkoutSet,
        SessionEntityType.completedSession => winner is CompletedWorkoutSession,
        SessionEntityType.completedExercise =>
          winner is CompletedWorkoutExercise,
        SessionEntityType.completedSet => winner is CompletedWorkoutSet,
        SessionEntityType.personalRecord => winner is PersonalRecord,
        SessionEntityType.personalRecordEvent => winner is PersonalRecordEvent,
      };

  bool _sameCurrentRecord(PersonalRecord a, PersonalRecord b) =>
      a.recordValue == b.recordValue &&
      a.completedSessionId == b.completedSessionId &&
      a.completedExerciseId == b.completedExerciseId &&
      a.completedSetId == b.completedSetId &&
      a.deletedAt == null;

  String _personalRecordEventKey(PersonalRecord record) =>
      '${record.userId}|${record.exerciseKey}|${record.recordKind.wireValue}|'
      '${record.recordScope}|${record.completedSessionId}|'
      '${record.completedSetId ?? 'workout'}|'
      '${record.recordValue.toStringAsFixed(3)}';

  ExerciseSource _exerciseSourceFromWire(String value) =>
      value == ExerciseSource.custom.name
      ? ExerciseSource.custom
      : ExerciseSource.system;

  List<String> _stringsFromJson(String source) {
    try {
      final decoded = jsonDecode(source);
      return decoded is List
          ? decoded.whereType<String>().toList(growable: false)
          : const [];
    } on FormatException {
      return const [];
    }
  }

  List<MuscleGroup> _muscleGroupsFromJson(String source) =>
      _stringsFromJson(source).map(muscleGroupFromWire).toList(growable: false);

  void _validateConfiguration(TemplateExerciseConfiguration value) {
    if (value.workingSets < 0 || value.workingSets > 100) {
      throw ArgumentError.value(value.workingSets, 'workingSets');
    }
    if (value.warmupSets < 0 || value.warmupSets > 100) {
      throw ArgumentError.value(value.warmupSets, 'warmupSets');
    }
    if (value.targetRepsMin < 0 ||
        value.targetRepsMax < value.targetRepsMin ||
        value.targetRepsMax > 100000) {
      throw ArgumentError('Target repetition range is invalid.');
    }
    if (value.restSeconds < 0 || value.restSeconds > 24 * 60 * 60) {
      throw ArgumentError.value(value.restSeconds, 'restSeconds');
    }
    _validateSetValues(
      weightKg: value.targetWeight,
      rpe: value.rpeTarget,
      rir: value.rirTarget,
    );
  }

  void _validateSetValues({
    double? weightKg,
    int? repetitions,
    int? durationSeconds,
    double? distanceMeters,
    double? rpe,
    double? rir,
  }) {
    if (weightKg != null &&
        (!weightKg.isFinite || weightKg < 0 || weightKg > 100000)) {
      throw ArgumentError.value(weightKg, 'weightKg');
    }
    if (repetitions != null && (repetitions < 0 || repetitions > 100000)) {
      throw ArgumentError.value(repetitions, 'repetitions');
    }
    if (durationSeconds != null &&
        (durationSeconds < 0 || durationSeconds > 7 * 24 * 60 * 60)) {
      throw ArgumentError.value(durationSeconds, 'durationSeconds');
    }
    if (distanceMeters != null &&
        (!distanceMeters.isFinite ||
            distanceMeters < 0 ||
            distanceMeters > 1000000000)) {
      throw ArgumentError.value(distanceMeters, 'distanceMeters');
    }
    if (rpe != null && (!rpe.isFinite || rpe < 0 || rpe > 10)) {
      throw ArgumentError.value(rpe, 'rpe');
    }
    if (rir != null && (!rir.isFinite || rir < 0 || rir > 10)) {
      throw ArgumentError.value(rir, 'rir');
    }
  }

  String _requiredId(String value, String name) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) throw ArgumentError.value(value, name);
    return trimmed;
  }

  String _requiredText(String value, String label, int maximumLength) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) throw ArgumentError('$label is required.');
    if (trimmed.length > maximumLength) {
      throw ArgumentError('$label must be $maximumLength characters or fewer.');
    }
    return trimmed;
  }

  String? _optionalText(String? value, int maximumLength) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    if (trimmed.length > maximumLength) {
      throw ArgumentError('Text must be $maximumLength characters or fewer.');
    }
    return trimmed;
  }

  String _safeError(Object error) {
    final value = error.toString();
    return value.length <= 1000 ? value : value.substring(0, 1000);
  }

  static double _maxDouble(double a, double b) => a > b ? a : b;
}

const Object _notProvided = Object();

class _NewRecordResult {
  const _NewRecordResult(this.events, this.completedSetIds);

  final List<PersonalRecordEvent> events;
  final Set<String> completedSetIds;
}

class _RecordCandidate {
  const _RecordCandidate({
    required this.exercise,
    required this.kind,
    required this.scope,
    required this.value,
    required this.achievedAt,
    this.weightKg,
    this.repetitions,
    this.estimatedOneRepMaxKg,
    this.completedSetId,
  });

  final CompletedWorkoutExercise exercise;
  final PersonalRecordKind kind;
  final String scope;
  final double value;
  final double? weightKg;
  final int? repetitions;
  final double? estimatedOneRepMaxKg;
  final String? completedSetId;
  final DateTime achievedAt;

  bool isBetterThan(_RecordCandidate other) {
    if (value != other.value) return value > other.value;
    final time = achievedAt.compareTo(other.achievedAt);
    if (time != 0) return time < 0;
    return (completedSetId ?? '').compareTo(other.completedSetId ?? '') < 0;
  }
}
