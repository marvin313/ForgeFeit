import 'dart:collection';
import 'dart:math' as math;

import '../../planning/domain/planning_models.dart';

enum WorkoutSetType { warmUp, working, dropSet, failure }

extension WorkoutSetTypeWire on WorkoutSetType {
  String get wireValue => switch (this) {
    WorkoutSetType.warmUp => 'warm_up',
    WorkoutSetType.working => 'working',
    WorkoutSetType.dropSet => 'drop_set',
    WorkoutSetType.failure => 'failure_set',
  };

  String get label => switch (this) {
    WorkoutSetType.warmUp => 'Warm-up',
    WorkoutSetType.working => 'Working',
    WorkoutSetType.dropSet => 'Drop set',
    WorkoutSetType.failure => 'Failure set',
  };
}

WorkoutSetType workoutSetTypeFromWire(String value) => value == 'failure'
    ? WorkoutSetType.failure
    : WorkoutSetType.values.firstWhere(
        (type) => type.wireValue == value,
        orElse: () => WorkoutSetType.working,
      );

enum RestTimerState { idle, running, paused, expired }

RestTimerState restTimerStateFromWire(String value) =>
    RestTimerState.values.firstWhere(
      (state) => state.name == value,
      orElse: () => RestTimerState.idle,
    );

enum PersonalRecordKind {
  heaviestWeight,
  mostRepsAtWeight,
  estimatedOneRepMax,
  setVolume,
  exerciseWorkoutVolume,
}

extension PersonalRecordKindWire on PersonalRecordKind {
  String get wireValue => switch (this) {
    PersonalRecordKind.heaviestWeight => 'heaviest_weight',
    PersonalRecordKind.mostRepsAtWeight => 'most_reps_at_weight',
    PersonalRecordKind.estimatedOneRepMax => 'estimated_1rm',
    PersonalRecordKind.setVolume => 'set_volume',
    PersonalRecordKind.exerciseWorkoutVolume => 'exercise_workout_volume',
  };

  String get label => switch (this) {
    PersonalRecordKind.heaviestWeight => 'Heaviest weight',
    PersonalRecordKind.mostRepsAtWeight => 'Most reps at a weight',
    PersonalRecordKind.estimatedOneRepMax => 'Estimated 1RM',
    PersonalRecordKind.setVolume => 'Highest set volume',
    PersonalRecordKind.exerciseWorkoutVolume => 'Highest workout volume',
  };
}

PersonalRecordKind personalRecordKindFromWire(String value) =>
    PersonalRecordKind.values.firstWhere(
      (kind) => kind.wireValue == value,
      orElse: () => throw FormatException('Unknown record kind: $value'),
    );

enum SessionEntityType {
  activeSession,
  activeExercise,
  activeSet,
  completedSession,
  completedExercise,
  completedSet,
  personalRecord,
  personalRecordEvent,
}

extension SessionEntityTypeWire on SessionEntityType {
  String get wireValue => switch (this) {
    SessionEntityType.activeSession => 'active_session',
    SessionEntityType.activeExercise => 'active_exercise',
    SessionEntityType.activeSet => 'active_set',
    SessionEntityType.completedSession => 'completed_session',
    SessionEntityType.completedExercise => 'completed_exercise',
    SessionEntityType.completedSet => 'completed_set',
    SessionEntityType.personalRecord => 'personal_record',
    SessionEntityType.personalRecordEvent => 'personal_record_event',
  };

  int get uploadPriority => switch (this) {
    SessionEntityType.activeSession || SessionEntityType.completedSession => 0,
    SessionEntityType.activeExercise ||
    SessionEntityType.completedExercise => 1,
    SessionEntityType.activeSet || SessionEntityType.completedSet => 2,
    SessionEntityType.personalRecord => 3,
    SessionEntityType.personalRecordEvent => 4,
  };
}

SessionEntityType sessionEntityTypeFromWire(String value) =>
    SessionEntityType.values.firstWhere(
      (type) => type.wireValue == value,
      orElse: () =>
          throw FormatException('Unknown session sync entity type: $value'),
    );

class ActiveWorkoutSession {
  const ActiveWorkoutSession({
    required this.id,
    required this.userId,
    required this.name,
    required this.startedAt,
    required this.weightUnit,
    required this.restTimerState,
    required this.restTimerDurationSeconds,
    required this.restTimerRemainingSeconds,
    required this.autoStartRestTimer,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.sourceTemplateId,
    this.notes,
    this.restTimerTargetEndAt,
    this.deletedAt,
  });

  final String id;
  final String userId;
  final String name;
  final String? sourceTemplateId;
  final DateTime startedAt;
  final String? notes;
  final String weightUnit;
  final RestTimerState restTimerState;
  final int restTimerDurationSeconds;
  final DateTime? restTimerTargetEndAt;
  final int restTimerRemainingSeconds;
  final bool autoStartRestTimer;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;

  bool get isDeleted => deletedAt != null;

  Duration elapsedAt(DateTime now) =>
      now.toUtc().difference(startedAt.toUtc()).isNegative
      ? Duration.zero
      : now.toUtc().difference(startedAt.toUtc());

  int restSecondsAt(DateTime now) {
    if (restTimerState == RestTimerState.running &&
        restTimerTargetEndAt != null) {
      return math.max(
        0,
        restTimerTargetEndAt!.toUtc().difference(now.toUtc()).inSeconds,
      );
    }
    return math.max(0, restTimerRemainingSeconds);
  }
}

class ActiveWorkoutExercise {
  ActiveWorkoutExercise({
    required this.id,
    required this.userId,
    required this.sessionId,
    required this.exerciseSource,
    required this.exerciseKey,
    required this.exerciseName,
    required this.primaryMuscleGroup,
    Iterable<MuscleGroup> secondaryMuscleGroups = const [],
    required this.equipment,
    required this.trackingType,
    required this.weightRelevant,
    required this.repetitionsRelevant,
    required this.distanceRelevant,
    required this.durationRelevant,
    required this.bodyweightRelevant,
    required this.plannedWorkingSets,
    required this.plannedWarmupSets,
    required this.minTargetReps,
    required this.maxTargetReps,
    required this.restSeconds,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.systemExerciseKey,
    this.customExerciseId,
    this.targetWeightKg,
    this.rpeTarget,
    this.rirTarget,
    this.notes,
    this.deletedAt,
  }) : secondaryMuscleGroups = UnmodifiableListView(
         List<MuscleGroup>.of(secondaryMuscleGroups),
       );

  final String id;
  final String userId;
  final String sessionId;
  final ExerciseSource exerciseSource;
  final String exerciseKey;
  final String? systemExerciseKey;
  final String? customExerciseId;
  final String exerciseName;
  final MuscleGroup primaryMuscleGroup;
  final List<MuscleGroup> secondaryMuscleGroups;
  final ExerciseEquipment equipment;
  final ExerciseTrackingType trackingType;
  final bool weightRelevant;
  final bool repetitionsRelevant;
  final bool distanceRelevant;
  final bool durationRelevant;
  final bool bodyweightRelevant;
  final int plannedWorkingSets;
  final int plannedWarmupSets;
  final int minTargetReps;
  final int maxTargetReps;
  final double? targetWeightKg;
  final int restSeconds;
  final double? rpeTarget;
  final double? rirTarget;
  final String? notes;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;

  bool get isDeleted => deletedAt != null;
}

class ActiveWorkoutSet {
  const ActiveWorkoutSet({
    required this.id,
    required this.userId,
    required this.sessionId,
    required this.sessionExerciseId,
    required this.setType,
    required this.isCompleted,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.weightKg,
    this.repetitions,
    this.durationSeconds,
    this.distanceMeters,
    this.rpe,
    this.rir,
    this.notes,
    this.completedAt,
    this.deletedAt,
  });

  final String id;
  final String userId;
  final String sessionId;
  final String sessionExerciseId;
  final WorkoutSetType setType;
  final double? weightKg;
  final int? repetitions;
  final int? durationSeconds;
  final double? distanceMeters;
  final double? rpe;
  final double? rir;
  final bool isCompleted;
  final String? notes;
  final int sortOrder;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;

  bool get isDeleted => deletedAt != null;
  bool get countsTowardRecords =>
      isCompleted && !isDeleted && setType != WorkoutSetType.warmUp;
  double get volumeKg => countsTowardRecords
      ? roundSessionMetric((weightKg ?? 0) * (repetitions ?? 0))
      : 0;
  double? get estimatedOneRepMaxKg => countsTowardRecords
      ? estimateEpleyOneRepMax(weightKg: weightKg, repetitions: repetitions)
      : null;
}

class ActiveWorkoutBundle {
  ActiveWorkoutBundle({
    required this.session,
    required Iterable<ActiveWorkoutExercise> exercises,
    required Iterable<ActiveWorkoutSet> sets,
  }) : exercises = UnmodifiableListView(
         [...exercises]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
       ),
       sets = UnmodifiableListView(
         [...sets]..sort((a, b) {
           final exercise = a.sessionExerciseId.compareTo(b.sessionExerciseId);
           return exercise != 0 ? exercise : a.sortOrder.compareTo(b.sortOrder);
         }),
       );

  final ActiveWorkoutSession session;
  final List<ActiveWorkoutExercise> exercises;
  final List<ActiveWorkoutSet> sets;

  List<ActiveWorkoutSet> setsFor(String exerciseId) => List.unmodifiable(
    sets.where((set) => set.sessionExerciseId == exerciseId && !set.isDeleted),
  );
}

class CompletedWorkoutSession {
  const CompletedWorkoutSession({
    required this.id,
    required this.userId,
    required this.name,
    required this.weightUnit,
    required this.startedAt,
    required this.endedAt,
    required this.durationSeconds,
    required this.exerciseCount,
    required this.workingSetCount,
    required this.totalCompletedSets,
    required this.totalRepetitions,
    required this.totalVolumeKg,
    required this.personalRecordCount,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.sourceActiveSessionId,
    this.sourceTemplateId,
    this.notes,
    this.deletedAt,
  });

  final String id;
  final String userId;
  final String? sourceActiveSessionId;
  final String? sourceTemplateId;
  final String name;
  final String? notes;
  final String weightUnit;
  final DateTime startedAt;
  final DateTime endedAt;
  final int durationSeconds;
  final int exerciseCount;
  final int workingSetCount;
  final int totalCompletedSets;
  final int totalRepetitions;
  final double totalVolumeKg;
  final int personalRecordCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;

  bool get isDeleted => deletedAt != null;
}

class CompletedWorkoutExercise {
  CompletedWorkoutExercise({
    required this.id,
    required this.userId,
    required this.sessionId,
    required this.exerciseSource,
    required this.exerciseKey,
    required this.exerciseName,
    required this.primaryMuscleGroup,
    Iterable<MuscleGroup> secondaryMuscleGroups = const [],
    required this.equipment,
    required this.trackingType,
    required this.weightRelevant,
    required this.repetitionsRelevant,
    required this.distanceRelevant,
    required this.durationRelevant,
    required this.bodyweightRelevant,
    required this.sortOrder,
    required this.completedSetCount,
    required this.workingSetCount,
    required this.totalRepetitions,
    required this.totalVolumeKg,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.sourceActiveExerciseId,
    this.systemExerciseKey,
    this.customExerciseId,
    this.notes,
    this.bestWeightKg,
    this.bestEstimatedOneRepMaxKg,
    this.deletedAt,
  }) : secondaryMuscleGroups = UnmodifiableListView(
         List<MuscleGroup>.of(secondaryMuscleGroups),
       );

  final String id;
  final String userId;
  final String sessionId;
  final String? sourceActiveExerciseId;
  final ExerciseSource exerciseSource;
  final String exerciseKey;
  final String? systemExerciseKey;
  final String? customExerciseId;
  final String exerciseName;
  final MuscleGroup primaryMuscleGroup;
  final List<MuscleGroup> secondaryMuscleGroups;
  final ExerciseEquipment equipment;
  final ExerciseTrackingType trackingType;
  final bool weightRelevant;
  final bool repetitionsRelevant;
  final bool distanceRelevant;
  final bool durationRelevant;
  final bool bodyweightRelevant;
  final String? notes;
  final int sortOrder;
  final int completedSetCount;
  final int workingSetCount;
  final int totalRepetitions;
  final double totalVolumeKg;
  final double? bestWeightKg;
  final double? bestEstimatedOneRepMaxKg;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;

  bool get isDeleted => deletedAt != null;
}

class CompletedWorkoutSet {
  const CompletedWorkoutSet({
    required this.id,
    required this.userId,
    required this.sessionId,
    required this.sessionExerciseId,
    required this.setType,
    required this.sortOrder,
    required this.setVolumeKg,
    required this.isPersonalRecord,
    required this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.sourceActiveSetId,
    this.weightKg,
    this.repetitions,
    this.durationSeconds,
    this.distanceMeters,
    this.rpe,
    this.rir,
    this.notes,
    this.estimatedOneRepMaxKg,
    this.deletedAt,
  });

  final String id;
  final String userId;
  final String sessionId;
  final String sessionExerciseId;
  final String? sourceActiveSetId;
  final WorkoutSetType setType;
  final double? weightKg;
  final int? repetitions;
  final int? durationSeconds;
  final double? distanceMeters;
  final double? rpe;
  final double? rir;
  final String? notes;
  final int sortOrder;
  final double setVolumeKg;
  final double? estimatedOneRepMaxKg;
  final bool isPersonalRecord;
  final DateTime completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;

  bool get isDeleted => deletedAt != null;
}

class CompletedWorkoutBundle {
  CompletedWorkoutBundle({
    required this.session,
    required Iterable<CompletedWorkoutExercise> exercises,
    required Iterable<CompletedWorkoutSet> sets,
  }) : exercises = UnmodifiableListView(
         [...exercises]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
       ),
       sets = UnmodifiableListView(
         [...sets]..sort((a, b) {
           final exercise = a.sessionExerciseId.compareTo(b.sessionExerciseId);
           return exercise != 0 ? exercise : a.sortOrder.compareTo(b.sortOrder);
         }),
       );

  final CompletedWorkoutSession session;
  final List<CompletedWorkoutExercise> exercises;
  final List<CompletedWorkoutSet> sets;

  List<CompletedWorkoutSet> setsFor(String exerciseId) => List.unmodifiable(
    sets.where((set) => set.sessionExerciseId == exerciseId && !set.isDeleted),
  );
}

class PersonalRecord {
  const PersonalRecord({
    required this.id,
    required this.userId,
    required this.exerciseSource,
    required this.exerciseKey,
    required this.exerciseName,
    required this.recordKind,
    required this.recordScope,
    required this.recordValue,
    required this.completedSessionId,
    required this.completedExerciseId,
    required this.achievedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.systemExerciseKey,
    this.customExerciseId,
    this.weightKg,
    this.repetitions,
    this.estimatedOneRepMaxKg,
    this.completedSetId,
    this.deletedAt,
  });

  final String id;
  final String userId;
  final ExerciseSource exerciseSource;
  final String exerciseKey;
  final String? systemExerciseKey;
  final String? customExerciseId;
  final String exerciseName;
  final PersonalRecordKind recordKind;
  final String recordScope;
  final double recordValue;
  final double? weightKg;
  final int? repetitions;
  final double? estimatedOneRepMaxKg;
  final String completedSessionId;
  final String completedExerciseId;
  final String? completedSetId;
  final DateTime achievedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;

  bool get isDeleted => deletedAt != null;
}

class PersonalRecordEvent {
  const PersonalRecordEvent({
    required this.id,
    required this.userId,
    required this.personalRecordId,
    required this.eventKey,
    required this.exerciseSource,
    required this.exerciseKey,
    required this.exerciseName,
    required this.recordKind,
    required this.recordScope,
    required this.recordValue,
    required this.completedSessionId,
    required this.completedExerciseId,
    required this.achievedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.weightKg,
    this.previousRecordValue,
    this.repetitions,
    this.estimatedOneRepMaxKg,
    this.completedSetId,
    this.deletedAt,
  });

  final String id;
  final String userId;
  final String personalRecordId;
  final String eventKey;
  final ExerciseSource exerciseSource;
  final String exerciseKey;
  final String exerciseName;
  final PersonalRecordKind recordKind;
  final String recordScope;
  final double? previousRecordValue;
  final double recordValue;
  final double? weightKg;
  final int? repetitions;
  final double? estimatedOneRepMaxKg;
  final String completedSessionId;
  final String completedExerciseId;
  final String? completedSetId;
  final DateTime achievedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;

  bool get isDeleted => deletedAt != null;
}

class PreviousPerformance {
  const PreviousPerformance({
    required this.performedAt,
    required this.exerciseName,
    required this.sets,
    this.isLegacyQuickLog = false,
  });

  final DateTime performedAt;
  final String exerciseName;
  final List<CompletedWorkoutSet> sets;
  final bool isLegacyQuickLog;
}

class WorkoutSummary {
  WorkoutSummary({
    required this.session,
    required Iterable<PersonalRecordEvent> personalRecords,
  }) : personalRecords = UnmodifiableListView(personalRecords);

  final CompletedWorkoutSession session;
  final List<PersonalRecordEvent> personalRecords;
}

class SessionCloudSnapshot {
  SessionCloudSnapshot({
    required Iterable<ActiveWorkoutSession> activeSessions,
    required Iterable<ActiveWorkoutExercise> activeExercises,
    required Iterable<ActiveWorkoutSet> activeSets,
    required Iterable<CompletedWorkoutSession> completedSessions,
    required Iterable<CompletedWorkoutExercise> completedExercises,
    required Iterable<CompletedWorkoutSet> completedSets,
    required Iterable<PersonalRecord> personalRecords,
    required Iterable<PersonalRecordEvent> personalRecordEvents,
  }) : activeSessions = UnmodifiableListView(List.of(activeSessions)),
       activeExercises = UnmodifiableListView(List.of(activeExercises)),
       activeSets = UnmodifiableListView(List.of(activeSets)),
       completedSessions = UnmodifiableListView(List.of(completedSessions)),
       completedExercises = UnmodifiableListView(List.of(completedExercises)),
       completedSets = UnmodifiableListView(List.of(completedSets)),
       personalRecords = UnmodifiableListView(List.of(personalRecords)),
       personalRecordEvents = UnmodifiableListView(
         List.of(personalRecordEvents),
       );

  factory SessionCloudSnapshot.empty() => SessionCloudSnapshot(
    activeSessions: const [],
    activeExercises: const [],
    activeSets: const [],
    completedSessions: const [],
    completedExercises: const [],
    completedSets: const [],
    personalRecords: const [],
    personalRecordEvents: const [],
  );

  final List<ActiveWorkoutSession> activeSessions;
  final List<ActiveWorkoutExercise> activeExercises;
  final List<ActiveWorkoutSet> activeSets;
  final List<CompletedWorkoutSession> completedSessions;
  final List<CompletedWorkoutExercise> completedExercises;
  final List<CompletedWorkoutSet> completedSets;
  final List<PersonalRecord> personalRecords;
  final List<PersonalRecordEvent> personalRecordEvents;
}

class ActiveWorkoutAlreadyExists implements Exception {
  const ActiveWorkoutAlreadyExists(this.active);

  final ActiveWorkoutBundle active;

  @override
  String toString() => 'An active workout is already in progress.';
}

/// Epley estimate used by ForgeFit: weight * (1 + repetitions / 30).
///
/// Values are stored rounded half-away-from-zero to three decimal places.
double? estimateEpleyOneRepMax({
  required double? weightKg,
  required int? repetitions,
}) {
  if (weightKg == null ||
      weightKg <= 0 ||
      repetitions == null ||
      repetitions <= 0) {
    return null;
  }
  return roundSessionMetric(weightKg * (1 + repetitions / 30));
}

double roundSessionMetric(double value) =>
    (value * 1000).roundToDouble() / 1000;
