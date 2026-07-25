import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';

class DataManagementException implements Exception {
  const DataManagementException(this.message);

  final String message;

  @override
  String toString() => message;
}

class DataExportFile {
  const DataExportFile({required this.filename, required this.bytes});

  final String filename;
  final List<int> bytes;

  String get text => utf8.decode(bytes);
}

/// Versioned, local-only data tools. Backups intentionally exclude all
/// credentials and outbox error strings; restore rebuilds safe durable queues.
class DataManagementService {
  DataManagementService({
    required AppDatabase database,
    DateTime Function()? clock,
  }) : _database = database,
       _clock = clock ?? DateTime.now;

  static const format = 'forgefit_backup';
  static const version = 1;

  static const _sections = <String>[
    'workouts',
    'workoutSets',
    'workoutSplits',
    'customExercises',
    'workoutTemplates',
    'templateExercises',
    'activeWorkoutSessions',
    'activeWorkoutExercises',
    'activeWorkoutSets',
    'completedWorkoutSessions',
    'completedWorkoutExercises',
    'completedWorkoutSets',
    'personalRecords',
    'personalRecordEvents',
  ];

  final AppDatabase _database;
  final DateTime Function() _clock;

  Future<DataExportFile> createJsonBackup(String userId) async {
    _requiredId(userId, 'user id');
    final data = await _readData(userId);
    final document = <String, Object?>{
      'format': format,
      'version': version,
      'exportedAt': _clock().toUtc().toIso8601String(),
      'data': data,
    };
    return DataExportFile(
      filename: _filename('forgefit_backup', 'json'),
      bytes: utf8.encode(const JsonEncoder.withIndent('  ').convert(document)),
    );
  }

  Future<void> restoreJsonBackup({
    required String userId,
    required String jsonText,
  }) async {
    _requiredId(userId, 'user id');
    final data = _parseAndValidate(jsonText, userId);
    _validateRowTypes(data);
    await _database.transaction(() async {
      await _clearUserData(userId);
      await _insertData(data);
      await _enqueueRestoredData(data, userId);
    });
  }

  Future<DataExportFile> createWorkoutCsv(String userId) async {
    _requiredId(userId, 'user id');
    final sessions =
        await (_database.select(_database.completedWorkoutSessions)..where(
              (row) => row.userId.equals(userId) & row.deletedAt.isNull(),
            ))
            .get();
    final exercises =
        await (_database.select(_database.completedWorkoutExercises)..where(
              (row) => row.userId.equals(userId) & row.deletedAt.isNull(),
            ))
            .get();
    final sets =
        await (_database.select(_database.completedWorkoutSets)..where(
              (row) => row.userId.equals(userId) & row.deletedAt.isNull(),
            ))
            .get();
    final templates = await (_database.select(
      _database.workoutTemplates,
    )..where((row) => row.userId.equals(userId))).get();
    final splits = await (_database.select(
      _database.workoutSplits,
    )..where((row) => row.userId.equals(userId))).get();

    final sessionsById = {for (final row in sessions) row.id: row};
    final exercisesById = {for (final row in exercises) row.id: row};
    final splitNames = {for (final row in splits) row.id: row.name};
    final templateSplitNames = {
      for (final row in templates)
        row.id: row.splitId == null
            ? 'No split'
            : splitNames[row.splitId!] ?? 'No split',
    };
    final rows = <List<Object?>>[
      const [
        'workout_id',
        'workout_date',
        'workout_name',
        'split_name',
        'exercise_id',
        'exercise_name',
        'exercise_source',
        'primary_muscle_group',
        'equipment',
        'set_number',
        'weight_kg',
        'reps',
        'set_completed',
        'workout_notes',
        'exercise_notes',
        'set_notes',
      ],
    ];
    final orderedSets =
        sets
            .where(
              (row) =>
                  sessionsById.containsKey(row.sessionId) &&
                  exercisesById.containsKey(row.sessionExerciseId),
            )
            .toList()
          ..sort((a, b) {
            final sessionOrder = sessionsById[a.sessionId]!.endedAt.compareTo(
              sessionsById[b.sessionId]!.endedAt,
            );
            if (sessionOrder != 0) return sessionOrder;
            final exerciseOrder = exercisesById[a.sessionExerciseId]!.sortOrder
                .compareTo(exercisesById[b.sessionExerciseId]!.sortOrder);
            return exerciseOrder != 0
                ? exerciseOrder
                : a.sortOrder.compareTo(b.sortOrder);
          });
    for (final set in orderedSets) {
      final workout = sessionsById[set.sessionId]!;
      final exercise = exercisesById[set.sessionExerciseId]!;
      rows.add([
        workout.id,
        DateFormat('yyyy-MM-dd').format(workout.endedAt.toLocal()),
        workout.name,
        workout.sourceTemplateId == null
            ? 'No split'
            : templateSplitNames[workout.sourceTemplateId!] ??
                  'Historical template',
        exercise.exerciseKey,
        exercise.exerciseName,
        exercise.exerciseSource,
        exercise.primaryMuscleGroup,
        exercise.equipment,
        set.sortOrder + 1,
        set.weightKg,
        set.repetitions,
        true,
        workout.notes,
        exercise.notes,
        set.notes,
      ]);
    }
    final csv = rows.map(_csvRow).join('\r\n');
    return DataExportFile(
      filename: _filename('forgefit_workouts', 'csv'),
      bytes: utf8.encode('$csv\r\n'),
    );
  }

  Future<Map<String, List<Map<String, dynamic>>>> _readData(
    String userId,
  ) async {
    Future<List<Map<String, dynamic>>> rows(Selectable<dynamic> query) async =>
        (await query.get())
            .map((row) => Map<String, dynamic>.from((row as dynamic).toJson()))
            .toList(growable: false);
    return {
      'workouts': await rows(
        _database.select(_database.workouts)
          ..where((row) => row.userId.equals(userId)),
      ),
      'workoutSets': await rows(
        _database.select(_database.workoutSets)
          ..where((row) => row.userId.equals(userId)),
      ),
      'workoutSplits': await rows(
        _database.select(_database.workoutSplits)
          ..where((row) => row.userId.equals(userId)),
      ),
      'customExercises': await rows(
        _database.select(_database.customExercises)
          ..where((row) => row.userId.equals(userId)),
      ),
      'workoutTemplates': await rows(
        _database.select(_database.workoutTemplates)
          ..where((row) => row.userId.equals(userId)),
      ),
      'templateExercises': await rows(
        _database.select(_database.templateExercises)
          ..where((row) => row.userId.equals(userId)),
      ),
      'activeWorkoutSessions': await rows(
        _database.select(_database.activeWorkoutSessions)
          ..where((row) => row.userId.equals(userId)),
      ),
      'activeWorkoutExercises': await rows(
        _database.select(_database.activeWorkoutExercises)
          ..where((row) => row.userId.equals(userId)),
      ),
      'activeWorkoutSets': await rows(
        _database.select(_database.activeWorkoutSets)
          ..where((row) => row.userId.equals(userId)),
      ),
      'completedWorkoutSessions': await rows(
        _database.select(_database.completedWorkoutSessions)
          ..where((row) => row.userId.equals(userId)),
      ),
      'completedWorkoutExercises': await rows(
        _database.select(_database.completedWorkoutExercises)
          ..where((row) => row.userId.equals(userId)),
      ),
      'completedWorkoutSets': await rows(
        _database.select(_database.completedWorkoutSets)
          ..where((row) => row.userId.equals(userId)),
      ),
      'personalRecords': await rows(
        _database.select(_database.personalRecords)
          ..where((row) => row.userId.equals(userId)),
      ),
      'personalRecordEvents': await rows(
        _database.select(_database.personalRecordEvents)
          ..where((row) => row.userId.equals(userId)),
      ),
    };
  }

  Map<String, List<Map<String, dynamic>>> _parseAndValidate(
    String jsonText,
    String userId,
  ) {
    Object? decoded;
    try {
      decoded = jsonDecode(jsonText);
    } on FormatException {
      throw const DataManagementException('This file is not valid JSON.');
    }
    if (decoded is! Map<String, dynamic> || decoded['format'] != format) {
      throw const DataManagementException(
        'This is not a ForgeFit backup file.',
      );
    }
    if (decoded['version'] is! int || decoded['version'] != version) {
      throw const DataManagementException(
        'This backup version is not supported.',
      );
    }
    if (decoded['exportedAt'] is! String ||
        DateTime.tryParse(decoded['exportedAt'] as String) == null) {
      throw const DataManagementException('The backup export date is invalid.');
    }
    final rawData = decoded['data'];
    if (rawData is! Map<String, dynamic>) {
      throw const DataManagementException(
        'The backup data section is missing.',
      );
    }
    final data = <String, List<Map<String, dynamic>>>{};
    for (final section in _sections) {
      final rawRows = rawData[section];
      if (rawRows is! List) {
        throw DataManagementException(
          'The $section section is missing or invalid.',
        );
      }
      data[section] = rawRows
          .map((row) {
            if (row is! Map) {
              throw DataManagementException(
                'The $section section contains an invalid record.',
              );
            }
            final map = Map<String, dynamic>.from(row);
            if (map['id'] is! String || (map['id'] as String).isEmpty) {
              throw DataManagementException(
                'The $section section contains a record without an ID.',
              );
            }
            if (map['userId'] != userId) {
              throw const DataManagementException(
                'A backup can only be restored to its original account.',
              );
            }
            return map;
          })
          .toList(growable: false);
      final ids = data[section]!.map((row) => row['id']).toSet();
      if (ids.length != data[section]!.length) {
        throw DataManagementException(
          'The $section section contains duplicate IDs.',
        );
      }
    }
    _validateReferences(data);
    return data;
  }

  void _validateRowTypes(Map<String, List<Map<String, dynamic>>> data) {
    try {
      for (final row in data['workouts']!) WorkoutRow.fromJson(row);
      for (final row in data['workoutSets']!) WorkoutSetRow.fromJson(row);
      for (final row in data['workoutSplits']!) WorkoutSplitRow.fromJson(row);
      for (final row in data['customExercises']!)
        CustomExerciseRow.fromJson(row);
      for (final row in data['workoutTemplates']!)
        WorkoutTemplateRow.fromJson(row);
      for (final row in data['templateExercises']!)
        TemplateExerciseRow.fromJson(row);
      for (final row in data['activeWorkoutSessions']!)
        ActiveWorkoutSessionRow.fromJson(row);
      for (final row in data['activeWorkoutExercises']!)
        ActiveWorkoutExerciseRow.fromJson(row);
      for (final row in data['activeWorkoutSets']!)
        ActiveWorkoutSetRow.fromJson(row);
      for (final row in data['completedWorkoutSessions']!)
        CompletedWorkoutSessionRow.fromJson(row);
      for (final row in data['completedWorkoutExercises']!)
        CompletedWorkoutExerciseRow.fromJson(row);
      for (final row in data['completedWorkoutSets']!)
        CompletedWorkoutSetRow.fromJson(row);
      for (final row in data['personalRecords']!)
        PersonalRecordRow.fromJson(row);
      for (final row in data['personalRecordEvents']!)
        PersonalRecordEventRow.fromJson(row);
    } on Object {
      throw const DataManagementException(
        'The backup contains an invalid field value.',
      );
    }
  }

  void _validateReferences(Map<String, List<Map<String, dynamic>>> data) {
    Set<Object?> ids(String section) =>
        data[section]!.map((row) => row['id']).toSet();
    void references(
      String section,
      String field,
      String target, {
      bool nullable = false,
    }) {
      final allowed = ids(target);
      for (final row in data[section]!) {
        final value = row[field];
        if (value == null && nullable) continue;
        if (value is! String || !allowed.contains(value)) {
          throw DataManagementException(
            'A $section record has an invalid $field reference.',
          );
        }
      }
    }

    references('workoutSets', 'workoutId', 'workouts');
    references('workoutTemplates', 'splitId', 'workoutSplits', nullable: true);
    references('templateExercises', 'templateId', 'workoutTemplates');
    references(
      'templateExercises',
      'customExerciseId',
      'customExercises',
      nullable: true,
    );
    references('activeWorkoutExercises', 'sessionId', 'activeWorkoutSessions');
    references('activeWorkoutSets', 'sessionId', 'activeWorkoutSessions');
    references(
      'activeWorkoutSets',
      'sessionExerciseId',
      'activeWorkoutExercises',
    );
    references(
      'completedWorkoutExercises',
      'sessionId',
      'completedWorkoutSessions',
    );
    references('completedWorkoutSets', 'sessionId', 'completedWorkoutSessions');
    references(
      'completedWorkoutSets',
      'sessionExerciseId',
      'completedWorkoutExercises',
    );
    references(
      'personalRecords',
      'completedSessionId',
      'completedWorkoutSessions',
    );
    references(
      'personalRecords',
      'completedExerciseId',
      'completedWorkoutExercises',
    );
    references(
      'personalRecords',
      'completedSetId',
      'completedWorkoutSets',
      nullable: true,
    );
    references('personalRecordEvents', 'personalRecordId', 'personalRecords');
    references(
      'personalRecordEvents',
      'completedSessionId',
      'completedWorkoutSessions',
    );
    references(
      'personalRecordEvents',
      'completedExerciseId',
      'completedWorkoutExercises',
    );
    references(
      'personalRecordEvents',
      'completedSetId',
      'completedWorkoutSets',
      nullable: true,
    );
  }

  Future<void> _clearUserData(String userId) async {
    await (_database.delete(
      _database.sessionSyncQueue,
    )..where((row) => row.userId.equals(userId))).go();
    await (_database.delete(
      _database.plannerSyncQueue,
    )..where((row) => row.userId.equals(userId))).go();
    await (_database.delete(
      _database.syncQueue,
    )..where((row) => row.userId.equals(userId))).go();
    await (_database.delete(
      _database.personalRecordEvents,
    )..where((row) => row.userId.equals(userId))).go();
    await (_database.delete(
      _database.personalRecords,
    )..where((row) => row.userId.equals(userId))).go();
    await (_database.delete(
      _database.completedWorkoutSets,
    )..where((row) => row.userId.equals(userId))).go();
    await (_database.delete(
      _database.completedWorkoutExercises,
    )..where((row) => row.userId.equals(userId))).go();
    await (_database.delete(
      _database.completedWorkoutSessions,
    )..where((row) => row.userId.equals(userId))).go();
    await (_database.delete(
      _database.activeWorkoutSets,
    )..where((row) => row.userId.equals(userId))).go();
    await (_database.delete(
      _database.activeWorkoutExercises,
    )..where((row) => row.userId.equals(userId))).go();
    await (_database.delete(
      _database.activeWorkoutSessions,
    )..where((row) => row.userId.equals(userId))).go();
    await (_database.delete(
      _database.templateExercises,
    )..where((row) => row.userId.equals(userId))).go();
    await (_database.delete(
      _database.workoutTemplates,
    )..where((row) => row.userId.equals(userId))).go();
    await (_database.delete(
      _database.customExercises,
    )..where((row) => row.userId.equals(userId))).go();
    await (_database.delete(
      _database.workoutSplits,
    )..where((row) => row.userId.equals(userId))).go();
    await (_database.delete(
      _database.workoutSets,
    )..where((row) => row.userId.equals(userId))).go();
    await (_database.delete(
      _database.workouts,
    )..where((row) => row.userId.equals(userId))).go();
  }

  Future<void> _insertData(Map<String, List<Map<String, dynamic>>> data) async {
    Future<void> insertAll(
      dynamic table,
      List<Map<String, dynamic>> rows,
      dynamic Function(Map<String, dynamic>) parse,
    ) async {
      for (final row in rows) {
        await _database.into(table).insertOnConflictUpdate(parse(row));
      }
    }

    await insertAll(
      _database.workoutSplits,
      data['workoutSplits']!,
      WorkoutSplitRow.fromJson,
    );
    await insertAll(
      _database.customExercises,
      data['customExercises']!,
      CustomExerciseRow.fromJson,
    );
    await insertAll(
      _database.workoutTemplates,
      data['workoutTemplates']!,
      WorkoutTemplateRow.fromJson,
    );
    await insertAll(
      _database.templateExercises,
      data['templateExercises']!,
      TemplateExerciseRow.fromJson,
    );
    await insertAll(_database.workouts, data['workouts']!, WorkoutRow.fromJson);
    await insertAll(
      _database.workoutSets,
      data['workoutSets']!,
      WorkoutSetRow.fromJson,
    );
    await insertAll(
      _database.activeWorkoutSessions,
      data['activeWorkoutSessions']!,
      ActiveWorkoutSessionRow.fromJson,
    );
    await insertAll(
      _database.activeWorkoutExercises,
      data['activeWorkoutExercises']!,
      ActiveWorkoutExerciseRow.fromJson,
    );
    await insertAll(
      _database.activeWorkoutSets,
      data['activeWorkoutSets']!,
      ActiveWorkoutSetRow.fromJson,
    );
    await insertAll(
      _database.completedWorkoutSessions,
      data['completedWorkoutSessions']!,
      CompletedWorkoutSessionRow.fromJson,
    );
    await insertAll(
      _database.completedWorkoutExercises,
      data['completedWorkoutExercises']!,
      CompletedWorkoutExerciseRow.fromJson,
    );
    await insertAll(
      _database.completedWorkoutSets,
      data['completedWorkoutSets']!,
      CompletedWorkoutSetRow.fromJson,
    );
    await insertAll(
      _database.personalRecords,
      data['personalRecords']!,
      PersonalRecordRow.fromJson,
    );
    await insertAll(
      _database.personalRecordEvents,
      data['personalRecordEvents']!,
      PersonalRecordEventRow.fromJson,
    );
  }

  Future<void> _enqueueRestoredData(
    Map<String, List<Map<String, dynamic>>> data,
    String userId,
  ) async {
    final now = _clock().toUtc();
    for (final workout in data['workouts']!) {
      await _database
          .into(_database.syncQueue)
          .insertOnConflictUpdate(
            SyncQueueRow(
              id: 'restore-workout-${workout['id']}',
              workoutId: workout['id'] as String,
              userId: userId,
              attemptCount: 0,
              lastError: null,
              lastAttemptAt: null,
              createdAt: now,
              updatedAt: now,
            ),
          );
    }
    await _enqueuePlanning(
      data['customExercises']!,
      'custom_exercise',
      userId,
      now,
    );
    await _enqueuePlanning(
      data['workoutSplits']!,
      'workout_split',
      userId,
      now,
    );
    await _enqueuePlanning(
      data['workoutTemplates']!,
      'workout_template',
      userId,
      now,
    );
    await _enqueuePlanning(
      data['templateExercises']!,
      'template_exercise',
      userId,
      now,
    );
    await _enqueueSessions(
      data['activeWorkoutSessions']!,
      'active_session',
      userId,
      now,
    );
    await _enqueueSessions(
      data['activeWorkoutExercises']!,
      'active_exercise',
      userId,
      now,
    );
    await _enqueueSessions(
      data['activeWorkoutSets']!,
      'active_set',
      userId,
      now,
    );
    await _enqueueSessions(
      data['completedWorkoutSessions']!,
      'completed_session',
      userId,
      now,
    );
    await _enqueueSessions(
      data['completedWorkoutExercises']!,
      'completed_exercise',
      userId,
      now,
    );
    await _enqueueSessions(
      data['completedWorkoutSets']!,
      'completed_set',
      userId,
      now,
    );
    await _enqueueSessions(
      data['personalRecords']!,
      'personal_record',
      userId,
      now,
    );
    await _enqueueSessions(
      data['personalRecordEvents']!,
      'personal_record_event',
      userId,
      now,
    );
  }

  Future<void> _enqueuePlanning(
    List<Map<String, dynamic>> rows,
    String type,
    String userId,
    DateTime now,
  ) async {
    for (final row in rows) {
      await _database
          .into(_database.plannerSyncQueue)
          .insertOnConflictUpdate(
            PlannerSyncQueueRow(
              id: 'restore-planning-$type-${row['id']}',
              userId: userId,
              entityType: type,
              entityId: row['id'] as String,
              entityVersion: row['version'] as int,
              attemptCount: 0,
              lastError: null,
              lastAttemptAt: null,
              createdAt: now,
              updatedAt: now,
            ),
          );
    }
  }

  Future<void> _enqueueSessions(
    List<Map<String, dynamic>> rows,
    String type,
    String userId,
    DateTime now,
  ) async {
    for (final row in rows) {
      await _database
          .into(_database.sessionSyncQueue)
          .insertOnConflictUpdate(
            SessionSyncQueueRow(
              id: 'restore-session-$type-${row['id']}',
              userId: userId,
              entityType: type,
              entityId: row['id'] as String,
              entityVersion: row['version'] as int,
              attemptCount: 0,
              lastError: null,
              lastAttemptAt: null,
              createdAt: now,
              updatedAt: now,
            ),
          );
    }
  }

  String _filename(String stem, String extension) =>
      '${stem}_${DateFormat('yyyyMMdd_HHmmss').format(_clock().toUtc())}.$extension';

  String _csvRow(List<Object?> values) => values.map(_csvCell).join(',');

  String _csvCell(Object? value) {
    if (value == null) return '';
    final text = value.toString();
    return text.contains(RegExp('[,\"\r\n]'))
        ? '"${text.replaceAll('"', '""')}"'
        : text;
  }

  void _requiredId(String value, String label) {
    if (value.trim().isEmpty)
      throw DataManagementException('A valid $label is required.');
  }
}
