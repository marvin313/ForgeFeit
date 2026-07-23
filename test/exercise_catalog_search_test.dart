import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/features/planning/domain/planning_models.dart';
import 'package:forgefit/features/planning/domain/system_exercise_catalog.dart';

void main() {
  group('built-in exercise catalogue', () {
    test('contains a broad, stable, read-only catalogue', () {
      final exercises = SystemExerciseCatalog.all;
      final ids = exercises.map((exercise) => exercise.exerciseId).toList();
      final normalizedNames = exercises
          .map((exercise) => normalizeExerciseSearchText(exercise.name))
          .toList();

      expect(exercises.length, greaterThanOrEqualTo(180));
      expect(ids.toSet(), hasLength(exercises.length));
      expect(normalizedNames.toSet(), hasLength(exercises.length));
      expect(
        ids.every((id) => RegExp(r'^[a-z0-9]+(?:_[a-z0-9]+)*$').hasMatch(id)),
        isTrue,
      );
      expect(
        exercises.every(
          (exercise) =>
              exercise.name.trim().isNotEmpty &&
              exercise.aliases.isNotEmpty &&
              exercise.keywords.isNotEmpty,
        ),
        isTrue,
      );
      expect(
        () => exercises.add(
          const ExerciseSelection.system(
            key: 'not_allowed',
            name: 'Not Allowed',
            primaryMuscleGroup: MuscleGroup.other,
            equipment: ExerciseEquipment.other,
          ),
        ),
        throwsUnsupportedError,
      );
      expect(
        () => exercises.first.aliases.add('mutation'),
        throwsUnsupportedError,
      );
    });

    test('covers every required muscle and equipment category', () {
      final primaryMuscles = SystemExerciseCatalog.all
          .map((exercise) => exercise.primaryMuscleGroup)
          .toSet();
      final equipment = SystemExerciseCatalog.all
          .map((exercise) => exercise.equipment)
          .toSet();

      expect(primaryMuscles, containsAll(MuscleGroup.values));
      expect(equipment, containsAll(ExerciseEquipment.values));
    });

    test('retains Stage 2 keys used by existing templates', () {
      const legacyKeys = {
        'barbell_bench_press',
        'incline_dumbbell_press',
        'cable_fly',
        'push_up',
        'pull_up',
        'barbell_row',
        'lat_pulldown',
        'seated_machine_row',
        'barbell_overhead_press',
        'dumbbell_lateral_raise',
        'cable_face_pull',
        'smith_shoulder_press',
        'barbell_curl',
        'incline_dumbbell_curl',
        'cable_curl',
        'close_grip_bench_press',
        'rope_pushdown',
        'bench_dip',
        'wrist_curl',
        'reverse_cable_curl',
        'back_squat',
        'leg_press',
        'smith_split_squat',
        'banded_spanish_squat',
        'romanian_deadlift',
        'seated_leg_curl',
        'dumbbell_single_leg_rdl',
        'barbell_hip_thrust',
        'cable_kickback',
        'banded_glute_bridge',
        'standing_calf_raise',
        'single_leg_calf_raise',
        'cable_crunch',
        'plank',
        'ab_wheel_rollout',
        'conventional_deadlift',
        'dumbbell_thruster',
        'burpee',
        'kettlebell_swing',
        'stationary_bike',
        'treadmill_run',
        'rowing_ergometer',
        'band_pull_apart',
        'machine_chest_press',
        'farmer_carry',
      };

      for (final key in legacyKeys) {
        expect(SystemExerciseCatalog.byKey(key), isNotNull, reason: key);
      }
    });

    test('muscle and equipment filters include relevant results', () {
      final chest = SystemExerciseCatalog.search(
        muscleGroup: MuscleGroup.chest,
      );
      final plateLoaded = SystemExerciseCatalog.search(
        equipment: ExerciseEquipment.plateLoadedMachine,
      );

      expect(
        chest.map((exercise) => exercise.exerciseId),
        containsAll({'barbell_bench_press', 'close_grip_bench_press'}),
      );
      expect(plateLoaded, isNotEmpty);
      expect(
        plateLoaded.every(
          (exercise) =>
              exercise.equipment == ExerciseEquipment.plateLoadedMachine,
        ),
        isTrue,
      );
    });

    test('tracking metadata and relevance flags agree', () {
      for (final exercise in SystemExerciseCatalog.all) {
        final expected = switch (exercise.trackingType) {
          ExerciseTrackingType.weightAndRepetitions => (
            weight: true,
            repetitions: true,
            distance: false,
            duration: false,
          ),
          ExerciseTrackingType.repetitions => (
            weight: false,
            repetitions: true,
            distance: false,
            duration: false,
          ),
          ExerciseTrackingType.duration => (
            weight: false,
            repetitions: false,
            distance: false,
            duration: true,
          ),
          ExerciseTrackingType.distanceAndDuration => (
            weight: false,
            repetitions: false,
            distance: true,
            duration: true,
          ),
          ExerciseTrackingType.weightAndDistance => (
            weight: true,
            repetitions: false,
            distance: true,
            duration: false,
          ),
          ExerciseTrackingType.weightAndDuration => (
            weight: true,
            repetitions: false,
            distance: false,
            duration: true,
          ),
        };

        expect(exercise.weightRelevant, expected.weight, reason: exercise.name);
        expect(
          exercise.repetitionsRelevant,
          expected.repetitions,
          reason: exercise.name,
        );
        expect(
          exercise.distanceRelevant,
          expected.distance,
          reason: exercise.name,
        );
        expect(
          exercise.durationRelevant,
          expected.duration,
          reason: exercise.name,
        );
      }
    });
  });

  group('exercise search', () {
    test('aliases return canonical exercises', () {
      expect(_ids('RDL'), contains('romanian_deadlift'));
      expect(_ids('OHP'), contains('barbell_overhead_press'));
      expect(
        _ids('rear delt'),
        containsAll(<String>{'reverse_pec_deck', 'cable_rear_delt_fly'}),
      );
      expect(
        _ids('side delt'),
        containsAll(<String>{'dumbbell_lateral_raise', 'cable_lateral_raise'}),
      );
      expect(
        _ids('ham curl'),
        containsAll(<String>{
          'seated_leg_curl',
          'lying_leg_curl',
          'standing_leg_curl',
        }),
      );
      expect(
        _ids('bench'),
        containsAll(<String>{
          'barbell_bench_press',
          'flat_dumbbell_bench_press',
          'machine_chest_press',
        }),
      );
      expect(
        _ids('abs'),
        containsAll(<String>{'cable_crunch', 'plank', 'hanging_leg_raise'}),
      );
      expect(
        _ids('bike'),
        containsAll(<String>{
          'stationary_bike',
          'spin_bike',
          'outdoor_cycling',
        }),
      );
      expect(_ids('pec fly'), containsAll(<String>{'pec_deck', 'cable_fly'}));
      expect(_ids('upper back row'), contains('seated_cable_row'));
      expect(_ids('lat row'), contains('single_arm_cable_row'));
    });

    test('normalizes case, punctuation, spaces, and partial words', () {
      expect(_ids('  REAR---DELT  '), contains('reverse_pec_deck'));
      expect(_ids('pulld'), contains('lat_pulldown'));
      expect(
        _ids('plate.loaded   chest'),
        contains('plate_loaded_chest_press'),
      );
      expect(_ids('HAM---CURL'), contains('seated_leg_curl'));
    });

    test('searches muscles, secondary muscles, and equipment metadata', () {
      expect(_ids('quadriceps barbell'), contains('back_squat'));
      expect(_ids('hamstrings barbell'), contains('back_squat'));
      expect(_ids('selectorised chest'), contains('machine_chest_press'));
    });

    test('never returns an exercise more than once', () {
      final results = SystemExerciseCatalog.search(query: 'tricep pushdown');
      final ids = results.map((exercise) => exercise.exerciseId).toList();

      expect(ids.toSet(), hasLength(ids.length));
      expect(ids, contains('rope_pushdown'));
    });

    test('custom selections use the same alias and keyword engine', () {
      final custom = CustomExercise(
        id: '10000000-0000-4000-8000-000000000001',
        userId: '20000000-0000-4000-8000-000000000001',
        name: 'Marvin Hinge',
        primaryMuscleGroup: MuscleGroup.hamstrings,
        secondaryMuscleGroups: const [MuscleGroup.glutes],
        equipment: ExerciseEquipment.kettlebell,
        isFavourite: false,
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
        version: 1,
        aliases: const ['My RDL', 'my rdl'],
        keywords: const ['posterior chain'],
      );

      expect(custom.selection.matchesSearch('MY---rdl'), isTrue);
      expect(custom.selection.matchesSearch('posterior glute'), isTrue);
      expect(custom.selection.matchesSearch('kettle hamstring'), isTrue);
      expect(custom.selection.matchesSearch('bench press'), isFalse);
    });
  });
}

Set<String> _ids(String query) => SystemExerciseCatalog.search(
  query: query,
).map((exercise) => exercise.exerciseId).toSet();
