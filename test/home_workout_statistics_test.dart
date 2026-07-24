import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/features/dashboard/presentation/dashboard_screen.dart';
import 'package:forgefit/features/sessions/domain/workout_session_models.dart';

void main() {
  final fixedNow = DateTime.utc(2026, 7, 24, 0);
  // 24 July in a UTC+10 device locale: [23 Jul 14:00Z, 24 Jul 14:00Z).
  final selectedLocalDay = LocalDayBounds(
    startInclusiveUtc: DateTime.utc(2026, 7, 23, 14),
    endExclusiveUtc: DateTime.utc(2026, 7, 24, 14),
  );

  test(
    'home statistics count completed sessions using the local calendar day',
    () {
      final statistics = HomeWorkoutStatistics.fromCompletedSessions(
        [
          // This is 24 July locally even though its stored UTC date is 23 July.
          _session('today', DateTime.utc(2026, 7, 23, 15, 30)),
          _session('earlier', DateTime.utc(2026, 7, 22, 14)),
        ],
        now: fixedNow,
        localDayBounds: selectedLocalDay,
      );

      expect(statistics.todayCount, 1);
      expect(statistics.allTimeCount, 2);
    },
  );

  test(
    'local-day boundaries include only finished sessions within the day',
    () {
      final statistics = HomeWorkoutStatistics.fromCompletedSessions(
        [
          _session(
            'before-local-midnight',
            DateTime.utc(2026, 7, 23, 13, 59, 59, 999),
          ),
          _session(
            'immediately-after-local-midnight',
            DateTime.utc(2026, 7, 23, 14, 0, 0, 1),
          ),
          _session('utc-date-differs', DateTime.utc(2026, 7, 23, 15, 30)),
          _session('next-local-day', DateTime.utc(2026, 7, 24, 14)),
        ],
        now: fixedNow,
        localDayBounds: selectedLocalDay,
      );

      expect(statistics.todayCount, 2);
      expect(statistics.allTimeCount, 4);
    },
  );

  test(
    'soft-deleted completed sessions and unfinished workouts are excluded',
    () {
      final statistics = HomeWorkoutStatistics.fromCompletedSessions(
        [
          _session('completed', DateTime.utc(2026, 7, 23, 15)),
          _session(
            'cancelled',
            DateTime.utc(2026, 7, 23, 16),
            deletedAt: DateTime.utc(2026, 7, 23, 16, 1),
          ),
          // Active unfinished workouts use a different model/table and cannot be
          // supplied to this completed-session-only calculation.
        ],
        now: fixedNow,
        localDayBounds: selectedLocalDay,
      );

      expect(statistics.todayCount, 1);
      expect(statistics.allTimeCount, 1);
    },
  );
}

CompletedWorkoutSession _session(
  String id,
  DateTime endedAt, {
  DateTime? deletedAt,
}) => CompletedWorkoutSession(
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
  deletedAt: deletedAt,
  version: 1,
);
