import 'package:flutter/material.dart';

import '../../../core/theme/forgefit_theme.dart';
import '../../planning/domain/planning_models.dart';
import '../../planning/presentation/exercise_picker_screen.dart';
import '../data/offline_first_session_repository.dart';
import '../domain/workout_session_models.dart';
import 'finish_workout_review_screen.dart';
import 'session_ui_widgets.dart';

typedef SessionExercisePicker =
    Future<ExerciseSelection?> Function(BuildContext context);

class ActiveWorkoutScreen extends StatefulWidget {
  const ActiveWorkoutScreen({
    super.key,
    required this.userId,
    required this.weightUnit,
    required this.repository,
    this.exercisePicker,
    this.onWorkoutFinished,
    this.onWorkoutDiscarded,
    this.onLocalChangeQueued,
  });

  final String userId;
  final String weightUnit;
  final OfflineFirstSessionRepository repository;
  final SessionExercisePicker? exercisePicker;
  final ValueChanged<CompletedWorkoutBundle>? onWorkoutFinished;
  final VoidCallback? onWorkoutDiscarded;
  final VoidCallback? onLocalChangeQueued;

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  late Stream<ActiveWorkoutBundle?> _stream;
  final Set<String> _busy = {};
  final Map<String, Future<PreviousPerformance?>> _previous = {};

  @override
  void initState() {
    super.initState();
    _stream = widget.repository.watchActiveWorkout(widget.userId);
  }

  @override
  void didUpdateWidget(covariant ActiveWorkoutScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId ||
        oldWidget.repository != widget.repository) {
      _stream = widget.repository.watchActiveWorkout(widget.userId);
      _previous.clear();
    }
  }

  Future<void> _run(String key, Future<void> Function() action) async {
    if (_busy.contains(key)) return;
    setState(() => _busy.add(key));
    try {
      await action();
      widget.onLocalChangeQueued?.call();
    } on Object catch (error) {
      if (mounted) showSessionError(context, error);
    } finally {
      if (mounted) setState(() => _busy.remove(key));
    }
  }

  Future<ExerciseSelection?> _pickExercise() {
    final picker = widget.exercisePicker;
    if (picker != null) return picker(context);
    return Navigator.of(context).push<ExerciseSelection>(
      MaterialPageRoute(
        builder: (_) => ExercisePickerScreen(userId: widget.userId),
      ),
    );
  }

  Future<void> _addExercise(ActiveWorkoutSession session) async {
    final selection = await _pickExercise();
    if (selection == null || !mounted) return;
    await _run('add-exercise', () async {
      await widget.repository.addExercise(
        userId: widget.userId,
        sessionId: session.id,
        exercise: selection,
      );
    });
  }

  Future<void> _replaceExercise(ActiveWorkoutExercise exercise) async {
    final replacement = await _pickExercise();
    if (replacement == null || !mounted) return;
    await _run('replace-${exercise.id}', () async {
      await widget.repository.replaceExercise(
        userId: widget.userId,
        exerciseId: exercise.id,
        replacement: replacement,
      );
      _previous.remove(exercise.exerciseKey);
    });
  }

  Future<void> _removeExercise(ActiveWorkoutExercise exercise) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove exercise?'),
        content: Text(
          '${exercise.exerciseName} and its active sets will be removed from this workout.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await _run('remove-${exercise.id}', () async {
      await widget.repository.removeExercise(
        userId: widget.userId,
        exerciseId: exercise.id,
      );
    });
  }

  Future<void> _editWorkout(ActiveWorkoutSession session) async {
    final draft = await showDialog<_WorkoutDraft>(
      context: context,
      builder: (_) => _WorkoutEditorDialog(session: session),
    );
    if (draft == null || !mounted) return;
    await _run('edit-workout', () async {
      await widget.repository.editActiveWorkout(
        userId: widget.userId,
        sessionId: session.id,
        name: draft.name,
        notes: draft.notes,
      );
    });
  }

  Future<void> _editExerciseNotes(ActiveWorkoutExercise exercise) async {
    final controller = TextEditingController(text: exercise.notes);
    final notes = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${exercise.exerciseName} notes'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          maxLength: 2000,
          decoration: const InputDecoration(hintText: 'Cues or reminders'),
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
    if (notes == null || !mounted) return;
    await _run('notes-${exercise.id}', () async {
      await widget.repository.editExerciseNotes(
        userId: widget.userId,
        exerciseId: exercise.id,
        notes: notes,
      );
    });
  }

  Future<void> _editSet(ActiveWorkoutSet set) async {
    final draft = await showModalBottomSheet<_SetDraft>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _SetEditorSheet(set: set, weightUnit: widget.weightUnit),
    );
    if (draft == null || !mounted) return;
    await _run('edit-set-${set.id}', () async {
      await widget.repository.editSet(
        userId: widget.userId,
        setId: set.id,
        setType: draft.type,
        weightKg: draft.weightKg,
        repetitions: draft.repetitions,
        durationSeconds: draft.durationSeconds,
        distanceMeters: draft.distanceMeters,
        rpe: draft.rpe,
        rir: draft.rir,
        notes: draft.notes,
      );
    });
  }

  Future<void> _setAction(ActiveWorkoutSet set, _SetAction action) async {
    if (action == _SetAction.edit) return _editSet(set);
    if (action == _SetAction.delete) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete set?'),
          content: const Text('This set will be removed from the workout.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }
    await _run('set-action-${set.id}', () async {
      switch (action) {
        case _SetAction.edit:
          break;
        case _SetAction.duplicate:
          await widget.repository.duplicateSet(
            userId: widget.userId,
            setId: set.id,
          );
        case _SetAction.copyWeight:
          await widget.repository.copyPreviousSetValues(
            userId: widget.userId,
            setId: set.id,
            copyWeight: true,
            copyRepetitions: false,
          );
        case _SetAction.copyReps:
          await widget.repository.copyPreviousSetValues(
            userId: widget.userId,
            setId: set.id,
            copyWeight: false,
            copyRepetitions: true,
          );
        case _SetAction.copyBoth:
          await widget.repository.copyPreviousSetValues(
            userId: widget.userId,
            setId: set.id,
          );
        case _SetAction.delete:
          await widget.repository.removeSet(
            userId: widget.userId,
            setId: set.id,
          );
      }
    });
  }

  Future<void> _toggleAllSets(ActiveWorkoutExercise exercise) => _run(
    'complete-all-${exercise.id}',
    () => widget.repository.toggleAllSetsCompleted(
      userId: widget.userId,
      exerciseId: exercise.id,
    ),
  );

  Future<void> _finish(ActiveWorkoutBundle bundle) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => FinishWorkoutReviewScreen(
          userId: widget.userId,
          weightUnit: widget.weightUnit,
          repository: widget.repository,
          activeWorkout: bundle,
          onWorkoutFinished: widget.onWorkoutFinished,
          onWorkoutDiscarded: widget.onWorkoutDiscarded,
          onLocalChangeQueued: widget.onLocalChangeQueued,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<ActiveWorkoutBundle?>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return SessionErrorState(
                title: 'Active workout could not be loaded',
                error: snapshot.error!,
                onRetry: () => setState(
                  () => _stream = widget.repository.watchActiveWorkout(
                    widget.userId,
                  ),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SessionLoadingState(
                label: 'Recovering your active workout…',
              );
            }
            final bundle = snapshot.data;
            if (bundle == null) {
              return SessionEmptyState(
                icon: Icons.fitness_center_rounded,
                title: 'No active workout',
                message:
                    'Start an empty workout or choose a template from the workout menu.',
                actionLabel: Navigator.of(context).canPop() ? 'Go back' : null,
                onAction: Navigator.of(context).canPop()
                    ? () => Navigator.pop(context)
                    : null,
              );
            }
            return _buildWorkout(context, bundle);
          },
        ),
      ),
    );
  }

  Widget _buildWorkout(BuildContext context, ActiveWorkoutBundle bundle) {
    final session = bundle.session;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 6),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Back',
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _editWorkout(session),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          'Started ${SessionFormat.dateTime(session.startedAt)}',
                          style: const TextStyle(
                            color: Color(0xFF8F99A5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              TextButton(
                key: const ValueKey('finish-workout-button'),
                onPressed: () => _finish(bundle),
                child: const Text('Finish'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 112),
            buildDefaultDragHandles: false,
            header: Column(
              children: [
                if ((session.notes ?? '').isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.sticky_note_2_outlined, size: 20),
                          const SizedBox(width: 10),
                          Expanded(child: Text(session.notes!)),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
              ],
            ),
            itemCount: bundle.exercises.length,
            onReorderItem: (oldIndex, newIndex) {
              final ids = bundle.exercises.map((item) => item.id).toList();
              final moved = ids.removeAt(oldIndex);
              ids.insert(newIndex, moved);
              _run('reorder-exercises', () async {
                await widget.repository.reorderExercises(
                  userId: widget.userId,
                  sessionId: session.id,
                  orderedExerciseIds: ids,
                );
              });
            },
            itemBuilder: (context, index) {
              final exercise = bundle.exercises[index];
              final sets = bundle.setsFor(exercise.id);
              final previous = _previous.putIfAbsent(
                exercise.exerciseKey,
                () => widget.repository.getPreviousPerformance(
                  userId: widget.userId,
                  exerciseKey: exercise.exerciseKey,
                  exerciseName: exercise.exerciseName,
                ),
              );
              return Padding(
                key: ValueKey('active-exercise-${exercise.id}'),
                padding: const EdgeInsets.only(bottom: 14),
                child: _ExerciseCard(
                  exercise: exercise,
                  sets: sets,
                  previous: previous,
                  weightUnit: widget.weightUnit,
                  index: index,
                  busy: _busy,
                  onReplace: () => _replaceExercise(exercise),
                  onRemove: () => _removeExercise(exercise),
                  onEditNotes: () => _editExerciseNotes(exercise),
                  onEditSet: _editSet,
                  onToggleAllSets: () => _toggleAllSets(exercise),
                  onSetAction: _setAction,
                  onAddSet: () => _run('add-set-${exercise.id}', () async {
                    await widget.repository.addSet(
                      userId: widget.userId,
                      exerciseId: exercise.id,
                    );
                  }),
                  onDuplicatePrevious: () =>
                      _run('duplicate-previous-${exercise.id}', () async {
                        await widget.repository.duplicatePreviousSet(
                          userId: widget.userId,
                          exerciseId: exercise.id,
                        );
                      }),
                  onReorderSets: (ids) =>
                      _run('reorder-sets-${exercise.id}', () async {
                        await widget.repository.reorderSets(
                          userId: widget.userId,
                          exerciseId: exercise.id,
                          orderedSetIds: ids,
                        );
                      }),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          decoration: const BoxDecoration(
            color: ForgeFitColors.background,
            border: Border(top: BorderSide(color: Color(0xFF242A32))),
          ),
          child: FilledButton.icon(
            key: const ValueKey('add-active-exercise-button'),
            onPressed: _busy.contains('add-exercise')
                ? null
                : () => _addExercise(session),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Exercise'),
          ),
        ),
      ],
    );
  }
}

/*class _WorkoutClockCard extends StatelessWidget {
  const _WorkoutClockCard({required this.session, required this.now});

  final ActiveWorkoutSession session;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
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
                color: ForgeFitColors.electricBlue.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.timer_outlined,
                color: ForgeFitColors.electricBlue,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Workout time',
                    style: TextStyle(color: Color(0xFF929CA8)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    SessionFormat.duration(session.elapsedAt(now)),
                    key: const ValueKey('elapsed-workout-time'),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              'Saved offline',
              style: TextStyle(color: ForgeFitColors.success, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _RestTimerCard extends StatelessWidget {
  const _RestTimerCard({
    required this.session,
    required this.now,
    required this.busy,
    required this.onAction,
    required this.onAutoStartChanged,
  });

  final ActiveWorkoutSession session;
  final DateTime now;
  final bool busy;
  final ValueChanged<_TimerAction> onAction;
  final ValueChanged<bool> onAutoStartChanged;

  @override
  Widget build(BuildContext context) {
    final remaining = session.restSecondsAt(now);
    final running = session.restTimerState == RestTimerState.running;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.hourglass_bottom_rounded,
                  color: ForgeFitColors.electricBlue,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Rest timer',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                TextButton(
                  onPressed: busy ? null : () => onAction(_TimerAction.change),
                  child: Text(
                    SessionFormat.duration(Duration(seconds: remaining)),
                    key: const ValueKey('rest-timer-value'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              alignment: WrapAlignment.center,
              children: [
                _TimerButton(
                  icon: running
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  label: running ? 'Pause' : 'Start',
                  onPressed: busy
                      ? null
                      : () => onAction(
                          running
                              ? _TimerAction.pause
                              : session.restTimerState == RestTimerState.paused
                              ? _TimerAction.resume
                              : _TimerAction.change,
                        ),
                ),
                _TimerButton(
                  icon: Icons.remove_rounded,
                  label: '15s',
                  onPressed: busy
                      ? null
                      : () => onAction(_TimerAction.subtract),
                ),
                _TimerButton(
                  icon: Icons.add_rounded,
                  label: '15s',
                  onPressed: busy ? null : () => onAction(_TimerAction.add),
                ),
                _TimerButton(
                  icon: Icons.replay_rounded,
                  label: 'Reset',
                  onPressed: busy ? null : () => onAction(_TimerAction.reset),
                ),
                _TimerButton(
                  icon: Icons.skip_next_rounded,
                  label: 'Skip',
                  onPressed: busy ? null : () => onAction(_TimerAction.skip),
                ),
              ],
            ),
            const Divider(height: 24),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: const Text('Start automatically after a completed set'),
              value: session.autoStartRestTimer,
              onChanged: busy ? null : onAutoStartChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerButton extends StatelessWidget {
  const _TimerButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onPressed,
    );
  }
}

*/

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.exercise,
    required this.sets,
    required this.previous,
    required this.weightUnit,
    required this.index,
    required this.busy,
    required this.onReplace,
    required this.onRemove,
    required this.onEditNotes,
    required this.onEditSet,
    required this.onToggleAllSets,
    required this.onSetAction,
    required this.onAddSet,
    required this.onDuplicatePrevious,
    required this.onReorderSets,
  });

  final ActiveWorkoutExercise exercise;
  final List<ActiveWorkoutSet> sets;
  final Future<PreviousPerformance?> previous;
  final String weightUnit;
  final int index;
  final Set<String> busy;
  final VoidCallback onReplace;
  final VoidCallback onRemove;
  final VoidCallback onEditNotes;
  final ValueChanged<ActiveWorkoutSet> onEditSet;
  final VoidCallback onToggleAllSets;
  final void Function(ActiveWorkoutSet, _SetAction) onSetAction;
  final VoidCallback onAddSet;
  final VoidCallback onDuplicatePrevious;
  final ValueChanged<List<String>> onReorderSets;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ReorderableDragStartListener(
                  index: index,
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.drag_indicator_rounded,
                      color: Color(0xFF6F7985),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.exerciseName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _targetSummary(exercise, weightUnit),
                        style: const TextStyle(
                          color: Color(0xFF929CA8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<_ExerciseAction>(
                  tooltip: 'Exercise actions',
                  onSelected: (action) {
                    switch (action) {
                      case _ExerciseAction.notes:
                        onEditNotes();
                      case _ExerciseAction.replace:
                        onReplace();
                      case _ExerciseAction.remove:
                        onRemove();
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: _ExerciseAction.notes,
                      child: Text('Edit notes'),
                    ),
                    PopupMenuItem(
                      value: _ExerciseAction.replace,
                      child: Text('Replace exercise'),
                    ),
                    PopupMenuItem(
                      value: _ExerciseAction.remove,
                      child: Text('Remove exercise'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              key: ValueKey('complete-all-sets-${exercise.id}'),
              onPressed: busy.contains('complete-all-${exercise.id}')
                  ? null
                  : onToggleAllSets,
              icon: Icon(
                sets.isNotEmpty && sets.every((set) => set.isCompleted)
                    ? Icons.check_circle_rounded
                    : Icons.done_all_rounded,
              ),
              label: Text(
                sets.isNotEmpty && sets.every((set) => set.isCompleted)
                    ? 'All sets complete — undo'
                    : 'Complete all valid sets',
              ),
            ),
            if ((exercise.notes ?? '').isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                exercise.notes!,
                style: const TextStyle(color: Color(0xFFB4BCC6)),
              ),
            ],
            const SizedBox(height: 12),
            FutureBuilder<PreviousPerformance?>(
              future: previous,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator(minHeight: 2);
                }
                if (snapshot.hasError) {
                  return const Text(
                    'Previous performance unavailable',
                    style: TextStyle(color: Color(0xFF8F99A5), fontSize: 12),
                  );
                }
                final performance = snapshot.data;
                if (performance == null) {
                  return const Text(
                    'No previous completed performance',
                    style: TextStyle(color: Color(0xFF8F99A5), fontSize: 12),
                  );
                }
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ForgeFitColors.surfaceHigh,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Previous • ${SessionFormat.date(performance.performedAt)}\n${_previousSummary(performance, weightUnit)}',
                    style: const TextStyle(
                      color: Color(0xFFAFB8C2),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            if (sets.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'No sets yet',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF8F99A5)),
                ),
              )
            else
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                buildDefaultDragHandles: false,
                itemCount: sets.length,
                onReorderItem: (oldIndex, newIndex) {
                  final ids = sets.map((item) => item.id).toList();
                  final moved = ids.removeAt(oldIndex);
                  ids.insert(newIndex, moved);
                  onReorderSets(ids);
                },
                itemBuilder: (context, setIndex) {
                  final set = sets[setIndex];
                  return _ActiveSetTile(
                    key: ValueKey('active-set-${set.id}'),
                    set: set,
                    displayIndex: setIndex + 1,
                    weightUnit: weightUnit,
                    dragIndex: setIndex,
                    onEdit: () => onEditSet(set),
                    onAction: (action) => onSetAction(set, action),
                  );
                },
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onAddSet,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add Set'),
                  ),
                ),
                const SizedBox(width: 9),
                IconButton.filledTonal(
                  tooltip: 'Duplicate previous set',
                  onPressed: onDuplicatePrevious,
                  icon: const Icon(Icons.copy_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveSetTile extends StatelessWidget {
  const _ActiveSetTile({
    super.key,
    required this.set,
    required this.displayIndex,
    required this.weightUnit,
    required this.dragIndex,
    required this.onEdit,
    required this.onAction,
  });

  final ActiveWorkoutSet set;
  final int displayIndex;
  final String weightUnit;
  final int dragIndex;
  final VoidCallback onEdit;
  final ValueChanged<_SetAction> onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
      decoration: BoxDecoration(
        color: set.isCompleted
            ? ForgeFitColors.success.withValues(alpha: 0.09)
            : ForgeFitColors.surfaceHigh,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: set.isCompleted
              ? ForgeFitColors.success.withValues(alpha: 0.3)
              : const Color(0xFF29313A),
        ),
      ),
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: dragIndex,
            child: const Padding(
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.drag_indicator_rounded,
                size: 19,
                color: Color(0xFF6F7985),
              ),
            ),
          ),
          SizedBox(
            width: 29,
            child: Text(
              '$displayIndex',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: InkWell(
              onTap: onEdit,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _setSummary(set, weightUnit),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      set.setType.label,
                      style: const TextStyle(
                        color: Color(0xFF8F99A5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuButton<_SetAction>(
            tooltip: 'Set actions',
            onSelected: onAction,
            itemBuilder: (_) => const [
              PopupMenuItem(value: _SetAction.edit, child: Text('Edit set')),
              PopupMenuItem(
                value: _SetAction.duplicate,
                child: Text('Duplicate set'),
              ),
              PopupMenuItem(
                value: _SetAction.copyWeight,
                child: Text('Copy previous weight'),
              ),
              PopupMenuItem(
                value: _SetAction.copyReps,
                child: Text('Copy previous reps'),
              ),
              PopupMenuItem(
                value: _SetAction.copyBoth,
                child: Text('Copy previous weight + reps'),
              ),
              PopupMenuItem(
                value: _SetAction.delete,
                child: Text('Delete set'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkoutEditorDialog extends StatefulWidget {
  const _WorkoutEditorDialog({required this.session});

  final ActiveWorkoutSession session;

  @override
  State<_WorkoutEditorDialog> createState() => _WorkoutEditorDialogState();
}

class _WorkoutEditorDialogState extends State<_WorkoutEditorDialog> {
  late final TextEditingController _name;
  late final TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.session.name);
    _notes = TextEditingController(text: widget.session.notes);
  }

  @override
  void dispose() {
    _name.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Workout details'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              maxLength: 120,
              decoration: const InputDecoration(labelText: 'Workout name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notes,
              maxLength: 4000,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Workout notes (optional)',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _name.text.trim().isEmpty
              ? null
              : () => Navigator.pop(
                  context,
                  _WorkoutDraft(_name.text.trim(), _notes.text.trim()),
                ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _SetEditorSheet extends StatefulWidget {
  const _SetEditorSheet({required this.set, required this.weightUnit});

  final ActiveWorkoutSet set;
  final String weightUnit;

  @override
  State<_SetEditorSheet> createState() => _SetEditorSheetState();
}

class _SetEditorSheetState extends State<_SetEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late WorkoutSetType _type;
  late final TextEditingController _weight;
  late final TextEditingController _reps;
  late final TextEditingController _duration;
  late final TextEditingController _distance;
  late final TextEditingController _rpe;
  late final TextEditingController _rir;
  late final TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    final set = widget.set;
    _type = set.setType;
    _weight = TextEditingController(
      text: set.weightKg == null
          ? ''
          : SessionFormat.number(
              SessionFormat.weightFromKg(set.weightKg!, widget.weightUnit),
              decimals: 2,
            ),
    );
    _reps = TextEditingController(text: set.repetitions?.toString() ?? '');
    _duration = TextEditingController(
      text: set.durationSeconds?.toString() ?? '',
    );
    _distance = TextEditingController(
      text: set.distanceMeters?.toString() ?? '',
    );
    _rpe = TextEditingController(text: set.rpe?.toString() ?? '');
    _rir = TextEditingController(text: set.rir?.toString() ?? '');
    _notes = TextEditingController(text: set.notes ?? '');
  }

  @override
  void dispose() {
    for (final controller in [
      _weight,
      _reps,
      _duration,
      _distance,
      _rpe,
      _rir,
      _notes,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  double? _double(String value) =>
      value.trim().isEmpty ? null : double.tryParse(value.trim());
  int? _int(String value) =>
      value.trim().isEmpty ? null : int.tryParse(value.trim());

  String? _validateNonNegative(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final number = double.tryParse(value.trim());
    if (number == null || number < 0) return 'Enter zero or a positive value';
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final rpe = _double(_rpe.text);
    final rir = _double(_rir.text);
    if (rpe != null && (rpe < 1 || rpe > 10)) {
      showSessionError(context, 'RPE must be between 1 and 10.');
      return;
    }
    if (rir != null && (rir < 0 || rir > 10)) {
      showSessionError(context, 'RIR must be between 0 and 10.');
      return;
    }
    Navigator.pop(
      context,
      _SetDraft(
        type: _type,
        weightKg: _double(_weight.text) == null
            ? null
            : SessionFormat.weightToKg(
                _double(_weight.text)!,
                widget.weightUnit,
              ),
        repetitions: _int(_reps.text),
        durationSeconds: _int(_duration.text),
        distanceMeters: _double(_distance.text),
        rpe: rpe,
        rir: rir,
        notes: _notes.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        18,
        12,
        18,
        18 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A535E),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Edit set',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<WorkoutSetType>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Set type'),
                items: WorkoutSetType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _type = value ?? _type),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _weight,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: _validateNonNegative,
                      decoration: InputDecoration(
                        labelText:
                            'Weight ${widget.weightUnit == 'lb' ? 'lb' : 'kg'}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _reps,
                      keyboardType: TextInputType.number,
                      validator: _validateNonNegative,
                      decoration: const InputDecoration(labelText: 'Reps'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _duration,
                      keyboardType: TextInputType.number,
                      validator: _validateNonNegative,
                      decoration: const InputDecoration(
                        labelText: 'Duration sec',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _distance,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: _validateNonNegative,
                      decoration: const InputDecoration(
                        labelText: 'Distance m',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _rpe,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'RPE (optional)',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _rir,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'RIR (optional)',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notes,
                maxLines: 3,
                maxLength: 2000,
                decoration: const InputDecoration(
                  labelText: 'Set note (optional)',
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(onPressed: _save, child: const Text('Save Set')),
            ],
          ),
        ),
      ),
    );
  }
}

enum _ExerciseAction { notes, replace, remove }

enum _SetAction { edit, duplicate, copyWeight, copyReps, copyBoth, delete }

class _WorkoutDraft {
  const _WorkoutDraft(this.name, this.notes);
  final String name;
  final String notes;
}

class _SetDraft {
  const _SetDraft({
    required this.type,
    required this.weightKg,
    required this.repetitions,
    required this.durationSeconds,
    required this.distanceMeters,
    required this.rpe,
    required this.rir,
    required this.notes,
  });

  final WorkoutSetType type;
  final double? weightKg;
  final int? repetitions;
  final int? durationSeconds;
  final double? distanceMeters;
  final double? rpe;
  final double? rir;
  final String notes;
}

String _targetSummary(ActiveWorkoutExercise exercise, String unit) {
  final parts = <String>[
    '${exercise.plannedWorkingSets} working',
    '${exercise.minTargetReps}-${exercise.maxTargetReps} reps',
  ];
  if (exercise.plannedWarmupSets > 0) {
    parts.insert(0, '${exercise.plannedWarmupSets} warm-up');
  }
  if (exercise.targetWeightKg case final weight?) {
    parts.add('${SessionFormat.weight(weight, unit)} target');
  }
  return parts.join(' • ');
}

String _setSummary(ActiveWorkoutSet set, String unit) {
  final parts = <String>[];
  if (set.weightKg case final value?) {
    parts.add(SessionFormat.weight(value, unit));
  }
  if (set.repetitions case final value?) {
    parts.add('$value reps');
  }
  if (set.durationSeconds case final value?) {
    parts.add('${value}s');
  }
  if (set.distanceMeters case final value?) {
    parts.add('${SessionFormat.number(value)} m');
  }
  if (set.rpe case final value?) {
    parts.add('RPE ${SessionFormat.number(value)}');
  }
  if (set.rir case final value?) {
    parts.add('RIR ${SessionFormat.number(value)}');
  }
  return parts.isEmpty ? 'Tap to enter performance' : parts.join(' • ');
}

String _previousSummary(PreviousPerformance performance, String unit) {
  if (performance.sets.isEmpty) {
    return performance.isLegacyQuickLog
        ? 'Legacy quick-log entry'
        : 'No completed sets';
  }
  return performance.sets
      .map((set) {
        final parts = <String>[];
        if (set.weightKg case final weight?) {
          parts.add(SessionFormat.weight(weight, unit));
        }
        if (set.repetitions case final reps?) {
          parts.add('$reps reps');
        }
        if (set.rpe case final rpe?) {
          parts.add('RPE ${SessionFormat.number(rpe)}');
        }
        if (set.rir case final rir?) {
          parts.add('RIR ${SessionFormat.number(rir)}');
        }
        return parts.join(' × ');
      })
      .join('  |  ');
}
