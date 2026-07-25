import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/providers.dart';
import 'package:forgefit/core/theme/forgefit_theme.dart';
import 'package:forgefit/features/planning/domain/planning_models.dart';
import 'package:forgefit/features/planning/domain/system_exercise_catalog.dart';

import 'custom_exercise_editor_screen.dart';

enum _PickerMode { all, favourites, recent, mine }

enum _CustomAction { favourite, edit }

class ExercisePickerScreen extends ConsumerStatefulWidget {
  const ExercisePickerScreen({
    super.key,
    required this.userId,
    this.selectionMode = true,
    this.multiSelect = false,
    this.unavailableExerciseKeys = const <String>{},
  });

  final String userId;
  final bool selectionMode;
  final bool multiSelect;
  final Set<String> unavailableExerciseKeys;

  @override
  ConsumerState<ExercisePickerScreen> createState() =>
      _ExercisePickerScreenState();
}

class _ExercisePickerScreenState extends ConsumerState<ExercisePickerScreen> {
  final _searchController = TextEditingController();
  late Future<PlanningSnapshot> _snapshotFuture;
  _PickerMode _mode = _PickerMode.all;
  MuscleGroup? _muscle;
  ExerciseEquipment? _equipment;
  final Set<String> _busyCustomIds = {};
  final LinkedHashMap<String, ExerciseSelection> _selected =
      LinkedHashMap<String, ExerciseSelection>();

  String _selectionKey(ExerciseSelection selection) =>
      '${selection.source.name}:${selection.exerciseId}';

  @override
  void initState() {
    super.initState();
    _snapshotFuture = _loadSnapshot();
    _searchController.addListener(_searchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_searchChanged)
      ..dispose();
    super.dispose();
  }

  Future<PlanningSnapshot> _loadSnapshot() {
    return ref.read(planningRepositoryProvider).getSnapshot(widget.userId);
  }

  void _searchChanged() => setState(() {});

  void _reloadRecent() {
    setState(() => _snapshotFuture = _loadSnapshot());
  }

  Future<void> _createCustomExercise() async {
    await Navigator.of(context).push<CustomExercise>(
      MaterialPageRoute(
        builder: (_) => CustomExerciseEditorScreen(userId: widget.userId),
      ),
    );
    if (mounted) _reloadRecent();
  }

  Future<void> _editCustomExercise(CustomExercise exercise) async {
    await Navigator.of(context).push<CustomExercise>(
      MaterialPageRoute(
        builder: (_) => CustomExerciseEditorScreen(
          userId: widget.userId,
          exercise: exercise,
        ),
      ),
    );
    if (mounted) _reloadRecent();
  }

  Future<void> _toggleFavourite(CustomExercise exercise) async {
    if (_busyCustomIds.contains(exercise.id)) return;
    setState(() => _busyCustomIds.add(exercise.id));
    try {
      await ref
          .read(planningRepositoryProvider)
          .setCustomExerciseFavourite(
            userId: widget.userId,
            exerciseId: exercise.id,
            isFavourite: !exercise.isFavourite,
          );
      unawaited(_trySync());
    } on Object catch (error) {
      if (mounted) _showError('Favourite could not be updated: $error');
    } finally {
      if (mounted) setState(() => _busyCustomIds.remove(exercise.id));
    }
  }

  Future<void> _trySync() async {
    try {
      await ref
          .read(syncCoordinatorProvider)
          .sync(widget.userId, forceAfterCurrent: true);
    } on Object {
      // The local favourite remains queued for the connectivity retry.
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  List<_PickerItem> _itemsFor(
    List<CustomExercise> customExercises,
    PlanningSnapshot? snapshot,
  ) {
    final customById = {
      for (final exercise in customExercises) exercise.id: exercise,
    };
    final List<_PickerItem> items;
    switch (_mode) {
      case _PickerMode.all:
        items = [
          ...SystemExerciseCatalog.all.map(_PickerItem.system),
          ...customExercises.map(_PickerItem.custom),
        ];
      case _PickerMode.favourites:
        items = customExercises
            .where((exercise) => exercise.isFavourite)
            .map(_PickerItem.custom)
            .toList();
      case _PickerMode.mine:
        items = customExercises.map(_PickerItem.custom).toList();
      case _PickerMode.recent:
        items = _recentItems(snapshot, customById);
    }

    final query = _searchController.text;
    final seen = <String>{};
    final filtered = items.where((item) {
      final selection = item.selection;
      final identity = '${selection.source.name}:${selection.exerciseId}';
      return seen.add(identity) &&
          selection.matchesSearch(query) &&
          (_muscle == null ||
              selection.primaryMuscleGroup == _muscle ||
              selection.secondaryMuscleGroups.contains(_muscle)) &&
          (_equipment == null || selection.equipment == _equipment);
    }).toList();
    if (_mode != _PickerMode.recent) {
      filtered.sort((a, b) {
        // Keep private movements easy to reach even with the full built-in
        // catalogue, then sort each group alphabetically.
        final customOrder = (b.custom == null ? 0 : 1).compareTo(
          a.custom == null ? 0 : 1,
        );
        if (customOrder != 0) return customOrder;
        return a.selection.name.toLowerCase().compareTo(
          b.selection.name.toLowerCase(),
        );
      });
    }
    return filtered;
  }

  List<_PickerItem> _recentItems(
    PlanningSnapshot? snapshot,
    Map<String, CustomExercise> customById,
  ) {
    if (snapshot == null) return [];
    final entries = [...snapshot.templateExercises]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final seen = <String>{};
    final results = <_PickerItem>[];
    for (final entry in entries) {
      final String key;
      final _PickerItem? item;
      if (entry.customExerciseId case final customId?) {
        key = 'custom:$customId';
        final custom = customById[customId];
        item = custom == null ? null : _PickerItem.custom(custom);
      } else if (entry.systemExerciseKey case final systemKey?) {
        key = 'system:$systemKey';
        final selection = SystemExerciseCatalog.byKey(systemKey);
        item = selection == null ? null : _PickerItem.system(selection);
      } else {
        continue;
      }
      if (item != null && seen.add(key)) results.add(item);
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    final customState = ref.watch(customExercisesProvider(widget.userId));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selectionMode
              ? widget.multiSelect
                    ? 'Choose exercises'
                    : 'Choose exercise'
              : 'Exercise library',
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createCustomExercise,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Custom'),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: TextField(
                controller: _searchController,
                autofocus: widget.selectionMode,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search every exercise',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          onPressed: _searchController.clear,
                          icon: const Icon(Icons.close_rounded),
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 60,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: _PickerMode.values
                    .map((mode) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          selected: _mode == mode,
                          label: Text(_modeLabel(mode)),
                          avatar: Icon(_modeIcon(mode), size: 18),
                          onSelected: (_) => setState(() => _mode = mode),
                        ),
                      );
                    })
                    .toList(growable: false),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                children: [
                  DropdownButtonFormField<MuscleGroup?>(
                    initialValue: _muscle,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Muscle',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    items: [
                      const DropdownMenuItem<MuscleGroup?>(
                        child: Text('All muscles'),
                      ),
                      ...MuscleGroup.values.map(
                        (group) => DropdownMenuItem<MuscleGroup?>(
                          value: group,
                          child: Text(group.label),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() => _muscle = value),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<ExerciseEquipment?>(
                    initialValue: _equipment,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Equipment',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    items: [
                      const DropdownMenuItem<ExerciseEquipment?>(
                        child: Text('All equipment'),
                      ),
                      ...ExerciseEquipment.values.map(
                        (equipment) => DropdownMenuItem<ExerciseEquipment?>(
                          value: equipment,
                          child: Text(equipment.label),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() => _equipment = value),
                  ),
                ],
              ),
            ),
            Expanded(
              child: customState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => _PickerErrorState(
                  message: 'Custom exercises could not be loaded: $error',
                  onRetry: () =>
                      ref.invalidate(customExercisesProvider(widget.userId)),
                ),
                data: (customExercises) => FutureBuilder<PlanningSnapshot>(
                  future: _snapshotFuture,
                  builder: (context, snapshotState) {
                    if (_mode == _PickerMode.recent &&
                        snapshotState.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (_mode == _PickerMode.recent && snapshotState.hasError) {
                      return _PickerErrorState(
                        message:
                            'Recently used exercises could not be loaded: ${snapshotState.error}',
                        onRetry: _reloadRecent,
                      );
                    }
                    final items = _itemsFor(
                      customExercises,
                      snapshotState.data,
                    );
                    if (items.isEmpty) {
                      return _PickerEmptyState(
                        mode: _mode,
                        filtered:
                            _searchController.text.trim().isNotEmpty ||
                            _muscle != null ||
                            _equipment != null,
                        onCreate: _createCustomExercise,
                      );
                    }
                    return ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        2,
                        16,
                        widget.multiSelect ? 112 : 96,
                      ),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 9),
                      itemBuilder: (context, index) =>
                          _exerciseTile(items[index]),
                    );
                  },
                ),
              ),
            ),
            if (widget.multiSelect)
              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                  decoration: const BoxDecoration(
                    color: ForgeFitColors.background,
                    border: Border(top: BorderSide(color: Color(0xFF242A32))),
                  ),
                  child: FilledButton.icon(
                    key: const ValueKey('add-selected-exercises-button'),
                    onPressed: _selected.isEmpty
                        ? null
                        : () => Navigator.of(context).pop(
                            List<ExerciseSelection>.unmodifiable(
                              _selected.values,
                            ),
                          ),
                    icon: const Icon(Icons.add_task_rounded),
                    label: Text('Add selected (${_selected.length})'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _exerciseTile(_PickerItem item) {
    final selection = item.selection;
    final custom = item.custom;
    final selectionKey = _selectionKey(selection);
    final unavailable = widget.unavailableExerciseKeys.contains(selectionKey);
    final selected = _selected.containsKey(selectionKey);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(14, 7, 8, 7),
        onTap: widget.selectionMode && !unavailable
            ? widget.multiSelect
                  ? () => setState(() {
                      if (selected) {
                        _selected.remove(selectionKey);
                      } else {
                        _selected[selectionKey] = selection;
                      }
                    })
                  : () => Navigator.of(context).pop(selection)
            : custom == null
            ? null
            : () => _editCustomExercise(custom),
        onLongPress: custom == null ? null : () => _editCustomExercise(custom),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: custom == null
                ? const Color(0xFF073B55)
                : const Color(0xFF272148),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            custom == null
                ? Icons.fitness_center_rounded
                : Icons.person_outline_rounded,
            color: custom == null
                ? ForgeFitColors.electricBlue
                : const Color(0xFFB9A7FF),
          ),
        ),
        title: Text(
          selection.name,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          '${selection.primaryMuscleGroup.label} · ${selection.equipment.label}'
          '${custom?.isFavourite == true ? ' · Favourite' : ''}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: widget.multiSelect
            ? Checkbox.adaptive(
                value: selected,
                onChanged: unavailable
                    ? null
                    : (_) => setState(() {
                        if (selected) {
                          _selected.remove(selectionKey);
                        } else {
                          _selected[selectionKey] = selection;
                        }
                      }),
              )
            : custom == null
            ? Icon(
                unavailable
                    ? Icons.check_circle_outline_rounded
                    : widget.selectionMode
                    ? Icons.chevron_right_rounded
                    : Icons.lock_outline_rounded,
              )
            : _busyCustomIds.contains(custom.id)
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : PopupMenuButton<_CustomAction>(
                tooltip: 'Custom exercise actions',
                onSelected: (action) {
                  switch (action) {
                    case _CustomAction.favourite:
                      _toggleFavourite(custom);
                    case _CustomAction.edit:
                      _editCustomExercise(custom);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: _CustomAction.favourite,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        custom.isFavourite
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                      ),
                      title: Text(
                        custom.isFavourite
                            ? 'Remove favourite'
                            : 'Add favourite',
                      ),
                    ),
                  ),
                  const PopupMenuItem(
                    value: _CustomAction.edit,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Edit exercise'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  String _modeLabel(_PickerMode mode) => switch (mode) {
    _PickerMode.all => 'All',
    _PickerMode.favourites => 'Favourites',
    _PickerMode.recent => 'Recent',
    _PickerMode.mine => 'My exercises',
  };

  IconData _modeIcon(_PickerMode mode) => switch (mode) {
    _PickerMode.all => Icons.apps_rounded,
    _PickerMode.favourites => Icons.star_outline_rounded,
    _PickerMode.recent => Icons.history_rounded,
    _PickerMode.mine => Icons.person_outline_rounded,
  };
}

class _PickerItem {
  const _PickerItem(this.selection, [this.custom]);

  factory _PickerItem.system(ExerciseSelection selection) =>
      _PickerItem(selection);

  factory _PickerItem.custom(CustomExercise exercise) =>
      _PickerItem(exercise.selection, exercise);

  final ExerciseSelection selection;
  final CustomExercise? custom;
}

class _PickerErrorState extends StatelessWidget {
  const _PickerErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 46,
              color: ForgeFitColors.warning,
            ),
            const SizedBox(height: 14),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 18),
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

class _PickerEmptyState extends StatelessWidget {
  const _PickerEmptyState({
    required this.mode,
    required this.filtered,
    required this.onCreate,
  });

  final _PickerMode mode;
  final bool filtered;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final message = filtered
        ? 'No exercises match these filters.'
        : switch (mode) {
            _PickerMode.favourites =>
              'Favourite a custom exercise to keep it close.',
            _PickerMode.recent =>
              'Exercises appear here after you add them to a template.',
            _PickerMode.mine => 'Create your first private exercise.',
            _PickerMode.all => 'No exercises are available.',
          };
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 52,
              color: Color(0xFF69727E),
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFFAAB2BD)),
            ),
            if (!filtered && mode == _PickerMode.mine) ...[
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Create exercise'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
