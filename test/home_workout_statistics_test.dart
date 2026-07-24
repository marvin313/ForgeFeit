import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/features/dashboard/presentation/dashboard_screen.dart';
import 'package:forgefit/features/sessions/domain/workout_session_models.dart';

void main() {
  test(
    'home statistics count completed sessions using the local calendar day',
    () {
      final now = DateTime(2026, 7, 24, 9);
      final statistics = HomeWorkoutStatistics.fromCompletedSessions([
        _session('today', DateTime.utc(2026, 7, 23, 15, 30)),
        _session('earlier', DateTime.utc(2026, 7, 22, 14)),
      ], now: now);

      expect(statistics.todayCount, 1);
      expect(statistics.allTimeCount, 2);
    },
  );
}

CompletedWorkoutSession _session(String id, DateTime endedAt) =>
    CompletedWorkoutSession(
      id: id,
      userId: 'user-a',
      name: 'Completed',
      weightUnit: 'kg',
      startedAt: endedAt.subtract(const Duration(hours: 1)),
      endedAt: endedAt,
      durationSeconds: 3600,
      exerciseCount: 1,
      workingSetCount: 1,
      totalCompletedSets: 1,
      totalRepetitions: 8,
      totalVolumeKg: 640,
      personalRecordCount: 0,
      createdAt: endedAt,
      updatedAt: endedAt,
      version: 1,
    );
