import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/providers.dart';
import 'package:forgefit/core/theme/forgefit_theme.dart';
import 'package:forgefit/features/planning/domain/planning_models.dart';
import 'package:forgefit/features/planning/presentation/planning_widgets.dart';
import 'package:forgefit/features/sessions/data/offline_first_session_repository.dart';
import 'package:forgefit/features/sessions/domain/workout_session_models.dart';
import 'package:forgefit/features/sessions/presentation/active_workout_screen.dart';
import 'package:forgefit/features/sessions/presentation/finish_workout_review_screen.dart';
import 'package:forgefit/features/workouts/presentation/workout_form_screen.dart';

class StartWorkoutScreen extends ConsumerStatefulWidget {
  const StartWorkoutScreen({
    super.key,
    required this.userId,
    required this.weightUnit,
  });

  final String userId;
  final String weightUnit;

  @override
  ConsumerState<StartWorkoutScreen> createState() => _StartWorkoutScreenState();
}

class _StartWorkoutScreenState extends ConsumerState<StartWorkoutScreen> {
  final _searchController = TextEditingController();
  PlanningTemplateScope _scope = const PlanningTemplateScope.all();
  String _query = '';
  bool _starting = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showTemplatePreview(
    WorkoutTemplate template,
    String splitName,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: ForgeFitColors.surface,
      builder: (_) => _TemplatePreviewSheet(
        userId: widget.userId,
        weightUnit: widget.weightUnit,
        template: template,
        splitName: splitName,
        onStart: () => _startFromTemplate(template),
      ),
    );
  }

  OfflineFirstSessionRepository get _sessions =>
      ref.read(sessionRepositoryProvider);

  Future<void> _startEmptyWorkout() async {
    final draft = await showDialog<_EmptyWorkoutDraft>(
      context: context,
      builder: (_) => const _EmptyWorkoutDialog(),
    );
    if (draft == null || !mounted) return;
    await _startWorkout(
      () => _sessions.startEmptyWorkout(
        userId: widget.userId,
        name: draft.name,
        notes: draft.notes,
        weightUnit: widget.weightUnit,
      ),
    );
  }

  Future<void> _startFromTemplate(WorkoutTemplate template) => _startWorkout(
    () => _sessions.startWorkoutFromTemplate(
      userId: widget.userId,
      templateId: template.id,
      weightUnit: widget.weightUnit,
    ),
  );

  Future<void> _startWorkout(
    Future<ActiveWorkoutBundle> Function() create,
  ) async {
    if (_starting) return;
    setState(() => _starting = true);
    try {
      var active = await _sessions.getActiveWorkout(widget.userId);
      if (active != null && mounted) {
        final action = await _activeWorkoutChoice(active);
        if (!mounted || action == _ActiveWorkoutChoice.cancel) return;
        switch (action) {
          case _ActiveWorkoutChoice.continueWorkout:
            await _openActiveWorkout();
            return;
          case _ActiveWorkoutChoice.finishWorkout:
            await Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (_) => FinishWorkoutReviewScreen(
                  userId: widget.userId,
                  weightUnit: widget.weightUnit,
                  repository: _sessions,
                  activeWorkout: active!,
                  onLocalChangeQueued: _requestSync,
                ),
              ),
            );
          case _ActiveWorkoutChoice.discardWorkout:
            await _sessions.discardActiveWorkout(
              userId: widget.userId,
              sessionId: active.session.id,
            );
            _requestSync();
          case _ActiveWorkoutChoice.cancel:
            return;
        }
        active = await _sessions.getActiveWorkout(widget.userId);
        if (active != null) return;
      }
      await create();
      _requestSync();
      if (mounted) await _openActiveWorkout();
    } on Object catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Workout could not be started: $error')),
      );
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  Future<_ActiveWorkoutChoice> _activeWorkoutChoice(
    ActiveWorkoutBundle active,
  ) async {
    return await showDialog<_ActiveWorkoutChoice>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Workout already in progress'),
            content: Text(
              '“${active.session.name}” is safely saved on this device. What would you like to do?',
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(context, _ActiveWorkoutChoice.cancel),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pop(context, _ActiveWorkoutChoice.discardWorkout),
                child: const Text('Discard Current'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pop(context, _ActiveWorkoutChoice.finishWorkout),
                child: const Text('Finish Current'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(
                  context,
                  _ActiveWorkoutChoice.continueWorkout,
                ),
                child: const Text('Continue Current'),
              ),
            ],
          ),
        ) ??
        _ActiveWorkoutChoice.cancel;
  }

  Future<void> _openActiveWorkout() => Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (_) => ActiveWorkoutScreen(
        userId: widget.userId,
        weightUnit: widget.weightUnit,
        repository: _sessions,
        onLocalChangeQueued: _requestSync,
      ),
    ),
  );

  void _requestSync() {
    unawaited(
      ref
          .read(syncCoordinatorProvider)
          .sync(widget.userId, forceAfterCurrent: true),
    );
  }

  Future<void> _refresh() => refreshPlanning(ref, widget.userId);

  void _retry() {
    ref.invalidate(workoutSplitsProvider(widget.userId));
    ref.invalidate(workoutTemplatesProvider(widget.userId));
    unawaited(_refresh());
  }

  @override
  Widget build(BuildContext context) {
    final splitsAsync = ref.watch(workoutSplitsProvider(widget.userId));
    final templatesAsync = ref.watch(workoutTemplatesProvider(widget.userId));
    final headerSplits = splitsAsync.asData?.value ?? const <WorkoutSplit>[];
    final selectedScope = effectivePlanningScope(_scope, headerSplits);

    return Scaffold(
      appBar: AppBar(title: const Text('Start Workout')),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            key: const PageStorageKey('start-workout-template-list'),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                sliver: SliverList.list(
                  children: [
                    Text(
                      'Choose a template',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Choose any template or begin without one. Splits only organise this list.',
                      style: TextStyle(color: Color(0xFF949EAA), height: 1.45),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      key: const Key('start-empty-workout'),
                      onPressed: _starting ? null : _startEmptyWorkout,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Start Empty Workout'),
                    ),
                    const SizedBox(height: 16),
                    PlanningSearchField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _query = value),
                    ),
                    const SizedBox(height: 14),
                    PlanningTemplateScopeBar(
                      splits: headerSplits,
                      selected: selectedScope,
                      onChanged: (scope) => setState(() => _scope = scope),
                    ),
                  ],
                ),
              ),
              ...splitsAsync.when<List<Widget>>(
                loading: () => const [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: PlanningLoadingState(),
                  ),
                ],
                error: (error, _) => [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: PlanningStateMessage(
                      icon: Icons.error_outline_rounded,
                      title: 'Splits could not be loaded',
                      message: error.toString(),
                      actionLabel: 'Try again',
                      onAction: _retry,
                    ),
                  ),
                ],
                data: (splits) => templatesAsync.when<List<Widget>>(
                  loading: () => const [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: PlanningLoadingState(),
                    ),
                  ],
                  error: (error, _) => [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: PlanningStateMessage(
                        icon: Icons.error_outline_rounded,
                        title: 'Templates could not be loaded',
                        message: error.toString(),
                        actionLabel: 'Try again',
                        onAction: _retry,
                      ),
                    ),
                  ],
                  data: (templates) => _templateSlivers(
                    splits,
                    templates,
                    effectivePlanningScope(_scope, splits),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _templateSlivers(
    List<WorkoutSplit> splits,
    List<WorkoutTemplate> templates,
    PlanningTemplateScope scope,
  ) {
    final filtered = templates
        .where((template) {
          return scope.contains(template) &&
              planningTemplateMatches(
                template,
                _query,
                planningSplitName(splits, template.splitId),
              );
        })
        .toList(growable: false);

    if (filtered.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: PlanningStateMessage(
            key: const Key('start-workout-empty'),
            icon: _query.trim().isEmpty
                ? Icons.fitness_center_rounded
                : Icons.search_off_rounded,
            title: templates.isEmpty
                ? 'No templates yet'
                : 'No matching templates',
            message: templates.isEmpty
                ? 'Start an empty workout now, or create a reusable routine in the Templates tab.'
                : 'Try another search or choose All Templates.',
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
        sliver: SliverList.separated(
          itemCount: filtered.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final template = filtered[index];
            final splitName = planningSplitName(splits, template.splitId);
            return PlanningTemplateCard(
              key: ValueKey('start-template-${template.id}'),
              userId: widget.userId,
              template: template,
              splitName: splitName,
              onTap: () => _showTemplatePreview(template, splitName),
            );
          },
        ),
      ),
    ];
  }
}

class _TemplatePreviewSheet extends ConsumerWidget {
  const _TemplatePreviewSheet({
    required this.userId,
    required this.weightUnit,
    required this.template,
    required this.splitName,
    required this.onStart,
  });

  final String userId;
  final String weightUnit;
  final WorkoutTemplate template;
  final String splitName;
  final Future<void> Function() onStart;

  Future<void> _quickLog(
    BuildContext context,
    TemplateExercise exercise,
  ) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => WorkoutFormScreen(
          userId: userId,
          weightUnit: weightUnit,
          initialExerciseName: exercise.exerciseName,
        ),
      ),
    );
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${exercise.exerciseName} was saved on this device.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = (userId: userId, templateId: template.id);
    final exercises = ref.watch(templateExercisesProvider(query));
    final height = MediaQuery.sizeOf(context).height * 0.78;
    return SizedBox(
      key: ValueKey('template-preview-${template.id}'),
      height: height,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                PlanningIconBadge(
                  icon: template.icon,
                  colorValue: template.colorValue,
                  size: 52,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        splitName,
                        style: const TextStyle(color: Color(0xFF929CA8)),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Close preview',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            if (template.notes?.trim().isNotEmpty == true) ...[
              const SizedBox(height: 14),
              Text(
                template.notes!.trim(),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFFA8B1BC), height: 1.4),
              ),
            ],
            const SizedBox(height: 18),
            FilledButton.icon(
              key: ValueKey('start-template-workout-${template.id}'),
              onPressed: () async {
                Navigator.of(context).pop();
                await onStart();
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start this workout'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Or keep using the Stage 1 quick log',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: exercises.when(
                loading: () => const PlanningLoadingState(
                  label: 'Loading configured exercises...',
                ),
                error: (error, _) => PlanningStateMessage(
                  icon: Icons.error_outline_rounded,
                  title: 'Exercises could not be loaded',
                  message: error.toString(),
                  actionLabel: 'Try again',
                  onAction: () =>
                      ref.invalidate(templateExercisesProvider(query)),
                ),
                data: (items) => items.isEmpty
                    ? const PlanningStateMessage(
                        key: Key('template-preview-empty'),
                        icon: Icons.playlist_add_rounded,
                        title: 'No configured exercises',
                        message:
                            'Add exercises from the Templates tab before starting from this template.',
                      )
                    : ListView.separated(
                        key: ValueKey(
                          'template-preview-exercises-${template.id}',
                        ),
                        padding: const EdgeInsets.only(bottom: 18),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 9),
                        itemBuilder: (context, index) {
                          final exercise = items[index];
                          final accent = Theme.of(context).colorScheme.primary;
                          return Card(
                            key: ValueKey('preview-exercise-${exercise.id}'),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 14, 8, 14),
                              child: Row(
                                children: [
                                  Container(
                                    width: 34,
                                    height: 34,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: accent.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: accent,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          exercise.exerciseName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          _configurationSummary(exercise),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Color(0xFF929CA8),
                                            fontSize: 12,
                                            height: 1.35,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton.filled(
                                    key: ValueKey(
                                      'quick-log-exercise-${exercise.id}',
                                    ),
                                    tooltip:
                                        'Quick log ${exercise.exerciseName}',
                                    onPressed: () =>
                                        _quickLog(context, exercise),
                                    icon: const Icon(Icons.add_rounded),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _configurationSummary(TemplateExercise exercise) {
    final parts = <String>[
      '${exercise.workingSets} working ${exercise.workingSets == 1 ? 'set' : 'sets'}',
      '${exercise.targetRepsMin}-${exercise.targetRepsMax} reps',
      '${exercise.restSeconds}s rest',
    ];
    if (exercise.warmupSets > 0) {
      parts.add('${exercise.warmupSets} warm-up');
    }
    if (exercise.targetWeight case final target?) {
      final formatted = target == target.roundToDouble()
          ? target.toStringAsFixed(0)
          : target.toStringAsFixed(1);
      parts.add('$formatted ${weightUnit == 'lb' ? 'lb' : 'kg'}');
    }
    if (exercise.rpeTarget case final rpe?) parts.add('RPE $rpe');
    if (exercise.rirTarget case final rir?) parts.add('RIR $rir');
    return parts.join(' | ');
  }
}

enum _ActiveWorkoutChoice {
  continueWorkout,
  finishWorkout,
  discardWorkout,
  cancel,
}

class _EmptyWorkoutDraft {
  const _EmptyWorkoutDraft(this.name, this.notes);

  final String name;
  final String? notes;
}

class _EmptyWorkoutDialog extends StatefulWidget {
  const _EmptyWorkoutDialog();

  @override
  State<_EmptyWorkoutDialog> createState() => _EmptyWorkoutDialogState();
}

class _EmptyWorkoutDialogState extends State<_EmptyWorkoutDialog> {
  final _name = TextEditingController(text: 'Workout');
  final _notes = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final valid = _name.text.trim().isNotEmpty;
    return AlertDialog(
      title: const Text('Start empty workout'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _name,
            autofocus: true,
            maxLength: 120,
            textCapitalization: TextCapitalization.words,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(labelText: 'Workout name'),
          ),
          TextField(
            controller: _notes,
            maxLength: 4000,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Workout note (optional)',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: valid
              ? () => Navigator.pop(
                  context,
                  _EmptyWorkoutDraft(
                    _name.text.trim(),
                    _notes.text.trim().isEmpty ? null : _notes.text.trim(),
                  ),
                )
              : null,
          child: const Text('Start Workout'),
        ),
      ],
    );
  }
}
