import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/features/planning/domain/planning_models.dart';
import 'package:forgefit/features/progress/domain/progress_calculations.dart';
import 'package:forgefit/features/sessions/domain/workout_session_models.dart';

void main() {
  final now = DateTime(2026, 7, 25, 12);

  test('personal records use completed working sets and the Epley formula', () {
    final bundle = _bundle(
      id: 'one',
      endedAt: DateTime(2026, 7, 24, 10),
      exercise: _exercise(
        id: 'exercise-one',
        key: 'bench',
        name: 'Bench Press',
      ),
      sets: [
        _set(id: 'a', exerciseId: 'exercise-one', weight: 80, reps: 8),
        _set(id: 'b', exerciseId: 'exercise-one', weight: 100, reps: 3),
        _set(
          id: 'warm-up',
          exerciseId: 'exercise-one',
          weight: 120,
          reps: 1,
          type: WorkoutSetType.warmUp,
        ),
        _set(id: 'invalid', exerciseId: 'exercise-one', weight: 100, reps: 0),
      ],
    );

    final record = ProgressCalculator.personalRecords([bundle]).single;

    expect(record.heaviestWeight!.value, 100);
    expect(record.bestRepetitions!.value, 8);
    expect(record.bestSet!.value, 640);
    expect(record.estimatedOneRepMax!.value, 110);
    expect(record.highestSingleWorkoutVolume!.value, 940);
  });

  test(
    'invalid, cardio and unweighted bodyweight sets do not create weight records',
    () {
      final cardio = _bundle(
        id: 'cardio',
        endedAt: now,
        exercise: _exercise(
          id: 'exercise-cardio',
          key: 'run',
          name: 'Run',
          muscle: MuscleGroup.cardio,
          weightRelevant: false,
        ),
        sets: [
          _set(
            id: 'run-set',
            exerciseId: 'exercise-cardio',
            weight: 20,
            reps: 10,
          ),
        ],
      );
      final bodyweight = _bundle(
        id: 'bodyweight',
        endedAt: now,
        exercise: _exercise(
          id: 'exercise-bodyweight',
          key: 'push-up',
          name: 'Push-up',
          bodyweightRelevant: true,
        ),
        sets: [
          _set(id: 'push-up-set', exerciseId: 'exercise-bodyweight', reps: 15),
        ],
      );

      final records = ProgressCalculator.personalRecords([cardio, bodyweight]);
      final volumes = ProgressCalculator.trainingVolume(
        bundles: [cardio, bodyweight],
        grouping: ProgressVolumeGrouping.workout,
      );

      expect(records.every((record) => record.heaviestWeight == null), isTrue);
      expect(volumes, isEmpty);
    },
  );

  test('weighted bodyweight work uses only entered external weight', () {
    final bundle = _bundle(
      id: 'weighted-bodyweight',
      endedAt: now,
      exercise: _exercise(
        id: 'exercise-one',
        key: 'weighted-dip',
        name: 'Weighted Dip',
        bodyweightRelevant: true,
      ),
      sets: [_set(id: 'set', exerciseId: 'exercise-one', weight: 20, reps: 8)],
    );

    final volume = ProgressCalculator.trainingVolume(
      bundles: [bundle],
      grouping: ProgressVolumeGrouping.workout,
    ).single;

    expect(volume.value, 160);
  });

  test('time filters use inclusive local-day boundaries', () {
    final range = progressDateRange(ProgressTimeRange.week, now);
    final within = _bundle(id: 'within', endedAt: DateTime(2026, 7, 19, 0));
    final before = _bundle(
      id: 'before',
      endedAt: DateTime(2026, 7, 18, 23, 59),
    );
    final afterMidnight = _bundle(
      id: 'today',
      endedAt: DateTime(2026, 7, 25, 23, 59),
    );

    final result = ProgressCalculator.completedInRange([
      within,
      before,
      afterMidnight,
    ], range);

    expect(result.map((bundle) => bundle.session.id), ['within', 'today']);
  });

  test('volume groups by local workout, week and month', () {
    final first = _bundle(id: 'first', endedAt: DateTime(2026, 7, 20, 9));
    final second = _bundle(id: 'second', endedAt: DateTime(2026, 7, 21, 9));
    final august = _bundle(id: 'august', endedAt: DateTime(2026, 8, 1, 9));

    expect(
      ProgressCalculator.trainingVolume(
        bundles: [first, second, august],
        grouping: ProgressVolumeGrouping.workout,
      ),
      hasLength(3),
    );
    final weekly = ProgressCalculator.trainingVolume(
      bundles: [first, second, august],
      grouping: ProgressVolumeGrouping.week,
    );
    expect(weekly.first.value, 1600);
    final monthly = ProgressCalculator.trainingVolume(
      bundles: [first, second, august],
      grouping: ProgressVolumeGrouping.month,
    );
    expect(monthly.map((point) => point.value), [1600, 800]);
  });

  test(
    'strength graph uses stable exercise identity despite a renamed exercise',
    () {
      final oldName = _bundle(
        id: 'old',
        endedAt: DateTime(2026, 7, 20, 9),
        exercise: _exercise(
          id: 'old-exercise',
          key: 'custom-1',
          name: 'Old name',
        ),
        sets: [
          _set(id: 'old-set', exerciseId: 'old-exercise', weight: 60, reps: 8),
        ],
      );
      final newName = _bundle(
        id: 'new',
        endedAt: DateTime(2026, 7, 22, 9),
        exercise: _exercise(
          id: 'new-exercise',
          key: 'custom-1',
          name: 'New name',
        ),
        sets: [
          _set(id: 'new-set', exerciseId: 'new-exercise', weight: 70, reps: 6),
        ],
      );

      final points = ProgressCalculator.exerciseProgress(
        bundles: [oldName, newName],
        exerciseKey: 'custom-1',
        metric: ExerciseProgressMetric.bestWeight,
      );

      expect(points.map((point) => point.value), [60, 70]);
      expect(
        ProgressCalculator.exerciseOptions([oldName, newName]),
        hasLength(1),
      );
    },
  );

  test(
    'consistency handles empty history, one workout and local-day streaks',
    () {
      final empty = ProgressCalculator.consistency(
        allBundles: const [],
        filteredBundles: const [],
        now: now,
      );
      expect(empty.workoutsCompleted, 0);
      expect(empty.longestStreakDays, 0);

      final days = [
        _bundle(id: 'one', endedAt: DateTime(2026, 7, 23, 9)),
        _bundle(id: 'two', endedAt: DateTime(2026, 7, 24, 9)),
        _bundle(id: 'three', endedAt: DateTime(2026, 7, 25, 9)),
      ];
      final consistency = ProgressCalculator.consistency(
        allBundles: days,
        filteredBundles: days,
        now: now,
      );
      expect(consistency.currentStreakDays, 3);
      expect(consistency.longestStreakDays, 3);
      expect(consistency.completedWorkingSets, 3);
    },
  );
}

CompletedWorkoutBundle _bundle({
  required String id,
  required DateTime endedAt,
  CompletedWorkoutExercise? exercise,
  List<CompletedWorkoutSet>? sets,
}) {
  final item =
      exercise ??
      _exercise(id: '$id-exercise', key: 'bench', name: 'Bench Press');
  final entries =
      sets ?? [_set(id: '$id-set', exerciseId: item.id, weight: 100, reps: 8)];
  return CompletedWorkoutBundle(
    session: CompletedWorkoutSession(
      id: id,
      userId: 'user',
      name: 'Upper',
      weightUnit: 'kg',
      startedAt: endedAt.subtract(const Duration(hours: 1)),
      endedAt: endedAt,
      durationSeconds: 3600,
      exerciseCount: 1,
      workingSetCount: entries.length,
      totalCompletedSets: entries.length,
      totalRepetitions: entries.fold(
        0,
        (sum, set) => sum + (set.repetitions ?? 0),
      ),
      totalVolumeKg: 0,
      personalRecordCount: 0,
      createdAt: endedAt,
      updatedAt: endedAt,
      version: 1,
    ),
    exercises: [item],
    sets: entries,
  );
}

CompletedWorkoutExercise _exercise({
  required String id,
  required String key,
  required String name,
  MuscleGroup muscle = MuscleGroup.chest,
  bool weightRelevant = true,
  bool bodyweightRelevant = false,
}) => CompletedWorkoutExercise(
  id: id,
  userId: 'user',
  sessionId: 'session',
  exerciseSource: ExerciseSource.system,
  exerciseKey: key,
  exerciseName: name,
  primaryMuscleGroup: muscle,
  equipment: ExerciseEquipment.barbell,
  trackingType: weightRelevant
      ? ExerciseTrackingType.weightAndRepetitions
      : ExerciseTrackingType.distanceAndDuration,
  weightRelevant: weightRelevant,
  repetitionsRelevant: true,
  distanceRelevant: false,
  durationRelevant: false,
  bodyweightRelevant: bodyweightRelevant,
  sortOrder: 0,
  completedSetCount: 1,
  workingSetCount: 1,
  totalRepetitions: 0,
  totalVolumeKg: 0,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
  version: 1,
);

CompletedWorkoutSet _set({
  required String id,
  required String exerciseId,
  double? weight,
  int? reps,
  WorkoutSetType type = WorkoutSetType.working,
}) => CompletedWorkoutSet(
  id: id,
  userId: 'user',
  sessionId: 'session',
  sessionExerciseId: exerciseId,
  setType: type,
  sortOrder: 0,
  setVolumeKg: (weight ?? 0) * (reps ?? 0),
  isPersonalRecord: false,
  completedAt: DateTime(2026),
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
  version: 1,
  weightKg: weight,
  repetitions: reps,
);
