import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/providers.dart';
import 'package:forgefit/features/planning/domain/planning_models.dart';
import 'package:forgefit/features/planning/presentation/planning_widgets.dart';
import 'package:forgefit/features/planning/presentation/split_editor_screen.dart';
import 'package:forgefit/features/planning/presentation/template_group_screen.dart';

class ManageSplitsScreen extends ConsumerStatefulWidget {
  const ManageSplitsScreen({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<ManageSplitsScreen> createState() => _ManageSplitsScreenState();
}

class _ManageSplitsScreenState extends ConsumerState<ManageSplitsScreen> {
  final Set<String> _busySplitIds = <String>{};
  List<WorkoutSplit> _orderedSplits = const [];
  String _incomingSignature = '';
  bool _savingOrder = false;

  Future<void> _createSplit() {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => SplitEditorScreen(userId: widget.userId),
      ),
    );
  }

  Future<void> _openGroup(String? splitId) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) =>
            TemplateGroupScreen(userId: widget.userId, splitId: splitId),
      ),
    );
  }

  Future<void> _handleSplitAction(
    PlanningSplitAction action,
    WorkoutSplit split,
    List<WorkoutSplit> splits,
    List<WorkoutTemplate> templates,
  ) async {
    if (_busySplitIds.contains(split.id)) return;
    if (action == PlanningSplitAction.edit) {
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) =>
              SplitEditorScreen(userId: widget.userId, split: split),
        ),
      );
      return;
    }

    setState(() => _busySplitIds.add(split.id));
    try {
      final repository = ref.read(planningRepositoryProvider);
      switch (action) {
        case PlanningSplitAction.edit:
          break;
        case PlanningSplitAction.duplicate:
          final copy = await repository.duplicateSplit(
            userId: widget.userId,
            splitId: split.id,
          );
          syncPlanningSoon(ref, widget.userId);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${copy.name} and its templates were saved offline.',
                ),
              ),
            );
          }
        case PlanningSplitAction.delete:
          final templateCount = templates
              .where((template) => template.splitId == split.id)
              .length;
          final destination = await showSplitDeleteDestination(
            context: context,
            split: split,
            splits: splits,
            templateCount: templateCount,
          );
          if (destination == null || !mounted) return;
          await repository.deleteSplit(
            userId: widget.userId,
            splitId: split.id,
            destinationSplitId: destination.splitId,
          );
          syncPlanningSoon(ref, widget.userId);
          if (mounted) {
            final message = templateCount == 0
                ? '${split.name} was deleted.'
                : '$templateCount ${templateCount == 1 ? 'template was' : 'templates were'} moved to ${destination.label}.';
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          }
      }
    } on Object catch (error) {
      if (mounted) showPlanningError(context, 'Split action', error);
    } finally {
      if (mounted) {
        setState(() => _busySplitIds.remove(split.id));
      }
    }
  }

  Future<void> _reorderSplits(int oldIndex, int newIndex) async {
    if (_savingOrder || oldIndex == newIndex) return;

    final before = List<WorkoutSplit>.of(_orderedSplits);
    final reordered = List<WorkoutSplit>.of(_orderedSplits);
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);
    setState(() {
      _orderedSplits = reordered;
      _savingOrder = true;
    });

    try {
      await ref
          .read(planningRepositoryProvider)
          .reorderSplits(
            userId: widget.userId,
            orderedSplitIds: reordered.map((split) => split.id).toList(),
          );
      syncPlanningSoon(ref, widget.userId);
    } on Object catch (error) {
      if (mounted) {
        setState(() => _orderedSplits = before);
        showPlanningError(context, 'Split reorder', error);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage splits'),
        actions: [
          IconButton(
            key: const Key('create-split'),
            tooltip: 'Create split',
            onPressed: _createSplit,
            icon: const Icon(Icons.create_new_folder_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: splitsAsync.when(
          loading: () =>
              const PlanningLoadingState(label: 'Loading your splits...'),
          error: (error, _) => PlanningStateMessage(
            icon: Icons.error_outline_rounded,
            title: 'Splits could not be loaded',
            message: error.toString(),
            actionLabel: 'Try again',
            onAction: _retry,
          ),
          data: (splits) => templatesAsync.when(
            loading: () =>
                const PlanningLoadingState(label: 'Loading your templates...'),
            error: (error, _) => PlanningStateMessage(
              icon: Icons.error_outline_rounded,
              title: 'Templates could not be loaded',
              message: error.toString(),
              actionLabel: 'Try again',
              onAction: _retry,
            ),
            data: (templates) => _buildSplitList(splits, templates),
          ),
        ),
      ),
    );
  }

  Widget _buildSplitList(
    List<WorkoutSplit> splits,
    List<WorkoutTemplate> templates,
  ) {
    final signature = splits
        .map((split) => '${split.id}:${split.sortOrder}:${split.version}')
        .join('|');
    if (!_savingOrder && signature != _incomingSignature) {
      _orderedSplits = List<WorkoutSplit>.of(splits);
      _incomingSignature = signature;
    }
    final noSplitCount = templates
        .where((template) => template.splitId == null)
        .length;

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ReorderableListView.builder(
        key: const PageStorageKey('manage-splits-list'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        buildDefaultDragHandles: false,
        header: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Splits are optional folders. Drag your custom splits into any order.',
              style: TextStyle(color: Color(0xFF949EAA), height: 1.45),
            ),
            const SizedBox(height: 18),
            PlanningNoSplitCard(
              templateCount: noSplitCount,
              onTap: () => _openGroup(null),
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Your splits',
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
            if (_orderedSplits.isEmpty)
              PlanningStateMessage(
                key: const Key('splits-empty'),
                icon: Icons.create_new_folder_outlined,
                title: 'No custom splits yet',
                message:
                    'Create one when folders help. Templates can always stay in No Split.',
                actionLabel: 'Create split',
                onAction: _createSplit,
              ),
          ],
        ),
        itemCount: _orderedSplits.length,
        onReorderItem: _reorderSplits,
        itemBuilder: (context, index) {
          final split = _orderedSplits[index];
          final templateCount = templates
              .where((template) => template.splitId == split.id)
              .length;
          return Padding(
            key: ValueKey('managed-split-${split.id}'),
            padding: EdgeInsets.only(
              bottom: index == _orderedSplits.length - 1 ? 0 : 10,
            ),
            child: PlanningSplitCard(
              split: split,
              templateCount: templateCount,
              enabled: !_busySplitIds.contains(split.id) && !_savingOrder,
              dragIndex: index,
              onTap: () => _openGroup(split.id),
              onAction: (action) => unawaited(
                _handleSplitAction(action, split, splits, templates),
              ),
            ),
          );
        },
      ),
    );
  }
}
