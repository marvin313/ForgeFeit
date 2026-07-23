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
    required this.onShowPersonalRecords,
  });

  final String userId;
  final String displayName;
  final String weightUnit;
  final VoidCallback onStartWorkout;
  final VoidCallback onContinueWorkout;
  final VoidCallback onQuickLog;
  final VoidCallback onShowTemplates;
  final VoidCallback onShowHistory;
  final VoidCallback onShowPersonalRecords;

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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _greeting(),
                            style: const TextStyle(
                              color: Color(0xFF8F99A5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    SyncStatusChip(userId: userId),
                  ],
                ),
                const SizedBox(height: 26),
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
                        icon: Icons.emoji_events_outlined,
                        label: 'Personal Records',
                        onPressed: onShowPersonalRecords,
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
                workouts.when(
                  loading: () => const _SummaryLoading(),
                  error: (_, _) => _SummaryError(
                    onRetry: () =>
                        ref.invalidate(workoutHistoryProvider(userId)),
                  ),
                  data: (items) =>
                      _WorkoutSummary(workouts: items, weightUnit: weightUnit),
                ),
                const SizedBox(height: 28),
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

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'GOOD MORNING';
    if (hour < 18) return 'GOOD AFTERNOON';
    return 'GOOD EVENING';
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF006DAD), Color(0xFF00A8FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: ForgeFitColors.electricBlue.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'READY TO TRAIN?',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: const Color(0xFFD9F3FF),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'Start your workout',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Choose any template or train without one.',
                      style: TextStyle(color: Color(0xFFD9F3FF), height: 1.35),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.fitness_center_rounded,
                color: Color(0xFFD9F3FF),
                size: 54,
              ),
            ],
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onStartWorkout,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF07131A),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Start Workout'),
          ),
          TextButton.icon(
            onPressed: onQuickLog,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFEAF8FF),
              minimumSize: const Size.fromHeight(44),
            ),
            icon: const Icon(Icons.flash_on_outlined, size: 19),
            label: const Text('Quick log one set'),
          ),
        ],
      ),
    );
  }
}

class _TemplatesShortcut extends StatelessWidget {
  const _TemplatesShortcut({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
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
                  color: ForgeFitColors.electricBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.view_list_rounded,
                  color: ForgeFitColors.electricBlue,
                ),
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
    final completedSets = active.sets.where((set) => set.isCompleted).length;
    return Card(
      color: ForgeFitColors.electricBlue.withValues(alpha: 0.13),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              const Icon(
                Icons.play_circle_fill_rounded,
                color: ForgeFitColors.electricBlue,
                size: 42,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CONTINUE WORKOUT',
                      style: TextStyle(
                        color: ForgeFitColors.electricBlue,
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
              Icon(icon, color: ForgeFitColors.electricBlue),
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
            const Icon(
              Icons.check_circle_rounded,
              color: ForgeFitColors.electricBlue,
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

class _WorkoutSummary extends StatelessWidget {
  const _WorkoutSummary({required this.workouts, required this.weightUnit});

  final List<WorkoutEntry> workouts;
  final String weightUnit;

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    final todayCount = workouts
        .where(
          (workout) =>
              DateUtils.dateOnly(workout.performedAt.toLocal()) == today,
        )
        .length;
    final totalReps = workouts.fold<int>(0, (sum, item) => sum + item.reps);
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.today_outlined,
            label: 'TODAY',
            value: '$todayCount',
            detail: todayCount == 1 ? 'workout' : 'workouts',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            icon: Icons.repeat_rounded,
            label: 'ALL TIME',
            value: '$totalReps',
            detail: 'reps | $weightUnit',
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.detail,
  });

  final IconData icon;
  final String label;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Card(
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
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            Text(detail, style: const TextStyle(color: Color(0xFF929CA8))),
          ],
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
