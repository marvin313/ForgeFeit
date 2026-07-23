import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/workout_entry.dart';

typedef RemoteWorkoutPageLoader =
    Future<List<Map<String, dynamic>>> Function({
      required String table,
      required String userId,
      required int offset,
      required int limit,
    });

abstract interface class RemoteWorkoutDataSource {
  Future<void> upsertWorkout(WorkoutEntry workout);

  Future<void> upsertWorkoutSet(WorkoutSetEntry workoutSet);

  Future<List<WorkoutEntry>> fetchWorkouts(String userId);
}

/// Maps the domain aggregate to the RLS-protected Supabase tables.
class SupabaseRemoteWorkoutDataSource implements RemoteWorkoutDataSource {
  SupabaseRemoteWorkoutDataSource(
    SupabaseClient client, {
    int restorationPageSize = 500,
    this.pageLoader,
  }) : assert(restorationPageSize > 0),
       _client = client,
       _restorationPageSize = restorationPageSize;

  final SupabaseClient _client;
  final int _restorationPageSize;
  final RemoteWorkoutPageLoader? pageLoader;

  @override
  Future<void> upsertWorkout(WorkoutEntry workout) async {
    await _client.from('workouts').upsert({
      'id': workout.id,
      'user_id': workout.userId,
      'exercise_name': workout.exerciseName,
      'performed_at': workout.performedAt.toUtc().toIso8601String(),
      'created_at': workout.createdAt.toUtc().toIso8601String(),
      'updated_at': workout.updatedAt.toUtc().toIso8601String(),
    }, onConflict: 'id');
  }

  @override
  Future<void> upsertWorkoutSet(WorkoutSetEntry workoutSet) async {
    await _client.from('workout_sets').upsert({
      'id': workoutSet.id,
      'workout_id': workoutSet.workoutId,
      'user_id': workoutSet.userId,
      'weight': workoutSet.weight,
      'reps': workoutSet.reps,
      'set_order': workoutSet.setOrder,
      'created_at': workoutSet.createdAt.toUtc().toIso8601String(),
      'updated_at': workoutSet.updatedAt.toUtc().toIso8601String(),
    }, onConflict: 'id');
  }

  @override
  Future<List<WorkoutEntry>> fetchWorkouts(String userId) async {
    final workoutRows = await _fetchAllOwnedRows('workouts', userId);
    final setRows = await _fetchAllOwnedRows('workout_sets', userId);

    final setsByWorkout = <String, List<WorkoutSetEntry>>{};
    for (final row in setRows) {
      final workoutId = _requiredString(row, 'workout_id');
      final set = WorkoutSetEntry(
        id: _requiredString(row, 'id'),
        workoutId: workoutId,
        userId: _requiredString(row, 'user_id'),
        weight: _requiredNumber(row, 'weight').toDouble(),
        reps: _requiredNumber(row, 'reps').toInt(),
        setOrder: _requiredNumber(row, 'set_order').toInt(),
        createdAt: _requiredDateTime(row, 'created_at'),
        updatedAt: _requiredDateTime(row, 'updated_at'),
      );
      setsByWorkout.putIfAbsent(workoutId, () => []).add(set);
    }

    for (final sets in setsByWorkout.values) {
      sets.sort((left, right) {
        final byOrder = left.setOrder.compareTo(right.setOrder);
        return byOrder != 0 ? byOrder : left.id.compareTo(right.id);
      });
    }

    final workouts = workoutRows.map((row) {
      final workoutId = _requiredString(row, 'id');
      return WorkoutEntry(
        id: workoutId,
        userId: _requiredString(row, 'user_id'),
        exerciseName: _requiredString(row, 'exercise_name'),
        performedAt: _requiredDateTime(row, 'performed_at'),
        createdAt: _requiredDateTime(row, 'created_at'),
        updatedAt: _requiredDateTime(row, 'updated_at'),
        sets: List.unmodifiable(setsByWorkout[workoutId] ?? const []),
      );
    }).toList();
    workouts.sort((left, right) {
      final byDate = right.performedAt.compareTo(left.performedAt);
      return byDate != 0 ? byDate : left.id.compareTo(right.id);
    });
    return workouts;
  }

  /// Downloads every owner-scoped row without relying on PostgREST's maximum
  /// response size. Ordering by the immutable UUID makes offset pages stable
  /// and deterministic for legacy restore.
  Future<List<Map<String, dynamic>>> _fetchAllOwnedRows(
    String table,
    String userId,
  ) async {
    return fetchAllRemoteWorkoutPages(
      pageSize: _restorationPageSize,
      loadPage: (offset, limit) {
        final injectedLoader = pageLoader;
        if (injectedLoader != null) {
          return injectedLoader(
            table: table,
            userId: userId,
            offset: offset,
            limit: limit,
          );
        }
        return _client
            .from(table)
            .select()
            .eq('user_id', userId)
            .order('id')
            .range(offset, offset + limit - 1);
      },
    );
  }
}

typedef RemoteWorkoutPageFetcher =
    Future<List<Map<String, dynamic>>> Function(int offset, int limit);

/// Collects deterministic pages until the server returns a short or empty
/// page. Kept separate from Supabase so boundary behaviour is unit-testable.
Future<List<Map<String, dynamic>>> fetchAllRemoteWorkoutPages({
  required RemoteWorkoutPageFetcher loadPage,
  int pageSize = 500,
}) async {
  if (pageSize <= 0) {
    throw ArgumentError.value(pageSize, 'pageSize', 'Must be greater than 0.');
  }

  final rows = <Map<String, dynamic>>[];
  var offset = 0;
  while (true) {
    final page = await loadPage(offset, pageSize);
    rows.addAll(page);
    if (page.length < pageSize) {
      return rows;
    }
    offset += pageSize;
  }
}

String _requiredString(Map<String, dynamic> row, String field) {
  final value = row[field];
  if (value is String && value.isNotEmpty) {
    return value;
  }
  throw FormatException('Supabase returned an invalid $field value.');
}

num _requiredNumber(Map<String, dynamic> row, String field) {
  final value = row[field];
  if (value is num) {
    return value;
  }
  if (value is String) {
    final parsed = num.tryParse(value);
    if (parsed != null) {
      return parsed;
    }
  }
  throw FormatException('Supabase returned an invalid $field value.');
}

DateTime _requiredDateTime(Map<String, dynamic> row, String field) {
  final value = row[field];
  if (value is DateTime) {
    return value;
  }
  if (value is String) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) {
      return parsed;
    }
  }
  throw FormatException('Supabase returned an invalid $field value.');
}
