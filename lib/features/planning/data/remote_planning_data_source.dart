import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/planning_models.dart';

abstract interface class RemotePlanningDataSource {
  Future<WorkoutSplit> upsertWorkoutSplit(WorkoutSplit split);

  Future<WorkoutTemplate> upsertWorkoutTemplate(WorkoutTemplate template);

  Future<CustomExercise> upsertCustomExercise(CustomExercise exercise);

  Future<TemplateExercise> upsertTemplateExercise(TemplateExercise exercise);

  /// Returns a complete user-owned snapshot, including soft-deleted records.
  Future<PlanningSnapshot> fetchSnapshot(String userId);
}

/// Maps Stage 2 domain records to the RLS-protected Supabase tables.
class SupabaseRemotePlanningDataSource implements RemotePlanningDataSource {
  SupabaseRemotePlanningDataSource(SupabaseClient client) : _client = client;

  final SupabaseClient _client;

  @override
  Future<WorkoutSplit> upsertWorkoutSplit(WorkoutSplit split) async {
    final rows = await _client.from('workout_splits').upsert({
      'id': split.id,
      'user_id': split.userId,
      'name': split.name,
      'description': split.description,
      'icon': split.icon,
      'color_value': split.colorValue,
      'sort_order': split.sortOrder,
      'created_at': _timestamp(split.createdAt),
      'updated_at': _timestamp(split.updatedAt),
      'deleted_at': _optionalTimestamp(split.deletedAt),
      'version': split.version,
    }, onConflict: 'id').select();
    if (rows.isNotEmpty) return _splitFromMap(rows.single);
    return _fetchWinner(
      table: 'workout_splits',
      id: split.id,
      userId: split.userId,
      decode: _splitFromMap,
    );
  }

  @override
  Future<WorkoutTemplate> upsertWorkoutTemplate(
    WorkoutTemplate template,
  ) async {
    final rows = await _client.from('workout_templates').upsert({
      'id': template.id,
      'user_id': template.userId,
      'split_id': template.splitId,
      'name': template.name,
      'icon': template.icon,
      'color_value': template.colorValue,
      'notes': template.notes,
      'sort_order': template.sortOrder,
      'created_at': _timestamp(template.createdAt),
      'updated_at': _timestamp(template.updatedAt),
      'deleted_at': _optionalTimestamp(template.deletedAt),
      'version': template.version,
    }, onConflict: 'id').select();
    if (rows.isNotEmpty) return _templateFromMap(rows.single);
    return _fetchWinner(
      table: 'workout_templates',
      id: template.id,
      userId: template.userId,
      decode: _templateFromMap,
    );
  }

  @override
  Future<CustomExercise> upsertCustomExercise(CustomExercise exercise) async {
    final rows = await _client.from('custom_exercises').upsert({
      'id': exercise.id,
      'user_id': exercise.userId,
      'name': exercise.name,
      'primary_muscle_group': exercise.primaryMuscleGroup.wireValue,
      'secondary_muscle_groups': [
        for (final group in exercise.secondaryMuscleGroups) group.wireValue,
      ],
      'equipment': exercise.equipment.wireValue,
      'aliases': exercise.aliases,
      'search_keywords': exercise.keywords,
      'instructions': exercise.instructions,
      'personal_notes': exercise.personalNotes,
      'is_favourite': exercise.isFavourite,
      'last_used_at': _optionalTimestamp(exercise.lastUsedAt),
      'created_at': _timestamp(exercise.createdAt),
      'updated_at': _timestamp(exercise.updatedAt),
      'deleted_at': _optionalTimestamp(exercise.deletedAt),
      'version': exercise.version,
    }, onConflict: 'id').select();
    if (rows.isNotEmpty) return _customExerciseFromMap(rows.single);
    return _fetchWinner(
      table: 'custom_exercises',
      id: exercise.id,
      userId: exercise.userId,
      decode: _customExerciseFromMap,
    );
  }

  @override
  Future<TemplateExercise> upsertTemplateExercise(
    TemplateExercise exercise,
  ) async {
    final rows = await _client.from('template_exercises').upsert({
      'id': exercise.id,
      'user_id': exercise.userId,
      'template_id': exercise.templateId,
      'custom_exercise_id': exercise.customExerciseId,
      'system_exercise_key': exercise.systemExerciseKey,
      'exercise_source': exercise.source.name,
      'exercise_name': exercise.exerciseName,
      'primary_muscle_group': exercise.primaryMuscleGroup.wireValue,
      'equipment': exercise.equipment.wireValue,
      'working_sets': exercise.workingSets,
      'warm_up_sets': exercise.warmupSets,
      'min_target_reps': exercise.targetRepsMin,
      'max_target_reps': exercise.targetRepsMax,
      'target_weight': exercise.targetWeight,
      'rest_seconds': exercise.restSeconds,
      'rpe_target': exercise.rpeTarget,
      'rir_target': exercise.rirTarget,
      'notes': exercise.notes,
      'sort_order': exercise.sortOrder,
      'created_at': _timestamp(exercise.createdAt),
      'updated_at': _timestamp(exercise.updatedAt),
      'deleted_at': _optionalTimestamp(exercise.deletedAt),
      'version': exercise.version,
    }, onConflict: 'id').select();
    if (rows.isNotEmpty) return _templateExerciseFromMap(rows.single);
    return _fetchWinner(
      table: 'template_exercises',
      id: exercise.id,
      userId: exercise.userId,
      decode: _templateExerciseFromMap,
    );
  }

  @override
  Future<PlanningSnapshot> fetchSnapshot(String userId) async {
    final splitRows = await _fetchAllOwned('workout_splits', userId);
    final customExerciseRows = await _fetchAllOwned('custom_exercises', userId);
    final templateRows = await _fetchAllOwned('workout_templates', userId);
    final templateExerciseRows = await _fetchAllOwned(
      'template_exercises',
      userId,
    );

    return PlanningSnapshot(
      splits: splitRows.map(_splitFromMap),
      customExercises: customExerciseRows.map(_customExerciseFromMap),
      templates: templateRows.map(_templateFromMap),
      templateExercises: templateExerciseRows.map(_templateExerciseFromMap),
    );
  }

  /// PostgREST projects enforce a maximum response size. Fetching stable ID
  /// pages makes restore complete even for users with large template libraries.
  Future<List<Map<String, dynamic>>> _fetchAllOwned(
    String table,
    String userId,
  ) async {
    const pageSize = 500;
    final rows = <Map<String, dynamic>>[];
    var offset = 0;
    while (true) {
      final page = await _client
          .from(table)
          .select()
          .eq('user_id', userId)
          .order('id')
          .range(offset, offset + pageSize - 1);
      rows.addAll(page);
      if (page.length < pageSize) {
        return rows;
      }
      offset += pageSize;
    }
  }

  Future<T> _fetchWinner<T>({
    required String table,
    required String id,
    required String userId,
    required T Function(Map<String, dynamic>) decode,
  }) async {
    final row = await _client
        .from(table)
        .select()
        .eq('id', id)
        .eq('user_id', userId)
        .maybeSingle();
    if (row == null) {
      throw StateError(
        'Supabase did not return the accepted $table record for this user.',
      );
    }
    return decode(row);
  }
}

WorkoutSplit _splitFromMap(Map<String, dynamic> row) {
  return WorkoutSplit(
    id: _requiredString(row, 'id'),
    userId: _requiredString(row, 'user_id'),
    name: _requiredString(row, 'name'),
    description: _optionalString(row, 'description'),
    icon: _requiredString(row, 'icon'),
    colorValue: _requiredInt(row, 'color_value'),
    sortOrder: _requiredInt(row, 'sort_order'),
    createdAt: _requiredDateTime(row, 'created_at'),
    updatedAt: _requiredDateTime(row, 'updated_at'),
    deletedAt: _optionalDateTime(row, 'deleted_at'),
    version: _requiredInt(row, 'version'),
  );
}

WorkoutTemplate _templateFromMap(Map<String, dynamic> row) {
  return WorkoutTemplate(
    id: _requiredString(row, 'id'),
    userId: _requiredString(row, 'user_id'),
    splitId: _optionalString(row, 'split_id'),
    name: _requiredString(row, 'name'),
    icon: _requiredString(row, 'icon'),
    colorValue: _requiredInt(row, 'color_value'),
    notes: _optionalString(row, 'notes'),
    sortOrder: _requiredInt(row, 'sort_order'),
    createdAt: _requiredDateTime(row, 'created_at'),
    updatedAt: _requiredDateTime(row, 'updated_at'),
    deletedAt: _optionalDateTime(row, 'deleted_at'),
    version: _requiredInt(row, 'version'),
  );
}

CustomExercise _customExerciseFromMap(Map<String, dynamic> row) {
  return CustomExercise(
    id: _requiredString(row, 'id'),
    userId: _requiredString(row, 'user_id'),
    name: _requiredString(row, 'name'),
    primaryMuscleGroup: muscleGroupFromWire(
      _requiredString(row, 'primary_muscle_group'),
    ),
    secondaryMuscleGroups: _stringList(
      row,
      'secondary_muscle_groups',
    ).map(muscleGroupFromWire),
    equipment: exerciseEquipmentFromWire(_requiredString(row, 'equipment')),
    aliases: _optionalStringList(row, 'aliases'),
    keywords: _optionalStringList(row, 'search_keywords'),
    instructions: _optionalString(row, 'instructions'),
    personalNotes: _optionalString(row, 'personal_notes'),
    isFavourite: _requiredBool(row, 'is_favourite'),
    lastUsedAt: _optionalDateTime(row, 'last_used_at'),
    createdAt: _requiredDateTime(row, 'created_at'),
    updatedAt: _requiredDateTime(row, 'updated_at'),
    deletedAt: _optionalDateTime(row, 'deleted_at'),
    version: _requiredInt(row, 'version'),
  );
}

TemplateExercise _templateExerciseFromMap(Map<String, dynamic> row) {
  return TemplateExercise(
    id: _requiredString(row, 'id'),
    userId: _requiredString(row, 'user_id'),
    templateId: _requiredString(row, 'template_id'),
    customExerciseId: _optionalString(row, 'custom_exercise_id'),
    systemExerciseKey: _optionalString(row, 'system_exercise_key'),
    exerciseName: _requiredString(row, 'exercise_name'),
    primaryMuscleGroup: muscleGroupFromWire(
      _requiredString(row, 'primary_muscle_group'),
    ),
    equipment: exerciseEquipmentFromWire(_requiredString(row, 'equipment')),
    workingSets: _requiredInt(row, 'working_sets'),
    warmupSets: _requiredInt(row, 'warm_up_sets'),
    targetRepsMin: _requiredInt(row, 'min_target_reps'),
    targetRepsMax: _requiredInt(row, 'max_target_reps'),
    targetWeight: _optionalDouble(row, 'target_weight'),
    restSeconds: _requiredInt(row, 'rest_seconds'),
    rpeTarget: _optionalDouble(row, 'rpe_target'),
    rirTarget: _optionalDouble(row, 'rir_target'),
    notes: _optionalString(row, 'notes'),
    sortOrder: _requiredInt(row, 'sort_order'),
    createdAt: _requiredDateTime(row, 'created_at'),
    updatedAt: _requiredDateTime(row, 'updated_at'),
    deletedAt: _optionalDateTime(row, 'deleted_at'),
    version: _requiredInt(row, 'version'),
  );
}

String _timestamp(DateTime value) => value.toUtc().toIso8601String();

String? _optionalTimestamp(DateTime? value) =>
    value == null ? null : _timestamp(value);

String _requiredString(Map<String, dynamic> row, String field) {
  final value = row[field];
  if (value is String && value.trim().isNotEmpty) {
    return value;
  }
  throw FormatException('Supabase returned an invalid $field value.');
}

String? _optionalString(Map<String, dynamic> row, String field) {
  final value = row[field];
  if (value == null) {
    return null;
  }
  if (value is String) {
    return value;
  }
  throw FormatException('Supabase returned an invalid $field value.');
}

int _requiredInt(Map<String, dynamic> row, String field) {
  final value = row[field];
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    final parsed = int.tryParse(value);
    if (parsed != null) {
      return parsed;
    }
  }
  throw FormatException('Supabase returned an invalid $field value.');
}

double? _optionalDouble(Map<String, dynamic> row, String field) {
  final value = row[field];
  if (value == null) {
    return null;
  }
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    final parsed = double.tryParse(value);
    if (parsed != null) {
      return parsed;
    }
  }
  throw FormatException('Supabase returned an invalid $field value.');
}

bool _requiredBool(Map<String, dynamic> row, String field) {
  final value = row[field];
  if (value is bool) {
    return value;
  }
  throw FormatException('Supabase returned an invalid $field value.');
}

DateTime _requiredDateTime(Map<String, dynamic> row, String field) {
  final parsed = _optionalDateTime(row, field);
  if (parsed != null) {
    return parsed;
  }
  throw FormatException('Supabase returned an invalid $field value.');
}

DateTime? _optionalDateTime(Map<String, dynamic> row, String field) {
  final value = row[field];
  if (value == null) {
    return null;
  }
  if (value is DateTime) {
    return value.toUtc();
  }
  if (value is String) {
    return DateTime.tryParse(value)?.toUtc();
  }
  throw FormatException('Supabase returned an invalid $field value.');
}

List<String> _stringList(Map<String, dynamic> row, String field) {
  final value = row[field];
  if (value is List) {
    return value
        .map((entry) {
          if (entry is String) {
            return entry;
          }
          throw FormatException('Supabase returned an invalid $field value.');
        })
        .toList(growable: false);
  }
  if (value is String) {
    final decoded = jsonDecode(value);
    if (decoded is List) {
      return decoded
          .map((entry) {
            if (entry is String) {
              return entry;
            }
            throw FormatException('Supabase returned an invalid $field value.');
          })
          .toList(growable: false);
    }
  }
  throw FormatException('Supabase returned an invalid $field value.');
}

List<String> _optionalStringList(Map<String, dynamic> row, String field) {
  if (row[field] == null) return const [];
  return _stringList(row, field);
}
