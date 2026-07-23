import 'package:flutter/material.dart';

import '../../../core/theme/forgefit_theme.dart';
import '../data/offline_first_session_repository.dart';
import '../domain/workout_session_models.dart';
import 'session_ui_widgets.dart';

class CompletedWorkoutDetailScreen extends StatefulWidget {
  const CompletedWorkoutDetailScreen({
    super.key,
    required this.userId,
    required this.weightUnit,
    required this.repository,
    required this.sessionId,
    this.initialWorkout,
    this.onLocalChangeQueued,
  });

  final String userId;
  final String weightUnit;
  final OfflineFirstSessionRepository repository;
  final String sessionId;
  final CompletedWorkoutBundle? initialWorkout;
  final VoidCallback? onLocalChangeQueued;

  @override
  State<CompletedWorkoutDetailScreen> createState() =>
      _CompletedWorkoutDetailScreenState();
}

class _CompletedWorkoutDetailScreenState
    extends State<CompletedWorkoutDetailScreen> {
  late Future<CompletedWorkoutBundle> _workout;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load(useInitial: true);
  }

  void _load({bool useInitial = false}) {
    _workout = useInitial && widget.initialWorkout != null
        ? Future.value(widget.initialWorkout)
        : widget.repository.getCompletedWorkout(
            userId: widget.userId,
            sessionId: widget.sessionId,
          );
  }

  void _retry() => setState(_load);

  Future<void> _editNotes(CompletedWorkoutSession session) async {
    final controller = TextEditingController(text: session.notes);
    final value = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit workout notes'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          maxLength: 4000,
          decoration: const InputDecoration(hintText: 'Optional notes'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value == null || !mounted) return;
    setState(() => _busy = true);
    try {
      await widget.repository.editCompletedWorkoutNotes(
        userId: widget.userId,
        sessionId: session.id,
        notes: value,
      );
      widget.onLocalChangeQueued?.call();
      if (mounted) setState(_load);
    } on Object catch (error) {
      if (mounted) showSessionError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete completed workout?'),
        content: const Text(
          'The workout will be hidden and affected personal records will be recalculated from remaining history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: ForgeFitColors.danger,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await widget.repository.softDeleteCompletedWorkout(
        userId: widget.userId,
        sessionId: widget.sessionId,
      );
      widget.onLocalChangeQueued?.call();
      if (mounted) Navigator.pop(context, true);
    } on Object catch (error) {
      if (mounted) showSessionError(context, error);
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Details'),
        actions: [
          IconButton(
            tooltip: 'Delete workout',
            onPressed: _busy ? null : _delete,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: FutureBuilder<CompletedWorkoutBundle>(
          future: _workout,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SessionLoadingState(
                label: 'Loading workout details…',
              );
            }
            if (snapshot.hasError) {
              return SessionErrorState(
                title: 'Workout details could not be loaded',
                error: snapshot.error!,
                onRetry: _retry,
              );
            }
            return _DetailContent(
              workout: snapshot.requireData,
              weightUnit: widget.weightUnit,
              busy: _busy,
              onEditNotes: _editNotes,
            );
          },
        ),
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({
    required this.workout,
    required this.weightUnit,
    required this.busy,
    required this.onEditNotes,
  });

  final CompletedWorkoutBundle workout;
  final String weightUnit;
  final bool busy;
  final ValueChanged<CompletedWorkoutSession> onEditNotes;

  @override
  Widget build(BuildContext context) {
    final session = workout.session;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
      children: [
        Text(
          session.name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 5),
        Text(
          '${SessionFormat.dateTime(session.startedAt)} – '
          '${TimeOfDay.fromDateTime(session.endedAt.toLocal()).format(context)}',
          style: const TextStyle(color: Color(0xFF929CA8)),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.65,
          children: [
            SessionMetricTile(
              label: 'Duration',
              value: SessionFormat.duration(
                Duration(seconds: session.durationSeconds),
              ),
            ),
            SessionMetricTile(
              label: 'Exercises',
              value: '${session.exerciseCount}',
            ),
            SessionMetricTile(
              label: 'Completed sets',
              value: '${session.totalCompletedSets}',
            ),
            SessionMetricTile(
              label: 'Volume',
              value: SessionFormat.volumeKg(session.totalVolumeKg),
              highlight: true,
            ),
          ],
        ),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Workout notes',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Edit notes',
                      onPressed: busy ? null : () => onEditNotes(session),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  ],
                ),
                Text(
                  (session.notes ?? '').isEmpty
                      ? 'No notes added.'
                      : session.notes!,
                  style: const TextStyle(color: Color(0xFFB0BAC4)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Performance',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        if (workout.exercises.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                'No completed exercises were saved.',
                style: TextStyle(color: Color(0xFF929CA8)),
              ),
            ),
          )
        else
          ...workout.exercises.map(
            (exercise) => Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: _CompletedExerciseCard(
                exercise: exercise,
                sets: workout.setsFor(exercise.id),
                weightUnit: weightUnit,
              ),
            ),
          ),
        const SizedBox(height: 12),
        const Text(
          'Performance values are read-only so workout totals and personal records remain audit-safe.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF7F8995), fontSize: 12),
        ),
      ],
    );
  }
}

class _CompletedExerciseCard extends StatelessWidget {
  const _CompletedExerciseCard({
    required this.exercise,
    required this.sets,
    required this.weightUnit,
  });

  final CompletedWorkoutExercise exercise;
  final List<CompletedWorkoutSet> sets;
  final String weightUnit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        shape: const Border(),
        collapsedShape: const Border(),
        title: Text(
          exercise.exerciseName,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text(
          '${exercise.completedSetCount} sets • '
          '${SessionFormat.volumeKg(exercise.totalVolumeKg)}',
        ),
        children: [
          if ((exercise.notes ?? '').isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  exercise.notes!,
                  style: const TextStyle(color: Color(0xFF9DA7B2)),
                ),
              ),
            ),
          ...sets.asMap().entries.map(
            (entry) => Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ForgeFitColors.surfaceHigh,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 28,
                    child: Text(
                      '${entry.key + 1}',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _completedSetSummary(entry.value, weightUnit),
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          entry.value.setType.label,
                          style: const TextStyle(
                            color: Color(0xFF8F99A5),
                            fontSize: 11,
                          ),
                        ),
                        if ((entry.value.notes ?? '').isNotEmpty)
                          Text(
                            entry.value.notes!,
                            style: const TextStyle(
                              color: Color(0xFFADB6C0),
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (entry.value.isPersonalRecord)
                    const Tooltip(
                      message: 'Personal record',
                      child: Icon(
                        Icons.emoji_events_rounded,
                        color: ForgeFitColors.warning,
                        size: 21,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

String _completedSetSummary(CompletedWorkoutSet set, String unit) {
  final parts = <String>[];
  if (set.weightKg case final weight?) {
    parts.add(SessionFormat.weight(weight, unit));
  }
  if (set.repetitions case final reps?) parts.add('$reps reps');
  if (set.durationSeconds case final seconds?) parts.add('${seconds}s');
  if (set.distanceMeters case final distance?) {
    parts.add('${SessionFormat.number(distance)} m');
  }
  if (set.rpe case final rpe?) parts.add('RPE ${SessionFormat.number(rpe)}');
  if (set.rir case final rir?) parts.add('RIR ${SessionFormat.number(rir)}');
  return parts.isEmpty ? 'Completed set' : parts.join(' • ');
}
