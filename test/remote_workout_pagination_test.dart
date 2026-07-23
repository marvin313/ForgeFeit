import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/features/workouts/data/remote_workout_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _userId = '10000000-0000-4000-8000-000000000001';

void main() {
  test('legacy restore paginates every workout and workout set', () async {
    const pageSize = 500;
    const workoutCount = 503;
    const setsPerWorkout = 2;
    final timestamp = DateTime.utc(2026, 7, 22, 10);
    final workouts = List.generate(workoutCount, (index) {
      final id = _uuid('2', index);
      return <String, dynamic>{
        'id': id,
        'user_id': _userId,
        'exercise_name': 'Legacy exercise $index',
        'performed_at': timestamp
            .subtract(Duration(minutes: index))
            .toIso8601String(),
        'created_at': timestamp.toIso8601String(),
        'updated_at': timestamp.toIso8601String(),
      };
    });
    final sets = <Map<String, dynamic>>[
      for (var workoutIndex = 0; workoutIndex < workoutCount; workoutIndex++)
        for (var setIndex = 0; setIndex < setsPerWorkout; setIndex++)
          <String, dynamic>{
            'id': _uuid('3', workoutIndex * setsPerWorkout + setIndex),
            'workout_id': _uuid('2', workoutIndex),
            'user_id': _userId,
            'weight': 50.0 + setIndex,
            'reps': 8 + setIndex,
            'set_order': setIndex,
            'created_at': timestamp.toIso8601String(),
            'updated_at': timestamp.toIso8601String(),
          },
    ];
    final requests = <({String table, int offset, int limit})>[];
    final client = SupabaseClient(
      'https://example.supabase.co',
      'publishable-test-key',
    );
    addTearDown(client.dispose);
    final remote = SupabaseRemoteWorkoutDataSource(
      client,
      restorationPageSize: pageSize,
      pageLoader:
          ({
            required table,
            required userId,
            required offset,
            required limit,
          }) async {
            expect(userId, _userId);
            requests.add((table: table, offset: offset, limit: limit));
            final source = table == 'workouts' ? workouts : sets;
            if (offset >= source.length) return const [];
            return source.sublist(
              offset,
              math.min(offset + limit, source.length),
            );
          },
    );

    final restored = await remote.fetchWorkouts(_userId);

    expect(restored, hasLength(workoutCount));
    expect(restored.expand((workout) => workout.sets), hasLength(1006));
    expect(restored.map((workout) => workout.id).toSet(), hasLength(503));
    expect(
      restored.expand((workout) => workout.sets).map((set) => set.id).toSet(),
      hasLength(1006),
    );
    expect(restored.every((workout) => workout.userId == _userId), isTrue);
    expect(restored.every((workout) => workout.sets.length == 2), isTrue);
    expect(
      requests
          .where((request) => request.table == 'workouts')
          .map((request) => request.offset),
      [0, 500],
    );
    expect(
      requests
          .where((request) => request.table == 'workout_sets')
          .map((request) => request.offset),
      [0, 500, 1000],
    );
  });

  test('page collector validates its page size', () async {
    expect(
      () =>
          fetchAllRemoteWorkoutPages(loadPage: (_, _) async => [], pageSize: 0),
      throwsArgumentError,
    );
  });
}

String _uuid(String prefix, int value) {
  return '$prefix${value.toString().padLeft(7, '0')}-0000-4000-8000-000000000001';
}
