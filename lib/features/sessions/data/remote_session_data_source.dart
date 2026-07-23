import 'package:supabase_flutter/supabase_flutter.dart';

import '../../planning/domain/planning_models.dart';
import '../domain/workout_session_models.dart';

abstract interface class RemoteSessionDataSource {
  Future<ActiveWorkoutSession> upsertActiveSession(
    ActiveWorkoutSession session,
  );

  Future<ActiveWorkoutExercise> upsertActiveExercise(
    ActiveWorkoutExercise exercise,
  );

  Future<ActiveWorkoutSet> upsertActiveSet(ActiveWorkoutSet set);

  Future<CompletedWorkoutSession> upsertCompletedSession(
    CompletedWorkoutSession session,
  );

  Future<CompletedWorkoutExercise> upsertCompletedExercise(
    CompletedWorkoutExercise exercise,
  );

  Future<CompletedWorkoutSet> upsertCompletedSet(CompletedWorkoutSet set);

  Future<PersonalRecord> upsertPersonalRecord(PersonalRecord record);

  Future<PersonalRecordEvent> upsertPersonalRecordEvent(
    PersonalRecordEvent event,
  );

  Future<SessionCloudSnapshot> fetchSnapshot(String userId);
}

/// Owner-scoped Supabase adapter for the Stage 3 snapshot tables.
///
/// Stable UUID upserts are version-guarded by migration 0003. A stale write
/// returns no row, so the accepted cloud winner is fetched and returned.
class SupabaseRemoteSessionDataSource implements RemoteSessionDataSource {
  SupabaseRemoteSessionDataSource(SupabaseClient client) : _client = client;

  final SupabaseClient _client;

  @override
  Future<ActiveWorkoutSession> upsertActiveSession(
    ActiveWorkoutSession value,
  ) => _upsert(
    'active_workout_sessions',
    value.id,
    value.userId,
    _activeSessionPayload(value),
    _activeSessionFromMap,
  );

  @override
  Future<ActiveWorkoutExercise> upsertActiveExercise(
    ActiveWorkoutExercise value,
  ) => _upsert(
    'active_workout_exercises',
    value.id,
    value.userId,
    _activeExercisePayload(value),
    _activeExerciseFromMap,
  );

  @override
  Future<ActiveWorkoutSet> upsertActiveSet(ActiveWorkoutSet value) => _upsert(
    'active_workout_sets',
    value.id,
    value.userId,
    _activeSetPayload(value),
    (row) => _activeSetFromMap(row, value.sessionId),
  );

  @override
  Future<CompletedWorkoutSession> upsertCompletedSession(
    CompletedWorkoutSession value,
  ) => _upsert(
    'completed_workout_sessions',
    value.id,
    value.userId,
    _completedSessionPayload(value),
    _completedSessionFromMap,
  );

  @override
  Future<CompletedWorkoutExercise> upsertCompletedExercise(
    CompletedWorkoutExercise value,
  ) => _upsert(
    'completed_workout_exercises',
    value.id,
    value.userId,
    _completedExercisePayload(value),
    _completedExerciseFromMap,
  );

  @override
  Future<CompletedWorkoutSet> upsertCompletedSet(CompletedWorkoutSet value) =>
      _upsert(
        'completed_workout_sets',
        value.id,
        value.userId,
        _completedSetPayload(value),
        (row) => _completedSetFromMap(row, value.sessionId),
      );

  @override
  Future<PersonalRecord> upsertPersonalRecord(PersonalRecord value) => _upsert(
    'personal_records',
    value.id,
    value.userId,
    _personalRecordPayload(value),
    _personalRecordFromMap,
  );

  @override
  Future<PersonalRecordEvent> upsertPersonalRecordEvent(
    PersonalRecordEvent value,
  ) => _upsert(
    'personal_record_events',
    value.id,
    value.userId,
    _personalRecordEventPayload(value),
    _personalRecordEventFromMap,
  );

  @override
  Future<SessionCloudSnapshot> fetchSnapshot(String userId) async {
    final activeSessionRows = await _fetchAllOwned(
      'active_workout_sessions',
      userId,
    );
    final activeExerciseRows = await _fetchAllOwned(
      'active_workout_exercises',
      userId,
    );
    final activeSetRows = await _fetchAllOwned('active_workout_sets', userId);
    final completedSessionRows = await _fetchAllOwned(
      'completed_workout_sessions',
      userId,
    );
    final completedExerciseRows = await _fetchAllOwned(
      'completed_workout_exercises',
      userId,
    );
    final completedSetRows = await _fetchAllOwned(
      'completed_workout_sets',
      userId,
    );
    final personalRecordRows = await _fetchAllOwned('personal_records', userId);
    final eventRows = await _fetchAllOwned('personal_record_events', userId);

    final activeExercises = activeExerciseRows
        .map(_activeExerciseFromMap)
        .toList(growable: false);
    final activeSessionByExercise = {
      for (final exercise in activeExercises) exercise.id: exercise.sessionId,
    };
    final completedExercises = completedExerciseRows
        .map(_completedExerciseFromMap)
        .toList(growable: false);
    final completedSessionByExercise = {
      for (final exercise in completedExercises)
        exercise.id: exercise.sessionId,
    };

    return SessionCloudSnapshot(
      activeSessions: activeSessionRows.map(_activeSessionFromMap),
      activeExercises: activeExercises,
      activeSets: activeSetRows.map((row) {
        final exerciseId = _requiredString(row, 'active_exercise_id');
        final sessionId = activeSessionByExercise[exerciseId];
        if (sessionId == null) {
          throw const FormatException(
            'Cloud active set referenced an unknown exercise.',
          );
        }
        return _activeSetFromMap(row, sessionId);
      }),
      completedSessions: completedSessionRows.map(_completedSessionFromMap),
      completedExercises: completedExercises,
      completedSets: completedSetRows.map((row) {
        final exerciseId = _requiredString(row, 'completed_exercise_id');
        final sessionId = completedSessionByExercise[exerciseId];
        if (sessionId == null) {
          throw const FormatException(
            'Cloud completed set referenced an unknown exercise.',
          );
        }
        return _completedSetFromMap(row, sessionId);
      }),
      personalRecords: personalRecordRows.map(_personalRecordFromMap),
      personalRecordEvents: eventRows.map(_personalRecordEventFromMap),
    );
  }

  Future<T> _upsert<T>(
    String table,
    String id,
    String userId,
    Map<String, Object?> payload,
    T Function(Map<String, dynamic>) decode,
  ) async {
    final rows = await _client
        .from(table)
        .upsert(payload, onConflict: 'id')
        .select();
    if (rows.isNotEmpty) return decode(rows.single);
    final winner = await _client
        .from(table)
        .select()
        .eq('id', id)
        .eq('user_id', userId)
        .maybeSingle();
    if (winner == null) {
      throw StateError('Supabase did not return the accepted $table row.');
    }
    return decode(winner);
  }

  Future<List<Map<String, dynamic>>> _fetchAllOwned(
    String table,
    String userId,
  ) async {
    const pageSize = 500;
    final result = <Map<String, dynamic>>[];
    for (var offset = 0; ; offset += pageSize) {
      final page = await _client
          .from(table)
          .select()
          .eq('user_id', userId)
          .order('id')
          .range(offset, offset + pageSize - 1);
      result.addAll(page);
      if (page.length < pageSize) return result;
    }
  }
}

Map<String, Object?> _basePayload({
  required String id,
  required String userId,
  required DateTime createdAt,
  required DateTime updatedAt,
  required DateTime? deletedAt,
  required int version,
}) => {
  'id': id,
  'user_id': userId,
  'created_at': _timestamp(createdAt),
  'updated_at': _timestamp(updatedAt),
  'deleted_at': _optionalTimestamp(deletedAt),
  'version': version,
};

Map<String, Object?> _activeSessionPayload(ActiveWorkoutSession value) => {
  ..._basePayload(
    id: value.id,
    userId: value.userId,
    createdAt: value.createdAt,
    updatedAt: value.updatedAt,
    deletedAt: value.deletedAt,
    version: value.version,
  ),
  'source_template_id': value.sourceTemplateId,
  'name': value.name,
  'notes': value.notes,
  'weight_unit': value.weightUnit,
  'started_at': _timestamp(value.startedAt),
  'auto_start_rest_timer': value.autoStartRestTimer,
  'rest_timer_state': value.restTimerState.name,
  'rest_timer_duration_seconds': value.restTimerDurationSeconds,
  'rest_timer_target_end_at': _optionalTimestamp(value.restTimerTargetEndAt),
  'rest_timer_remaining_seconds': value.restTimerState == RestTimerState.paused
      ? value.restTimerRemainingSeconds
      : null,
};

Map<String, Object?> _activeExercisePayload(ActiveWorkoutExercise value) => {
  ..._basePayload(
    id: value.id,
    userId: value.userId,
    createdAt: value.createdAt,
    updatedAt: value.updatedAt,
    deletedAt: value.deletedAt,
    version: value.version,
  ),
  'active_session_id': value.sessionId,
  ..._exerciseSnapshotPayload(
    source: value.exerciseSource,
    key: value.exerciseKey,
    systemKey: value.systemExerciseKey,
    customId: value.customExerciseId,
    name: value.exerciseName,
    primaryMuscle: value.primaryMuscleGroup,
    secondaryMuscles: value.secondaryMuscleGroups,
    equipment: value.equipment,
    trackingType: value.trackingType,
    weightRelevant: value.weightRelevant,
    repetitionsRelevant: value.repetitionsRelevant,
    distanceRelevant: value.distanceRelevant,
    durationRelevant: value.durationRelevant,
    bodyweightRelevant: value.bodyweightRelevant,
  ),
  'planned_working_sets': value.plannedWorkingSets,
  'planned_warm_up_sets': value.plannedWarmupSets,
  'min_target_reps': value.minTargetReps,
  'max_target_reps': value.maxTargetReps,
  'target_weight_kg': value.targetWeightKg,
  'rest_seconds': value.restSeconds,
  'rpe_target': value.rpeTarget,
  'rir_target': value.rirTarget,
  'notes': value.notes,
  'sort_order': value.sortOrder,
};

Map<String, Object?> _exerciseSnapshotPayload({
  required ExerciseSource source,
  required String key,
  required String? systemKey,
  required String? customId,
  required String name,
  required MuscleGroup primaryMuscle,
  required List<MuscleGroup> secondaryMuscles,
  required ExerciseEquipment equipment,
  required ExerciseTrackingType trackingType,
  required bool weightRelevant,
  required bool repetitionsRelevant,
  required bool distanceRelevant,
  required bool durationRelevant,
  required bool bodyweightRelevant,
}) => {
  'exercise_source': source.name,
  'exercise_key': key,
  'system_exercise_key': systemKey,
  'custom_exercise_id': customId,
  'exercise_name': name,
  'primary_muscle_group': primaryMuscle.wireValue,
  'secondary_muscle_groups': [
    for (final muscle in secondaryMuscles) muscle.wireValue,
  ],
  'equipment': equipment.wireValue,
  'tracking_type': trackingType.wireValue,
  'tracks_weight': weightRelevant,
  'tracks_repetitions': repetitionsRelevant,
  'tracks_distance': distanceRelevant,
  'tracks_duration': durationRelevant,
  'tracks_bodyweight': bodyweightRelevant,
};

Map<String, Object?> _activeSetPayload(ActiveWorkoutSet value) => {
  ..._basePayload(
    id: value.id,
    userId: value.userId,
    createdAt: value.createdAt,
    updatedAt: value.updatedAt,
    deletedAt: value.deletedAt,
    version: value.version,
  ),
  'active_exercise_id': value.sessionExerciseId,
  'set_type': value.setType.wireValue,
  'weight_kg': value.weightKg,
  'repetitions': value.repetitions,
  'duration_seconds': value.durationSeconds,
  'distance_meters': value.distanceMeters,
  'rpe': value.rpe,
  'rir': value.rir,
  'is_completed': value.isCompleted,
  'completed_at': _optionalTimestamp(value.completedAt),
  'notes': value.notes,
  'set_order': value.sortOrder,
};

Map<String, Object?> _completedSessionPayload(CompletedWorkoutSession value) =>
    {
      ..._basePayload(
        id: value.id,
        userId: value.userId,
        createdAt: value.createdAt,
        updatedAt: value.updatedAt,
        deletedAt: value.deletedAt,
        version: value.version,
      ),
      'source_active_session_id': value.sourceActiveSessionId,
      'source_template_id': value.sourceTemplateId,
      'name': value.name,
      'notes': value.notes,
      'weight_unit': value.weightUnit,
      'started_at': _timestamp(value.startedAt),
      'ended_at': _timestamp(value.endedAt),
      'duration_seconds': value.durationSeconds,
      'exercise_count': value.exerciseCount,
      'working_set_count': value.workingSetCount,
      'completed_set_count': value.totalCompletedSets,
      'total_repetitions': value.totalRepetitions,
      'total_volume_kg': value.totalVolumeKg,
      'personal_record_count': value.personalRecordCount,
    };

Map<String, Object?> _completedExercisePayload(
  CompletedWorkoutExercise value,
) => {
  ..._basePayload(
    id: value.id,
    userId: value.userId,
    createdAt: value.createdAt,
    updatedAt: value.updatedAt,
    deletedAt: value.deletedAt,
    version: value.version,
  ),
  'completed_session_id': value.sessionId,
  'source_active_exercise_id': value.sourceActiveExerciseId,
  ..._exerciseSnapshotPayload(
    source: value.exerciseSource,
    key: value.exerciseKey,
    systemKey: value.systemExerciseKey,
    customId: value.customExerciseId,
    name: value.exerciseName,
    primaryMuscle: value.primaryMuscleGroup,
    secondaryMuscles: value.secondaryMuscleGroups,
    equipment: value.equipment,
    trackingType: value.trackingType,
    weightRelevant: value.weightRelevant,
    repetitionsRelevant: value.repetitionsRelevant,
    distanceRelevant: value.distanceRelevant,
    durationRelevant: value.durationRelevant,
    bodyweightRelevant: value.bodyweightRelevant,
  ),
  'notes': value.notes,
  'sort_order': value.sortOrder,
  'completed_set_count': value.completedSetCount,
  'working_set_count': value.workingSetCount,
  'total_repetitions': value.totalRepetitions,
  'total_volume_kg': value.totalVolumeKg,
  'best_weight_kg': value.bestWeightKg,
  'best_estimated_one_rep_max_kg': value.bestEstimatedOneRepMaxKg,
};

Map<String, Object?> _completedSetPayload(CompletedWorkoutSet value) => {
  ..._basePayload(
    id: value.id,
    userId: value.userId,
    createdAt: value.createdAt,
    updatedAt: value.updatedAt,
    deletedAt: value.deletedAt,
    version: value.version,
  ),
  'completed_exercise_id': value.sessionExerciseId,
  'source_active_set_id': value.sourceActiveSetId,
  'set_type': value.setType.wireValue,
  'weight_kg': value.weightKg,
  'repetitions': value.repetitions,
  'duration_seconds': value.durationSeconds,
  'distance_meters': value.distanceMeters,
  'rpe': value.rpe,
  'rir': value.rir,
  'is_completed': true,
  'completed_at': _timestamp(value.completedAt),
  'notes': value.notes,
  'set_order': value.sortOrder,
  'set_volume_kg': value.weightKg != null && value.repetitions != null
      ? value.setVolumeKg
      : null,
  'estimated_one_rep_max_kg': value.estimatedOneRepMaxKg,
  'is_personal_record': value.isPersonalRecord,
};

Map<String, Object?> _personalRecordPayload(PersonalRecord value) => {
  ..._basePayload(
    id: value.id,
    userId: value.userId,
    createdAt: value.createdAt,
    updatedAt: value.updatedAt,
    deletedAt: value.deletedAt,
    version: value.version,
  ),
  ..._recordIdentityPayload(
    source: value.exerciseSource,
    key: value.exerciseKey,
    systemKey: value.systemExerciseKey,
    customId: value.customExerciseId,
    exerciseName: value.exerciseName,
    kind: value.recordKind,
    scope: value.recordScope,
    value: value.recordValue,
    weightKg: value.weightKg,
    repetitions: value.repetitions,
    estimatedOneRepMaxKg: value.estimatedOneRepMaxKg,
  ),
  'source_completed_session_id': value.completedSessionId,
  'source_completed_exercise_id': value.completedExerciseId,
  'source_completed_set_id': value.completedSetId,
  'achieved_at': _timestamp(value.achievedAt),
};

Map<String, Object?> _personalRecordEventPayload(PersonalRecordEvent value) => {
  ..._basePayload(
    id: value.id,
    userId: value.userId,
    createdAt: value.createdAt,
    updatedAt: value.updatedAt,
    deletedAt: value.deletedAt,
    version: value.version,
  ),
  'personal_record_id': value.personalRecordId,
  'event_key': value.eventKey,
  ..._recordIdentityPayload(
    source: value.exerciseSource,
    key: value.exerciseKey,
    systemKey: value.exerciseSource == ExerciseSource.system
        ? value.exerciseKey
        : null,
    customId: value.exerciseSource == ExerciseSource.custom
        ? value.exerciseKey
        : null,
    exerciseName: value.exerciseName,
    kind: value.recordKind,
    scope: value.recordScope,
    value: value.recordValue,
    weightKg: value.weightKg,
    repetitions: value.repetitions,
    estimatedOneRepMaxKg: value.estimatedOneRepMaxKg,
    event: true,
  ),
  'previous_record_value': value.previousRecordValue,
  'source_completed_session_id': value.completedSessionId,
  'source_completed_exercise_id': value.completedExerciseId,
  'source_completed_set_id': value.completedSetId,
  'achieved_at': _timestamp(value.achievedAt),
};

Map<String, Object?> _recordIdentityPayload({
  required ExerciseSource source,
  required String key,
  required String? systemKey,
  required String? customId,
  required String exerciseName,
  required PersonalRecordKind kind,
  required String scope,
  required double value,
  required double? weightKg,
  required int? repetitions,
  required double? estimatedOneRepMaxKg,
  bool event = false,
}) => {
  'exercise_source': source.name,
  'exercise_key': key,
  'system_exercise_key': systemKey,
  'custom_exercise_id': customId,
  'exercise_name': exerciseName,
  'record_kind': kind.wireValue,
  'record_scope': scope,
  event ? 'new_record_value' : 'record_value': value,
  'weight_kg': weightKg,
  'repetitions': repetitions,
  'estimated_one_rep_max_kg': estimatedOneRepMaxKg,
  'set_volume_kg': kind == PersonalRecordKind.setVolume ? value : null,
  'exercise_workout_volume_kg': kind == PersonalRecordKind.exerciseWorkoutVolume
      ? value
      : null,
  'calculation_formula': kind == PersonalRecordKind.estimatedOneRepMax
      ? 'epley: weight_kg * (1 + repetitions / 30)'
      : null,
};

ActiveWorkoutSession _activeSessionFromMap(Map<String, dynamic> row) =>
    ActiveWorkoutSession(
      id: _requiredString(row, 'id'),
      userId: _requiredString(row, 'user_id'),
      sourceTemplateId: _optionalString(row, 'source_template_id'),
      name: _requiredString(row, 'name'),
      notes: _optionalString(row, 'notes'),
      weightUnit: _requiredString(row, 'weight_unit'),
      startedAt: _requiredDateTime(row, 'started_at'),
      autoStartRestTimer: _requiredBool(row, 'auto_start_rest_timer'),
      restTimerState: restTimerStateFromWire(
        _requiredString(row, 'rest_timer_state'),
      ),
      restTimerDurationSeconds: _requiredInt(
        row,
        'rest_timer_duration_seconds',
      ),
      restTimerTargetEndAt: _optionalDateTime(row, 'rest_timer_target_end_at'),
      restTimerRemainingSeconds:
          _optionalInt(row, 'rest_timer_remaining_seconds') ?? 0,
      createdAt: _requiredDateTime(row, 'created_at'),
      updatedAt: _requiredDateTime(row, 'updated_at'),
      deletedAt: _optionalDateTime(row, 'deleted_at'),
      version: _requiredInt(row, 'version'),
    );

ActiveWorkoutExercise _activeExerciseFromMap(Map<String, dynamic> row) =>
    ActiveWorkoutExercise(
      id: _requiredString(row, 'id'),
      userId: _requiredString(row, 'user_id'),
      sessionId: _requiredString(row, 'active_session_id'),
      exerciseSource: _exerciseSource(row),
      exerciseKey: _requiredString(row, 'exercise_key'),
      systemExerciseKey: _optionalString(row, 'system_exercise_key'),
      customExerciseId: _optionalString(row, 'custom_exercise_id'),
      exerciseName: _requiredString(row, 'exercise_name'),
      primaryMuscleGroup: muscleGroupFromWire(
        _requiredString(row, 'primary_muscle_group'),
      ),
      secondaryMuscleGroups: _stringList(
        row,
        'secondary_muscle_groups',
      ).map(muscleGroupFromWire),
      equipment: exerciseEquipmentFromWire(_requiredString(row, 'equipment')),
      trackingType: exerciseTrackingTypeFromWire(
        _requiredString(row, 'tracking_type'),
      ),
      weightRelevant: _requiredBool(row, 'tracks_weight'),
      repetitionsRelevant: _requiredBool(row, 'tracks_repetitions'),
      distanceRelevant: _requiredBool(row, 'tracks_distance'),
      durationRelevant: _requiredBool(row, 'tracks_duration'),
      bodyweightRelevant: _requiredBool(row, 'tracks_bodyweight'),
      plannedWorkingSets: _requiredInt(row, 'planned_working_sets'),
      plannedWarmupSets: _requiredInt(row, 'planned_warm_up_sets'),
      minTargetReps: _optionalInt(row, 'min_target_reps') ?? 1,
      maxTargetReps: _optionalInt(row, 'max_target_reps') ?? 1,
      targetWeightKg: _optionalDouble(row, 'target_weight_kg'),
      restSeconds: _requiredInt(row, 'rest_seconds'),
      rpeTarget: _optionalDouble(row, 'rpe_target'),
      rirTarget: _optionalDouble(row, 'rir_target'),
      notes: _optionalString(row, 'notes'),
      sortOrder: _requiredInt(row, 'sort_order'),
      createdAt: _requiredDateTime(row, 'created_at'),
      updatedAt: _requiredDateTime(row, 'updated_at'),
      deletedAt: _optionalDateTime(row, 'deleted_at'),
      version: _requiredInt(row, 'version'),
    );

ActiveWorkoutSet _activeSetFromMap(
  Map<String, dynamic> row,
  String sessionId,
) => ActiveWorkoutSet(
  id: _requiredString(row, 'id'),
  userId: _requiredString(row, 'user_id'),
  sessionId: sessionId,
  sessionExerciseId: _requiredString(row, 'active_exercise_id'),
  setType: workoutSetTypeFromWire(_requiredString(row, 'set_type')),
  weightKg: _optionalDouble(row, 'weight_kg'),
  repetitions: _optionalInt(row, 'repetitions'),
  durationSeconds: _optionalInt(row, 'duration_seconds'),
  distanceMeters: _optionalDouble(row, 'distance_meters'),
  rpe: _optionalDouble(row, 'rpe'),
  rir: _optionalDouble(row, 'rir'),
  isCompleted: _requiredBool(row, 'is_completed'),
  completedAt: _optionalDateTime(row, 'completed_at'),
  notes: _optionalString(row, 'notes'),
  sortOrder: _requiredInt(row, 'set_order'),
  createdAt: _requiredDateTime(row, 'created_at'),
  updatedAt: _requiredDateTime(row, 'updated_at'),
  deletedAt: _optionalDateTime(row, 'deleted_at'),
  version: _requiredInt(row, 'version'),
);

CompletedWorkoutSession _completedSessionFromMap(Map<String, dynamic> row) =>
    CompletedWorkoutSession(
      id: _requiredString(row, 'id'),
      userId: _requiredString(row, 'user_id'),
      sourceActiveSessionId: _optionalString(row, 'source_active_session_id'),
      sourceTemplateId: _optionalString(row, 'source_template_id'),
      name: _requiredString(row, 'name'),
      notes: _optionalString(row, 'notes'),
      weightUnit: _requiredString(row, 'weight_unit'),
      startedAt: _requiredDateTime(row, 'started_at'),
      endedAt: _requiredDateTime(row, 'ended_at'),
      durationSeconds: _requiredInt(row, 'duration_seconds'),
      exerciseCount: _requiredInt(row, 'exercise_count'),
      workingSetCount: _requiredInt(row, 'working_set_count'),
      totalCompletedSets: _requiredInt(row, 'completed_set_count'),
      totalRepetitions: _requiredInt(row, 'total_repetitions'),
      totalVolumeKg: _requiredDouble(row, 'total_volume_kg'),
      personalRecordCount: _requiredInt(row, 'personal_record_count'),
      createdAt: _requiredDateTime(row, 'created_at'),
      updatedAt: _requiredDateTime(row, 'updated_at'),
      deletedAt: _optionalDateTime(row, 'deleted_at'),
      version: _requiredInt(row, 'version'),
    );

CompletedWorkoutExercise _completedExerciseFromMap(Map<String, dynamic> row) =>
    CompletedWorkoutExercise(
      id: _requiredString(row, 'id'),
      userId: _requiredString(row, 'user_id'),
      sessionId: _requiredString(row, 'completed_session_id'),
      sourceActiveExerciseId: _optionalString(row, 'source_active_exercise_id'),
      exerciseSource: _exerciseSource(row),
      exerciseKey: _requiredString(row, 'exercise_key'),
      systemExerciseKey: _optionalString(row, 'system_exercise_key'),
      customExerciseId: _optionalString(row, 'custom_exercise_id'),
      exerciseName: _requiredString(row, 'exercise_name'),
      primaryMuscleGroup: muscleGroupFromWire(
        _requiredString(row, 'primary_muscle_group'),
      ),
      secondaryMuscleGroups: _stringList(
        row,
        'secondary_muscle_groups',
      ).map(muscleGroupFromWire),
      equipment: exerciseEquipmentFromWire(_requiredString(row, 'equipment')),
      trackingType: exerciseTrackingTypeFromWire(
        _requiredString(row, 'tracking_type'),
      ),
      weightRelevant: _requiredBool(row, 'tracks_weight'),
      repetitionsRelevant: _requiredBool(row, 'tracks_repetitions'),
      distanceRelevant: _requiredBool(row, 'tracks_distance'),
      durationRelevant: _requiredBool(row, 'tracks_duration'),
      bodyweightRelevant: _requiredBool(row, 'tracks_bodyweight'),
      notes: _optionalString(row, 'notes'),
      sortOrder: _requiredInt(row, 'sort_order'),
      completedSetCount: _requiredInt(row, 'completed_set_count'),
      workingSetCount: _requiredInt(row, 'working_set_count'),
      totalRepetitions: _requiredInt(row, 'total_repetitions'),
      totalVolumeKg: _requiredDouble(row, 'total_volume_kg'),
      bestWeightKg: _optionalDouble(row, 'best_weight_kg'),
      bestEstimatedOneRepMaxKg: _optionalDouble(
        row,
        'best_estimated_one_rep_max_kg',
      ),
      createdAt: _requiredDateTime(row, 'created_at'),
      updatedAt: _requiredDateTime(row, 'updated_at'),
      deletedAt: _optionalDateTime(row, 'deleted_at'),
      version: _requiredInt(row, 'version'),
    );

CompletedWorkoutSet _completedSetFromMap(
  Map<String, dynamic> row,
  String sessionId,
) => CompletedWorkoutSet(
  id: _requiredString(row, 'id'),
  userId: _requiredString(row, 'user_id'),
  sessionId: sessionId,
  sessionExerciseId: _requiredString(row, 'completed_exercise_id'),
  sourceActiveSetId: _optionalString(row, 'source_active_set_id'),
  setType: workoutSetTypeFromWire(_requiredString(row, 'set_type')),
  weightKg: _optionalDouble(row, 'weight_kg'),
  repetitions: _optionalInt(row, 'repetitions'),
  durationSeconds: _optionalInt(row, 'duration_seconds'),
  distanceMeters: _optionalDouble(row, 'distance_meters'),
  rpe: _optionalDouble(row, 'rpe'),
  rir: _optionalDouble(row, 'rir'),
  notes: _optionalString(row, 'notes'),
  sortOrder: _requiredInt(row, 'set_order'),
  setVolumeKg: _optionalDouble(row, 'set_volume_kg') ?? 0,
  estimatedOneRepMaxKg: _optionalDouble(row, 'estimated_one_rep_max_kg'),
  isPersonalRecord: _requiredBool(row, 'is_personal_record'),
  completedAt: _requiredDateTime(row, 'completed_at'),
  createdAt: _requiredDateTime(row, 'created_at'),
  updatedAt: _requiredDateTime(row, 'updated_at'),
  deletedAt: _optionalDateTime(row, 'deleted_at'),
  version: _requiredInt(row, 'version'),
);

PersonalRecord _personalRecordFromMap(Map<String, dynamic> row) =>
    PersonalRecord(
      id: _requiredString(row, 'id'),
      userId: _requiredString(row, 'user_id'),
      exerciseSource: _exerciseSource(row),
      exerciseKey: _requiredString(row, 'exercise_key'),
      systemExerciseKey: _optionalString(row, 'system_exercise_key'),
      customExerciseId: _optionalString(row, 'custom_exercise_id'),
      exerciseName: _requiredString(row, 'exercise_name'),
      recordKind: personalRecordKindFromWire(
        _requiredString(row, 'record_kind'),
      ),
      recordScope: _requiredString(row, 'record_scope'),
      recordValue: _requiredDouble(row, 'record_value'),
      weightKg: _optionalDouble(row, 'weight_kg'),
      repetitions: _optionalInt(row, 'repetitions'),
      estimatedOneRepMaxKg: _optionalDouble(row, 'estimated_one_rep_max_kg'),
      completedSessionId: _requiredString(row, 'source_completed_session_id'),
      completedExerciseId: _requiredString(row, 'source_completed_exercise_id'),
      completedSetId: _optionalString(row, 'source_completed_set_id'),
      achievedAt: _requiredDateTime(row, 'achieved_at'),
      createdAt: _requiredDateTime(row, 'created_at'),
      updatedAt: _requiredDateTime(row, 'updated_at'),
      deletedAt: _optionalDateTime(row, 'deleted_at'),
      version: _requiredInt(row, 'version'),
    );

PersonalRecordEvent _personalRecordEventFromMap(Map<String, dynamic> row) =>
    PersonalRecordEvent(
      id: _requiredString(row, 'id'),
      userId: _requiredString(row, 'user_id'),
      personalRecordId: _requiredString(row, 'personal_record_id'),
      eventKey: _requiredString(row, 'event_key'),
      exerciseSource: _exerciseSource(row),
      exerciseKey: _requiredString(row, 'exercise_key'),
      exerciseName: _requiredString(row, 'exercise_name'),
      recordKind: personalRecordKindFromWire(
        _requiredString(row, 'record_kind'),
      ),
      recordScope: _requiredString(row, 'record_scope'),
      previousRecordValue: _optionalDouble(row, 'previous_record_value'),
      recordValue: _requiredDouble(row, 'new_record_value'),
      weightKg: _optionalDouble(row, 'weight_kg'),
      repetitions: _optionalInt(row, 'repetitions'),
      estimatedOneRepMaxKg: _optionalDouble(row, 'estimated_one_rep_max_kg'),
      completedSessionId: _requiredString(row, 'source_completed_session_id'),
      completedExerciseId: _requiredString(row, 'source_completed_exercise_id'),
      completedSetId: _optionalString(row, 'source_completed_set_id'),
      achievedAt: _requiredDateTime(row, 'achieved_at'),
      createdAt: _requiredDateTime(row, 'created_at'),
      updatedAt: _requiredDateTime(row, 'updated_at'),
      deletedAt: _optionalDateTime(row, 'deleted_at'),
      version: _requiredInt(row, 'version'),
    );

ExerciseSource _exerciseSource(Map<String, dynamic> row) {
  final value = _requiredString(row, 'exercise_source');
  return ExerciseSource.values.firstWhere(
    (source) => source.name == value,
    orElse: () => throw FormatException('Unknown exercise source: $value'),
  );
}

String _timestamp(DateTime value) => value.toUtc().toIso8601String();
String? _optionalTimestamp(DateTime? value) =>
    value == null ? null : _timestamp(value);

String _requiredString(Map<String, dynamic> row, String field) {
  final value = row[field];
  if (value is String && value.trim().isNotEmpty) return value;
  throw FormatException('Supabase returned an invalid $field value.');
}

String? _optionalString(Map<String, dynamic> row, String field) {
  final value = row[field];
  if (value == null) return null;
  if (value is String) return value;
  throw FormatException('Supabase returned an invalid $field value.');
}

int _requiredInt(Map<String, dynamic> row, String field) {
  final value = _optionalInt(row, field);
  if (value != null) return value;
  throw FormatException('Supabase returned an invalid $field value.');
}

int? _optionalInt(Map<String, dynamic> row, String field) {
  final value = row[field];
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  throw FormatException('Supabase returned an invalid $field value.');
}

double _requiredDouble(Map<String, dynamic> row, String field) {
  final value = _optionalDouble(row, field);
  if (value != null) return value;
  throw FormatException('Supabase returned an invalid $field value.');
}

double? _optionalDouble(Map<String, dynamic> row, String field) {
  final value = row[field];
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  throw FormatException('Supabase returned an invalid $field value.');
}

bool _requiredBool(Map<String, dynamic> row, String field) {
  final value = row[field];
  if (value is bool) return value;
  throw FormatException('Supabase returned an invalid $field value.');
}

DateTime _requiredDateTime(Map<String, dynamic> row, String field) {
  final value = _optionalDateTime(row, field);
  if (value != null) return value;
  throw FormatException('Supabase returned an invalid $field value.');
}

DateTime? _optionalDateTime(Map<String, dynamic> row, String field) {
  final value = row[field];
  if (value == null) return null;
  if (value is DateTime) return value.toUtc();
  if (value is String) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) return parsed.toUtc();
  }
  throw FormatException('Supabase returned an invalid $field value.');
}

List<String> _stringList(Map<String, dynamic> row, String field) {
  final value = row[field];
  if (value is List && value.every((entry) => entry is String)) {
    return value.cast<String>();
  }
  throw FormatException('Supabase returned an invalid $field value.');
}
