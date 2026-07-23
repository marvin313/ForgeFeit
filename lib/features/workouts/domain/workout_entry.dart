/// A complete workout and all of its sets.
///
/// IDs are generated on-device before the workout is persisted. The same IDs
/// are used for every upload retry so a retry can never create a duplicate.
class WorkoutEntry {
  const WorkoutEntry({
    required this.id,
    required this.userId,
    required this.exerciseName,
    required this.performedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.sets,
  });

  final String id;
  final String userId;
  final String exerciseName;
  final DateTime performedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<WorkoutSetEntry> sets;

  /// Convenience value for the milestone UI, which currently saves one set.
  double get weight => sets.isEmpty ? 0 : sets.first.weight;

  /// Convenience value for the milestone UI, which currently saves one set.
  int get reps => sets.isEmpty ? 0 : sets.first.reps;
}

class WorkoutSetEntry {
  const WorkoutSetEntry({
    required this.id,
    required this.workoutId,
    required this.userId,
    required this.weight,
    required this.reps,
    required this.createdAt,
    required this.updatedAt,
    this.setOrder = 1,
  });

  final String id;
  final String workoutId;
  final String userId;
  final double weight;
  final int reps;
  final int setOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
}
