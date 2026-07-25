import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/providers.dart';
import 'package:forgefit/core/theme/forgefit_theme.dart';
import 'package:forgefit/features/sessions/domain/workout_session_models.dart';
import 'package:forgefit/features/workouts/domain/workout_entry.dart';
import 'package:forgefit/features/workouts/presentation/sync_status_chip.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({
    super.key,
    required this.userId,
    required this.displayName,
    required this.weightUnit,
    required this.onStartWorkout,
    required this.onContinueWorkout,
    required this.onQuickLog,
    required this.onShowTemplates,
    required this.onShowHistory,
    required this.onShowCalendar,
    required this.onShowProgress,
  });

  final String userId;
  final String displayName;
  final String weightUnit;
  final VoidCallback onStartWorkout;
  final VoidCallback onContinueWorkout;
  final VoidCallback onQuickLog;
  final VoidCallback onShowTemplates;
  final VoidCallback onShowHistory;
  final VoidCallback onShowCalendar;
  final VoidCallback onShowProgress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(workoutHistoryProvider(userId));
    final activeWorkout = ref.watch(activeWorkoutProvider(userId));
    final completedSessions = ref.watch(
      completedWorkoutSessionsProvider(userId),
    );
    return RefreshIndicator(
      onRefresh: () async {
        try {
          await ref.read(workoutRepositoryProvider).restore(userId);
        } on Object {
          // Pull-to-refresh still retries the pending upload queue below.
        }
        try {
          await ref.read(sessionRepositoryProvider).restoreFromCloud(userId);
        } on Object {
          // Local active and completed sessions remain visible while offline.
        }
        await ref.read(syncCoordinatorProvider).sync(userId);
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
            sliver: SliverList.list(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: SyncStatusChip(userId: userId),
                ),
                const SizedBox(height: 12),
                activeWorkout.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (active) => active == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _ContinueWorkoutCard(
                            active: active,
                            onPressed: onContinueWorkout,
                          ),
                        ),
                ),
                completedSessions.when(
                  loading: () => const _SummaryLoading(),
                  error: (_, _) => _SummaryError(
                    onRetry: () => ref.invalidate(
                      completedWorkoutSessionsProvider(userId),
                    ),
                  ),
                  data: (items) => _WeekTrainingCard(
                    sessions: items,
                    onShowCalendar: onShowCalendar,
                  ),
                ),
                const SizedBox(height: 14),
                _StartWorkoutHero(
                  onStartWorkout: onStartWorkout,
                  onQuickLog: onQuickLog,
                ),
                const SizedBox(height: 14),
                _TemplatesShortcut(onPressed: onShowTemplates),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _HomeShortcut(
                        icon: Icons.insights_outlined,
                        label: 'Progress',
                        onPressed: onShowProgress,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _HomeShortcut(
                        icon: Icons.history_rounded,
                        label: 'Workout History',
                        onPressed: onShowHistory,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 20),
                completedSessions.when(
                  loading: () => const _SummaryLoading(),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (items) => _WorkoutSummary(
                    sessions: items,
                    onShowCalendar: onShowCalendar,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Recent Workouts',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onShowHistory,
                      child: const Text('View all'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                completedSessions.when(
                  loading: () => const _LatestLoading(),
                  error: (_, _) => const _LatestEmpty(
                    text: 'Completed workouts are unavailable.',
                  ),
                  data: (items) => items.isEmpty
                      ? const _LatestEmpty(
                          text: 'Finished workouts will appear here.',
                        )
                      : Column(
                          children: items
                              .take(3)
                              .map(
                                (session) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _RecentSessionCard(session: session),
                                ),
                              )
                              .toList(growable: false),
                        ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Latest quick log',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onShowHistory,
                      child: const Text('Legacy history'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                workouts.when(
                  loading: () => const _LatestLoading(),
                  error: (_, _) => const _LatestEmpty(
                    text: 'Latest workout is unavailable.',
                  ),
                  data: (items) => items.isEmpty
                      ? const _LatestEmpty(
                          text: 'Your first logged workout will appear here.',
                        )
                      : _LatestWorkout(
                          workout: items.first,
                          weightUnit: weightUnit,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StartWorkoutHero extends StatelessWidget {
  const _StartWorkoutHero({
    required this.onStartWorkout,
    required this.onQuickLog,
  });

  final VoidCallback onStartWorkout;
  final VoidCallback onQuickLog;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: onStartWorkout,
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('START WORKOUT'),
        ),
        const SizedBox(height: 2),
        TextButton.icon(
          onPressed: onQuickLog,
          icon: const Icon(Icons.flash_on_outlined, size: 18),
          label: const Text('Quick log one set'),
        ),
      ],
    );
  }
}

class _TemplatesShortcut extends StatelessWidget {
  const _TemplatesShortcut({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.view_list_rounded, color: accent),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Workout templates',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Build and organise your own routines.',
                      style: TextStyle(color: Color(0xFF929DA9), fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF929DA9)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContinueWorkoutCard extends StatelessWidget {
  const _ContinueWorkoutCard({required this.active, required this.onPressed});

  final ActiveWorkoutBundle active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final completedSets = active.sets.where((set) => set.isCompleted).length;
    return Card(
      color: accent.withValues(alpha: 0.13),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(Icons.play_circle_fill_rounded, color: accent, size: 42),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONTINUE WORKOUT',
                      style: TextStyle(
                        color: accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      active.session.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${active.exercises.length} exercises • $completedSets completed sets',
                      style: const TextStyle(color: Color(0xFF9BA7B4)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeShortcut extends StatelessWidget {
  const _HomeShortcut({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 9),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentSessionCard extends StatelessWidget {
  const _RecentSessionCard({required this.session});

  final CompletedWorkoutSession session;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: Theme.of(context).colorScheme.primary,
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
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat(
                      'd MMM • h:mm a',
                    ).format(session.endedAt.toLocal()),
                    style: const TextStyle(
                      color: Color(0xFF909AA6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${session.workingSetCount} sets',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekTrainingCard extends StatelessWidget {
  const _WeekTrainingCard({
    required this.sessions,
    required this.onShowCalendar,
  });

  final List<CompletedWorkoutSession> sessions;
  final VoidCallback onShowCalendar;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().toLocal();
    final start = DateTime(today.year, today.month, today.day - 6);
    final end = DateTime(today.year, today.month, today.day + 1);
    final thisWeek = sessions
        .where(
          (session) =>
              !session.isDeleted &&
              !session.endedAt.toLocal().isBefore(start) &&
              session.endedAt.toLocal().isBefore(end),
        )
        .toList(growable: false);
    final sets = thisWeek.fold<int>(
      0,
      (total, session) => total + session.workingSetCount,
    );
    final volume = thisWeek.fold<double>(
      0,
      (total, session) => total + session.totalVolumeKg,
    );
    final completedDays = {
      for (final session in thisWeek)
        DateTime(
          session.endedAt.toLocal().year,
          session.endedAt.toLocal().month,
          session.endedAt.toLocal().day,
        ),
    };
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onShowCalendar,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'THIS WEEK',
                  style: TextStyle(
                    color: ForgeFitColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _WeekMetric(
                      value: '${thisWeek.length}',
                      label: 'Workouts',
                    ),
                  ),
                  Expanded(
                    child: _WeekMetric(value: '$sets', label: 'Sets'),
                  ),
                  Expanded(
                    child: _WeekMetric(
                      value: _compactVolume(volume),
                      label: 'kg Volume',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  for (var index = 0; index < 7; index++)
                    Expanded(
                      child: _WeekDay(
                        day: start.add(Duration(days: index)),
                        completed: completedDays.contains(
                          DateTime(start.year, start.month, start.day + index),
                        ),
                        isToday: DateUtils.isSameDay(
                          start.add(Duration(days: index)),
                          today,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _compactVolume(double value) {
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}k';
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
  }
}

class _WeekMetric extends StatelessWidget {
  const _WeekMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
      ),
      const SizedBox(height: 2),
      Text(
        label,
        style: const TextStyle(
          color: ForgeFitColors.textTertiary,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _WeekDay extends StatelessWidget {
  const _WeekDay({
    required this.day,
    required this.completed,
    required this.isToday,
  });

  final DateTime day;
  final bool completed;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        Text(
          DateFormat('E').format(day).substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: ForgeFitColors.textTertiary,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isToday ? accent.withValues(alpha: 0.18) : null,
            shape: BoxShape.circle,
            border: Border.all(
              color: completed
                  ? accent
                  : isToday
                  ? accent.withValues(alpha: 0.55)
                  : ForgeFitColors.border,
            ),
          ),
          child: completed
              ? Icon(Icons.check_rounded, size: 15, color: accent)
              : Text(
                  '${day.day}',
                  style: const TextStyle(
                    color: ForgeFitColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ],
    );
  }
}

class HomeWorkoutStatistics {
  const HomeWorkoutStatistics({
    required this.todayCount,
    required this.allTimeCount,
  });

  final int todayCount;
  final int allTimeCount;

  /// Counts a device-local calendar day by comparing UTC instants against the
  /// UTC boundaries of that local day. Tests can inject [localDayBounds] so
  /// they never depend on the host runner's timezone.
  factory HomeWorkoutStatistics.fromCompletedSessions(
    List<CompletedWorkoutSession> sessions, {
    DateTime? now,
    LocalDayBounds? localDayBounds,
  }) {
    final bounds =
        localDayBounds ??
        LocalDayBounds.forDeviceLocalNow(now ?? DateTime.now());
    final completedSessions = sessions
        .where((session) => !session.isDeleted)
        .toList(growable: false);
    final todayCount = completedSessions
        .where((session) => bounds.includes(session.endedAt))
        .length;
    return HomeWorkoutStatistics(
      todayCount: todayCount,
      allTimeCount: completedSessions.length,
    );
  }
}

/// The UTC instants that bound one user/device-local calendar day.
class LocalDayBounds {
  const LocalDayBounds({
    required this.startInclusiveUtc,
    required this.endExclusiveUtc,
  });

  final DateTime startInclusiveUtc;
  final DateTime endExclusiveUtc;

  factory LocalDayBounds.forDeviceLocalNow(DateTime now) {
    final localNow = now.toLocal();
    final startLocal = DateTime(localNow.year, localNow.month, localNow.day);
    final nextStartLocal = DateTime(
      localNow.year,
      localNow.month,
      localNow.day + 1,
    );
    return LocalDayBounds(
      startInclusiveUtc: startLocal.toUtc(),
      endExclusiveUtc: nextStartLocal.toUtc(),
    );
  }

  bool includes(DateTime instant) {
    final utcInstant = instant.toUtc();
    return !utcInstant.isBefore(startInclusiveUtc) &&
        utcInstant.isBefore(endExclusiveUtc);
  }
}

class _WorkoutSummary extends StatelessWidget {
  const _WorkoutSummary({required this.sessions, required this.onShowCalendar});

  final List<CompletedWorkoutSession> sessions;
  final VoidCallback onShowCalendar;

  @override
  Widget build(BuildContext context) {
    final statistics = HomeWorkoutStatistics.fromCompletedSessions(sessions);
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.today_outlined,
            label: 'TODAY',
            value: '${statistics.todayCount}',
            detail: statistics.todayCount == 1 ? 'workout' : 'workouts',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            key: const ValueKey('home-all-time-calendar'),
            icon: Icons.repeat_rounded,
            label: 'ALL TIME',
            value: '${statistics.allTimeCount}',
            detail: statistics.allTimeCount == 1 ? 'workout' : 'workouts',
            onTap: onShowCalendar,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.detail,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final String detail;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF8E98A4),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(detail, style: const TextStyle(color: Color(0xFF929CA8))),
            ],
          ),
        ),
      ),
    );
  }
}

class _LatestWorkout extends StatelessWidget {
  const _LatestWorkout({required this.workout, required this.weightUnit});

  final WorkoutEntry workout;
  final String weightUnit;

  @override
  Widget build(BuildContext context) {
    final value = workout.weight == workout.weight.roundToDouble()
        ? workout.weight.toStringAsFixed(0)
        : workout.weight.toStringAsFixed(1);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.bolt_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.exerciseName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat(
                      'd MMM, h:mm a',
                    ).format(workout.performedAt.toLocal()),
                    style: const TextStyle(color: Color(0xFF909AA6)),
                  ),
                ],
              ),
            ),
            Text(
              '$value $weightUnit x ${workout.reps}',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryLoading extends StatelessWidget {
  const _SummaryLoading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 126,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _SummaryError extends StatelessWidget {
  const _SummaryError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onRetry,
      icon: const Icon(Icons.refresh_rounded),
      label: const Text('Reload workout summary'),
    );
  }
}

class _LatestLoading extends StatelessWidget {
  const _LatestLoading();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: SizedBox(
        height: 92,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _LatestEmpty extends StatelessWidget {
  const _LatestEmpty({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Row(
          children: [
            const Icon(Icons.inbox_outlined, color: Color(0xFF7F8995)),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Color(0xFF9AA4B0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
