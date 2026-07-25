import 'package:flutter/material.dart';

import '../../planning/domain/planning_models.dart';
import '../../workouts/domain/workout_entry.dart';
import '../data/offline_first_session_repository.dart';
import '../domain/workout_session_models.dart';
import 'completed_workout_detail_screen.dart';
import 'session_ui_widgets.dart';
import 'workout_calendar.dart';

class SessionHistoryScreen extends StatefulWidget {
  const SessionHistoryScreen({
    super.key,
    required this.userId,
    required this.weightUnit,
    required this.repository,
    this.legacyQuickLogs = const [],
    this.onOpenLegacyQuickLog,
    this.onStartWorkout,
    this.onLocalChangeQueued,
    this.embedded = false,
    this.showCalendar = false,
  });

  final String userId;
  final String weightUnit;
  final OfflineFirstSessionRepository repository;
  final List<WorkoutEntry> legacyQuickLogs;
  final ValueChanged<WorkoutEntry>? onOpenLegacyQuickLog;
  final VoidCallback? onStartWorkout;
  final VoidCallback? onLocalChangeQueued;
  final bool embedded;
  final bool showCalendar;

  @override
  State<SessionHistoryScreen> createState() => _SessionHistoryScreenState();
}

class _SessionHistoryScreenState extends State<SessionHistoryScreen> {
  final _search = TextEditingController();
  late Stream<List<CompletedWorkoutSession>> _stream;
  late bool _showCalendar;

  @override
  void initState() {
    super.initState();
    _stream = widget.repository.watchCompletedSessions(widget.userId);
    _showCalendar = widget.showCalendar;
    _search.addListener(_changed);
  }

  @override
  void didUpdateWidget(covariant SessionHistoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId ||
        oldWidget.repository != widget.repository) {
      _stream = widget.repository.watchCompletedSessions(widget.userId);
    }
    if (widget.showCalendar && !oldWidget.showCalendar) {
      _showCalendar = true;
    }
  }

  @override
  void dispose() {
    _search
      ..removeListener(_changed)
      ..dispose();
    super.dispose();
  }

  void _changed() => setState(() {});

  void _retry() => setState(
    () => _stream = widget.repository.watchCompletedSessions(widget.userId),
  );

  Future<void> _refresh() async {
    try {
      await widget.repository.restoreFromCloud(widget.userId);
    } finally {
      widget.onLocalChangeQueued?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = SafeArea(
      top: false,
      child: Column(
        children: [
          if (widget.embedded)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 2),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Workout History',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: _showCalendar
                      ? const Text(
                          'Completed workouts by local calendar date',
                          style: TextStyle(color: Color(0xFF9099A5)),
                        )
                      : TextField(
                          key: const ValueKey('session-history-search'),
                          controller: _search,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: 'Search completed workouts',
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: _search.text.isEmpty
                                ? null
                                : IconButton(
                                    tooltip: 'Clear search',
                                    onPressed: _search.clear,
                                    icon: const Icon(Icons.close_rounded),
                                  ),
                          ),
                        ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  key: const ValueKey('session-history-calendar-toggle'),
                  tooltip: _showCalendar ? 'Show list' : 'Show calendar',
                  onPressed: () =>
                      setState(() => _showCalendar = !_showCalendar),
                  icon: Icon(
                    _showCalendar
                        ? Icons.list_rounded
                        : Icons.calendar_month_rounded,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<CompletedWorkoutSession>>(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SessionErrorState(
                    title: 'Workout history could not be loaded',
                    error: snapshot.error!,
                    onRetry: _retry,
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SessionLoadingState(
                    label: 'Loading completed workouts…',
                  );
                }
                final sessions =
                    snapshot.data ?? const <CompletedWorkoutSession>[];
                return _showCalendar
                    ? WorkoutCalendar(
                        sessions: sessions,
                        onOpenSession: _openSession,
                      )
                    : _buildHistory(sessions);
              },
            ),
          ),
        ],
      ),
    );
    if (widget.embedded) return body;
    return Scaffold(
      appBar: AppBar(title: const Text('Workout History')),
      body: body,
    );
  }

  Widget _buildHistory(List<CompletedWorkoutSession> sessions) {
    final query = normalizeExerciseSearchText(_search.text);
    final items =
        <_HistoryItem>[
            ...sessions.map(_HistoryItem.session),
            ...widget.legacyQuickLogs.map(_HistoryItem.legacy),
          ].where((item) {
            if (query.isEmpty) return true;
            return normalizeExerciseSearchText(item.searchable).contains(query);
          }).toList()
          ..sort((a, b) => b.performedAt.compareTo(a.performedAt));

    if (items.isEmpty) {
      final searching = query.isNotEmpty;
      return SessionEmptyState(
        icon: searching
            ? Icons.search_off_rounded
            : Icons.history_toggle_off_rounded,
        title: searching ? 'No matching workouts' : 'No completed workouts',
        message: searching
            ? 'Try a different workout name or clear the search.'
            : 'Finished sessions and preserved legacy quick logs will appear here.',
        actionLabel: !searching && widget.onStartWorkout != null
            ? 'Start Workout'
            : null,
        onAction: !searching ? widget.onStartWorkout : null,
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 30),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = items[index];
          return item.session != null
              ? _CompletedSessionCard(
                  session: item.session!,
                  weightUnit: widget.weightUnit,
                  onTap: () => _openSession(item.session!),
                )
              : _LegacyQuickLogCard(
                  workout: item.legacy!,
                  weightUnit: widget.weightUnit,
                  onTap: widget.onOpenLegacyQuickLog == null
                      ? null
                      : () => widget.onOpenLegacyQuickLog!(item.legacy!),
                );
        },
      ),
    );
  }

  void _openSession(CompletedWorkoutSession session) {
    Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => CompletedWorkoutDetailScreen(
          userId: widget.userId,
          weightUnit: widget.weightUnit,
          repository: widget.repository,
          sessionId: session.id,
          onLocalChangeQueued: widget.onLocalChangeQueued,
        ),
      ),
    );
  }
}

class _CompletedSessionCard extends StatelessWidget {
  const _CompletedSessionCard({
    required this.session,
    required this.weightUnit,
    required this.onTap,
  });

  final CompletedWorkoutSession session;
  final String weightUnit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.fitness_center_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      SessionFormat.dateTime(session.endedAt),
                      style: const TextStyle(
                        color: Color(0xFF929CA8),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '${SessionFormat.duration(Duration(seconds: session.durationSeconds))} • '
                      '${session.exerciseCount} exercises • ${session.workingSetCount} working sets',
                      style: const TextStyle(
                        color: Color(0xFFB0B9C3),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    SessionFormat.volumeKg(session.totalVolumeKg),
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  if (session.personalRecordCount > 0) ...[
                    const SizedBox(height: 7),
                    Text(
                      '${session.personalRecordCount} PR${session.personalRecordCount == 1 ? '' : 's'}',
                      style: const TextStyle(
                        color: Color(0xFFFFBF4B),
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF727C88),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegacyQuickLogCard extends StatelessWidget {
  const _LegacyQuickLogCard({
    required this.workout,
    required this.weightUnit,
    required this.onTap,
  });

  final WorkoutEntry workout;
  final String weightUnit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.bolt_rounded, color: Color(0xFFFFBF4B)),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            workout.exerciseName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFFFBF4B,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'LEGACY QUICK LOG',
                            style: TextStyle(
                              color: Color(0xFFFFBF4B),
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${SessionFormat.dateTime(workout.performedAt)} • '
                      '${SessionFormat.number(workout.weight)} $weightUnit × ${workout.reps}',
                      style: const TextStyle(
                        color: Color(0xFF929CA8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryItem {
  const _HistoryItem._({this.session, this.legacy});

  factory _HistoryItem.session(CompletedWorkoutSession value) =>
      _HistoryItem._(session: value);
  factory _HistoryItem.legacy(WorkoutEntry value) =>
      _HistoryItem._(legacy: value);

  final CompletedWorkoutSession? session;
  final WorkoutEntry? legacy;

  DateTime get performedAt => session?.endedAt ?? legacy!.performedAt;
  String get searchable => session == null
      ? '${legacy!.exerciseName} legacy quick log'
      : '${session!.name} ${session!.notes ?? ''}';
}
