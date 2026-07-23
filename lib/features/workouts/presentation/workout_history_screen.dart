import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/providers.dart';
import 'package:forgefit/features/workouts/domain/workout_entry.dart';
import 'package:forgefit/features/workouts/presentation/sync_status_chip.dart';
import 'package:intl/intl.dart';

class WorkoutHistoryScreen extends ConsumerWidget {
  const WorkoutHistoryScreen({
    super.key,
    required this.userId,
    required this.weightUnit,
    required this.onAddWorkout,
  });

  final String userId;
  final String weightUnit;
  final VoidCallback onAddWorkout;

  Future<void> _retry(WidgetRef ref) async {
    try {
      await ref.read(workoutRepositoryProvider).restore(userId);
    } on Object {
      // Local history remains available when the restore request cannot run.
    }
    await ref.read(syncCoordinatorProvider).sync(userId);
    ref.invalidate(workoutHistoryProvider(userId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workouts = ref.watch(workoutHistoryProvider(userId));
    return RefreshIndicator(
      onRefresh: () => _retry(ref),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
            sliver: SliverToBoxAdapter(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Workout history',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Stored on this device and restored from your account.',
                          style: TextStyle(color: Color(0xFF949EAA)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  SyncStatusChip(userId: userId),
                ],
              ),
            ),
          ),
          ...workouts.when(
            loading: () => const [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Loading your workout history…',
                        style: TextStyle(color: Color(0xFF9AA4B0)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            error: (error, _) => [
              SliverFillRemaining(
                hasScrollBody: false,
                child: _HistoryError(
                  message: error.toString(),
                  onRetry: () => _retry(ref),
                ),
              ),
            ],
            data: (items) => items.isEmpty
                ? [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyHistory(onAddWorkout: onAddWorkout),
                    ),
                  ]
                : [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                      sliver: SliverList.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) => _WorkoutCard(
                          workout: items[index],
                          weightUnit: weightUnit,
                        ),
                      ),
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({required this.workout, required this.weightUnit});

  final WorkoutEntry workout;
  final String weightUnit;

  @override
  Widget build(BuildContext context) {
    final weight = workout.weight;
    final formattedWeight = weight == weight.roundToDouble()
        ? weight.toStringAsFixed(0)
        : weight.toStringAsFixed(1);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
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
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.exerciseName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat(
                      'EEE, d MMM • h:mm a',
                    ).format(workout.performedAt.toLocal()),
                    style: const TextStyle(
                      color: Color(0xFF8E98A4),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$formattedWeight $weightUnit',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  '${workout.reps} reps',
                  style: const TextStyle(
                    color: Color(0xFFA2ABB5),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory({required this.onAddWorkout});

  final VoidCallback onAddWorkout;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history_toggle_off_rounded,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                'No workouts yet',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              const Text(
                'Log your first set. It will appear here immediately, even without internet.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF98A2AE), height: 1.45),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onAddWorkout,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Log a workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryError extends StatelessWidget {
  const _HistoryError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            const Text(
              'Workout history could not be loaded.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF9BA5B0)),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
