import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('WorkoutRow')
class Workouts extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get exerciseName => text().withLength(min: 1, max: 120)();
  DateTimeColumn get performedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WorkoutSetRow')
class WorkoutSets extends Table {
  TextColumn get id => text()();
  TextColumn get workoutId =>
      text().references(Workouts, #id, onDelete: KeyAction.cascade)();
  TextColumn get userId => text()();
  RealColumn get weight => real()();
  IntColumn get reps => integer()();
  IntColumn get setOrder => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {workoutId, setOrder},
  ];
}

/// A durable outbox. There can be exactly one pending upsert per workout.
@DataClassName('SyncQueueRow')
class SyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get workoutId =>
      text().references(Workouts, #id, onDelete: KeyAction.cascade)();
  TextColumn get userId => text()();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {workoutId},
  ];
}

@DataClassName('WorkoutSplitRow')
class WorkoutSplits extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
  TextColumn get icon => text().withLength(min: 1, max: 32)();
  IntColumn get colorValue => integer()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CustomExerciseRow')
class CustomExercises extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get primaryMuscleGroup => text()();
  TextColumn get secondaryMuscleGroupsJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get equipment => text()();
  TextColumn get instructions => text().nullable()();
  TextColumn get personalNotes => text().nullable()();
  TextColumn get aliasesJson => text().withDefault(const Constant('[]'))();
  TextColumn get searchKeywordsJson =>
      text().withDefault(const Constant('[]'))();
  BoolColumn get isFavourite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastUsedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WorkoutTemplateRow')
class WorkoutTemplates extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get splitId => text().nullable().references(
    WorkoutSplits,
    #id,
    onDelete: KeyAction.noAction,
  )();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get icon => text().withLength(min: 1, max: 32)();
  IntColumn get colorValue => integer()();
  TextColumn get notes => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TemplateExerciseRow')
class TemplateExercises extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get templateId =>
      text().references(WorkoutTemplates, #id, onDelete: KeyAction.cascade)();
  TextColumn get customExerciseId => text().nullable().references(
    CustomExercises,
    #id,
    onDelete: KeyAction.noAction,
  )();
  TextColumn get systemExerciseKey => text().nullable()();
  TextColumn get exerciseName => text().withLength(min: 1, max: 120)();
  TextColumn get primaryMuscleGroup => text()();
  TextColumn get equipment => text()();
  IntColumn get workingSets => integer().withDefault(const Constant(3))();
  IntColumn get warmupSets => integer().withDefault(const Constant(0))();
  IntColumn get targetRepsMin => integer().withDefault(const Constant(8))();
  IntColumn get targetRepsMax => integer().withDefault(const Constant(12))();
  RealColumn get targetWeight => real().nullable()();
  IntColumn get restSeconds => integer().withDefault(const Constant(90))();
  RealColumn get rpeTarget => real().nullable()();
  RealColumn get rirTarget => real().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => const [
    'CHECK ((custom_exercise_id IS NOT NULL) != '
        '(system_exercise_key IS NOT NULL))',
  ];
}

/// A coalescing, version-aware durable outbox for mutable Stage 2 records.
///
/// It intentionally has no foreign key to an entity table: a soft-deletion
/// tombstone must remain uploadable even when related records are removed.
@DataClassName('PlannerSyncQueueRow')
class PlannerSyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  IntColumn get entityVersion => integer()();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, entityType, entityId},
  ];
}

@DataClassName('ActiveWorkoutSessionRow')
class ActiveWorkoutSessions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get sourceTemplateId => text().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  TextColumn get notes => text().nullable()();
  TextColumn get weightUnit => text().withDefault(const Constant('kg'))();
  TextColumn get restTimerState => text().withDefault(const Constant('idle'))();
  IntColumn get restTimerDurationSeconds =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get restTimerTargetEndAt => dateTime().nullable()();
  IntColumn get restTimerRemainingSeconds =>
      integer().withDefault(const Constant(0))();
  BoolColumn get autoStartRestTimer =>
      boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ActiveWorkoutExerciseRow')
class ActiveWorkoutExercises extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get sessionId => text().references(
    ActiveWorkoutSessions,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get exerciseSource => text()();
  TextColumn get exerciseKey => text()();
  TextColumn get systemExerciseKey => text().nullable()();
  TextColumn get customExerciseId => text().nullable()();
  TextColumn get exerciseName => text().withLength(min: 1, max: 120)();
  TextColumn get primaryMuscleGroup => text()();
  TextColumn get secondaryMuscleGroupsJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get equipment => text()();
  TextColumn get trackingType => text()();
  BoolColumn get weightRelevant => boolean()();
  BoolColumn get repetitionsRelevant => boolean()();
  BoolColumn get distanceRelevant => boolean()();
  BoolColumn get durationRelevant => boolean()();
  BoolColumn get bodyweightRelevant => boolean()();
  IntColumn get plannedWorkingSets => integer()();
  IntColumn get plannedWarmupSets => integer()();
  IntColumn get minTargetReps => integer()();
  IntColumn get maxTargetReps => integer()();
  RealColumn get targetWeightKg => real().nullable()();
  IntColumn get restSeconds => integer()();
  RealColumn get rpeTarget => real().nullable()();
  RealColumn get rirTarget => real().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ActiveWorkoutSetRow')
class ActiveWorkoutSets extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get sessionId => text().references(
    ActiveWorkoutSessions,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get sessionExerciseId => text().references(
    ActiveWorkoutExercises,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get setType => text()();
  RealColumn get weightKg => real().nullable()();
  IntColumn get repetitions => integer().nullable()();
  IntColumn get durationSeconds => integer().nullable()();
  RealColumn get distanceMeters => real().nullable()();
  RealColumn get rpe => real().nullable()();
  RealColumn get rir => real().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CompletedWorkoutSessionRow')
class CompletedWorkoutSessions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get sourceActiveSessionId => text().nullable()();
  TextColumn get sourceTemplateId => text().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get notes => text().nullable()();
  TextColumn get weightUnit => text().withDefault(const Constant('kg'))();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();
  IntColumn get durationSeconds => integer()();
  IntColumn get exerciseCount => integer()();
  IntColumn get workingSetCount => integer()();
  IntColumn get totalCompletedSets => integer()();
  IntColumn get totalRepetitions => integer()();
  RealColumn get totalVolumeKg => real()();
  IntColumn get personalRecordCount =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CompletedWorkoutExerciseRow')
class CompletedWorkoutExercises extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get sessionId => text().references(
    CompletedWorkoutSessions,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get sourceActiveExerciseId => text().nullable()();
  TextColumn get exerciseSource => text()();
  TextColumn get exerciseKey => text()();
  TextColumn get systemExerciseKey => text().nullable()();
  TextColumn get customExerciseId => text().nullable()();
  TextColumn get exerciseName => text().withLength(min: 1, max: 120)();
  TextColumn get primaryMuscleGroup => text()();
  TextColumn get secondaryMuscleGroupsJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get equipment => text()();
  TextColumn get trackingType => text()();
  BoolColumn get weightRelevant => boolean()();
  BoolColumn get repetitionsRelevant => boolean()();
  BoolColumn get distanceRelevant => boolean()();
  BoolColumn get durationRelevant => boolean()();
  BoolColumn get bodyweightRelevant => boolean()();
  TextColumn get notes => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get completedSetCount => integer()();
  IntColumn get workingSetCount => integer()();
  IntColumn get totalRepetitions => integer()();
  RealColumn get totalVolumeKg => real()();
  RealColumn get bestWeightKg => real().nullable()();
  RealColumn get bestEstimatedOneRepMaxKg => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CompletedWorkoutSetRow')
class CompletedWorkoutSets extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get sessionId => text().references(
    CompletedWorkoutSessions,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get sessionExerciseId => text().references(
    CompletedWorkoutExercises,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get sourceActiveSetId => text().nullable()();
  TextColumn get setType => text()();
  RealColumn get weightKg => real().nullable()();
  IntColumn get repetitions => integer().nullable()();
  IntColumn get durationSeconds => integer().nullable()();
  RealColumn get distanceMeters => real().nullable()();
  RealColumn get rpe => real().nullable()();
  RealColumn get rir => real().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  RealColumn get setVolumeKg => real()();
  RealColumn get estimatedOneRepMaxKg => real().nullable()();
  BoolColumn get isPersonalRecord =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PersonalRecordRow')
class PersonalRecords extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get exerciseSource => text()();
  TextColumn get exerciseKey => text()();
  TextColumn get systemExerciseKey => text().nullable()();
  TextColumn get customExerciseId => text().nullable()();
  TextColumn get exerciseName => text().withLength(min: 1, max: 120)();
  TextColumn get recordKind => text()();
  TextColumn get recordScope => text().withDefault(const Constant('overall'))();
  RealColumn get recordValue => real()();
  RealColumn get weightKg => real().nullable()();
  IntColumn get repetitions => integer().nullable()();
  RealColumn get estimatedOneRepMaxKg => real().nullable()();
  TextColumn get completedSessionId => text()();
  TextColumn get completedExerciseId => text()();
  TextColumn get completedSetId => text().nullable()();
  DateTimeColumn get achievedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, exerciseKey, recordKind, recordScope},
  ];
}

@DataClassName('PersonalRecordEventRow')
class PersonalRecordEvents extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get personalRecordId => text()();
  TextColumn get eventKey => text()();
  TextColumn get exerciseSource => text()();
  TextColumn get exerciseKey => text()();
  TextColumn get exerciseName => text().withLength(min: 1, max: 120)();
  TextColumn get recordKind => text()();
  TextColumn get recordScope => text().withDefault(const Constant('overall'))();
  RealColumn get previousRecordValue => real().nullable()();
  RealColumn get recordValue => real()();
  RealColumn get weightKg => real().nullable()();
  IntColumn get repetitions => integer().nullable()();
  RealColumn get estimatedOneRepMaxKg => real().nullable()();
  TextColumn get completedSessionId => text()();
  TextColumn get completedExerciseId => text()();
  TextColumn get completedSetId => text().nullable()();
  DateTimeColumn get achievedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {eventKey},
  ];
}

@DataClassName('SessionSyncQueueRow')
class SessionSyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  IntColumn get entityVersion => integer()();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, entityType, entityId},
  ];
}

@DriftDatabase(
  tables: [
    Workouts,
    WorkoutSets,
    SyncQueue,
    WorkoutSplits,
    CustomExercises,
    WorkoutTemplates,
    TemplateExercises,
    PlannerSyncQueue,
    ActiveWorkoutSessions,
    ActiveWorkoutExercises,
    ActiveWorkoutSets,
    CompletedWorkoutSessions,
    CompletedWorkoutExercises,
    CompletedWorkoutSets,
    PersonalRecords,
    PersonalRecordEvents,
    SessionSyncQueue,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      // Schema upgrades are additive. Existing workout history and its
      // Stage 1 durable outbox are never recreated or cleared.
      if (from < 1) {
        await migrator.createAll();
        return;
      }
      if (from < 2) {
        await migrator.createTable(workoutSplits);
        await migrator.createTable(customExercises);
        await migrator.createTable(workoutTemplates);
        await migrator.createTable(templateExercises);
        await migrator.createTable(plannerSyncQueue);
      }
      if (from < 3) {
        // A direct v1 -> v3 upgrade creates CustomExercises from the current
        // definition above, so only an existing v2 table needs new columns.
        if (from >= 2) {
          await migrator.addColumn(
            customExercises,
            customExercises.aliasesJson,
          );
          await migrator.addColumn(
            customExercises,
            customExercises.searchKeywordsJson,
          );
        }
        await migrator.createTable(activeWorkoutSessions);
        await migrator.createTable(activeWorkoutExercises);
        await migrator.createTable(activeWorkoutSets);
        await migrator.createTable(completedWorkoutSessions);
        await migrator.createTable(completedWorkoutExercises);
        await migrator.createTable(completedWorkoutSets);
        await migrator.createTable(personalRecords);
        await migrator.createTable(personalRecordEvents);
        await migrator.createTable(sessionSyncQueue);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final file = File(p.join(documentsDirectory.path, 'forgefit.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
