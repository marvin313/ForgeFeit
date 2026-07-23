import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/providers.dart';
import 'package:forgefit/core/theme/forgefit_theme.dart';
import 'package:forgefit/features/planning/domain/planning_models.dart';

enum PlanningScopeKind { all, noSplit, split }

@immutable
class PlanningTemplateScope {
  const PlanningTemplateScope.all()
    : kind = PlanningScopeKind.all,
      splitId = null,
      label = 'All Templates';

  const PlanningTemplateScope.noSplit()
    : kind = PlanningScopeKind.noSplit,
      splitId = null,
      label = 'No Split';

  const PlanningTemplateScope.split({required String id, required this.label})
    : kind = PlanningScopeKind.split,
      splitId = id;

  final PlanningScopeKind kind;
  final String? splitId;
  final String label;

  String get storageKey => switch (kind) {
    PlanningScopeKind.all => 'all',
    PlanningScopeKind.noSplit => 'no-split',
    PlanningScopeKind.split => 'split-$splitId',
  };

  bool contains(WorkoutTemplate template) => switch (kind) {
    PlanningScopeKind.all => true,
    PlanningScopeKind.noSplit => template.splitId == null,
    PlanningScopeKind.split => template.splitId == splitId,
  };

  @override
  bool operator ==(Object other) {
    return other is PlanningTemplateScope &&
        other.kind == kind &&
        other.splitId == splitId;
  }

  @override
  int get hashCode => Object.hash(kind, splitId);
}

List<PlanningTemplateScope> planningScopes(List<WorkoutSplit> splits) {
  return [
    const PlanningTemplateScope.all(),
    const PlanningTemplateScope.noSplit(),
    for (final split in splits)
      PlanningTemplateScope.split(id: split.id, label: split.name),
  ];
}

PlanningTemplateScope effectivePlanningScope(
  PlanningTemplateScope selected,
  List<WorkoutSplit> splits,
) {
  if (selected.kind != PlanningScopeKind.split ||
      splits.any((split) => split.id == selected.splitId)) {
    return selected;
  }
  return const PlanningTemplateScope.all();
}

String planningSplitName(List<WorkoutSplit> splits, String? splitId) {
  if (splitId == null) return 'No Split';
  for (final split in splits) {
    if (split.id == splitId) return split.name;
  }
  return 'No Split';
}

bool planningTemplateMatches(
  WorkoutTemplate template,
  String query,
  String splitName,
) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) return true;
  return template.name.toLowerCase().contains(normalized) ||
      (template.notes?.toLowerCase().contains(normalized) ?? false) ||
      splitName.toLowerCase().contains(normalized);
}

class PlanningTemplateScopeBar extends StatelessWidget {
  const PlanningTemplateScopeBar({
    super.key,
    required this.splits,
    required this.selected,
    required this.onChanged,
  });

  final List<WorkoutSplit> splits;
  final PlanningTemplateScope selected;
  final ValueChanged<PlanningTemplateScope> onChanged;

  @override
  Widget build(BuildContext context) {
    final scopes = planningScopes(splits);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < scopes.length; index++) ...[
            ChoiceChip(
              key: ValueKey('template-filter-${scopes[index].storageKey}'),
              label: Text(scopes[index].label),
              selected: scopes[index] == selected,
              onSelected: (_) => onChanged(scopes[index]),
            ),
            if (index != scopes.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class PlanningSearchField extends StatelessWidget {
  const PlanningSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('template-search'),
      controller: controller,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search templates or splits',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                key: const Key('clear-template-search'),
                tooltip: 'Clear search',
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
                icon: const Icon(Icons.close_rounded),
              ),
      ),
    );
  }
}

class PlanningIconBadge extends StatelessWidget {
  const PlanningIconBadge({
    super.key,
    required this.icon,
    required this.colorValue,
    this.size = 48,
  });

  final String icon;
  final int colorValue;
  final double size;

  IconData? get _materialIcon => switch (icon.trim().toLowerCase()) {
    'folder' => Icons.folder_rounded,
    'workout' => Icons.fitness_center_rounded,
    'strength' => Icons.sports_gymnastics_rounded,
    'home' => Icons.home_rounded,
    'cardio' => Icons.directions_run_rounded,
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    final color = Color(colorValue);
    final materialIcon = _materialIcon;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(size * 0.31),
      ),
      child: materialIcon == null
          ? Text(
              icon,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: TextStyle(fontSize: size * 0.43),
            )
          : Icon(materialIcon, color: color, size: size * 0.52),
    );
  }
}

enum PlanningTemplateAction { edit, duplicate, move, delete }

class PlanningTemplateCard extends ConsumerWidget {
  const PlanningTemplateCard({
    super.key,
    required this.userId,
    required this.template,
    required this.splitName,
    this.onTap,
    this.onAction,
    this.dragIndex,
    this.enabled = true,
  });

  final String userId;
  final WorkoutTemplate template;
  final String splitName;
  final VoidCallback? onTap;
  final ValueChanged<PlanningTemplateAction>? onAction;
  final int? dragIndex;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercises = ref.watch(
      templateExercisesProvider((userId: userId, templateId: template.id)),
    );
    final exerciseLabel = exercises.when(
      loading: () => 'Loading exercises',
      error: (_, _) => 'Exercises unavailable',
      data: (items) =>
          items.length == 1 ? '1 exercise' : '${items.length} exercises',
    );
    final trailing = <Widget>[
      if (onAction != null)
        PopupMenuButton<PlanningTemplateAction>(
          key: ValueKey('template-actions-${template.id}'),
          enabled: enabled,
          tooltip: 'Template actions',
          onSelected: onAction,
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: PlanningTemplateAction.edit,
              child: _PlanningMenuLabel(
                icon: Icons.edit_outlined,
                label: 'Edit',
              ),
            ),
            PopupMenuItem(
              value: PlanningTemplateAction.duplicate,
              child: _PlanningMenuLabel(
                icon: Icons.copy_rounded,
                label: 'Duplicate',
              ),
            ),
            PopupMenuItem(
              value: PlanningTemplateAction.move,
              child: _PlanningMenuLabel(
                icon: Icons.drive_file_move_outline,
                label: 'Move',
              ),
            ),
            PopupMenuItem(
              value: PlanningTemplateAction.delete,
              child: _PlanningMenuLabel(
                icon: Icons.delete_outline_rounded,
                label: 'Delete',
                color: ForgeFitColors.danger,
              ),
            ),
          ],
        ),
      if (dragIndex case final index?)
        ReorderableDragStartListener(
          key: ValueKey('template-drag-${template.id}'),
          index: index,
          enabled: enabled,
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.drag_handle_rounded, color: Color(0xFF8C96A2)),
          ),
        ),
    ];

    return Card(
      key: key ?? ValueKey('template-card-${template.id}'),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 15, 8, 15),
          child: Row(
            children: [
              PlanningIconBadge(
                icon: template.icon,
                colorValue: template.colorValue,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$splitName | $exerciseLabel',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF919BA7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF8C96A2),
                  ),
                )
              else
                Row(mainAxisSize: MainAxisSize.min, children: trailing),
            ],
          ),
        ),
      ),
    );
  }
}

enum PlanningSplitAction { edit, duplicate, delete }

class PlanningSplitCard extends StatelessWidget {
  const PlanningSplitCard({
    super.key,
    required this.split,
    required this.templateCount,
    required this.onTap,
    required this.onAction,
    this.dragIndex,
    this.enabled = true,
  });

  final WorkoutSplit split;
  final int templateCount;
  final VoidCallback onTap;
  final ValueChanged<PlanningSplitAction> onAction;
  final int? dragIndex;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: key ?? ValueKey('split-card-${split.id}'),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 15, 8, 15),
          child: Row(
            children: [
              PlanningIconBadge(icon: split.icon, colorValue: split.colorValue),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      split.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      templateCount == 1
                          ? '1 template'
                          : '$templateCount templates',
                      style: const TextStyle(
                        color: Color(0xFF919BA7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<PlanningSplitAction>(
                key: ValueKey('split-actions-${split.id}'),
                enabled: enabled,
                tooltip: 'Split actions',
                onSelected: onAction,
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: PlanningSplitAction.edit,
                    child: _PlanningMenuLabel(
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                    ),
                  ),
                  PopupMenuItem(
                    value: PlanningSplitAction.duplicate,
                    child: _PlanningMenuLabel(
                      icon: Icons.copy_rounded,
                      label: 'Duplicate',
                    ),
                  ),
                  PopupMenuItem(
                    value: PlanningSplitAction.delete,
                    child: _PlanningMenuLabel(
                      icon: Icons.delete_outline_rounded,
                      label: 'Delete',
                      color: ForgeFitColors.danger,
                    ),
                  ),
                ],
              ),
              if (dragIndex case final index?)
                ReorderableDragStartListener(
                  key: ValueKey('split-drag-${split.id}'),
                  index: index,
                  enabled: enabled,
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.drag_handle_rounded,
                      color: Color(0xFF8C96A2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlanningNoSplitCard extends StatelessWidget {
  const PlanningNoSplitCard({
    super.key,
    required this.templateCount,
    required this.onTap,
  });

  final int templateCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: key ?? const Key('no-split-card'),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const PlanningIconBadge(icon: 'folder', colorValue: 0xFF7F8A96),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No Split',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      templateCount == 1
                          ? 'Permanent section | 1 template'
                          : 'Permanent section | $templateCount templates',
                      style: const TextStyle(
                        color: Color(0xFF919BA7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF8C96A2)),
            ],
          ),
        ),
      ),
    );
  }
}

class PlanningSectionHeader extends StatelessWidget {
  const PlanningSectionHeader({
    super.key,
    required this.title,
    required this.count,
    this.onManage,
  });

  final String title;
  final int count;
  final VoidCallback? onManage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$count',
          style: const TextStyle(
            color: Color(0xFF929CA8),
            fontWeight: FontWeight.w800,
          ),
        ),
        if (onManage != null) ...[
          const SizedBox(width: 4),
          TextButton(onPressed: onManage, child: const Text('Manage')),
        ],
      ],
    );
  }
}

class PlanningStateMessage extends StatelessWidget {
  const PlanningStateMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 58, color: ForgeFitColors.electricBlue),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 9),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF98A2AE), height: 1.45),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class PlanningLoadingState extends StatelessWidget {
  const PlanningLoadingState({super.key, this.label = 'Loading templates...'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(label, style: const TextStyle(color: Color(0xFF98A2AE))),
        ],
      ),
    );
  }
}

class PlanningDestination {
  const PlanningDestination({required this.splitId, required this.label});

  final String? splitId;
  final String label;
}

Future<PlanningDestination?> showTemplateMoveDestination({
  required BuildContext context,
  required WorkoutTemplate template,
  required List<WorkoutSplit> splits,
}) {
  return showModalBottomSheet<PlanningDestination>(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.72,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: Text(
                'Move ${template.name}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    key: const Key('move-template-no-split'),
                    enabled: template.splitId != null,
                    leading: const Icon(Icons.folder_off_outlined),
                    title: const Text('No Split'),
                    subtitle: const Text('Keep this template without a folder'),
                    trailing: template.splitId == null
                        ? const Icon(Icons.check_rounded)
                        : null,
                    onTap: template.splitId == null
                        ? null
                        : () => Navigator.of(context).pop(
                            const PlanningDestination(
                              splitId: null,
                              label: 'No Split',
                            ),
                          ),
                  ),
                  for (final split in splits)
                    ListTile(
                      key: ValueKey('move-template-${split.id}'),
                      enabled: split.id != template.splitId,
                      leading: PlanningIconBadge(
                        icon: split.icon,
                        colorValue: split.colorValue,
                        size: 40,
                      ),
                      title: Text(split.name),
                      trailing: split.id == template.splitId
                          ? const Icon(Icons.check_rounded)
                          : null,
                      onTap: split.id == template.splitId
                          ? null
                          : () => Navigator.of(context).pop(
                              PlanningDestination(
                                splitId: split.id,
                                label: split.name,
                              ),
                            ),
                    ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<PlanningDestination?> showSplitDeleteDestination({
  required BuildContext context,
  required WorkoutSplit split,
  required List<WorkoutSplit> splits,
  required int templateCount,
}) async {
  if (templateCount == 0) {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Delete ${split.name}?'),
            content: const Text(
              'This split is empty. The split will be removed on this device and queued for sync.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                key: const Key('confirm-delete-empty-split'),
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: ForgeFitColors.danger,
                ),
                child: const Text('Delete split'),
              ),
            ],
          ),
        ) ??
        false;
    return confirmed
        ? const PlanningDestination(splitId: null, label: 'No Split')
        : null;
  }

  return showModalBottomSheet<PlanningDestination>(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.72,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
              child: Text(
                'Delete ${split.name}?',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Text(
                'Choose where to move $templateCount ${templateCount == 1 ? 'template' : 'templates'}. No templates will be deleted.',
                style: const TextStyle(color: Color(0xFF9AA4B0), height: 1.4),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    key: const Key('delete-split-to-no-split'),
                    leading: const Icon(Icons.folder_off_outlined),
                    title: const Text('Move to No Split'),
                    subtitle: const Text('Then delete this split'),
                    onTap: () => Navigator.of(context).pop(
                      const PlanningDestination(
                        splitId: null,
                        label: 'No Split',
                      ),
                    ),
                  ),
                  for (final destination in splits.where(
                    (candidate) => candidate.id != split.id,
                  ))
                    ListTile(
                      key: ValueKey('delete-split-to-${destination.id}'),
                      leading: PlanningIconBadge(
                        icon: destination.icon,
                        colorValue: destination.colorValue,
                        size: 40,
                      ),
                      title: Text('Move to ${destination.name}'),
                      subtitle: const Text('Then delete this split'),
                      onTap: () => Navigator.of(context).pop(
                        PlanningDestination(
                          splitId: destination.id,
                          label: destination.name,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            TextButton(
              key: const Key('cancel-delete-split'),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<bool> confirmTemplateDelete(
  BuildContext context,
  WorkoutTemplate template,
) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Delete ${template.name}?'),
          content: const Text(
            'The template and its configured exercises will be removed locally and queued for cloud sync. Logged workouts are not affected.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              key: ValueKey('confirm-delete-template-${template.id}'),
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: ForgeFitColors.danger,
              ),
              child: const Text('Delete template'),
            ),
          ],
        ),
      ) ??
      false;
}

Future<void> refreshPlanning(WidgetRef ref, String userId) async {
  try {
    await ref.read(planningRepositoryProvider).restore(userId);
  } on Object {
    // The local streams remain usable while offline. Sync below still retries
    // any durable pending changes.
  }
  try {
    await ref.read(syncCoordinatorProvider).sync(userId);
  } on Object {
    // Sync status is shown by the existing app-level status chip.
  }
}

void syncPlanningSoon(WidgetRef ref, String userId) {
  unawaited(() async {
    try {
      await ref
          .read(syncCoordinatorProvider)
          .sync(userId, forceAfterCurrent: true);
    } on Object {
      // The change is already in the durable outbox and will retry later.
    }
  }());
}

void showPlanningError(BuildContext context, String action, Object error) {
  if (!context.mounted) return;
  final raw = error.toString().trim();
  final message = raw.isEmpty ? 'Unknown error' : raw;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('$action could not be completed: $message')),
  );
}

class _PlanningMenuLabel extends StatelessWidget {
  const _PlanningMenuLabel({
    required this.icon,
    required this.label,
    this.color,
  });

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}
