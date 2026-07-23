import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/providers.dart';
import 'package:forgefit/core/theme/forgefit_theme.dart';
import 'package:forgefit/features/planning/domain/planning_models.dart';

import 'exercise_picker_screen.dart';
import 'template_exercise_editor_sheet.dart';

enum _EntryAction { configure, replace, duplicate, remove }

class TemplateEditorScreen extends ConsumerStatefulWidget {
  const TemplateEditorScreen({
    super.key,
    required this.userId,
    this.template,
    this.initialSplitId,
  });

  final String userId;
  final WorkoutTemplate? template;
  final String? initialSplitId;

  @override
  ConsumerState<TemplateEditorScreen> createState() =>
      _TemplateEditorScreenState();
}

class _TemplateEditorScreenState extends ConsumerState<TemplateEditorScreen> {
  static const _noSplitValue = '__no_split__';
  static const _icons = ['🏋️', '💪', '⚡', '🔥', '🎯', '🚴', '🏠', '🧱'];
  static const _colors = [
    0xFF00A8FF,
    0xFF7C5CFC,
    0xFFFF5C8A,
    0xFFFF9F43,
    0xFF45D483,
    0xFF24C8C8,
    0xFFE0C34A,
    0xFF8E9AAF,
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _iconController;
  late final TextEditingController _notesController;
  late WorkoutTemplate? _template;
  late String? _splitId;
  late int _colorValue;
  bool _busy = false;
  bool _entriesBusy = false;
  bool _showValidation = false;
  bool _detailsDirty = false;

  @override
  void initState() {
    super.initState();
    _template = widget.template;
    _splitId = widget.template?.splitId ?? widget.initialSplitId;
    _colorValue = widget.template?.colorValue ?? _colors.first;
    _nameController = TextEditingController(text: widget.template?.name ?? '');
    _iconController = TextEditingController(
      text: widget.template?.icon ?? '🏋️',
    );
    _notesController = TextEditingController(
      text: widget.template?.notes ?? '',
    );
    _nameController.addListener(_markDetailsDirty);
    _iconController.addListener(_markDetailsDirty);
    _notesController.addListener(_markDetailsDirty);
  }

  @override
  void dispose() {
    _nameController
      ..removeListener(_markDetailsDirty)
      ..dispose();
    _iconController
      ..removeListener(_markDetailsDirty)
      ..dispose();
    _notesController
      ..removeListener(_markDetailsDirty)
      ..dispose();
    super.dispose();
  }

  void _markDetailsDirty() {
    if (!_detailsDirty && mounted) setState(() => _detailsDirty = true);
  }

  Future<void> _saveDetails({bool closeAfter = false}) async {
    setState(() => _showValidation = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _busy = true);
    try {
      final repository = ref.read(planningRepositoryProvider);
      final WorkoutTemplate saved;
      final current = _template;
      if (current == null) {
        saved = await repository.createTemplate(
          userId: widget.userId,
          name: _nameController.text,
          splitId: _splitId,
          icon: _iconController.text,
          colorValue: _colorValue,
          notes: _notesController.text,
        );
      } else {
        saved = await repository.updateTemplate(
          userId: widget.userId,
          templateId: current.id,
          name: _nameController.text,
          splitId: _splitId,
          icon: _iconController.text,
          colorValue: _colorValue,
          notes: _notesController.text,
        );
      }
      if (!mounted) return;
      setState(() {
        _template = saved;
        _splitId = saved.splitId;
        _detailsDirty = false;
        _busy = false;
      });
      unawaited(_trySync());
      if (closeAfter) {
        Navigator.of(context).pop(saved);
      } else if (current == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Template saved. Add any exercises you want.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Template details saved locally.')),
        );
      }
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _busy = false);
      _showError('Template could not be saved on this device: $error');
    }
  }

  Future<void> _done() async {
    final template = _template;
    if (template == null || _detailsDirty) {
      await _saveDetails(closeAfter: true);
    } else {
      Navigator.of(context).pop(template);
    }
  }

  Future<ExerciseSelection?> _pickExercise() {
    return Navigator.of(context).push<ExerciseSelection>(
      MaterialPageRoute(
        builder: (_) => ExercisePickerScreen(userId: widget.userId),
      ),
    );
  }

  Future<void> _addExercise() async {
    final template = _template;
    if (template == null || _entriesBusy) return;
    final selection = await _pickExercise();
    if (selection == null || !mounted) return;
    final configuration = await TemplateExerciseEditorSheet.show(
      context,
      exerciseName: selection.name,
    );
    if (configuration == null || !mounted) return;

    await _runEntryMutation(
      () => ref
          .read(planningRepositoryProvider)
          .addExerciseToTemplate(
            userId: widget.userId,
            templateId: template.id,
            exercise: selection,
            configuration: configuration,
          ),
      failurePrefix: 'Exercise could not be added',
    );
  }

  Future<void> _configureEntry(TemplateExercise entry) async {
    final configuration = await TemplateExerciseEditorSheet.show(
      context,
      initial: entry.configuration,
      exerciseName: entry.exerciseName,
    );
    if (configuration == null || !mounted) return;
    await _runEntryMutation(
      () => ref
          .read(planningRepositoryProvider)
          .updateTemplateExercise(
            userId: widget.userId,
            templateExerciseId: entry.id,
            configuration: configuration,
          ),
      failurePrefix: 'Exercise targets could not be saved',
    );
  }

  Future<void> _replaceEntry(TemplateExercise entry) async {
    final replacement = await _pickExercise();
    if (replacement == null || !mounted) return;
    await _runEntryMutation(
      () => ref
          .read(planningRepositoryProvider)
          .replaceTemplateExercise(
            userId: widget.userId,
            templateExerciseId: entry.id,
            replacement: replacement,
          ),
      failurePrefix: 'Exercise could not be replaced',
    );
  }

  Future<void> _duplicateEntry(TemplateExercise entry) async {
    await _runEntryMutation(
      () => ref
          .read(planningRepositoryProvider)
          .duplicateTemplateExercise(
            userId: widget.userId,
            templateExerciseId: entry.id,
          ),
      failurePrefix: 'Exercise could not be duplicated',
    );
  }

  Future<void> _removeEntry(TemplateExercise entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove exercise?'),
        content: Text(
          '${entry.exerciseName} and its planned targets will be removed from this template.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: ForgeFitColors.danger,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await _runEntryMutation(
      () => ref
          .read(planningRepositoryProvider)
          .removeTemplateExercise(
            userId: widget.userId,
            templateExerciseId: entry.id,
          ),
      failurePrefix: 'Exercise could not be removed',
    );
  }

  Future<void> _reorderEntries(
    List<TemplateExercise> entries,
    int oldIndex,
    int newIndex,
  ) async {
    if (_entriesBusy || oldIndex == newIndex) return;
    final reordered = [...entries];
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);
    final template = _template;
    if (template == null) return;
    await _runEntryMutation(
      () => ref
          .read(planningRepositoryProvider)
          .reorderTemplateExercises(
            userId: widget.userId,
            templateId: template.id,
            orderedTemplateExerciseIds: reordered
                .map((entry) => entry.id)
                .toList(growable: false),
          ),
      failurePrefix: 'Exercise order could not be saved',
    );
  }

  Future<void> _runEntryMutation(
    Future<Object?> Function() mutation, {
    required String failurePrefix,
  }) async {
    if (_entriesBusy) return;
    setState(() => _entriesBusy = true);
    try {
      await mutation();
      unawaited(_trySync());
    } on Object catch (error) {
      if (mounted) _showError('$failurePrefix: $error');
    } finally {
      if (mounted) setState(() => _entriesBusy = false);
    }
  }

  Future<void> _trySync() async {
    try {
      await ref
          .read(syncCoordinatorProvider)
          .sync(widget.userId, forceAfterCurrent: true);
    } on Object {
      // The durable outbox keeps every local change for a later retry.
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final splitsState = ref.watch(workoutSplitsProvider(widget.userId));
    final template = _template;
    final entriesState = template == null
        ? null
        : ref.watch(
            templateExercisesProvider((
              userId: widget.userId,
              templateId: template.id,
            )),
          );

    return PopScope(
      canPop: !_busy && !_entriesBusy,
      child: Scaffold(
        appBar: AppBar(
          title: Text(template == null ? 'Create template' : 'Edit template'),
          actions: [
            TextButton(
              onPressed: _busy || _entriesBusy ? null : _done,
              child: const Text('Done'),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          top: false,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 36),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Form(
                      key: _formKey,
                      autovalidateMode: _showValidation
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      child: _detailsCard(splitsState),
                    ),
                    const SizedBox(height: 18),
                    if (template == null)
                      _BeforeCreateCard(onCreate: () => _saveDetails())
                    else ...[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Exercises',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: _entriesBusy ? null : _addExercise,
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Add exercise'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Choose any movement. The selected split never limits this list.',
                        style: TextStyle(color: Color(0xFF8F99A5)),
                      ),
                      const SizedBox(height: 14),
                      if (_entriesBusy) const LinearProgressIndicator(),
                      if (_entriesBusy) const SizedBox(height: 10),
                      _entriesSection(entriesState!),
                    ],
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _busy ? null : () => _saveDetails(),
                      icon: _busy
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        _busy
                            ? 'Saving on device...'
                            : template == null
                            ? 'Create template'
                            : 'Save template details',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.offline_bolt_outlined,
                          size: 17,
                          color: ForgeFitColors.electricBlue,
                        ),
                        SizedBox(width: 7),
                        Flexible(
                          child: Text(
                            'Every edit is stored locally before cloud sync.',
                            style: TextStyle(color: Color(0xFF87919D)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailsCard(AsyncValue<List<WorkoutSplit>> splitsState) {
    final splits = splitsState.value ?? const <WorkoutSplit>[];
    final selectedUnavailable =
        _splitId != null && !splits.any((split) => split.id == _splitId);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Template details',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              enabled: !_busy,
              autofocus: _template == null,
              textCapitalization: TextCapitalization.words,
              maxLength: 100,
              decoration: const InputDecoration(
                labelText: 'Template name',
                hintText: 'Tuesday strength',
                prefixIcon: Icon(Icons.description_outlined),
              ),
              validator: (value) {
                if ((value ?? '').trim().isEmpty) {
                  return 'Enter a template name.';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              key: ValueKey(_splitId),
              initialValue: _splitId ?? _noSplitValue,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Split (optional)',
                prefixIcon: Icon(Icons.folder_outlined),
              ),
              items: [
                const DropdownMenuItem(
                  value: _noSplitValue,
                  child: Text('No Split'),
                ),
                ...splits.map(
                  (split) => DropdownMenuItem(
                    value: split.id,
                    child: Text('${split.icon}  ${split.name}'),
                  ),
                ),
                if (selectedUnavailable)
                  DropdownMenuItem(
                    value: _splitId,
                    child: const Text('Unavailable split'),
                  ),
              ],
              onChanged: _busy || splitsState.isLoading || splitsState.hasError
                  ? null
                  : (value) {
                      setState(() {
                        _splitId = value == _noSplitValue ? null : value;
                        _detailsDirty = true;
                      });
                    },
            ),
            if (splitsState.isLoading) ...[
              const SizedBox(height: 8),
              const LinearProgressIndicator(),
            ],
            if (splitsState.hasError) ...[
              const SizedBox(height: 8),
              Text(
                'Splits could not be loaded. Keep the current assignment or try again.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () =>
                      ref.invalidate(workoutSplitsProvider(widget.userId)),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Reload splits'),
                ),
              ),
            ],
            const SizedBox(height: 14),
            TextFormField(
              controller: _iconController,
              enabled: !_busy,
              maxLength: 16,
              decoration: const InputDecoration(
                labelText: 'Icon or emoji',
                prefixIcon: Icon(Icons.emoji_emotions_outlined),
              ),
              validator: (value) {
                final icon = (value ?? '').trim();
                if (icon.isEmpty) return 'Choose an icon or emoji.';
                if (icon.runes.length > 16) {
                  return 'Use 16 characters or fewer.';
                }
                return null;
              },
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _icons
                  .map(
                    (icon) => ChoiceChip(
                      label: Text(icon),
                      selected: _iconController.text == icon,
                      onSelected: _busy
                          ? null
                          : (_) {
                              setState(() {
                                _iconController.text = icon;
                                _detailsDirty = true;
                              });
                            },
                    ),
                  )
                  .toList(growable: false),
            ),
            const SizedBox(height: 20),
            Text(
              'Colour',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 11,
              runSpacing: 11,
              children: _colors
                  .map((value) {
                    final selected = value == _colorValue;
                    return InkWell(
                      onTap: _busy
                          ? null
                          : () {
                              setState(() {
                                _colorValue = value;
                                _detailsDirty = true;
                              });
                            },
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Color(value),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected ? Colors.white : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: selected
                            ? const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    );
                  })
                  .toList(growable: false),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _notesController,
              enabled: !_busy,
              textCapitalization: TextCapitalization.sentences,
              minLines: 2,
              maxLines: 5,
              maxLength: 4000,
              decoration: const InputDecoration(
                labelText: 'Template notes (optional)',
                hintText: 'Goal, progression, or setup notes',
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _entriesSection(AsyncValue<List<TemplateExercise>> state) {
    return state.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(30),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: ForgeFitColors.warning,
                size: 38,
              ),
              const SizedBox(height: 10),
              Text(
                'Exercises could not be loaded: $error',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  final template = _template;
                  if (template == null) return;
                  ref.invalidate(
                    templateExercisesProvider((
                      userId: widget.userId,
                      templateId: template.id,
                    )),
                  );
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
      data: (entries) {
        if (entries.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 28, 22, 26),
              child: Column(
                children: [
                  const Icon(
                    Icons.playlist_add_rounded,
                    size: 52,
                    color: Color(0xFF69727E),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Build this workout your way',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'No exercise is mandatory. Add any built-in or custom movement.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF8F99A5)),
                  ),
                  const SizedBox(height: 18),
                  OutlinedButton.icon(
                    onPressed: _entriesBusy ? null : _addExercise,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add first exercise'),
                  ),
                ],
              ),
            ),
          );
        }
        return ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          itemCount: entries.length,
          onReorderItem: (oldIndex, newIndex) =>
              _reorderEntries(entries, oldIndex, newIndex),
          itemBuilder: (context, index) {
            final entry = entries[index];
            return Padding(
              key: ValueKey(entry.id),
              padding: const EdgeInsets.only(bottom: 10),
              child: _entryCard(entry, index),
            );
          },
        );
      },
    );
  }

  Widget _entryCard(TemplateExercise entry, int index) {
    final details = <String>[
      '${entry.workingSets} working set${entry.workingSets == 1 ? '' : 's'}',
      if (entry.warmupSets > 0) '${entry.warmupSets} warm-up',
      '${entry.targetRepsMin}–${entry.targetRepsMax} reps',
      '${entry.restSeconds}s rest',
      if (entry.targetWeight != null) '${_number(entry.targetWeight!)} target',
      if (entry.rpeTarget != null) 'RPE ${_number(entry.rpeTarget!)}',
      if (entry.rirTarget != null) 'RIR ${_number(entry.rirTarget!)}',
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 4, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReorderableDragStartListener(
              index: index,
              enabled: !_entriesBusy,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(4, 16, 10, 16),
                child: Icon(
                  Icons.drag_indicator_rounded,
                  color: Color(0xFF69727E),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: _entriesBusy ? null : () => _configureEntry(entry),
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.exerciseName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${entry.primaryMuscleGroup.label} · ${entry.equipment.label}',
                        style: const TextStyle(color: Color(0xFF8F99A5)),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        details.join('  ·  '),
                        style: const TextStyle(
                          color: Color(0xFFC4CBD4),
                          height: 1.35,
                        ),
                      ),
                      if (entry.notes case final notes?) ...[
                        const SizedBox(height: 6),
                        Text(
                          notes,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF8F99A5),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            PopupMenuButton<_EntryAction>(
              enabled: !_entriesBusy,
              tooltip: 'Exercise actions',
              onSelected: (action) {
                switch (action) {
                  case _EntryAction.configure:
                    _configureEntry(entry);
                  case _EntryAction.replace:
                    _replaceEntry(entry);
                  case _EntryAction.duplicate:
                    _duplicateEntry(entry);
                  case _EntryAction.remove:
                    _removeEntry(entry);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: _EntryAction.configure,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.tune_rounded),
                    title: Text('Edit targets'),
                  ),
                ),
                PopupMenuItem(
                  value: _EntryAction.replace,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.swap_horiz_rounded),
                    title: Text('Replace exercise'),
                  ),
                ),
                PopupMenuItem(
                  value: _EntryAction.duplicate,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.copy_rounded),
                    title: Text('Duplicate entry'),
                  ),
                ),
                PopupMenuItem(
                  value: _EntryAction.remove,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.delete_outline_rounded,
                      color: ForgeFitColors.danger,
                    ),
                    title: Text('Remove exercise'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _number(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);
}

class _BeforeCreateCard extends StatelessWidget {
  const _BeforeCreateCard({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const Icon(
              Icons.playlist_add_check_circle_outlined,
              color: ForgeFitColors.electricBlue,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'Save the template, then add exercises',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 7),
            const Text(
              'The template is stored on this device first. It can stay empty or contain any exercises you choose.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF8F99A5), height: 1.4),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Create and continue'),
            ),
          ],
        ),
      ),
    );
  }
}
