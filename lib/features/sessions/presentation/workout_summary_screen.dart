import 'package:flutter/material.dart';

import '../../../core/theme/forgefit_theme.dart';
import '../data/offline_first_session_repository.dart';
import '../domain/workout_session_models.dart';
import 'session_ui_widgets.dart';

class WorkoutSummaryScreen extends StatefulWidget {
  const WorkoutSummaryScreen({
    super.key,
    required this.userId,
    required this.weightUnit,
    required this.repository,
    required this.sessionId,
    this.initialSummary,
    this.onDone,
    this.onViewHistory,
  });

  final String userId;
  final String weightUnit;
  final String sessionId;
  final OfflineFirstSessionRepository repository;
  final WorkoutSummary? initialSummary;
  final VoidCallback? onDone;
  final VoidCallback? onViewHistory;

  @override
  State<WorkoutSummaryScreen> createState() => _WorkoutSummaryScreenState();
}

class _WorkoutSummaryScreenState extends State<WorkoutSummaryScreen> {
  late Future<WorkoutSummary> _summary;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _summary = widget.initialSummary != null
        ? Future.value(widget.initialSummary)
        : widget.repository.getWorkoutSummary(
            userId: widget.userId,
            sessionId: widget.sessionId,
          );
  }

  void _retry() => setState(_load);

  void _done() {
    final callback = widget.onDone;
    if (callback != null) {
      callback();
    } else {
      // Finish review replaces itself with this route while the active-workout
      // route remains below it. Remove the transient stack so Done always
      // returns to the authenticated home shell.
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Workout complete'),
      ),
      body: SafeArea(
        top: false,
        child: FutureBuilder<WorkoutSummary>(
          future: _summary,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SessionLoadingState(
                label: 'Building your workout summary…',
              );
            }
            if (snapshot.hasError) {
              return SessionErrorState(
                title: 'Summary could not be loaded',
                error: snapshot.error!,
                onRetry: _retry,
              );
            }
            return _SummaryContent(
              summary: snapshot.requireData,
              weightUnit: widget.weightUnit,
              onDone: _done,
              onViewHistory: widget.onViewHistory,
            );
          },
        ),
      ),
    );
  }
}

class _SummaryContent extends StatelessWidget {
  const _SummaryContent({
    required this.summary,
    required this.weightUnit,
    required this.onDone,
    required this.onViewHistory,
  });

  final WorkoutSummary summary;
  final String weightUnit;
  final VoidCallback onDone;
  final VoidCallback? onViewHistory;

  @override
  Widget build(BuildContext context) {
    final session = summary.session;
    final colors = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.primary.withValues(alpha: 0.32)),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: ForgeFitColors.success,
                size: 46,
              ),
              const SizedBox(height: 12),
              Text(
                session.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                SessionFormat.dateTime(session.endedAt),
                style: const TextStyle(color: ForgeFitColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
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
              value: SessionFormat.duration(
                Duration(seconds: session.durationSeconds),
              ),
              icon: Icons.timer_outlined,
            ),
            SessionMetricTile(
              label: 'Exercises',
              value: '${session.exerciseCount}',
              icon: Icons.fitness_center_rounded,
            ),
            SessionMetricTile(
              label: 'Working sets',
              value: '${session.workingSetCount}',
              icon: Icons.done_all_rounded,
            ),
            SessionMetricTile(
              label: 'Completed sets',
              value: '${session.totalCompletedSets}',
              icon: Icons.checklist_rounded,
            ),
            SessionMetricTile(
              label: 'Total repetitions',
              value: '${session.totalRepetitions}',
              icon: Icons.repeat_rounded,
            ),
            SessionMetricTile(
              label: 'Training volume',
              value: SessionFormat.volumeKg(session.totalVolumeKg),
              icon: Icons.monitor_weight_outlined,
              highlight: true,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Personal records',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        if (summary.personalRecords.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                'No new personal records this workout.',
                style: TextStyle(color: Color(0xFF98A2AE)),
              ),
            ),
          )
        else
          ...summary.personalRecords.map(
            (record) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.emoji_events_rounded,
                    color: ForgeFitColors.warning,
                  ),
                  title: Text(
                    record.exerciseName,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(record.recordKind.label),
                  trailing: Text(
                    _recordValue(record, weightUnit),
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
          ),
        if ((session.notes ?? '').isNotEmpty) ...[
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
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
                    style: const TextStyle(color: Color(0xFFB2BBC5)),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton(onPressed: onDone, child: const Text('Done')),
        if (onViewHistory != null) ...[
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: onViewHistory,
            child: const Text('View Workout History'),
          ),
        ],
      ],
    );
  }
}

String _recordValue(PersonalRecordEvent record, String unit) {
  return switch (record.recordKind) {
    PersonalRecordKind.mostRepsAtWeight =>
      record.weightKg == null
          ? '${record.repetitions ?? 0} reps'
          : '${record.repetitions ?? 0} reps @ '
                '${SessionFormat.weight(record.weightKg!, unit)}',
    PersonalRecordKind.heaviestWeight ||
    PersonalRecordKind.estimatedOneRepMax => SessionFormat.weight(
      record.recordValue,
      unit,
    ),
    PersonalRecordKind.setVolume || PersonalRecordKind.exerciseWorkoutVolume =>
      SessionFormat.volumeKg(record.recordValue),
  };
}
