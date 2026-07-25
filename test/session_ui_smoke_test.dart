import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/core/theme/forgefit_theme.dart';
import 'package:forgefit/features/planning/domain/planning_models.dart';
import 'package:forgefit/features/sessions/data/offline_first_session_repository.dart';
import 'package:forgefit/features/sessions/domain/workout_session_models.dart';
import 'package:forgefit/features/sessions/presentation/active_workout_screen.dart';
import 'package:forgefit/features/sessions/presentation/completed_workout_detail_screen.dart';
import 'package:forgefit/features/sessions/presentation/personal_records_screen.dart';
import 'package:forgefit/features/sessions/presentation/session_history_screen.dart';
import 'package:forgefit/features/sessions/presentation/session_ui_widgets.dart';
import 'package:forgefit/features/sessions/presentation/workout_summary_screen.dart';
import 'package:forgefit/features/workouts/domain/workout_entry.dart';

void main() {
  final fixture = _SessionFixture();

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('preferred-weight conversion round trips canonical kilograms', () {
    final pounds = SessionFormat.weightFromKg(100, 'lb');
    expect(pounds, closeTo(220.46226218, 0.00000001));
    expect(SessionFormat.weightToKg(pounds, 'lb'), closeTo(100, 0.00000001));
    expect(SessionFormat.weight(100, 'kg'), '100 kg');
    expect(SessionFormat.weight(100, 'lb'), '220.5 lb');
    expect(SessionFormat.volumeKg(1000), '1000 kg volume');
  });

  testWidgets('active workout fits an iPhone and exposes core controls', (
    tester,
  ) async {
    await _setIPhoneSize(tester);
    final repository = _FakeSessionRepository(fixture: fixture);

    await tester.pumpWidget(
      _app(
        ActiveWorkoutScreen(
          userId: fixture.userId,
          weightUnit: 'lb',
          repository: repository,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Push Strength'), findsOneWidget);
    expect(find.byKey(const ValueKey('elapsed-workout-time')), findsNothing);
    expect(find.text('Rest timer'), findsNothing);
    expect(find.byKey(const ValueKey('rest-timer-value')), findsNothing);
    expect(
      find.byKey(const ValueKey('complete-all-sets-active-exercise')),
      findsOneWidget,
    );
    expect(find.text('Barbell Bench Press'), findsOneWidget);
    expect(find.textContaining('176.4 lb'), findsWidgets);
    expect(
      find.byKey(const ValueKey('add-active-exercise-button')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('finish-workout-button')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('history merges completed sessions and legacy quick logs', (
    tester,
  ) async {
    await _setIPhoneSize(tester);
    final repository = _FakeSessionRepository(fixture: fixture);

    await tester.pumpWidget(
      _app(
        SessionHistoryScreen(
          userId: fixture.userId,
          weightUnit: 'kg',
          repository: repository,
          legacyQuickLogs: [fixture.legacyWorkout],
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Push Strength'), findsOneWidget);
    expect(find.text('LEGACY QUICK LOG'), findsOneWidget);
    expect(find.textContaining('kg volume'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('session-history-calendar-toggle')),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('workout-calendar-view')), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey('session-history-calendar-toggle')),
    );
    await tester.pumpAndSettle();
    expect(find.text('LEGACY QUICK LOG'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('session-history-search')),
      'legacy',
    );
    await tester.pump();
    expect(find.text('Push Strength'), findsNothing);
    expect(find.text('LEGACY QUICK LOG'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('summary and completed detail render read-only performance', (
    tester,
  ) async {
    await _setIPhoneSize(tester);
    final repository = _FakeSessionRepository(fixture: fixture);

    await tester.pumpWidget(
      _app(
        WorkoutSummaryScreen(
          userId: fixture.userId,
          weightUnit: 'kg',
          repository: repository,
          sessionId: fixture.completed.session.id,
          initialSummary: fixture.summary,
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Workout complete'), findsOneWidget);
    expect(find.text('Personal records'), findsOneWidget);
    expect(find.textContaining('kg volume'), findsWidgets);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      _app(
        CompletedWorkoutDetailScreen(
          userId: fixture.userId,
          weightUnit: 'kg',
          repository: repository,
          sessionId: fixture.completed.session.id,
          initialWorkout: fixture.completed,
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Performance'), findsOneWidget);
    expect(find.text('Barbell Bench Press'), findsOneWidget);
    expect(find.textContaining('80 kg'), findsWidgets);
    expect(find.textContaining('read-only'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'summary Done removes the active-workout stack and returns home',
    (tester) async {
      await _setIPhoneSize(tester);
      final repository = _FakeSessionRepository(fixture: fixture);

      await tester.pumpWidget(
        _app(_HomeRoute(fixture: fixture, repository: repository)),
      );
      await tester.tap(find.text('Open active workout'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Finish workout'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Finish review'));
      await tester.pumpAndSettle();

      expect(find.text('Workout complete'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Done'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();

      expect(find.text('ForgeFit Home'), findsOneWidget);
      expect(find.text('No active workout'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('personal records group current bests by exercise', (
    tester,
  ) async {
    await _setIPhoneSize(tester);
    final repository = _FakeSessionRepository(fixture: fixture);

    await tester.pumpWidget(
      _app(
        PersonalRecordsScreen(
          userId: fixture.userId,
          weightUnit: 'lb',
          repository: repository,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Barbell Bench Press'), findsOneWidget);
    expect(find.textContaining('current record'), findsOneWidget);
    await tester.tap(find.text('Barbell Bench Press'));
    await tester.pump();
    expect(find.text('Heaviest weight'), findsOneWidget);
    expect(find.textContaining('176.4 lb'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Widget _app(Widget home) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: buildForgeFitTheme(),
  home: home,
);

class _HomeRoute extends StatelessWidget {
  const _HomeRoute({required this.fixture, required this.repository});

  final _SessionFixture fixture;
  final _FakeSessionRepository repository;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: FilledButton(
        onPressed: () => Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (_) =>
                _ActiveRoute(fixture: fixture, repository: repository),
          ),
        ),
        child: const Text('Open active workout'),
      ),
    ),
    appBar: AppBar(title: const Text('ForgeFit Home')),
  );
}

class _ActiveRoute extends StatelessWidget {
  const _ActiveRoute({required this.fixture, required this.repository});

  final _SessionFixture fixture;
  final _FakeSessionRepository repository;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: FilledButton(
        onPressed: () => Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (_) =>
                _FinishReviewRoute(fixture: fixture, repository: repository),
          ),
        ),
        child: const Text('Finish workout'),
      ),
    ),
  );
}

class _FinishReviewRoute extends StatelessWidget {
  const _FinishReviewRoute({required this.fixture, required this.repository});

  final _SessionFixture fixture;
  final _FakeSessionRepository repository;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: FilledButton(
        onPressed: () => Navigator.of(context).pushReplacement<void, void>(
          MaterialPageRoute(
            builder: (_) => WorkoutSummaryScreen(
              userId: fixture.userId,
              weightUnit: 'kg',
              repository: repository,
              sessionId: fixture.completed.session.id,
              initialSummary: fixture.summary,
            ),
          ),
        ),
        child: const Text('Finish review'),
      ),
    ),
  );
}

Future<void> _setIPhoneSize(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(390, 844);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
}

class _FakeSessionRepository implements OfflineFirstSessionRepository {
  _FakeSessionRepository({required this.fixture});

  final _SessionFixture fixture;

  @override
  Stream<ActiveWorkoutBundle?> watchActiveWorkout(String userId) =>
      Stream.value(fixture.active);

  @override
  Stream<List<CompletedWorkoutSession>> watchCompletedSessions(String userId) =>
      Stream.value([fixture.completed.session]);

  @override
  Stream<List<PersonalRecord>> watchPersonalRecords(String userId) =>
      Stream.value(fixture.records);

  @override
  Future<PreviousPerformance?> getPreviousPerformance({
    required String userId,
    required String exerciseKey,
    required String exerciseName,
  }) async => PreviousPerformance(
    performedAt: fixture.completed.session.endedAt,
    exerciseName: exerciseName,
    sets: fixture.completed.sets,
  );

  @override
  Future<CompletedWorkoutBundle> getCompletedWorkout({
    required String userId,
    required String sessionId,
  }) async => fixture.completed;

  @override
  Future<WorkoutSummary> getWorkoutSummary({
    required String userId,
    required String sessionId,
  }) async => fixture.summary;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SessionFixture {
  _SessionFixture() {
    final now = DateTime.utc(2026, 7, 22, 8);
    final activeSession = ActiveWorkoutSession(
      id: 'active-session',
      userId: userId,
      name: 'Push Strength',
      startedAt: now.subtract(const Duration(minutes: 42)),
      weightUnit: 'kg',
      restTimerState: RestTimerState.paused,
      restTimerDurationSeconds: 90,
      restTimerRemainingSeconds: 45,
      autoStartRestTimer: true,
      createdAt: now,
      updatedAt: now,
      version: 1,
      notes: 'Keep one repetition in reserve.',
    );
    final activeExercise = ActiveWorkoutExercise(
      id: 'active-exercise',
      userId: userId,
      sessionId: activeSession.id,
      exerciseSource: ExerciseSource.system,
      exerciseKey: 'flat_barbell_bench_press',
      systemExerciseKey: 'flat_barbell_bench_press',
      exerciseName: 'Barbell Bench Press',
      primaryMuscleGroup: MuscleGroup.chest,
      equipment: ExerciseEquipment.barbell,
      trackingType: ExerciseTrackingType.weightAndRepetitions,
      weightRelevant: true,
      repetitionsRelevant: true,
      distanceRelevant: false,
      durationRelevant: false,
      bodyweightRelevant: false,
      plannedWorkingSets: 3,
      plannedWarmupSets: 1,
      minTargetReps: 5,
      maxTargetReps: 8,
      targetWeightKg: 80,
      restSeconds: 120,
      sortOrder: 0,
      createdAt: now,
      updatedAt: now,
      version: 1,
    );
    final activeSet = ActiveWorkoutSet(
      id: 'active-set',
      userId: userId,
      sessionId: activeSession.id,
      sessionExerciseId: activeExercise.id,
      setType: WorkoutSetType.working,
      weightKg: 80,
      repetitions: 8,
      rpe: 8,
      isCompleted: true,
      sortOrder: 0,
      completedAt: now,
      createdAt: now,
      updatedAt: now,
      version: 2,
    );
    active = ActiveWorkoutBundle(
      session: activeSession,
      exercises: [activeExercise],
      sets: [activeSet],
    );

    final completedSession = CompletedWorkoutSession(
      id: 'completed-session',
      userId: userId,
      name: 'Push Strength',
      weightUnit: 'kg',
      startedAt: now.subtract(const Duration(hours: 1)),
      endedAt: now,
      durationSeconds: 3600,
      exerciseCount: 1,
      workingSetCount: 1,
      totalCompletedSets: 1,
      totalRepetitions: 8,
      totalVolumeKg: 640,
      personalRecordCount: 1,
      createdAt: now,
      updatedAt: now,
      version: 1,
      notes: 'Strong session.',
    );
    final completedExercise = CompletedWorkoutExercise(
      id: 'completed-exercise',
      userId: userId,
      sessionId: completedSession.id,
      exerciseSource: ExerciseSource.system,
      exerciseKey: 'flat_barbell_bench_press',
      systemExerciseKey: 'flat_barbell_bench_press',
      exerciseName: 'Barbell Bench Press',
      primaryMuscleGroup: MuscleGroup.chest,
      equipment: ExerciseEquipment.barbell,
      trackingType: ExerciseTrackingType.weightAndRepetitions,
      weightRelevant: true,
      repetitionsRelevant: true,
      distanceRelevant: false,
      durationRelevant: false,
      bodyweightRelevant: false,
      sortOrder: 0,
      completedSetCount: 1,
      workingSetCount: 1,
      totalRepetitions: 8,
      totalVolumeKg: 640,
      bestWeightKg: 80,
      bestEstimatedOneRepMaxKg: 101.333,
      createdAt: now,
      updatedAt: now,
      version: 1,
    );
    final completedSet = CompletedWorkoutSet(
      id: 'completed-set',
      userId: userId,
      sessionId: completedSession.id,
      sessionExerciseId: completedExercise.id,
      setType: WorkoutSetType.working,
      weightKg: 80,
      repetitions: 8,
      rpe: 8,
      sortOrder: 0,
      setVolumeKg: 640,
      estimatedOneRepMaxKg: 101.333,
      isPersonalRecord: true,
      completedAt: now,
      createdAt: now,
      updatedAt: now,
      version: 1,
    );
    completed = CompletedWorkoutBundle(
      session: completedSession,
      exercises: [completedExercise],
      sets: [completedSet],
    );

    final record = PersonalRecord(
      id: 'record',
      userId: userId,
      exerciseSource: ExerciseSource.system,
      exerciseKey: completedExercise.exerciseKey,
      systemExerciseKey: completedExercise.exerciseKey,
      exerciseName: completedExercise.exerciseName,
      recordKind: PersonalRecordKind.heaviestWeight,
      recordScope: 'overall',
      recordValue: 80,
      weightKg: 80,
      repetitions: 8,
      completedSessionId: completedSession.id,
      completedExerciseId: completedExercise.id,
      completedSetId: completedSet.id,
      achievedAt: now,
      createdAt: now,
      updatedAt: now,
      version: 1,
    );
    records = [record];
    final event = PersonalRecordEvent(
      id: 'record-event',
      userId: userId,
      personalRecordId: record.id,
      eventKey: 'event-key',
      exerciseSource: ExerciseSource.system,
      exerciseKey: completedExercise.exerciseKey,
      exerciseName: completedExercise.exerciseName,
      recordKind: record.recordKind,
      recordScope: record.recordScope,
      recordValue: record.recordValue,
      weightKg: record.weightKg,
      repetitions: record.repetitions,
      completedSessionId: completedSession.id,
      completedExerciseId: completedExercise.id,
      completedSetId: completedSet.id,
      achievedAt: now,
      createdAt: now,
      updatedAt: now,
      version: 1,
    );
    summary = WorkoutSummary(
      session: completedSession,
      personalRecords: [event],
    );

    legacyWorkout = WorkoutEntry(
      id: 'legacy-workout',
      userId: userId,
      exerciseName: 'Legacy Dumbbell Curl',
      performedAt: now.subtract(const Duration(days: 2)),
      createdAt: now,
      updatedAt: now,
      sets: [
        WorkoutSetEntry(
          id: 'legacy-set',
          workoutId: 'legacy-workout',
          userId: userId,
          weight: 15,
          reps: 12,
          createdAt: now,
          updatedAt: now,
        ),
      ],
    );
  }

  final String userId = 'user-1';
  late final ActiveWorkoutBundle active;
  late final CompletedWorkoutBundle completed;
  late final List<PersonalRecord> records;
  late final WorkoutSummary summary;
  late final WorkoutEntry legacyWorkout;
}
