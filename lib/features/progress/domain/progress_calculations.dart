import 'dart:math' as math;

import '../../sessions/domain/workout_session_models.dart';

/// A single, local-calendar filter shared by the Progress experience.
enum ProgressTimeRange { week, month, threeMonths, sixMonths, year, allTime }

extension ProgressTimeRangePresentation on ProgressTimeRange {
  String get label => switch (this) {
    ProgressTimeRange.week => '1 week',
    ProgressTimeRange.month => '1 month',
    ProgressTimeRange.threeMonths => '3 months',
    ProgressTimeRange.sixMonths => '6 months',
    ProgressTimeRange.year => '1 year',
    ProgressTimeRange.allTime => 'All time',
  };
}

enum ExerciseProgressMetric { bestWeight, estimatedOneRepMax, bestSetVolume }

extension ExerciseProgressMetricPresentation on ExerciseProgressMetric {
  String get label => switch (this) {
    ExerciseProgressMetric.bestWeight => 'Best weight',
    ExerciseProgressMetric.estimatedOneRepMax => 'Estimated 1RM',
    ExerciseProgressMetric.bestSetVolume => 'Best-set volume',
  };
}

enum ProgressVolumeGrouping { workout, week, month }

class LocalDateRange {
  const LocalDateRange({required this.start, required this.endExclusive});

  final DateTime? start;
  final DateTime endExclusive;

  bool contains(DateTime value) {
    final local = value.toLocal();
    return (start == null || !local.isBefore(start!)) &&
        local.isBefore(endExclusive);
  }
}

LocalDateRange progressDateRange(ProgressTimeRange range, DateTime now) {
  final local = now.toLocal();
  final today = DateTime(local.year, local.month, local.day);
  final endExclusive = today.add(const Duration(days: 1));
  final start = switch (range) {
    ProgressTimeRange.week => today.subtract(const Duration(days: 6)),
    ProgressTimeRange.month => DateTime(local.year, local.month - 1, local.day),
    ProgressTimeRange.threeMonths => DateTime(
      local.year,
      local.month - 3,
      local.day,
    ),
    ProgressTimeRange.sixMonths => DateTime(
      local.year,
      local.month - 6,
      local.day,
    ),
    ProgressTimeRange.year => DateTime(local.year - 1, local.month, local.day),
    ProgressTimeRange.allTime => null,
  };
  return LocalDateRange(start: start, endExclusive: endExclusive);
}

class ProgressPoint {
  const ProgressPoint({
    required this.date,
    required this.value,
    required this.label,
  });

  final DateTime date;
  final double value;
  final String label;
}

class ExerciseWeightProgressSummary {
  const ExerciseWeightProgressSummary({
    required this.startingWeightKg,
    required this.latestWeightKg,
    required this.changeKg,
    required this.changePercentage,
  });

  final double startingWeightKg;
  final double latestWeightKg;
  final double changeKg;
  final double? changePercentage;
}

class ProgressSetRecord {
  const ProgressSetRecord({
    required this.value,
    required this.achievedAt,
    this.weightKg,
    this.repetitions,
  });

  final double value;
  final DateTime achievedAt;
  final double? weightKg;
  final int? repetitions;
}

class ExercisePersonalRecords {
  const ExercisePersonalRecords({
    required this.exerciseKey,
    required this.exerciseName,
    this.heaviestWeight,
    this.bestRepetitions,
    this.bestSet,
    this.estimatedOneRepMax,
    this.highestSingleWorkoutVolume,
  });

  final String exerciseKey;
  final String exerciseName;
  final ProgressSetRecord? heaviestWeight;
  final ProgressSetRecord? bestRepetitions;
  final ProgressSetRecord? bestSet;
  final ProgressSetRecord? estimatedOneRepMax;
  final ProgressSetRecord? highestSingleWorkoutVolume;
}

class NamedProgressValue {
  const NamedProgressValue(this.name, this.value);

  final String name;
  final int value;
}

class ProgressConsistency {
  const ProgressConsistency({
    required this.workoutsCompleted,
    required this.averageWorkoutsPerWeek,
    required this.completedWorkingSets,
    required this.completedRepetitions,
    required this.currentStreakDays,
    required this.longestStreakDays,
    required this.mostFrequentExercises,
    required this.mostFrequentSplits,
  });

  final int workoutsCompleted;
  final double averageWorkoutsPerWeek;
  final int completedWorkingSets;
  final int completedRepetitions;
  final int currentStreakDays;
  final int longestStreakDays;
  final List<NamedProgressValue> mostFrequentExercises;
  final List<NamedProgressValue> mostFrequentSplits;
}

class ProgressExerciseOption {
  const ProgressExerciseOption({required this.key, required this.name});

  final String key;
  final String name;
}

/// Pure completed-workout calculations. Timestamps remain UTC in storage and
/// are converted to a local date only at the filtering/grouping boundary.
class ProgressCalculator {
  static const int maximumEstimatedOneRepMaxRepetitions = 30;

  static List<CompletedWorkoutBundle> completedInRange(
    Iterable<CompletedWorkoutBundle> bundles,
    LocalDateRange range,
  ) => List.unmodifiable(
    bundles.where(
      (bundle) =>
          !bundle.session.isDeleted && range.contains(bundle.session.endedAt),
    ),
  );

  static List<ProgressExerciseOption> exerciseOptions(
    Iterable<CompletedWorkoutBundle> bundles,
  ) {
    final options = <String, ProgressExerciseOption>{};
    final latest = <String, DateTime>{};
    for (final bundle in bundles) {
      if (bundle.session.isDeleted) continue;
      for (final exercise in bundle.exercises) {
        if (exercise.isDeleted) continue;
        options.putIfAbsent(
          exercise.exerciseKey,
          () => ProgressExerciseOption(
            key: exercise.exerciseKey,
            name: exercise.exerciseName,
          ),
        );
        final performedAt = bundle.session.endedAt.toUtc();
        if (performedAt.isAfter(
          latest[exercise.exerciseKey] ?? DateTime(1900),
        )) {
          latest[exercise.exerciseKey] = performedAt;
        }
      }
    }
    final values = options.values.toList()
      ..sort((a, b) {
        final recent = (latest[b.key] ?? DateTime(1900)).compareTo(
          latest[a.key] ?? DateTime(1900),
        );
        return recent == 0 ? a.name.compareTo(b.name) : recent;
      });
    return List.unmodifiable(values);
  }

  static List<ExercisePersonalRecords> personalRecords(
    Iterable<CompletedWorkoutBundle> bundles,
  ) {
    final groups = <String, List<_ExerciseSet>>{};
    final names = <String, String>{};
    for (final bundle in bundles) {
      if (bundle.session.isDeleted) continue;
      for (final exercise in bundle.exercises) {
        if (exercise.isDeleted) continue;
        names.putIfAbsent(exercise.exerciseKey, () => exercise.exerciseName);
        for (final set in _workingSets(bundle, exercise)) {
          groups.putIfAbsent(exercise.exerciseKey, () => []).add(set);
        }
      }
    }
    final records = <ExercisePersonalRecords>[];
    for (final entry in groups.entries) {
      final sets = entry.value;
      final weighted = sets.where(_hasMeaningfulExternalWeight).toList();
      ProgressSetRecord? recordFor(
        Iterable<_ExerciseSet> candidates,
        double Function(_ExerciseSet value) selector,
      ) {
        _ExerciseSet? best;
        for (final candidate in candidates) {
          if (best == null || selector(candidate) > selector(best)) {
            best = candidate;
          }
        }
        return best == null
            ? null
            : ProgressSetRecord(
                value: selector(best),
                achievedAt: best.set.completedAt,
                weightKg: best.set.weightKg,
                repetitions: best.set.repetitions,
              );
      }

      records.add(
        ExercisePersonalRecords(
          exerciseKey: entry.key,
          exerciseName: names[entry.key] ?? entry.key,
          heaviestWeight: recordFor(weighted, (set) => set.set.weightKg!),
          bestRepetitions: recordFor(
            sets.where((set) => (set.set.repetitions ?? 0) > 0),
            (set) => set.set.repetitions!.toDouble(),
          ),
          bestSet: recordFor(weighted, _setVolume),
          estimatedOneRepMax: recordFor(
            weighted.where((set) => _estimatedOneRepMax(set) != null),
            (set) => _estimatedOneRepMax(set)!,
          ),
          highestSingleWorkoutVolume: _highestWorkoutVolume(weighted),
        ),
      );
    }
    records.sort((a, b) => a.exerciseName.compareTo(b.exerciseName));
    return List.unmodifiable(records);
  }

  static List<ProgressPoint> exerciseProgress({
    required Iterable<CompletedWorkoutBundle> bundles,
    required String exerciseKey,
    required ExerciseProgressMetric metric,
  }) {
    final pointsByLocalDate = <DateTime, ProgressPoint>{};
    for (final bundle in bundles) {
      if (bundle.session.isDeleted) continue;
      final values = <double>[];
      for (final exercise in bundle.exercises) {
        if (exercise.isDeleted || exercise.exerciseKey != exerciseKey) continue;
        for (final item in _workingSets(bundle, exercise)) {
          final value = switch (metric) {
            ExerciseProgressMetric.bestWeight =>
              _hasMeaningfulExternalWeight(item) ? item.set.weightKg! : null,
            ExerciseProgressMetric.estimatedOneRepMax => _estimatedOneRepMax(
              item,
            ),
            ExerciseProgressMetric.bestSetVolume =>
              _hasMeaningfulExternalWeight(item) ? _setVolume(item) : null,
          };
          if (value != null) values.add(value);
        }
      }
      if (values.isNotEmpty) {
        final local = bundle.session.endedAt.toLocal();
        final date = DateTime(local.year, local.month, local.day);
        final point = ProgressPoint(
          date: date,
          value: values.reduce(math.max),
          label: bundle.session.name,
        );
        final existing = pointsByLocalDate[date];
        if (existing == null || point.value > existing.value) {
          pointsByLocalDate[date] = point;
        }
      }
    }
    final points = pointsByLocalDate.values.toList();
    points.sort((a, b) => a.date.compareTo(b.date));
    return List.unmodifiable(points);
  }

  /// The primary Progress chart: one highest valid lifted weight for each
  /// local calendar date on which this stable exercise identity was performed.
  static List<ProgressPoint> exerciseWeightProgress({
    required Iterable<CompletedWorkoutBundle> bundles,
    required String exerciseKey,
  }) => exerciseProgress(
    bundles: bundles,
    exerciseKey: exerciseKey,
    metric: ExerciseProgressMetric.bestWeight,
  );

  static ExerciseWeightProgressSummary? weightProgressSummary(
    List<ProgressPoint> points,
  ) {
    if (points.isEmpty) return null;
    final startingWeight = points.first.value;
    final latestWeight = points.last.value;
    final change = latestWeight - startingWeight;
    return ExerciseWeightProgressSummary(
      startingWeightKg: startingWeight,
      latestWeightKg: latestWeight,
      changeKg: change,
      changePercentage: startingWeight > 0
          ? change / startingWeight * 100
          : null,
    );
  }

  static List<ProgressPoint> trainingVolume({
    required Iterable<CompletedWorkoutBundle> bundles,
    required ProgressVolumeGrouping grouping,
  }) {
    final values = <DateTime, double>{};
    final labels = <DateTime, String>{};
    for (final bundle in bundles) {
      if (bundle.session.isDeleted) continue;
      var volume = 0.0;
      for (final exercise in bundle.exercises) {
        if (exercise.isDeleted) continue;
        volume += _workingSets(bundle, exercise)
            .where(_hasMeaningfulExternalWeight)
            .fold(0.0, (sum, item) => sum + _setVolume(item));
      }
      if (volume <= 0) continue;
      final date = _volumeGroupDate(bundle.session.endedAt, grouping);
      values[date] = (values[date] ?? 0) + volume;
      labels.putIfAbsent(
        date,
        () => grouping == ProgressVolumeGrouping.workout
            ? bundle.session.name
            : grouping.name,
      );
    }
    final dates = values.keys.toList()..sort();
    return List.unmodifiable(
      dates.map(
        (date) => ProgressPoint(
          date: date,
          value: values[date]!,
          label: labels[date]!,
        ),
      ),
    );
  }

  static ProgressConsistency consistency({
    required Iterable<CompletedWorkoutBundle> allBundles,
    required Iterable<CompletedWorkoutBundle> filteredBundles,
    required DateTime now,
    Map<String, String> splitNameByTemplateId = const {},
  }) {
    final filtered = filteredBundles
        .where((bundle) => !bundle.session.isDeleted)
        .toList();
    var workingSets = 0;
    var repetitions = 0;
    final exercises = <String, int>{};
    final splits = <String, int>{};
    for (final bundle in filtered) {
      final splitName = bundle.session.sourceTemplateId == null
          ? 'No split'
          : splitNameByTemplateId[bundle.session.sourceTemplateId!] ??
                bundle.session.name;
      splits[splitName] = (splits[splitName] ?? 0) + 1;
      for (final exercise in bundle.exercises) {
        final sets = _workingSets(bundle, exercise).toList();
        if (sets.isEmpty) continue;
        exercises[exercise.exerciseName] =
            (exercises[exercise.exerciseName] ?? 0) + 1;
        workingSets += sets.length;
        repetitions += sets.fold(0, (sum, item) => sum + item.set.repetitions!);
      }
    }
    final first = filtered.isEmpty
        ? null
        : filtered
              .map((bundle) => bundle.session.endedAt.toLocal())
              .reduce((a, b) => a.isBefore(b) ? a : b);
    final weeks = first == null
        ? 1.0
        : math.max(1.0, now.toLocal().difference(first).inDays / 7 + 1 / 7);
    return ProgressConsistency(
      workoutsCompleted: filtered.length,
      averageWorkoutsPerWeek: filtered.length / weeks,
      completedWorkingSets: workingSets,
      completedRepetitions: repetitions,
      currentStreakDays: _currentStreak(allBundles, now),
      longestStreakDays: _longestStreak(allBundles),
      mostFrequentExercises: _topValues(exercises),
      mostFrequentSplits: _topValues(splits),
    );
  }

  static Iterable<_ExerciseSet> _workingSets(
    CompletedWorkoutBundle bundle,
    CompletedWorkoutExercise exercise,
  ) sync* {
    for (final set in bundle.setsFor(exercise.id)) {
      if (set.isDeleted ||
          set.setType == WorkoutSetType.warmUp ||
          (set.repetitions ?? 0) <= 0) {
        continue;
      }
      yield _ExerciseSet(exercise: exercise, set: set, session: bundle.session);
    }
  }

  static bool _hasMeaningfulExternalWeight(_ExerciseSet item) =>
      item.exercise.weightRelevant &&
      item.exercise.primaryMuscleGroup.name != 'cardio' &&
      (item.set.weightKg ?? 0) > 0 &&
      (item.set.repetitions ?? 0) > 0;

  static double _setVolume(_ExerciseSet item) =>
      item.set.weightKg! * item.set.repetitions!;

  static double? _estimatedOneRepMax(_ExerciseSet item) {
    final reps = item.set.repetitions;
    if (!_hasMeaningfulExternalWeight(item) ||
        reps == null ||
        reps > maximumEstimatedOneRepMaxRepetitions) {
      return null;
    }
    return estimateEpleyOneRepMax(
      weightKg: item.set.weightKg,
      repetitions: reps,
    );
  }

  static ProgressSetRecord? _highestWorkoutVolume(
    Iterable<_ExerciseSet> weighted,
  ) {
    final grouped = <String, List<_ExerciseSet>>{};
    for (final item in weighted) {
      grouped.putIfAbsent(item.session.id, () => []).add(item);
    }
    List<_ExerciseSet>? best;
    double bestValue = -1;
    for (final sets in grouped.values) {
      final value = sets.fold(0.0, (sum, item) => sum + _setVolume(item));
      if (value > bestValue) {
        bestValue = value;
        best = sets;
      }
    }
    if (best == null) return null;
    final representative = best.first;
    return ProgressSetRecord(
      value: bestValue,
      achievedAt: representative.session.endedAt,
    );
  }

  static DateTime _volumeGroupDate(
    DateTime date,
    ProgressVolumeGrouping grouping,
  ) {
    final local = date.toLocal();
    final day = DateTime(local.year, local.month, local.day);
    return switch (grouping) {
      ProgressVolumeGrouping.workout => day,
      ProgressVolumeGrouping.week => day.subtract(
        Duration(days: day.weekday - DateTime.monday),
      ),
      ProgressVolumeGrouping.month => DateTime(local.year, local.month),
    };
  }

  static List<NamedProgressValue> _topValues(Map<String, int> values) {
    final entries =
        values.entries
            .map((entry) => NamedProgressValue(entry.key, entry.value))
            .toList()
          ..sort((a, b) {
            final count = b.value.compareTo(a.value);
            return count == 0 ? a.name.compareTo(b.name) : count;
          });
    return List.unmodifiable(entries.take(3));
  }

  static Set<DateTime> _completedDays(
    Iterable<CompletedWorkoutBundle> bundles,
  ) {
    final dates = <DateTime>{};
    for (final bundle in bundles) {
      if (bundle.session.isDeleted) continue;
      final value = bundle.session.endedAt.toLocal();
      dates.add(DateTime(value.year, value.month, value.day));
    }
    return dates;
  }

  static int _currentStreak(
    Iterable<CompletedWorkoutBundle> bundles,
    DateTime now,
  ) {
    final dates = _completedDays(bundles);
    final local = now.toLocal();
    var day = DateTime(local.year, local.month, local.day);
    if (!dates.contains(day)) day = day.subtract(const Duration(days: 1));
    var streak = 0;
    while (dates.contains(day)) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  static int _longestStreak(Iterable<CompletedWorkoutBundle> bundles) {
    final dates = _completedDays(bundles).toList()..sort();
    var best = 0;
    var current = 0;
    DateTime? previous;
    for (final day in dates) {
      current = previous != null && day.difference(previous).inDays == 1
          ? current + 1
          : 1;
      best = math.max(best, current);
      previous = day;
    }
    return best;
  }
}

class _ExerciseSet {
  const _ExerciseSet({
    required this.exercise,
    required this.set,
    required this.session,
  });

  final CompletedWorkoutExercise exercise;
  final CompletedWorkoutSet set;
  final CompletedWorkoutSession session;
}
