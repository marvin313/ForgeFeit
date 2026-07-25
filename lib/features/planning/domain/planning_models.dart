import 'dart:collection';

enum MuscleGroup {
  chest,
  back,
  shoulders,
  biceps,
  triceps,
  forearms,
  quadriceps,
  hamstrings,
  glutes,
  calves,
  core,
  fullBody,
  cardio,
  mobility,
  rehabilitation,
  other,
}

extension MuscleGroupPresentation on MuscleGroup {
  String get wireValue => switch (this) {
    MuscleGroup.fullBody => 'full_body',
    _ => name,
  };

  String get label => switch (this) {
    MuscleGroup.fullBody => 'Full body',
    MuscleGroup.chest => 'Chest',
    MuscleGroup.back => 'Back',
    MuscleGroup.shoulders => 'Shoulders',
    MuscleGroup.biceps => 'Biceps',
    MuscleGroup.triceps => 'Triceps',
    MuscleGroup.forearms => 'Forearms',
    MuscleGroup.quadriceps => 'Quadriceps',
    MuscleGroup.hamstrings => 'Hamstrings',
    MuscleGroup.glutes => 'Glutes',
    MuscleGroup.calves => 'Calves',
    MuscleGroup.core => 'Core',
    MuscleGroup.cardio => 'Cardio',
    MuscleGroup.mobility => 'Mobility',
    MuscleGroup.rehabilitation => 'Rehabilitation',
    MuscleGroup.other => 'Other',
  };
}

MuscleGroup muscleGroupFromWire(String value) {
  final normalized = _normalizePlanningWireValue(value);
  final canonical = switch (normalized) {
    'abs' => 'core',
    'quads' => 'quadriceps',
    'shoulder' => 'shoulders',
    'fullbody' => 'full_body',
    _ => normalized,
  };
  return MuscleGroup.values.firstWhere(
    (group) => group.wireValue == canonical,
    orElse: () => MuscleGroup.other,
  );
}

enum ExerciseEquipment {
  barbell,
  dumbbell,
  cable,
  machine,
  plateLoadedMachine,
  selectorisedMachine,
  smithMachine,
  bodyweight,
  resistanceBand,
  kettlebell,
  medicineBall,
  cardioEquipment,
  other,
}

extension ExerciseEquipmentPresentation on ExerciseEquipment {
  String get wireValue => switch (this) {
    ExerciseEquipment.smithMachine => 'smith_machine',
    ExerciseEquipment.plateLoadedMachine => 'plate_loaded_machine',
    ExerciseEquipment.selectorisedMachine => 'selectorised_machine',
    ExerciseEquipment.resistanceBand => 'resistance_band',
    ExerciseEquipment.medicineBall => 'medicine_ball',
    ExerciseEquipment.cardioEquipment => 'cardio_equipment',
    _ => name,
  };

  String get label => switch (this) {
    ExerciseEquipment.barbell => 'Barbell',
    ExerciseEquipment.dumbbell => 'Dumbbell',
    ExerciseEquipment.cable => 'Cable',
    ExerciseEquipment.machine => 'Machine',
    ExerciseEquipment.plateLoadedMachine => 'Plate-loaded machine',
    ExerciseEquipment.selectorisedMachine => 'Selectorised machine',
    ExerciseEquipment.smithMachine => 'Smith machine',
    ExerciseEquipment.bodyweight => 'Bodyweight',
    ExerciseEquipment.resistanceBand => 'Resistance band',
    ExerciseEquipment.kettlebell => 'Kettlebell',
    ExerciseEquipment.medicineBall => 'Medicine ball',
    ExerciseEquipment.cardioEquipment => 'Cardio equipment',
    ExerciseEquipment.other => 'Other',
  };
}

ExerciseEquipment exerciseEquipmentFromWire(String value) {
  final normalized = _normalizePlanningWireValue(value);
  final canonical = switch (normalized) {
    'selectorized_machine' => 'selectorised_machine',
    'cardio' => 'cardio_equipment',
    _ => normalized,
  };
  return ExerciseEquipment.values.firstWhere(
    (equipment) => equipment.wireValue == canonical,
    orElse: () => ExerciseEquipment.other,
  );
}

String _normalizePlanningWireValue(String value) {
  return value.trim().toLowerCase().replaceAll(RegExp(r'[\s-]+'), '_');
}

enum ExerciseSource { system, custom }

/// The fields a movement normally records while a workout is active.
///
/// Explicit relevance flags on [ExerciseSelection] remain the source of truth
/// for rendering individual inputs. This enum provides a stable, searchable
/// category for catalogue filtering and future session defaults.
enum ExerciseTrackingType {
  weightAndRepetitions,
  repetitions,
  duration,
  distanceAndDuration,
  weightAndDistance,
  weightAndDuration,
}

extension ExerciseTrackingTypePresentation on ExerciseTrackingType {
  String get wireValue => switch (this) {
    ExerciseTrackingType.weightAndRepetitions => 'weight_and_repetitions',
    ExerciseTrackingType.repetitions => 'repetitions',
    ExerciseTrackingType.duration => 'duration',
    ExerciseTrackingType.distanceAndDuration => 'distance_and_duration',
    ExerciseTrackingType.weightAndDistance => 'weight_and_distance',
    ExerciseTrackingType.weightAndDuration => 'weight_and_duration',
  };

  String get label => switch (this) {
    ExerciseTrackingType.weightAndRepetitions => 'Weight and repetitions',
    ExerciseTrackingType.repetitions => 'Repetitions',
    ExerciseTrackingType.duration => 'Duration',
    ExerciseTrackingType.distanceAndDuration => 'Distance and duration',
    ExerciseTrackingType.weightAndDistance => 'Weight and distance',
    ExerciseTrackingType.weightAndDuration => 'Weight and duration',
  };
}

ExerciseTrackingType exerciseTrackingTypeFromWire(String value) {
  final normalized = value.trim().toLowerCase().replaceAll(' ', '_');
  return ExerciseTrackingType.values.firstWhere(
    (trackingType) => trackingType.wireValue == normalized,
    orElse: () => ExerciseTrackingType.weightAndRepetitions,
  );
}

enum PlanningEntityType {
  customExercise,
  workoutSplit,
  workoutTemplate,
  templateExercise,
}

extension PlanningEntityTypeWireValue on PlanningEntityType {
  String get wireValue => switch (this) {
    PlanningEntityType.customExercise => 'custom_exercise',
    PlanningEntityType.workoutSplit => 'workout_split',
    PlanningEntityType.workoutTemplate => 'workout_template',
    PlanningEntityType.templateExercise => 'template_exercise',
  };

  int get uploadPriority => switch (this) {
    PlanningEntityType.customExercise || PlanningEntityType.workoutSplit => 0,
    PlanningEntityType.workoutTemplate => 1,
    PlanningEntityType.templateExercise => 2,
  };
}

PlanningEntityType planningEntityTypeFromWire(String value) {
  return PlanningEntityType.values.firstWhere(
    (type) => type.wireValue == value,
    orElse: () =>
        throw FormatException('Unknown planning sync entity type: $value'),
  );
}

class WorkoutSplit {
  const WorkoutSplit({
    required this.id,
    required this.userId,
    required this.name,
    required this.icon,
    required this.colorValue,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.description,
    this.deletedAt,
  });

  final String id;
  final String userId;
  final String name;
  final String? description;
  final String icon;
  final int colorValue;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;

  bool get isDeleted => deletedAt != null;
}

class WorkoutTemplate {
  const WorkoutTemplate({
    required this.id,
    required this.userId,
    required this.name,
    required this.icon,
    required this.colorValue,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.splitId,
    this.notes,
    this.deletedAt,
  });

  final String id;
  final String userId;
  final String? splitId;
  final String name;
  final String icon;
  final int colorValue;
  final String? notes;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;

  bool get isDeleted => deletedAt != null;
}

class CustomExercise {
  CustomExercise({
    required this.id,
    required this.userId,
    required this.name,
    required this.primaryMuscleGroup,
    required Iterable<MuscleGroup> secondaryMuscleGroups,
    required this.equipment,
    required this.isFavourite,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    Iterable<String> aliases = const [],
    Iterable<String> keywords = const [],
    this.trackingType = ExerciseTrackingType.weightAndRepetitions,
    this.weightRelevant = true,
    this.repetitionsRelevant = true,
    this.distanceRelevant = false,
    this.durationRelevant = false,
    this.bodyweightRelevant = false,
    this.instructions,
    this.personalNotes,
    this.lastUsedAt,
    this.deletedAt,
  }) : secondaryMuscleGroups = UnmodifiableListView(
         List<MuscleGroup>.of(secondaryMuscleGroups),
       ),
       aliases = UnmodifiableListView(List<String>.of(aliases)),
       keywords = UnmodifiableListView(List<String>.of(keywords));

  final String id;
  final String userId;
  final String name;
  final MuscleGroup primaryMuscleGroup;
  final List<MuscleGroup> secondaryMuscleGroups;
  final ExerciseEquipment equipment;
  final List<String> aliases;
  final List<String> keywords;
  final ExerciseTrackingType trackingType;
  final bool weightRelevant;
  final bool repetitionsRelevant;
  final bool distanceRelevant;
  final bool durationRelevant;
  final bool bodyweightRelevant;
  final String? instructions;
  final String? personalNotes;
  final bool isFavourite;
  final DateTime? lastUsedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int version;

  bool get isDeleted => deletedAt != null;

  ExerciseSelection get selection => ExerciseSelection.custom(this);
}

/// A system or custom movement chosen without reference to any workout split.
///
/// Keeping this split-agnostic is intentional: a split is only an optional
/// organisational folder and never filters or restricts exercise selection.
class ExerciseSelection {
  const ExerciseSelection.system({
    required String key,
    required this.name,
    required this.primaryMuscleGroup,
    required this.equipment,
    this.secondaryMuscleGroups = const [],
    this.aliases = const [],
    this.keywords = const [],
    this.trackingType = ExerciseTrackingType.weightAndRepetitions,
    this.weightRelevant = true,
    this.repetitionsRelevant = true,
    this.distanceRelevant = false,
    this.durationRelevant = false,
    this.bodyweightRelevant = false,
  }) : source = ExerciseSource.system,
       exerciseId = key;

  ExerciseSelection.custom(CustomExercise exercise)
    : source = ExerciseSource.custom,
      exerciseId = exercise.id,
      name = exercise.name,
      primaryMuscleGroup = exercise.primaryMuscleGroup,
      equipment = exercise.equipment,
      secondaryMuscleGroups = exercise.secondaryMuscleGroups,
      aliases = exercise.aliases,
      keywords = exercise.keywords,
      trackingType = exercise.trackingType,
      weightRelevant = exercise.weightRelevant,
      repetitionsRelevant = exercise.repetitionsRelevant,
      distanceRelevant = exercise.distanceRelevant,
      durationRelevant = exercise.durationRelevant,
      bodyweightRelevant = exercise.bodyweightRelevant;

  final ExerciseSource source;
  final String exerciseId;
  final String name;
  final MuscleGroup primaryMuscleGroup;
  final ExerciseEquipment equipment;
  final List<MuscleGroup> secondaryMuscleGroups;
  final List<String> aliases;
  final List<String> keywords;
  final ExerciseTrackingType trackingType;
  final bool weightRelevant;
  final bool repetitionsRelevant;
  final bool distanceRelevant;
  final bool durationRelevant;
  final bool bodyweightRelevant;

  /// Matches names and all search metadata using punctuation-insensitive,
  /// case-insensitive token matching. Every query token must match at least one
  /// searchable token, with partial words accepted in either direction.
  bool matchesSearch(String query) {
    final normalizedQuery = normalizeExerciseSearchText(query);
    if (normalizedQuery.isEmpty) return true;

    final searchable = normalizeExerciseSearchText(
      [
        name,
        ...aliases,
        ...keywords,
        primaryMuscleGroup.label,
        ...secondaryMuscleGroups.map((group) => group.label),
        equipment.label,
      ].join(' '),
    );
    final searchableTokens = searchable.split(' ');
    return normalizedQuery
        .split(' ')
        .every(
          (queryToken) => searchableTokens.any(
            (candidate) =>
                candidate.contains(queryToken) ||
                queryToken.contains(candidate),
          ),
        );
  }

  String? get systemExerciseKey =>
      source == ExerciseSource.system ? exerciseId : null;

  String? get customExerciseId =>
      source == ExerciseSource.custom ? exerciseId : null;
}

/// Produces the canonical form used by built-in and custom exercise search.
String normalizeExerciseSearchText(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
      .trim()
      .replaceAll(RegExp(r'\s+'), ' ');
}

class TemplateExerciseConfiguration {
  const TemplateExerciseConfiguration({
    this.workingSets = 3,
    this.warmupSets = 0,
    this.targetRepsMin = 8,
    this.targetRepsMax = 12,
    this.targetWeight,
    this.restSeconds = 90,
    this.rpeTarget,
    this.rirTarget,
    this.notes,
  });

  final int workingSets;
  final int warmupSets;
  final int targetRepsMin;
  final int targetRepsMax;
  final double? targetWeight;
  final int restSeconds;
  final double? rpeTarget;
  final double? rirTarget;
  final String? notes;
}

class TemplateExercise {
  const TemplateExercise({
    required this.id,
    required this.userId,
    required this.templateId,
    required this.exerciseName,
    required this.primaryMuscleGroup,
    required this.equipment,
    required this.workingSets,
    required this.warmupSets,
    required this.targetRepsMin,
    required this.targetRepsMax,
    required this.restSeconds,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    this.customExerciseId,
    this.systemExerciseKey,
    this.targetWeight,
    this.rpeTarget,
    this.rirTarget,
    this.notes,
    this.deletedAt,
  });

  final String id;
  final String userId;
  final String templateId;
  final String? customExerciseId;
  final String? systemExerciseKey;
  final String exerciseName;
  final MuscleGroup primaryMuscleGroup;
  final ExerciseEquipment equipment;
  final int workingSets;
  final int warmupSets;
  final int targetRepsMin;
  final int targetRepsMax;
  final double? targetWeight;
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

  ExerciseSource get source =>
      customExerciseId == null ? ExerciseSource.system : ExerciseSource.custom;

  TemplateExerciseConfiguration get configuration =>
      TemplateExerciseConfiguration(
        workingSets: workingSets,
        warmupSets: warmupSets,
        targetRepsMin: targetRepsMin,
        targetRepsMax: targetRepsMax,
        targetWeight: targetWeight,
        restSeconds: restSeconds,
        rpeTarget: rpeTarget,
        rirTarget: rirTarget,
        notes: notes,
      );
}

class PlanningSnapshot {
  PlanningSnapshot({
    required Iterable<WorkoutSplit> splits,
    required Iterable<WorkoutTemplate> templates,
    required Iterable<CustomExercise> customExercises,
    required Iterable<TemplateExercise> templateExercises,
  }) : splits = UnmodifiableListView(List<WorkoutSplit>.of(splits)),
       templates = UnmodifiableListView(List<WorkoutTemplate>.of(templates)),
       customExercises = UnmodifiableListView(
         List<CustomExercise>.of(customExercises),
       ),
       templateExercises = UnmodifiableListView(
         List<TemplateExercise>.of(templateExercises),
       );

  factory PlanningSnapshot.empty() => PlanningSnapshot(
    splits: const [],
    templates: const [],
    customExercises: const [],
    templateExercises: const [],
  );

  final List<WorkoutSplit> splits;
  final List<WorkoutTemplate> templates;
  final List<CustomExercise> customExercises;
  final List<TemplateExercise> templateExercises;
}
