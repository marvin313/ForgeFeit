import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/core/database/app_database.dart';
import 'package:forgefit/features/planning/domain/planning_models.dart';
import 'package:forgefit/features/planning/domain/system_exercise_catalog.dart';
import 'package:forgefit/features/sessions/data/offline_first_session_repository.dart';
import 'package:forgefit/features/sessions/data/remote_session_data_source.dart';
import 'package:forgefit/features/sessions/domain/workout_session_models.dart';

void main() {
  late AppDatabase database;
  late _FakeSessionRemote remote;
  late _Clock clock;
  late _Ids ids;
  late OfflineFirstSessionRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    remote = _FakeSessionRemote();
    clock = _Clock(DateTime.utc(2026, 7, 22, 8));
    ids = _Ids();
    repository = OfflineFirstSessionRepository(
      database: database,
      remote: remote,
      clock: clock.call,
      idGenerator: ids.call,
    );
  });

  tearDown(() => database.close());

  test(
    'template start snapshots independently and enforces one active workout',
    () async {
      final createdAt = clock.call();
      await database
          .into(database.workoutTemplates)
          .insert(
            WorkoutTemplatesCompanion.insert(
              id: 'template-1',
              userId: 'user-a',
              name: 'Strength A',
              icon: 'bolt',
              colorValue: 0xff1976ff,
              createdAt: createdAt,
              updatedAt: createdAt,
            ),
          );
      await database
          .into(database.templateExercises)
          .insert(
            TemplateExercisesCompanion.insert(
              id: 'template-exercise-1',
              userId: 'user-a',
              templateId: 'template-1',
              systemExerciseKey: const Value('barbell_bench_press'),
              exerciseName: 'Flat Barbell Bench Press',
              primaryMuscleGroup: MuscleGroup.chest.wireValue,
              equipment: ExerciseEquipment.barbell.wireValue,
              workingSets: const Value(2),
              warmupSets: const Value(1),
              targetRepsMin: const Value(5),
              targetRepsMax: const Value(8),
              targetWeight: const Value(80),
              restSeconds: const Value(120),
              rpeTarget: const Value(8),
              notes: const Value('Pause the first rep'),
              createdAt: createdAt,
              updatedAt: createdAt,
            ),
          );

      final active = await repository.startWorkoutFromTemplate(
        userId: 'user-a',
        templateId: 'template-1',
        notes: 'Good sleep',
      );

      expect(active.session.name, 'Strength A');
      expect(active.session.notes, 'Good sleep');
      expect(active.exercises, hasLength(1));
      expect(active.sets, hasLength(3));
      expect(active.exercises.single.plannedWorkingSets, 2);
      expect(active.exercises.single.restSeconds, 120);
      expect(active.exercises.single.id, isNot('template-exercise-1'));
      expect(
        () => repository.startEmptyWorkout(userId: 'user-a'),
        throwsA(isA<ActiveWorkoutAlreadyExists>()),
      );

      await (database.update(
        database.workoutTemplates,
      )..where((row) => row.id.equals('template-1'))).write(
        const WorkoutTemplatesCompanion(name: Value('Changed template')),
      );
      await (database.update(database.templateExercises)
            ..where((row) => row.id.equals('template-exercise-1')))
          .write(const TemplateExercisesCompanion(workingSets: Value(9)));

      final restored = OfflineFirstSessionRepository(
        database: database,
        remote: remote,
        clock: clock.call,
        idGenerator: ids.call,
      );
      final recovered = await restored.getActiveWorkout('user-a');
      expect(recovered!.session.name, 'Strength A');
      expect(recovered.exercises.single.plannedWorkingSets, 2);
      expect(await restored.getActiveWorkout('user-b'), isNull);
    },
  );

  test(
    'set lifecycle, validation, ordering and timestamp-based timer persist',
    () async {
      final active = await repository.startEmptyWorkout(userId: 'user-a');
      final exercise = await repository.addExercise(
        userId: 'user-a',
        sessionId: active.session.id,
        exercise: SystemExerciseCatalog.byKey('barbell_bench_press')!,
        configuration: const TemplateExerciseConfiguration(
          workingSets: 1,
          targetRepsMin: 5,
          targetRepsMax: 8,
          restSeconds: 90,
        ),
      );
      final secondExercise = await repository.addExercise(
        userId: 'user-a',
        sessionId: active.session.id,
        exercise: SystemExerciseCatalog.byKey('lat_pulldown')!,
        configuration: const TemplateExerciseConfiguration(workingSets: 1),
      );
      final replacement = await repository.replaceExercise(
        userId: 'user-a',
        exerciseId: secondExercise.id,
        replacement: SystemExerciseCatalog.byKey('dumbbell_row')!,
      );
      expect(replacement.id, secondExercise.id);
      expect(replacement.exerciseKey, 'dumbbell_row');
      final notedExercise = await repository.editExerciseNotes(
        userId: 'user-a',
        exerciseId: secondExercise.id,
        notes: 'Keep the elbow tucked',
      );
      expect(notedExercise.notes, 'Keep the elbow tucked');
      await repository.reorderExercises(
        userId: 'user-a',
        sessionId: active.session.id,
        orderedExerciseIds: [secondExercise.id, exercise.id],
      );
      var bundle = (await repository.getActiveWorkout('user-a'))!;
      expect(bundle.exercises.map((entry) => entry.id), [
        secondExercise.id,
        exercise.id,
      ]);
      final first = bundle.setsFor(exercise.id).single;

      expect(
        () => repository.editSet(
          userId: 'user-a',
          setId: first.id,
          setType: WorkoutSetType.working,
          weightKg: -1,
          repetitions: 5,
          durationSeconds: null,
          distanceMeters: null,
          rpe: null,
          rir: null,
          notes: null,
        ),
        throwsArgumentError,
      );
      final edited = await repository.editSet(
        userId: 'user-a',
        setId: first.id,
        setType: WorkoutSetType.working,
        weightKg: 82.5,
        repetitions: 6,
        durationSeconds: null,
        distanceMeters: null,
        rpe: 8.5,
        rir: 1,
        notes: 'Clean rep speed',
      );
      final completed = await repository.completeSet(
        userId: 'user-a',
        setId: edited.id,
      );
      expect(completed.isCompleted, isTrue);
      bundle = (await repository.getActiveWorkout('user-a'))!;
      expect(bundle.session.restTimerState, RestTimerState.running);
      expect(bundle.session.restSecondsAt(clock.call()), 90);

      clock.advance(const Duration(seconds: 30));
      var timer = await repository.pauseRestTimer(
        userId: 'user-a',
        sessionId: active.session.id,
      );
      expect(timer.restTimerState, RestTimerState.paused);
      expect(timer.restTimerRemainingSeconds, 60);
      timer = await repository.adjustRestTimer(
        userId: 'user-a',
        sessionId: active.session.id,
        seconds: -15,
      );
      expect(timer.restTimerRemainingSeconds, 45);
      timer = await repository.resumeRestTimer(
        userId: 'user-a',
        sessionId: active.session.id,
      );
      expect(timer.restSecondsAt(clock.call()), 45);
      clock.advance(const Duration(seconds: 50));
      expect(timer.restSecondsAt(clock.call()), 0);
      timer = await repository.resetRestTimer(
        userId: 'user-a',
        sessionId: active.session.id,
      );
      expect(timer.restTimerRemainingSeconds, 75);
      timer = await repository.skipRestTimer(
        userId: 'user-a',
        sessionId: active.session.id,
      );
      expect(timer.restTimerState, RestTimerState.idle);
      timer = await repository.setAutomaticRestTimer(
        userId: 'user-a',
        sessionId: active.session.id,
        enabled: false,
      );
      expect(timer.autoStartRestTimer, isFalse);

      final duplicate = await repository.duplicateSet(
        userId: 'user-a',
        setId: first.id,
      );
      expect(duplicate.id, isNot(first.id));
      expect(duplicate.isCompleted, isFalse);
      expect(duplicate.weightKg, 82.5);
      final third = await repository.addSet(
        userId: 'user-a',
        exerciseId: exercise.id,
        setType: WorkoutSetType.dropSet,
      );
      final copied = await repository.copyPreviousSetValues(
        userId: 'user-a',
        setId: third.id,
      );
      expect(copied.weightKg, duplicate.weightKg);
      expect(copied.repetitions, duplicate.repetitions);
      await repository.reorderSets(
        userId: 'user-a',
        exerciseId: exercise.id,
        orderedSetIds: [third.id, duplicate.id, first.id],
      );
      bundle = (await repository.getActiveWorkout('user-a'))!;
      expect(bundle.setsFor(exercise.id).map((set) => set.id), [
        third.id,
        duplicate.id,
        first.id,
      ]);
      final uncompleted = await repository.uncompleteSet(
        userId: 'user-a',
        setId: first.id,
      );
      expect(uncompleted.isCompleted, isFalse);
      expect(uncompleted.completedAt, isNull);
      await repository.removeSet(userId: 'user-a', setId: duplicate.id);
      bundle = (await repository.getActiveWorkout('user-a'))!;
      expect(bundle.setsFor(exercise.id).map((set) => set.id), [
        third.id,
        first.id,
      ]);
      await repository.completeSet(userId: 'user-a', setId: third.id);
      expect(
        (await repository.getActiveWorkout('user-a'))!.session.restTimerState,
        RestTimerState.idle,
      );
      await repository.removeExercise(
        userId: 'user-a',
        exerciseId: secondExercise.id,
      );
      bundle = (await repository.getActiveWorkout('user-a'))!;
      expect(bundle.exercises.map((entry) => entry.id), [exercise.id]);
      expect(bundle.setsFor(secondExercise.id), isEmpty);
      final tombstones = await repository.pendingUploads('user-a');
      expect(
        tombstones
            .where(
              (item) =>
                  item.entityType == SessionEntityType.activeExercise &&
                  item.entityId == secondExercise.id,
            )
            .map((item) => (item.entity as ActiveWorkoutExercise).isDeleted),
        [true],
      );
    },
  );

  test(
    'finish is atomic, totals and PRs are deterministic, delete recomputes',
    () async {
      final first = await _finishBenchWorkout(
        repository: repository,
        clock: clock,
        weightsAndReps: const [
          (60.0, 10, true),
          (100.0, 5, false),
          (90.0, 10, false),
        ],
        notes: 'First full session',
      );

      expect(first.session.totalCompletedSets, 3);
      expect(first.session.workingSetCount, 2);
      expect(first.session.totalRepetitions, 25);
      expect(first.session.totalVolumeKg, 1400);
      expect(first.session.exerciseCount, 1);
      expect(first.session.personalRecordCount, 6);
      expect(first.session.notes, 'First full session');
      expect(await repository.getActiveWorkout('user-a'), isNull);
      expect(first.sets.where((set) => set.isPersonalRecord), hasLength(2));

      var records = await repository.watchPersonalRecords('user-a').first;
      expect(records, hasLength(6));
      expect(
        records
            .singleWhere(
              (record) =>
                  record.recordKind == PersonalRecordKind.heaviestWeight,
            )
            .recordValue,
        100,
      );
      expect(
        records
            .singleWhere(
              (record) =>
                  record.recordKind == PersonalRecordKind.estimatedOneRepMax,
            )
            .recordValue,
        120,
      );
      expect(
        records
            .singleWhere(
              (record) =>
                  record.recordKind == PersonalRecordKind.exerciseWorkoutVolume,
            )
            .recordValue,
        1400,
      );
      final summary = await repository.getWorkoutSummary(
        userId: 'user-a',
        sessionId: first.session.id,
      );
      expect(summary.personalRecords, hasLength(6));

      clock.advance(const Duration(hours: 24));
      final second = await _finishBenchWorkout(
        repository: repository,
        clock: clock,
        weightsAndReps: const [(110.0, 5, false)],
      );
      records = await repository.watchPersonalRecords('user-a').first;
      expect(
        records
            .singleWhere(
              (record) =>
                  record.recordKind == PersonalRecordKind.heaviestWeight,
            )
            .recordValue,
        110,
      );
      expect(second.session.personalRecordCount, 3);

      await repository.softDeleteCompletedWorkout(
        userId: 'user-a',
        sessionId: second.session.id,
      );
      records = await repository.watchPersonalRecords('user-a').first;
      expect(
        records
            .singleWhere(
              (record) =>
                  record.recordKind == PersonalRecordKind.heaviestWeight,
            )
            .recordValue,
        100,
      );
      expect(
        records.where((record) => record.recordScope == 'weight_kg:110.000'),
        isEmpty,
      );
      final history = await repository.searchCompletedWorkouts(
        userId: 'user-a',
      );
      expect(history.map((session) => session.id), [first.session.id]);
    },
  );

  test(
    'previous performance excludes deleted history and labels legacy fallback',
    () async {
      final completed = await _finishBenchWorkout(
        repository: repository,
        clock: clock,
        weightsAndReps: const [(75.0, 8, false)],
      );
      var previous = await repository.getPreviousPerformance(
        userId: 'user-a',
        exerciseKey: 'barbell_bench_press',
        exerciseName: 'Flat Barbell Bench Press',
      );
      expect(previous!.isLegacyQuickLog, isFalse);
      expect(previous.sets.single.weightKg, 75);

      await repository.softDeleteCompletedWorkout(
        userId: 'user-a',
        sessionId: completed.session.id,
      );
      final now = clock.call();
      await database
          .into(database.workouts)
          .insert(
            WorkoutRow(
              id: 'legacy-workout',
              userId: 'user-a',
              exerciseName: 'Flat Barbell Bench Press',
              performedAt: now,
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.workoutSets)
          .insert(
            WorkoutSetRow(
              id: 'legacy-set',
              workoutId: 'legacy-workout',
              userId: 'user-a',
              weight: 70,
              reps: 10,
              setOrder: 1,
              createdAt: now,
              updatedAt: now,
            ),
          );
      previous = await repository.getPreviousPerformance(
        userId: 'user-a',
        exerciseKey: 'barbell_bench_press',
        exerciseName: 'Flat Barbell Bench Press',
      );
      expect(previous!.isLegacyQuickLog, isTrue);
      expect(previous.sets.single.weightKg, 70);
    },
  );

  test(
    'training volume uses completed working sets and explicit load only',
    () async {
      final barbell = await repository.startEmptyWorkout(
        userId: 'user-a',
        name: 'Volume checks',
      );
      final bench = await repository.addExercise(
        userId: 'user-a',
        sessionId: barbell.session.id,
        exercise: SystemExerciseCatalog.byKey('barbell_bench_press')!,
        configuration: const TemplateExerciseConfiguration(workingSets: 0),
      );
      for (final weight in const [80.0, 80.0, 80.0]) {
        final set = await repository.addSet(
          userId: 'user-a',
          exerciseId: bench.id,
          weightKg: weight,
          repetitions: 8,
        );
        await repository.completeSet(
          userId: 'user-a',
          setId: set.id,
          startAutomaticRestTimer: false,
        );
      }
      final incomplete = await repository.addSet(
        userId: 'user-a',
        exerciseId: bench.id,
        weightKg: 100,
        repetitions: 10,
      );
      expect(incomplete.isCompleted, isFalse);
      final varied = await repository.addSet(
        userId: 'user-a',
        exerciseId: bench.id,
        weightKg: 60,
        repetitions: 5,
      );
      await repository.completeSet(
        userId: 'user-a',
        setId: varied.id,
        startAutomaticRestTimer: false,
      );
      final zeroWeight = await repository.addSet(
        userId: 'user-a',
        exerciseId: bench.id,
        weightKg: 0,
        repetitions: 15,
      );
      await repository.completeSet(
        userId: 'user-a',
        setId: zeroWeight.id,
        startAutomaticRestTimer: false,
      );
      final completed = await repository.finishWorkout(
        userId: 'user-a',
        sessionId: barbell.session.id,
      );
      // 3 x 8 x 80 plus 5 x 60. The incomplete and zero-load sets add nothing.
      expect(completed.session.totalVolumeKg, 2220);

      final bodyweight = await repository.startEmptyWorkout(
        userId: 'user-a',
        name: 'Bodyweight checks',
      );
      final abRoller = await repository.addExercise(
        userId: 'user-a',
        sessionId: bodyweight.session.id,
        exercise: SystemExerciseCatalog.byKey('ab_wheel_rollout')!,
        configuration: const TemplateExerciseConfiguration(workingSets: 0),
      );
      final bodyweightSet = await repository.addSet(
        userId: 'user-a',
        exerciseId: abRoller.id,
        repetitions: 12,
      );
      await repository.completeSet(
        userId: 'user-a',
        setId: bodyweightSet.id,
        startAutomaticRestTimer: false,
      );
      final weightedBodyweightSet = await repository.addSet(
        userId: 'user-a',
        exerciseId: abRoller.id,
        weightKg: 10,
        repetitions: 12,
      );
      await repository.completeSet(
        userId: 'user-a',
        setId: weightedBodyweightSet.id,
        startAutomaticRestTimer: false,
      );
      final bodyweightCompleted = await repository.finishWorkout(
        userId: 'user-a',
        sessionId: bodyweight.session.id,
      );
      // Bodyweight is not inferred as load; only explicitly entered added weight counts.
      expect(bodyweightCompleted.session.totalVolumeKg, 120);
    },
  );

  test(
    'custom exercise keeps its UUID snapshot and excludes incomplete and warm-up PRs',
    () async {
      const customId = 'custom-exercise-stable-id';
      final custom = CustomExercise(
        id: customId,
        userId: 'user-a',
        name: 'Cable Sprint Pull',
        primaryMuscleGroup: MuscleGroup.fullBody,
        secondaryMuscleGroups: const [MuscleGroup.back],
        equipment: ExerciseEquipment.cable,
        isFavourite: true,
        createdAt: clock.call(),
        updatedAt: clock.call(),
        version: 1,
      );
      final active = await repository.startEmptyWorkout(userId: 'user-a');
      final exercise = await repository.addExercise(
        userId: 'user-a',
        sessionId: active.session.id,
        exercise: custom.selection,
        configuration: const TemplateExerciseConfiguration(
          workingSets: 0,
          warmupSets: 0,
          targetRepsMin: 0,
          targetRepsMax: 0,
          restSeconds: 0,
        ),
      );
      final warmup = await repository.addSet(
        userId: 'user-a',
        exerciseId: exercise.id,
        setType: WorkoutSetType.warmUp,
        weightKg: 80,
        repetitions: 20,
      );
      await repository.completeSet(
        userId: 'user-a',
        setId: warmup.id,
        startAutomaticRestTimer: false,
      );
      final working = await repository.addSet(
        userId: 'user-a',
        exerciseId: exercise.id,
        weightKg: 40,
        repetitions: 10,
      );
      await repository.completeSet(
        userId: 'user-a',
        setId: working.id,
        startAutomaticRestTimer: false,
      );
      await repository.addSet(
        userId: 'user-a',
        exerciseId: exercise.id,
        weightKg: 100,
        repetitions: 100,
      );
      clock.advance(const Duration(minutes: 30));
      final completed = await repository.finishWorkout(
        userId: 'user-a',
        sessionId: active.session.id,
      );

      expect(completed.session.totalCompletedSets, 2);
      expect(completed.session.totalRepetitions, 30);
      expect(completed.session.totalVolumeKg, 400);
      expect(completed.exercises.single.exerciseKey, customId);
      expect(completed.exercises.single.customExerciseId, customId);
      expect(completed.exercises.single.exerciseSource, ExerciseSource.custom);
      final records = await repository.watchPersonalRecords('user-a').first;
      expect(
        records
            .singleWhere(
              (record) =>
                  record.recordKind == PersonalRecordKind.heaviestWeight,
            )
            .recordValue,
        40,
      );
      expect(
        records.every((record) => record.customExerciseId == customId),
        isTrue,
      );
      final previous = await repository.getPreviousPerformance(
        userId: 'user-a',
        exerciseKey: customId,
        exerciseName: custom.name,
      );
      expect(previous!.isLegacyQuickLog, isFalse);
      expect(previous.sets, hasLength(2));
    },
  );

  test(
    'durable outbox coalesces, retries idempotently and restore is owner scoped',
    () async {
      final active = await repository.startEmptyWorkout(userId: 'user-a');
      final initialSessionUpload = (await repository.pendingUploads('user-a'))
          .singleWhere(
            (upload) => upload.entityType == SessionEntityType.activeSession,
          );
      await repository.editActiveWorkout(
        userId: 'user-a',
        sessionId: active.session.id,
        name: 'Renamed offline',
        notes: 'Pending newest version',
      );
      final coalesced = (await repository.pendingUploads('user-a')).singleWhere(
        (upload) => upload.entityType == SessionEntityType.activeSession,
      );
      expect(coalesced.queueId, initialSessionUpload.queueId);
      expect(
        coalesced.entityVersion,
        greaterThan(initialSessionUpload.entityVersion),
      );

      remote.failUploads = true;
      await expectLater(repository.uploadPending(coalesced), throwsStateError);
      await repository.markUploadFailed(coalesced, StateError('offline'));
      final failed = (await repository.pendingUploads(
        'user-a',
      )).singleWhere((upload) => upload.queueId == coalesced.queueId);
      expect(failed.attemptCount, 1);
      expect(failed.lastError, contains('offline'));

      remote.failUploads = false;
      final uploaded = await repository.uploadPendingChanges('user-a');
      expect(uploaded, greaterThanOrEqualTo(1));
      expect(await repository.pendingUploadCount('user-a'), 0);
      expect(remote.activeSessions, hasLength(1));
      expect(remote.activeSessions.values.single.name, 'Renamed offline');

      final foreign = _foreignCompletedSession(clock.call());
      remote.extraSnapshot = SessionCloudSnapshot(
        activeSessions: remote.activeSessions.values,
        activeExercises: remote.activeExercises.values,
        activeSets: remote.activeSets.values,
        completedSessions: [foreign],
        completedExercises: const [],
        completedSets: const [],
        personalRecords: const [],
        personalRecordEvents: const [],
      );
      await database.close();
      final fresh = AppDatabase(NativeDatabase.memory());
      database = fresh;
      final restored = OfflineFirstSessionRepository(
        database: fresh,
        remote: remote,
        clock: clock.call,
        idGenerator: _Ids().call,
      );
      await restored.restoreFromCloud('user-a');
      expect(
        (await restored.getActiveWorkout('user-a'))!.session.name,
        'Renamed offline',
      );
      expect(await restored.searchCompletedWorkouts(userId: 'user-a'), isEmpty);
      expect(await restored.getActiveWorkout('user-b'), isNull);
      expect(await restored.pendingUploadCount('user-a'), 0);
    },
  );

  test(
    'active session tombstone uploads before a replacement open session',
    () async {
      final old = await repository.startEmptyWorkout(
        userId: 'user-a',
        name: 'Old active',
      );
      await repository.discardActiveWorkout(
        userId: 'user-a',
        sessionId: old.session.id,
      );
      final replacement = await repository.startEmptyWorkout(
        userId: 'user-a',
        name: 'Replacement',
      );

      final sessions = (await repository.pendingUploads('user-a'))
          .where((item) => item.entityType == SessionEntityType.activeSession)
          .toList();
      expect(sessions, hasLength(2));
      expect((sessions.first.entity as ActiveWorkoutSession).isDeleted, isTrue);
      expect(
        (sessions.last.entity as ActiveWorkoutSession).id,
        replacement.session.id,
      );
    },
  );

  test('upload rejects stale cloud result and adopts a newer winner', () async {
    await repository.startEmptyWorkout(userId: 'user-a', name: 'Local name');
    final pending = (await repository.pendingUploads('user-a')).singleWhere(
      (item) => item.entityType == SessionEntityType.activeSession,
    );
    remote.activeSessionWinner = (session) => _copySessionForRemote(
      session,
      name: 'Invalid stale result',
      version: session.version - 1,
    );
    await expectLater(repository.uploadPending(pending), throwsStateError);
    expect(
      (await repository.getActiveWorkout('user-a'))!.session.name,
      'Local name',
    );
    expect(await repository.pendingUploadCount('user-a'), greaterThan(0));

    remote.activeSessionWinner = (session) => _copySessionForRemote(
      session,
      name: 'Cloud conflict winner',
      version: session.version + 2,
    );
    await repository.uploadPending(pending);
    await repository.markUploadSucceeded(pending);
    final adopted = (await repository.getActiveWorkout('user-a'))!.session;
    expect(adopted.name, 'Cloud conflict winner');
    expect(adopted.version, pending.entityVersion + 2);
  });
}

Future<CompletedWorkoutBundle> _finishBenchWorkout({
  required OfflineFirstSessionRepository repository,
  required _Clock clock,
  required List<(double, int, bool)> weightsAndReps,
  String? notes,
}) async {
  final active = await repository.startEmptyWorkout(
    userId: 'user-a',
    name: 'Bench Session',
    notes: notes,
  );
  final exercise = await repository.addExercise(
    userId: 'user-a',
    sessionId: active.session.id,
    exercise: SystemExerciseCatalog.byKey('barbell_bench_press')!,
    configuration: const TemplateExerciseConfiguration(
      workingSets: 0,
      warmupSets: 0,
      targetRepsMin: 0,
      targetRepsMax: 0,
      restSeconds: 0,
    ),
  );
  for (final (weight, repetitions, warmup) in weightsAndReps) {
    final set = await repository.addSet(
      userId: 'user-a',
      exerciseId: exercise.id,
      setType: warmup ? WorkoutSetType.warmUp : WorkoutSetType.working,
      weightKg: weight,
      repetitions: repetitions,
    );
    await repository.completeSet(
      userId: 'user-a',
      setId: set.id,
      startAutomaticRestTimer: false,
    );
  }
  clock.advance(const Duration(hours: 1));
  return repository.finishWorkout(
    userId: 'user-a',
    sessionId: active.session.id,
  );
}

CompletedWorkoutSession _foreignCompletedSession(DateTime now) =>
    CompletedWorkoutSession(
      id: 'foreign-session',
      userId: 'user-b',
      name: 'Other account',
      weightUnit: 'kg',
      startedAt: now,
      endedAt: now,
      durationSeconds: 0,
      exerciseCount: 0,
      workingSetCount: 0,
      totalCompletedSets: 0,
      totalRepetitions: 0,
      totalVolumeKg: 0,
      personalRecordCount: 0,
      createdAt: now,
      updatedAt: now,
      version: 1,
    );

ActiveWorkoutSession _copySessionForRemote(
  ActiveWorkoutSession value, {
  required String name,
  required int version,
}) => ActiveWorkoutSession(
  id: value.id,
  userId: value.userId,
  name: name,
  sourceTemplateId: value.sourceTemplateId,
  startedAt: value.startedAt,
  notes: value.notes,
  weightUnit: value.weightUnit,
  restTimerState: value.restTimerState,
  restTimerDurationSeconds: value.restTimerDurationSeconds,
  restTimerTargetEndAt: value.restTimerTargetEndAt,
  restTimerRemainingSeconds: value.restTimerRemainingSeconds,
  autoStartRestTimer: value.autoStartRestTimer,
  createdAt: value.createdAt,
  updatedAt: value.updatedAt,
  deletedAt: value.deletedAt,
  version: version,
);

class _Clock {
  _Clock(this.now);

  DateTime now;

  DateTime call() => now;

  void advance(Duration duration) => now = now.add(duration);
}

class _Ids {
  var _value = 0;

  String call() => 'test-id-${++_value}';
}

class _FakeSessionRemote implements RemoteSessionDataSource {
  final activeSessions = <String, ActiveWorkoutSession>{};
  final activeExercises = <String, ActiveWorkoutExercise>{};
  final activeSets = <String, ActiveWorkoutSet>{};
  final completedSessions = <String, CompletedWorkoutSession>{};
  final completedExercises = <String, CompletedWorkoutExercise>{};
  final completedSets = <String, CompletedWorkoutSet>{};
  final personalRecords = <String, PersonalRecord>{};
  final personalRecordEvents = <String, PersonalRecordEvent>{};
  bool failUploads = false;
  SessionCloudSnapshot? extraSnapshot;
  ActiveWorkoutSession Function(ActiveWorkoutSession)? activeSessionWinner;

  void _failIfRequested() {
    if (failUploads) throw StateError('simulated offline');
  }

  @override
  Future<ActiveWorkoutSession> upsertActiveSession(
    ActiveWorkoutSession session,
  ) async {
    _failIfRequested();
    final winner = activeSessionWinner?.call(session) ?? session;
    activeSessions[session.id] = winner;
    return winner;
  }

  @override
  Future<ActiveWorkoutExercise> upsertActiveExercise(
    ActiveWorkoutExercise exercise,
  ) async {
    _failIfRequested();
    activeExercises[exercise.id] = exercise;
    return exercise;
  }

  @override
  Future<ActiveWorkoutSet> upsertActiveSet(ActiveWorkoutSet set) async {
    _failIfRequested();
    activeSets[set.id] = set;
    return set;
  }

  @override
  Future<CompletedWorkoutSession> upsertCompletedSession(
    CompletedWorkoutSession session,
  ) async {
    _failIfRequested();
    completedSessions[session.id] = session;
    return session;
  }

  @override
  Future<CompletedWorkoutExercise> upsertCompletedExercise(
    CompletedWorkoutExercise exercise,
  ) async {
    _failIfRequested();
    completedExercises[exercise.id] = exercise;
    return exercise;
  }

  @override
  Future<CompletedWorkoutSet> upsertCompletedSet(
    CompletedWorkoutSet set,
  ) async {
    _failIfRequested();
    completedSets[set.id] = set;
    return set;
  }

  @override
  Future<PersonalRecord> upsertPersonalRecord(PersonalRecord record) async {
    _failIfRequested();
    personalRecords[record.id] = record;
    return record;
  }

  @override
  Future<PersonalRecordEvent> upsertPersonalRecordEvent(
    PersonalRecordEvent event,
  ) async {
    _failIfRequested();
    personalRecordEvents[event.id] = event;
    return event;
  }

  @override
  Future<SessionCloudSnapshot> fetchSnapshot(String userId) async {
    return extraSnapshot ??
        SessionCloudSnapshot(
          activeSessions: activeSessions.values,
          activeExercises: activeExercises.values,
          activeSets: activeSets.values,
          completedSessions: completedSessions.values,
          completedExercises: completedExercises.values,
          completedSets: completedSets.values,
          personalRecords: personalRecords.values,
          personalRecordEvents: personalRecordEvents.values,
        );
  }
}
