import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/features/sessions/domain/workout_session_models.dart';
import 'package:forgefit/features/sessions/presentation/workout_calendar.dart';

void main() {
  test(
    'calendar groups completed sessions by an injected local calendar day',
    () {
      final sessions = [
        _session('late-utc', DateTime.utc(2026, 7, 23, 15), 'Full Body'),
        _session('same-day', DateTime.utc(2026, 7, 24, 8), 'Upper'),
        _session(
          'cancelled',
          DateTime.utc(2026, 7, 24, 9),
          'Cancelled',
          deletedAt: DateTime.utc(2026, 7, 24, 10),
        ),
      ];
      final grouped = WorkoutCalendarData.groupByLocalDay(
        sessions,
        toLocal: (value) => value.toUtc().add(const Duration(hours: 10)),
      );

      final day = DateTime(2026, 7, 24);
      expect(grouped[day]!.map((session) => session.name), [
        'Full Body',
        'Upper',
      ]);
      expect(grouped.values.expand((items) => items), hasLength(2));
    },
  );
}

CompletedWorkoutSession _session(
  String id,
  DateTime endedAt,
  String name, {
  DateTime? deletedAt,
}) => CompletedWorkoutSession(
  id: id,
  userId: 'user-a',
  name: name,
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
