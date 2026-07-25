import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/providers.dart';
import 'package:forgefit/core/settings/appearance_settings.dart';
import 'package:forgefit/features/planning/domain/planning_models.dart';
import 'package:forgefit/features/planning/presentation/custom_exercise_editor_screen.dart';
import 'package:forgefit/features/planning/presentation/exercise_picker_screen.dart';
import 'package:forgefit/features/planning/presentation/manage_splits_screen.dart';
import 'package:forgefit/features/planning/presentation/planning_widgets.dart';
import 'package:forgefit/features/planning/presentation/split_editor_screen.dart';
import 'package:forgefit/features/planning/presentation/template_editor_screen.dart';
import 'package:forgefit/features/planning/presentation/template_group_screen.dart';

enum _PlanningCreateAction { split, template, customExercise, exerciseLibrary }

class TemplateLibraryScreen extends ConsumerStatefulWidget {
  const TemplateLibraryScreen({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<TemplateLibraryScreen> createState() =>
      _TemplateLibraryScreenState();
}

class _TemplateLibraryScreenState extends ConsumerState<TemplateLibraryScreen> {
  final _searchController = TextEditingController();
  final Set<String> _busyTemplateIds = <String>{};
  PlanningTemplateScope _scope = const PlanningTemplateScope.all();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showCreateActions() async {
    final action = await showModalBottomSheet<_PlanningCreateAction>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 2, 12, 12),
              child: Text(
                'Create',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
            ),
            ListTile(
              key: const Key('create-split-action'),
              leading: const Icon(Icons.create_new_folder_outlined),
              title: const Text('Workout split'),
              subtitle: const Text('An optional folder for templates'),
              onTap: () =>
                  Navigator.of(context).pop(_PlanningCreateAction.split),
            ),
            ListTile(
              key: const Key('create-template-action'),
              leading: const Icon(Icons.note_add_outlined),
              title: const Text('Workout template'),
              subtitle: const Text('Plan any exercises you want'),
              onTap: () =>
                  Navigator.of(context).pop(_PlanningCreateAction.template),
            ),
            ListTile(
              key: const Key('create-custom-exercise-action'),
              leading: const Icon(Icons.add_circle_outline_rounded),
              title: const Text('Custom exercise'),
              subtitle: const Text('Create a private movement'),
              onTap: () => Navigator.of(
                context,
              ).pop(_PlanningCreateAction.customExercise),
            ),
            ListTile(
              key: const Key('exercise-library-action'),
              leading: const Icon(Icons.fitness_center_rounded),
              title: const Text('Exercise library'),
              subtitle: const Text('Browse and manage custom movements'),
              onTap: () => Navigator.of(
                context,
              ).pop(_PlanningCreateAction.exerciseLibrary),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
    if (action == null || !mounted) return;

    switch (action) {
      case _PlanningCreateAction.split:
        await Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (_) => SplitEditorScreen(userId: widget.userId),
          ),
        );
      case _PlanningCreateAction.template:
        final currentScope = effectivePlanningScope(
          _scope,
          ref.read(workoutSplitsProvider(widget.userId)).asData?.value ??
              const [],
        );
        await _openTemplateEditor(
          initialSplitId: currentScope.kind == PlanningScopeKind.split
              ? currentScope.splitId
              : null,
        );
      case _PlanningCreateAction.customExercise:
        await Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (_) => CustomExerciseEditorScreen(userId: widget.userId),
          ),
        );
      case _PlanningCreateAction.exerciseLibrary:
        await Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (_) => ExercisePickerScreen(
              userId: widget.userId,
              selectionMode: false,
            ),
          ),
        );
    }
  }

  Future<void> _openTemplateEditor({
    WorkoutTemplate? template,
    String? initialSplitId,
  }) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => TemplateEditorScreen(
          userId: widget.userId,
          template: template,
          initialSplitId: initialSplitId,
        ),
      ),
    );
  }

  Future<void> _manageGroup(String? splitId) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) =>
            TemplateGroupScreen(userId: widget.userId, splitId: splitId),
      ),
    );
  }

  Future<void> _handleTemplateAction(
    PlanningTemplateAction action,
    WorkoutTemplate template,
    List<WorkoutSplit> splits,
  ) async {
    if (_busyTemplateIds.contains(template.id)) return;
    if (action == PlanningTemplateAction.edit) {
      await _openTemplateEditor(template: template);
      return;
    }

    setState(() => _busyTemplateIds.add(template.id));
    try {
      final repository = ref.read(planningRepositoryProvider);
      switch (action) {
        case PlanningTemplateAction.edit:
          break;
        case PlanningTemplateAction.duplicate:
          final copy = await repository.duplicateTemplate(
            userId: widget.userId,
            templateId: template.id,
          );
          syncPlanningSoon(ref, widget.userId);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${copy.name} was saved offline.')),
            );
          }
        case PlanningTemplateAction.move:
          final destination = await showTemplateMoveDestination(
            context: context,
            template: template,
            splits: splits,
          );
          if (destination == null || !mounted) return;
          await repository.moveTemplate(
            userId: widget.userId,
            templateId: template.id,
            destinationSplitId: destination.splitId,
          );
          syncPlanningSoon(ref, widget.userId);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${template.name} moved to ${destination.label}.',
                ),
              ),
            );
          }
        case PlanningTemplateAction.delete:
          if (!await confirmTemplateDelete(context, template) || !mounted) {
            return;
          }
          await repository.deleteTemplate(
            userId: widget.userId,
            templateId: template.id,
          );
          syncPlanningSoon(ref, widget.userId);
      }
    } on Object catch (error) {
      if (mounted) showPlanningError(context, 'Template action', error);
    } finally {
      if (mounted) {
        setState(() => _busyTemplateIds.remove(template.id));
      }
    }
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

    return RefreshIndicator(
      onRefresh: _refresh,
      child: CustomScrollView(
        key: const PageStorageKey('template-library-scroll'),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
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
                            'Workout templates',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Splits organise templates. They never limit your exercises.',
                            style: TextStyle(
                              color: Color(0xFF949EAA),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      key: const Key('open-planning-create-menu'),
                      onPressed: _showCreateActions,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 46),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                      ),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Create'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                PlanningSearchField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                ),
                const SizedBox(height: 14),
                PlanningTemplateScopeBar(
                  splits: headerSplits,
                  selected: selectedScope,
                  onChanged: (scope) {
                    ForgeFitHaptics.selection(
                      ref.read(appearanceProvider).hapticsEnabled,
                    );
                    setState(() => _scope = scope);
                  },
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    key: const Key('manage-splits'),
                    onPressed: () => Navigator.of(context).push<void>(
                      MaterialPageRoute(
                        builder: (_) =>
                            ManageSplitsScreen(userId: widget.userId),
                      ),
                    ),
                    icon: const Icon(Icons.reorder_rounded),
                    label: const Text('Manage and reorder splits'),
                  ),
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
                  icon: Icons.cloud_off_outlined,
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
              data: (templates) => [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                  sliver: SliverToBoxAdapter(
                    child: _buildTemplateContent(
                      splits: splits,
                      templates: templates,
                      selectedScope: effectivePlanningScope(_scope, splits),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateContent({
    required List<WorkoutSplit> splits,
    required List<WorkoutTemplate> templates,
    required PlanningTemplateScope selectedScope,
  }) {
    if (templates.isEmpty) {
      return PlanningStateMessage(
        key: const Key('templates-empty'),
        icon: Icons.note_add_outlined,
        title: 'Build your first template',
        message:
            'Create any routine you want. A split is optional and never chooses the exercises for you.',
        actionLabel: 'Create template',
        onAction: () => _openTemplateEditor(
          initialSplitId: selectedScope.kind == PlanningScopeKind.split
              ? selectedScope.splitId
              : null,
        ),
      );
    }

    final filtered = templates
        .where((template) {
          return selectedScope.contains(template) &&
              planningTemplateMatches(
                template,
                _query,
                planningSplitName(splits, template.splitId),
              );
        })
        .toList(growable: false);
    if (filtered.isEmpty) {
      return PlanningStateMessage(
        key: const Key('templates-filter-empty'),
        icon: Icons.search_off_rounded,
        title: 'No matching templates',
        message: _query.trim().isEmpty
            ? 'This section has no templates yet.'
            : 'Try a different search or choose another split.',
        actionLabel: _query.trim().isEmpty ? 'Create template' : null,
        onAction: _query.trim().isEmpty
            ? () => _openTemplateEditor(
                initialSplitId: selectedScope.kind == PlanningScopeKind.split
                    ? selectedScope.splitId
                    : null,
              )
            : null,
      );
    }

    if (selectedScope.kind != PlanningScopeKind.all) {
      return _TemplateSection(
        title: selectedScope.label,
        userId: widget.userId,
        splitId: selectedScope.splitId,
        templates: filtered,
        splits: splits,
        busyIds: _busyTemplateIds,
        onManage: () => _manageGroup(selectedScope.splitId),
        onOpen: (template) => _openTemplateEditor(template: template),
        onAction: (action, template) =>
            _handleTemplateAction(action, template, splits),
      );
    }

    final sections = <Widget>[];
    for (final split in splits) {
      final group = filtered
          .where((template) => template.splitId == split.id)
          .toList(growable: false);
      if (group.isEmpty) continue;
      sections.add(
        _TemplateSection(
          title: split.name,
          userId: widget.userId,
          splitId: split.id,
          templates: group,
          splits: splits,
          busyIds: _busyTemplateIds,
          onManage: () => _manageGroup(split.id),
          onOpen: (template) => _openTemplateEditor(template: template),
          onAction: (action, template) =>
              _handleTemplateAction(action, template, splits),
        ),
      );
      sections.add(const SizedBox(height: 26));
    }
    final noSplit = filtered
        .where((template) => template.splitId == null)
        .toList(growable: false);
    if (noSplit.isNotEmpty || _query.trim().isEmpty) {
      sections.add(
        _TemplateSection(
          title: 'No Split',
          userId: widget.userId,
          splitId: null,
          templates: noSplit,
          splits: splits,
          busyIds: _busyTemplateIds,
          onManage: () => _manageGroup(null),
          onOpen: (template) => _openTemplateEditor(template: template),
          onAction: (action, template) =>
              _handleTemplateAction(action, template, splits),
        ),
      );
    }
    return Column(children: sections);
  }
}

class _TemplateSection extends StatelessWidget {
  const _TemplateSection({
    required this.title,
    required this.userId,
    required this.splitId,
    required this.templates,
    required this.splits,
    required this.busyIds,
    required this.onManage,
    required this.onOpen,
    required this.onAction,
  });

  final String title;
  final String userId;
  final String? splitId;
  final List<WorkoutTemplate> templates;
  final List<WorkoutSplit> splits;
  final Set<String> busyIds;
  final VoidCallback onManage;
  final ValueChanged<WorkoutTemplate> onOpen;
  final void Function(PlanningTemplateAction, WorkoutTemplate) onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlanningSectionHeader(
          title: title,
          count: templates.length,
          onManage: onManage,
        ),
        const SizedBox(height: 10),
        if (templates.isEmpty)
          Container(
            key: ValueKey('empty-template-group-${splitId ?? 'none'}'),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF11151A),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF293039)),
            ),
            child: const Text(
              'No templates in this section.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF929CA8)),
            ),
          )
        else
          for (var index = 0; index < templates.length; index++) ...[
            PlanningTemplateCard(
              key: ValueKey('library-template-${templates[index].id}'),
              userId: userId,
              template: templates[index],
              splitName: planningSplitName(splits, templates[index].splitId),
              enabled: !busyIds.contains(templates[index].id),
              onTap: () => onOpen(templates[index]),
              onAction: (action) => onAction(action, templates[index]),
            ),
            if (index != templates.length - 1) const SizedBox(height: 10),
          ],
      ],
    );
  }
}
