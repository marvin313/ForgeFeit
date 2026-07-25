import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/app/providers.dart';
import 'package:forgefit/core/database/app_database.dart';
import 'package:forgefit/core/theme/forgefit_theme.dart';
import 'package:forgefit/features/planning/data/offline_first_planning_repository.dart';
import 'package:forgefit/features/planning/data/remote_planning_data_source.dart';
import 'package:forgefit/features/planning/domain/planning_models.dart';
import 'package:forgefit/features/planning/domain/system_exercise_catalog.dart';
import 'package:forgefit/features/planning/presentation/exercise_picker_screen.dart';
import 'package:forgefit/features/planning/presentation/start_workout_screen.dart';
import 'package:forgefit/features/planning/presentation/template_library_screen.dart';

const _userId = '10000000-0000-4000-8000-000000000001';

void main() {
  late AppDatabase database;
  late OfflineFirstPlanningRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = OfflineFirstPlanningRepository(
      database: database,
      remote: _EmptyPlanningRemote(),
    );
  });

  tearDown(() => database.close());

  testWidgets('template library renders permanent scopes and empty state', (
    tester,
  ) async {
    _useIphoneSize(tester);
    await tester.pumpWidget(
      _app(repository, const TemplateLibraryScreen(userId: _userId)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('open-planning-create-menu')), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('template-filter-all')),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('All Templates'), findsOneWidget);
    expect(find.text('No Split'), findsWidgets);
    await tester.scrollUntilVisible(
      find.byKey(const Key('templates-empty')),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Build your first template'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _disposeTestApp(tester);
  });

  testWidgets('Start Workout previews unrestricted configured exercises', (
    tester,
  ) async {
    _useIphoneSize(tester);
    final split = await repository.createSplit(
      userId: _userId,
      name: 'Push Pull Legs',
    );
    final template = await repository.createTemplate(
      userId: _userId,
      splitId: split.id,
      name: 'Anything day',
    );
    final entry = await repository.addExerciseToTemplate(
      userId: _userId,
      templateId: template.id,
      exercise: SystemExerciseCatalog.byKey('stationary_bike')!,
      configuration: const TemplateExerciseConfiguration(
        workingSets: 4,
        targetRepsMin: 12,
        targetRepsMax: 20,
        restSeconds: 60,
      ),
    );

    await tester.pumpWidget(
      _app(
        repository,
        const StartWorkoutScreen(userId: _userId, weightUnit: 'kg'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Anything day'));
    await tester.pumpAndSettle();

    expect(find.text('Stationary bike'), findsOneWidget);
    expect(find.textContaining('4 working sets'), findsOneWidget);
    expect(
      find.byKey(ValueKey('quick-log-exercise-${entry.id}')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
    await _disposeTestApp(tester);
  });

  testWidgets('exercise picker exposes favourite, recent, and custom views', (
    tester,
  ) async {
    _useIphoneSize(tester);
    final custom = await repository.createCustomExercise(
      userId: _userId,
      name: 'Private rotation',
      primaryMuscleGroup: MuscleGroup.core,
      equipment: ExerciseEquipment.cable,
      isFavourite: true,
    );
    final template = await repository.createTemplate(
      userId: _userId,
      name: 'No Split routine',
    );
    await repository.addExerciseToTemplate(
      userId: _userId,
      templateId: template.id,
      exercise: custom.selection,
    );

    await tester.pumpWidget(
      _app(repository, const ExercisePickerScreen(userId: _userId)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Ab wheel rollout'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Private rotation'),
      160,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Private rotation'), findsOneWidget);

    await tester.tap(find.text('Favourites'));
    await tester.pumpAndSettle();
    expect(find.text('Private rotation'), findsOneWidget);
    expect(find.text('Ab wheel rollout'), findsNothing);

    await tester.drag(
      find.byWidgetPredicate(
        (widget) =>
            widget is ListView && widget.scrollDirection == Axis.horizontal,
      ),
      const Offset(-90, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Recent'));
    await tester.pumpAndSettle();
    expect(find.text('Private rotation'), findsOneWidget);
    expect(
      tester
          .widget<ChoiceChip>(
            find.ancestor(
              of: find.text('Recent'),
              matching: find.byType(ChoiceChip),
            ),
          )
          .selected,
      isTrue,
    );
    expect(tester.takeException(), isNull);
    await _disposeTestApp(tester);
  });

  testWidgets('exercise picker selects multiple exercises in one visit', (
    tester,
  ) async {
    _useIphoneSize(tester);
    final custom = await repository.createCustomExercise(
      userId: _userId,
      name: 'Private rotation',
      primaryMuscleGroup: MuscleGroup.core,
      equipment: ExerciseEquipment.cable,
    );
    await tester.pumpWidget(
      _app(
        repository,
        const ExercisePickerScreen(userId: _userId, multiSelect: true),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ab wheel rollout'));
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text(custom.name),
      160,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text(custom.name));
    await tester.pump();

    expect(find.text('Add selected (2)'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await _disposeTestApp(tester);
  });
}

Widget _app(OfflineFirstPlanningRepository repository, Widget home) {
  return ProviderScope(
    overrides: [planningRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: buildForgeFitTheme(),
      home: Material(child: home),
    ),
  );
}

void _useIphoneSize(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(390, 844)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _disposeTestApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpAndSettle();
}

class _EmptyPlanningRemote implements RemotePlanningDataSource {
  @override
  Future<PlanningSnapshot> fetchSnapshot(String userId) async =>
      PlanningSnapshot.empty();

  @override
  Future<CustomExercise> upsertCustomExercise(CustomExercise exercise) async =>
      exercise;

  @override
  Future<TemplateExercise> upsertTemplateExercise(
    TemplateExercise exercise,
  ) async => exercise;

  @override
  Future<WorkoutSplit> upsertWorkoutSplit(WorkoutSplit split) async => split;

  @override
  Future<WorkoutTemplate> upsertWorkoutTemplate(
    WorkoutTemplate template,
  ) async => template;
}
