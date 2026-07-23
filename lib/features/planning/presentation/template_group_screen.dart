import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/providers.dart';
import 'package:forgefit/features/planning/domain/planning_models.dart';
import 'package:forgefit/features/planning/presentation/planning_widgets.dart';
import 'package:forgefit/features/planning/presentation/template_editor_screen.dart';

class TemplateGroupScreen extends ConsumerStatefulWidget {
  const TemplateGroupScreen({
    super.key,
    required this.userId,
    required this.splitId,
  });

  final String userId;
  final String? splitId;

  @override
  ConsumerState<TemplateGroupScreen> createState() =>
      _TemplateGroupScreenState();
}

class _TemplateGroupScreenState extends ConsumerState<TemplateGroupScreen> {
  final Set<String> _busyTemplateIds = <String>{};
  List<WorkoutTemplate> _orderedTemplates = const [];
  String _incomingSignature = '';
  bool _savingOrder = false;

  Future<void> _openEditor([WorkoutTemplate? template]) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => TemplateEditorScreen(
          userId: widget.userId,
          template: template,
          initialSplitId: template == null ? widget.splitId : null,
        ),
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
      await _openEditor(template);
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

  Future<void> _reorderTemplates(int oldIndex, int newIndex) async {
    if (_savingOrder || oldIndex == newIndex) return;

    final before = List<WorkoutTemplate>.of(_orderedTemplates);
    final reordered = List<WorkoutTemplate>.of(_orderedTemplates);
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);
    setState(() {
      _orderedTemplates = reordered;
      _savingOrder = true;
    });

    try {
      await ref
          .read(planningRepositoryProvider)
          .reorderTemplates(
            userId: widget.userId,
            splitId: widget.splitId,
            orderedTemplateIds: reordered
                .map((template) => template.id)
                .toList(),
          );
      syncPlanningSoon(ref, widget.userId);
    } on Object catch (error) {
      if (mounted) {
        setState(() => _orderedTemplates = before);
        showPlanningError(context, 'Template reorder', error);
      }
    } finally {
      if (mounted) setState(() => _savingOrder = false);
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
    final loadedSplits = splitsAsync.asData?.value ?? const <WorkoutSplit>[];
    final groupTitle = planningSplitName(loadedSplits, widget.splitId);

    return Scaffold(
      appBar: AppBar(
        title: Text(groupTitle),
        actions: [
          IconButton(
            key: const Key('create-template-in-group'),
            tooltip: 'Create template',
            onPressed: () => _openEditor(),
            icon: const Icon(Icons.note_add_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: splitsAsync.when(
          loading: () =>
              const PlanningLoadingState(label: 'Loading this split...'),
          error: (error, _) => PlanningStateMessage(
            icon: Icons.error_outline_rounded,
            title: 'This split could not be loaded',
            message: error.toString(),
            actionLabel: 'Try again',
            onAction: _retry,
          ),
          data: (splits) {
            if (widget.splitId != null &&
                !splits.any((split) => split.id == widget.splitId)) {
              return const PlanningStateMessage(
                icon: Icons.folder_off_outlined,
                title: 'This split is unavailable',
                message:
                    'It may have been deleted on another device. Your templates remain safe in their current section.',
              );
            }
            return templatesAsync.when(
              loading: () => const PlanningLoadingState(),
              error: (error, _) => PlanningStateMessage(
                icon: Icons.error_outline_rounded,
                title: 'Templates could not be loaded',
                message: error.toString(),
                actionLabel: 'Try again',
                onAction: _retry,
              ),
              data: (templates) => _buildTemplateList(splits, templates),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTemplateList(
    List<WorkoutSplit> splits,
    List<WorkoutTemplate> templates,
  ) {
    final incoming = templates
        .where((template) => template.splitId == widget.splitId)
        .toList(growable: false);
    final signature = incoming
        .map(
          (template) =>
              '${template.id}:${template.sortOrder}:${template.version}',
        )
        .join('|');
    if (!_savingOrder && signature != _incomingSignature) {
      _orderedTemplates = List<WorkoutTemplate>.of(incoming);
      _incomingSignature = signature;
    }
    final title = planningSplitName(splits, widget.splitId);

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ReorderableListView.builder(
        key: ValueKey('template-group-${widget.splitId ?? 'none'}'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        buildDefaultDragHandles: false,
        header: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.splitId == null
                  ? 'No Split is permanent. Drag templates into your preferred order.'
                  : 'This split only organises templates. Drag templates into your preferred order.',
              style: const TextStyle(color: Color(0xFF949EAA), height: 1.45),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${_orderedTemplates.length} ${_orderedTemplates.length == 1 ? 'template' : 'templates'}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                if (_savingOrder)
                  const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (_orderedTemplates.isEmpty)
              PlanningStateMessage(
                key: const Key('template-group-empty'),
                icon: Icons.note_add_outlined,
                title: 'No templates here yet',
                message: widget.splitId == null
                    ? 'Create a template without assigning a split.'
                    : 'Create a template in $title, then add any exercises you want.',
                actionLabel: 'Create template',
                onAction: () => _openEditor(),
              ),
          ],
        ),
        itemCount: _orderedTemplates.length,
        onReorderItem: _reorderTemplates,
        itemBuilder: (context, index) {
          final template = _orderedTemplates[index];
          return Padding(
            key: ValueKey('managed-template-${template.id}'),
            padding: EdgeInsets.only(
              bottom: index == _orderedTemplates.length - 1 ? 0 : 10,
            ),
            child: PlanningTemplateCard(
              userId: widget.userId,
              template: template,
              splitName: title,
              enabled: !_busyTemplateIds.contains(template.id) && !_savingOrder,
              dragIndex: index,
              onTap: () => _openEditor(template),
              onAction: (action) =>
                  unawaited(_handleTemplateAction(action, template, splits)),
            ),
          );
        },
      ),
    );
  }
}
