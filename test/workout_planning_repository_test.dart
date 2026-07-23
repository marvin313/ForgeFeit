import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/core/database/app_database.dart';
import 'package:forgefit/features/planning/data/offline_first_planning_repository.dart';
import 'package:forgefit/features/planning/data/remote_planning_data_source.dart';
import 'package:forgefit/features/planning/domain/planning_models.dart';
import 'package:forgefit/features/planning/domain/system_exercise_catalog.dart';

const _userA = '10000000-0000-4000-8000-000000000001';
const _userB = '10000000-0000-4000-8000-000000000002';

void main() {
  late AppDatabase database;
  late StrictFakePlanningRemote remote;
  late OfflineFirstPlanningRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    remote = StrictFakePlanningRemote();
    repository = OfflineFirstPlanningRepository(
      database: database,
      remote: remote,
      idGenerator: _UuidSequence().next,
      clock: _TestClock().now,
    );
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'creates, edits, and reorders splits and freely moves templates',
    () async {
      final upper = await repository.createSplit(
        userId: _userA,
        name: 'Upper / Lower',
        description: 'Four day routine',
        icon: 'UL',
        colorValue: 0xFF1188FF,
      );
      final strength = await repository.createSplit(
        userId: _userA,
        name: 'Strength',
      );
      final home = await repository.createSplit(
        userId: _userA,
        name: 'Home Workouts',
      );

      final edited = await repository.updateSplit(
        userId: _userA,
        splitId: strength.id,
        name: 'Powerbuilding',
        description: 'Main lifts and accessories',
        icon: 'PB',
        colorValue: 0xFFAA55FF,
      );
      expect(edited.name, 'Powerbuilding');
      expect(edited.version, 2);

      await repository.reorderSplits(
        userId: _userA,
        orderedSplitIds: [home.id, upper.id, strength.id],
      );
      var snapshot = await repository.getSnapshot(_userA);
      expect(snapshot.splits.map((split) => split.id), [
        home.id,
        upper.id,
        strength.id,
      ]);

      final noSplit = await repository.createTemplate(
        userId: _userA,
        name: 'Anything Day',
      );
      final inUpper = await repository.createTemplate(
        userId: _userA,
        splitId: upper.id,
        name: 'Upper A',
      );
      expect(noSplit.splitId, isNull);
      expect(inUpper.splitId, upper.id);

      var moved = await repository.moveTemplate(
        userId: _userA,
        templateId: noSplit.id,
        destinationSplitId: strength.id,
      );
      expect(moved.splitId, strength.id);
      moved = await repository.moveTemplate(
        userId: _userA,
        templateId: moved.id,
      );
      expect(moved.splitId, isNull);

      snapshot = await repository.getSnapshot(_userA);
      expect(
        snapshot.templates.map((template) => template.id),
        containsAll([noSplit.id, inUpper.id]),
      );
      expect(remote.templates, isEmpty, reason: 'all writes remain offline');
      expect(await repository.pendingCount(_userA), greaterThan(0));
    },
  );

  test(
    'split names never restrict system or custom exercise selection',
    () async {
      final split = await repository.createSplit(
        userId: _userA,
        name: 'Push Pull Legs',
      );
      final template = await repository.createTemplate(
        userId: _userA,
        splitId: split.id,
        name: 'Completely custom day',
      );
      final cycling = SystemExerciseCatalog.byKey('stationary_bike')!;
      final squat = SystemExerciseCatalog.byKey('back_squat')!;
      final row = SystemExerciseCatalog.byKey('barbell_row')!;

      await repository.addExerciseToTemplate(
        userId: _userA,
        templateId: template.id,
        exercise: cycling,
      );
      await repository.addExerciseToTemplate(
        userId: _userA,
        templateId: template.id,
        exercise: squat,
      );
      await repository.addExerciseToTemplate(
        userId: _userA,
        templateId: template.id,
        exercise: row,
      );

      final entries = (await repository.getSnapshot(_userA)).templateExercises
          .where((entry) => entry.templateId == template.id)
          .toList();
      expect(entries.map((entry) => entry.exerciseName), [
        cycling.name,
        squat.name,
        row.name,
      ]);
      expect(
        entries.map((entry) => entry.primaryMuscleGroup),
        containsAll([
          MuscleGroup.cardio,
          MuscleGroup.quadriceps,
          MuscleGroup.back,
        ]),
      );
    },
  );

  test(
    'custom exercises edit, favourite, remain referenced, and soft-delete',
    () async {
      final custom = await repository.createCustomExercise(
        userId: _userA,
        name: 'Garage sled drag',
        primaryMuscleGroup: MuscleGroup.quadriceps,
        secondaryMuscleGroups: const [MuscleGroup.glutes],
        equipment: ExerciseEquipment.other,
        instructions: 'Attach the loading strap.',
        personalNotes: 'Use the driveway.',
      );
      var edited = await repository.updateCustomExercise(
        userId: _userA,
        exerciseId: custom.id,
        name: 'Backward garage sled drag',
        primaryMuscleGroup: MuscleGroup.quadriceps,
        secondaryMuscleGroups: const [MuscleGroup.glutes, MuscleGroup.calves],
        equipment: ExerciseEquipment.other,
        instructions: 'Walk backwards under control.',
        personalNotes: null,
        isFavourite: false,
      );
      expect(edited.name, startsWith('Backward'));
      expect(edited.secondaryMuscleGroups, contains(MuscleGroup.calves));

      edited = await repository.setCustomExerciseFavourite(
        userId: _userA,
        exerciseId: custom.id,
        isFavourite: true,
      );
      expect(edited.isFavourite, isTrue);

      final template = await repository.createTemplate(
        userId: _userA,
        name: 'Garage session',
      );
      final entry = await repository.addExerciseToTemplate(
        userId: _userA,
        templateId: template.id,
        exercise: edited.selection,
      );
      expect(entry.customExerciseId, custom.id);

      await repository.deleteCustomExercise(
        userId: _userA,
        exerciseId: custom.id,
      );
      final active = await repository.getSnapshot(_userA);
      expect(active.customExercises, isEmpty);
      expect(active.templateExercises.single.exerciseName, edited.name);

      final all = await repository.getSnapshot(_userA, includeDeleted: true);
      final tombstone = all.customExercises.singleWhere(
        (exercise) => exercise.id == custom.id,
      );
      expect(tombstone.deletedAt, isNotNull);
      expect(tombstone.version, greaterThan(edited.version));
    },
  );

  test(
    'configures, replaces, duplicates, reorders, and removes template exercises',
    () async {
      final template = await repository.createTemplate(
        userId: _userA,
        name: 'Target practice',
      );
      final bench = await repository.addExerciseToTemplate(
        userId: _userA,
        templateId: template.id,
        exercise: SystemExerciseCatalog.byKey('barbell_bench_press')!,
        configuration: const TemplateExerciseConfiguration(
          workingSets: 5,
          warmupSets: 3,
          targetRepsMin: 3,
          targetRepsMax: 5,
          targetWeight: 100,
          restSeconds: 240,
          rpeTarget: 8.5,
          rirTarget: 2,
          notes: 'Pause every rep',
        ),
      );
      final squat = await repository.addExerciseToTemplate(
        userId: _userA,
        templateId: template.id,
        exercise: SystemExerciseCatalog.byKey('back_squat')!,
      );
      final benchCopy = await repository.duplicateTemplateExercise(
        userId: _userA,
        templateExerciseId: bench.id,
      );
      expect(benchCopy.id, isNot(bench.id));
      expect(benchCopy.configuration.workingSets, bench.workingSets);
      expect(benchCopy.sortOrder, 1);

      final changedBench = await repository.updateTemplateExercise(
        userId: _userA,
        templateExerciseId: bench.id,
        configuration: const TemplateExerciseConfiguration(
          workingSets: 4,
          warmupSets: 2,
          targetRepsMin: 6,
          targetRepsMax: 8,
          targetWeight: 92.5,
          restSeconds: 180,
          rpeTarget: 8,
          rirTarget: 1,
          notes: 'Touch and go',
        ),
      );
      expect(changedBench.workingSets, 4);
      expect(changedBench.targetWeight, 92.5);

      final replaced = await repository.replaceTemplateExercise(
        userId: _userA,
        templateExerciseId: squat.id,
        replacement: SystemExerciseCatalog.byKey('treadmill_run')!,
      );
      expect(replaced.exerciseName, 'Treadmill run');
      expect(replaced.workingSets, squat.workingSets);

      await repository.reorderTemplateExercises(
        userId: _userA,
        templateId: template.id,
        orderedTemplateExerciseIds: [replaced.id, bench.id, benchCopy.id],
      );
      var entries = _entriesFor(
        await repository.getSnapshot(_userA),
        template.id,
      );
      expect(entries.map((entry) => entry.id), [
        replaced.id,
        bench.id,
        benchCopy.id,
      ]);

      await repository.removeTemplateExercise(
        userId: _userA,
        templateExerciseId: benchCopy.id,
      );
      entries = _entriesFor(await repository.getSnapshot(_userA), template.id);
      expect(entries.map((entry) => entry.id), [replaced.id, bench.id]);
      expect(entries.map((entry) => entry.sortOrder), [0, 1]);
    },
  );

  test(
    'template and split duplication create fully independent UUID trees',
    () async {
      final split = await repository.createSplit(
        userId: _userA,
        name: 'Current Program',
        description: 'Block one',
        icon: 'CP',
        colorValue: 0xFF00AAFF,
      );
      final template = await repository.createTemplate(
        userId: _userA,
        splitId: split.id,
        name: 'Upper A',
        icon: 'UA',
        colorValue: 0xFF44BBFF,
        notes: 'Heavy day',
      );
      final originalEntry = await repository.addExerciseToTemplate(
        userId: _userA,
        templateId: template.id,
        exercise: SystemExerciseCatalog.byKey('barbell_bench_press')!,
        configuration: const TemplateExerciseConfiguration(
          workingSets: 5,
          warmupSets: 2,
          targetRepsMin: 4,
          targetRepsMax: 6,
          targetWeight: 105,
          restSeconds: 210,
          rpeTarget: 9,
          rirTarget: 1,
          notes: 'Competition pause',
        ),
      );

      final templateCopy = await repository.duplicateTemplate(
        userId: _userA,
        templateId: template.id,
      );
      expect(templateCopy.id, isNot(template.id));
      expect(templateCopy.name, 'Upper A Copy');
      expect(templateCopy.icon, template.icon);
      expect(templateCopy.colorValue, template.colorValue);
      expect(templateCopy.notes, template.notes);

      var snapshot = await repository.getSnapshot(_userA);
      final copiedEntry = _entriesFor(snapshot, templateCopy.id).single;
      expect(copiedEntry.id, isNot(originalEntry.id));
      expect(copiedEntry.configuration.workingSets, 5);
      expect(copiedEntry.targetWeight, 105);
      expect(copiedEntry.rpeTarget, 9);
      expect(copiedEntry.rirTarget, 1);
      expect(copiedEntry.notes, 'Competition pause');

      await repository.updateTemplateExercise(
        userId: _userA,
        templateExerciseId: copiedEntry.id,
        configuration: const TemplateExerciseConfiguration(workingSets: 2),
      );
      snapshot = await repository.getSnapshot(_userA);
      expect(_entriesFor(snapshot, template.id).single.workingSets, 5);
      expect(_entriesFor(snapshot, templateCopy.id).single.workingSets, 2);

      final splitCopy = await repository.duplicateSplit(
        userId: _userA,
        splitId: split.id,
      );
      expect(splitCopy.id, isNot(split.id));
      expect(splitCopy.name, 'Current Program Copy');
      snapshot = await repository.getSnapshot(_userA);
      final sourceTemplates = snapshot.templates
          .where((item) => item.splitId == split.id)
          .toList();
      final copiedTemplates = snapshot.templates
          .where((item) => item.splitId == splitCopy.id)
          .toList();
      expect(copiedTemplates, hasLength(sourceTemplates.length));
      expect(
        copiedTemplates
            .map((item) => item.id)
            .toSet()
            .intersection(sourceTemplates.map((item) => item.id).toSet()),
        isEmpty,
      );
      for (var index = 0; index < copiedTemplates.length; index++) {
        final sourceEntries = _entriesFor(snapshot, sourceTemplates[index].id);
        final copiedEntries = _entriesFor(snapshot, copiedTemplates[index].id);
        expect(copiedEntries, hasLength(sourceEntries.length));
        expect(
          copiedEntries
              .map((entry) => entry.id)
              .toSet()
              .intersection(sourceEntries.map((entry) => entry.id).toSet()),
          isEmpty,
        );
      }
    },
  );

  test('deleting a split moves, but never deletes, its templates', () async {
    final source = await repository.createSplit(
      userId: _userA,
      name: 'Previous Program',
    );
    final destination = await repository.createSplit(
      userId: _userA,
      name: 'Current Program',
    );
    final first = await repository.createTemplate(
      userId: _userA,
      splitId: source.id,
      name: 'Day one',
    );
    final second = await repository.createTemplate(
      userId: _userA,
      splitId: source.id,
      name: 'Day two',
    );

    await repository.deleteSplit(userId: _userA, splitId: source.id);
    var snapshot = await repository.getSnapshot(_userA);
    expect(
      snapshot.splits.map((split) => split.id),
      isNot(contains(source.id)),
    );
    expect(
      snapshot.templates
          .where(
            (template) => template.id == first.id || template.id == second.id,
          )
          .every((template) => template.splitId == null),
      isTrue,
    );

    final sourceTwo = await repository.createSplit(
      userId: _userA,
      name: 'Temporary',
    );
    final third = await repository.createTemplate(
      userId: _userA,
      splitId: sourceTwo.id,
      name: 'Moved day',
    );
    await repository.deleteSplit(
      userId: _userA,
      splitId: sourceTwo.id,
      destinationSplitId: destination.id,
    );
    snapshot = await repository.getSnapshot(_userA);
    expect(
      snapshot.templates
          .singleWhere((template) => template.id == third.id)
          .splitId,
      destination.id,
    );
    expect(
      snapshot.templates.map((template) => template.id),
      containsAll([first.id, second.id, third.id]),
    );
  });

  test('all local records and outbox rows are isolated by owner', () async {
    final splitA = await repository.createSplit(
      userId: _userA,
      name: 'User A split',
    );
    final splitB = await repository.createSplit(
      userId: _userB,
      name: 'User B split',
    );
    final templateA = await repository.createTemplate(
      userId: _userA,
      splitId: splitA.id,
      name: 'Private A',
    );
    await repository.createTemplate(
      userId: _userB,
      splitId: splitB.id,
      name: 'Private B',
    );

    final snapshotA = await repository.getSnapshot(_userA);
    final snapshotB = await repository.getSnapshot(_userB);
    expect(snapshotA.splits.map((split) => split.id), [splitA.id]);
    expect(snapshotB.splits.map((split) => split.id), [splitB.id]);
    expect(snapshotA.templates.single.name, 'Private A');
    expect(snapshotB.templates.single.name, 'Private B');
    expect(await repository.pendingCount(_userA), 2);
    expect(await repository.pendingCount(_userB), 2);

    await expectLater(
      repository.renameTemplate(
        userId: _userB,
        templateId: templateA.id,
        name: 'Stolen',
      ),
      throwsStateError,
    );
  });
}

List<TemplateExercise> _entriesFor(
  PlanningSnapshot snapshot,
  String templateId,
) {
  final entries =
      snapshot.templateExercises
          .where((entry) => entry.templateId == templateId)
          .toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return entries;
}

class StrictFakePlanningRemote implements RemotePlanningDataSource {
  final Map<String, WorkoutSplit> splits = {};
  final Map<String, WorkoutTemplate> templates = {};
  final Map<String, CustomExercise> customExercises = {};
  final Map<String, TemplateExercise> templateExercises = {};

  @override
  Future<WorkoutSplit> upsertWorkoutSplit(WorkoutSplit split) async {
    _requireStableOwner(splits[split.id]?.userId, split.userId);
    final current = splits[split.id];
    if (current != null && current.version >= split.version) return current;
    splits[split.id] = split;
    return split;
  }

  @override
  Future<WorkoutTemplate> upsertWorkoutTemplate(
    WorkoutTemplate template,
  ) async {
    _requireStableOwner(templates[template.id]?.userId, template.userId);
    final splitId = template.splitId;
    if (splitId != null && splits[splitId]?.userId != template.userId) {
      throw StateError('Template cannot reference another user split.');
    }
    final current = templates[template.id];
    if (current != null && current.version >= template.version) return current;
    templates[template.id] = template;
    return template;
  }

  @override
  Future<CustomExercise> upsertCustomExercise(CustomExercise exercise) async {
    _requireStableOwner(customExercises[exercise.id]?.userId, exercise.userId);
    final current = customExercises[exercise.id];
    if (current != null && current.version >= exercise.version) return current;
    customExercises[exercise.id] = exercise;
    return exercise;
  }

  @override
  Future<TemplateExercise> upsertTemplateExercise(
    TemplateExercise exercise,
  ) async {
    _requireStableOwner(
      templateExercises[exercise.id]?.userId,
      exercise.userId,
    );
    if (templates[exercise.templateId]?.userId != exercise.userId) {
      throw StateError('Exercise cannot reference another user template.');
    }
    final customId = exercise.customExerciseId;
    if (customId != null &&
        customExercises[customId]?.userId != exercise.userId) {
      throw StateError('Exercise cannot reference another user movement.');
    }
    final current = templateExercises[exercise.id];
    if (current != null && current.version >= exercise.version) return current;
    templateExercises[exercise.id] = exercise;
    return exercise;
  }

  @override
  Future<PlanningSnapshot> fetchSnapshot(String userId) async {
    return PlanningSnapshot(
      splits: splits.values.where((value) => value.userId == userId),
      templates: templates.values.where((value) => value.userId == userId),
      customExercises: customExercises.values.where(
        (value) => value.userId == userId,
      ),
      templateExercises: templateExercises.values.where(
        (value) => value.userId == userId,
      ),
    );
  }

  void _requireStableOwner(String? existing, String incoming) {
    if (existing != null && existing != incoming) {
      throw StateError('A UUID cannot change owners.');
    }
  }
}

class _UuidSequence {
  var _value = 1;

  String next() {
    final suffix = _value.toRadixString(16).padLeft(12, '0');
    _value++;
    return '20000000-0000-4000-8000-$suffix';
  }
}

class _TestClock {
  var _tick = 0;

  DateTime now() =>
      DateTime.utc(2026, 7, 22, 9).add(Duration(seconds: _tick++));
}
