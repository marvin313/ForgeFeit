import 'package:flutter/material.dart';

import '../../../core/settings/appearance_settings.dart';
import '../../../core/theme/forgefit_theme.dart';
import '../data/offline_first_session_repository.dart';
import '../domain/workout_session_models.dart';
import 'session_ui_widgets.dart';
import 'workout_summary_screen.dart';

class FinishWorkoutReviewScreen extends StatefulWidget {
  const FinishWorkoutReviewScreen({
    super.key,
    required this.userId,
    required this.weightUnit,
    required this.repository,
    required this.activeWorkout,
    this.onWorkoutFinished,
    this.onWorkoutDiscarded,
    this.onLocalChangeQueued,
    this.hapticsEnabled = true,
  });

  final String userId;
  final String weightUnit;
  final OfflineFirstSessionRepository repository;
  final ActiveWorkoutBundle activeWorkout;
  final ValueChanged<CompletedWorkoutBundle>? onWorkoutFinished;
  final VoidCallback? onWorkoutDiscarded;
  final VoidCallback? onLocalChangeQueued;
  final bool hapticsEnabled;

  @override
  State<FinishWorkoutReviewScreen> createState() =>
      _FinishWorkoutReviewScreenState();
}

class _FinishWorkoutReviewScreenState extends State<FinishWorkoutReviewScreen> {
  bool _saving = false;

  List<ActiveWorkoutSet> get _completedSets => widget.activeWorkout.sets
      .where((set) => set.isCompleted && !set.isDeleted)
      .toList(growable: false);

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final completed = await widget.repository.finishWorkout(
        userId: widget.userId,
        sessionId: widget.activeWorkout.session.id,
      );
      widget.onLocalChangeQueued?.call();
      if (!mounted) return;
      ForgeFitHaptics.success(widget.hapticsEnabled);
      widget.onWorkoutFinished?.call(completed);
      await Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute(
          builder: (_) => WorkoutSummaryScreen(
            userId: widget.userId,
            weightUnit: widget.weightUnit,
            repository: widget.repository,
            sessionId: completed.session.id,
          ),
        ),
      );
    } on Object catch (error) {
      if (mounted) showSessionError(context, error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _discard() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard this workout?'),
        content: const Text(
          'The active workout and its logged sets will be removed. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep Workout'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: ForgeFitColors.danger,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _saving = true);
    try {
      await widget.repository.discardActiveWorkout(
        userId: widget.userId,
        sessionId: widget.activeWorkout.session.id,
      );
      widget.onLocalChangeQueued?.call();
      if (!mounted) return;
      widget.onWorkoutDiscarded?.call();
      Navigator.pop(context);
    } on Object catch (error) {
      if (mounted) showSessionError(context, error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.activeWorkout.session;
    final completed = _completedSets;
    final completedExerciseIds = completed
        .map((set) => set.sessionExerciseId)
        .toSet();
    final working = completed
        .where((set) => set.setType != WorkoutSetType.warmUp)
        .length;
    final reps = completed.fold<int>(
      0,
      (total, set) => total + (set.repetitions ?? 0),
    );
    final volume = completed
        .where((set) => set.setType != WorkoutSetType.warmUp)
        .fold<double>(0, (total, set) => total + set.volumeKg);
    final elapsed = session.elapsedAt(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: const Text('Finish workout')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
          children: [
            Text(
              'Review before saving',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              session.name,
              style: const TextStyle(color: Color(0xFF9DA7B2), fontSize: 16),
            ),
            const SizedBox(height: 18),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.55,
              children: [
                SessionMetricTile(
                  label: 'Duration',
                  value: SessionFormat.duration(elapsed),
                  icon: Icons.timer_outlined,
                  highlight: true,
                ),
                SessionMetricTile(
                  label: 'Exercises completed',
                  value: '${completedExerciseIds.length}',
                  icon: Icons.fitness_center_rounded,
                ),
                SessionMetricTile(
                  label: 'Working sets',
                  value: '$working',
                  icon: Icons.check_circle_outline_rounded,
                ),
                SessionMetricTile(
                  label: 'Completed sets',
                  value: '${completed.length}',
                  icon: Icons.done_all_rounded,
                ),
                SessionMetricTile(
                  label: 'Total repetitions',
                  value: '$reps',
                  icon: Icons.repeat_rounded,
                ),
                SessionMetricTile(
                  label: 'Training volume',
                  value: SessionFormat.volumeKg(volume),
                  icon: Icons.monitor_weight_outlined,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(17),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.emoji_events_outlined,
                      color: ForgeFitColors.warning,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Personal records',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            completed.isEmpty
                                ? 'Complete at least one set to calculate records.'
                                : 'Records are calculated deterministically when the workout is saved.',
                            style: const TextStyle(
                              color: Color(0xFF9DA7B2),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if ((session.notes ?? '').isNotEmpty) ...[
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Workout notes',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        session.notes!,
                        style: const TextStyle(color: Color(0xFFB3BBC4)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 22),
            FilledButton.icon(
              key: const ValueKey('save-finish-workout-button'),
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_rounded),
              label: const Text('Save and Finish'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _saving ? null : () => Navigator.pop(context),
              child: const Text('Return to Workout'),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: _saving ? null : _discard,
              style: TextButton.styleFrom(
                foregroundColor: ForgeFitColors.danger,
              ),
              child: const Text('Discard Workout'),
            ),
          ],
        ),
      ),
    );
  }
}
