import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/providers.dart';
import 'package:forgefit/core/theme/forgefit_theme.dart';
import 'package:forgefit/features/planning/domain/planning_models.dart';

class CustomExerciseEditorScreen extends ConsumerStatefulWidget {
  const CustomExerciseEditorScreen({
    super.key,
    required this.userId,
    this.exercise,
  });

  final String userId;
  final CustomExercise? exercise;

  @override
  ConsumerState<CustomExerciseEditorScreen> createState() =>
      _CustomExerciseEditorScreenState();
}

class _CustomExerciseEditorScreenState
    extends ConsumerState<CustomExerciseEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _aliasesController;
  late final TextEditingController _keywordsController;
  late final TextEditingController _instructionsController;
  late final TextEditingController _notesController;
  late MuscleGroup _primaryMuscle;
  late ExerciseEquipment _equipment;
  late Set<MuscleGroup> _secondaryMuscles;
  late bool _isFavourite;
  bool _busy = false;
  bool _showValidation = false;

  bool get _editing => widget.exercise != null;

  @override
  void initState() {
    super.initState();
    final exercise = widget.exercise;
    _nameController = TextEditingController(text: exercise?.name ?? '');
    _aliasesController = TextEditingController(
      text: exercise?.aliases.join(', ') ?? '',
    );
    _keywordsController = TextEditingController(
      text: exercise?.keywords.join(', ') ?? '',
    );
    _instructionsController = TextEditingController(
      text: exercise?.instructions ?? '',
    );
    _notesController = TextEditingController(
      text: exercise?.personalNotes ?? '',
    );
    _primaryMuscle = exercise?.primaryMuscleGroup ?? MuscleGroup.other;
    _equipment = exercise?.equipment ?? ExerciseEquipment.other;
    _secondaryMuscles = {...?exercise?.secondaryMuscleGroups};
    _isFavourite = exercise?.isFavourite ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aliasesController.dispose();
    _keywordsController.dispose();
    _instructionsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _showValidation = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _busy = true);
    try {
      final repository = ref.read(planningRepositoryProvider);
      final CustomExercise saved;
      final current = widget.exercise;
      if (current == null) {
        saved = await repository.createCustomExercise(
          userId: widget.userId,
          name: _nameController.text,
          primaryMuscleGroup: _primaryMuscle,
          secondaryMuscleGroups: _secondaryMuscles,
          equipment: _equipment,
          aliases: _searchTerms(_aliasesController.text),
          keywords: _searchTerms(_keywordsController.text),
          instructions: _instructionsController.text,
          personalNotes: _notesController.text,
          isFavourite: _isFavourite,
        );
      } else {
        saved = await repository.updateCustomExercise(
          userId: widget.userId,
          exerciseId: current.id,
          name: _nameController.text,
          primaryMuscleGroup: _primaryMuscle,
          secondaryMuscleGroups: _secondaryMuscles,
          equipment: _equipment,
          aliases: _searchTerms(_aliasesController.text),
          keywords: _searchTerms(_keywordsController.text),
          instructions: _instructionsController.text,
          personalNotes: _notesController.text,
          isFavourite: _isFavourite,
        );
      }
      unawaited(_trySync());
      if (mounted) Navigator.of(context).pop(saved);
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _busy = false);
      _showError('Custom exercise could not be saved on this device: $error');
    }
  }

  Future<void> _delete() async {
    final exercise = widget.exercise;
    if (exercise == null || _busy) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete custom exercise?'),
        content: const Text(
          'The exercise will be hidden. Existing template entries keep their saved name and targets.',
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
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);
    try {
      await ref
          .read(planningRepositoryProvider)
          .deleteCustomExercise(userId: widget.userId, exerciseId: exercise.id);
      unawaited(_trySync());
      if (mounted) Navigator.of(context).pop();
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _busy = false);
      _showError('Custom exercise could not be deleted: $error');
    }
  }

  Future<void> _trySync() async {
    try {
      await ref
          .read(syncCoordinatorProvider)
          .sync(widget.userId, forceAfterCurrent: true);
    } on Object {
      // The durable queue keeps the local change for a later retry.
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_busy,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editing ? 'Edit custom exercise' : 'Custom exercise'),
        ),
        body: SafeArea(
          top: false,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _showValidation
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Private to your account and available offline.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFFAAB2BD),
                        ),
                      ),
                      const SizedBox(height: 22),
                      TextFormField(
                        controller: _nameController,
                        enabled: !_busy,
                        autofocus: !_editing,
                        textCapitalization: TextCapitalization.words,
                        maxLength: 120,
                        decoration: const InputDecoration(
                          labelText: 'Exercise name',
                          hintText: 'Single-arm cable press',
                          prefixIcon: Icon(Icons.fitness_center_rounded),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'Enter an exercise name.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _aliasesController,
                        enabled: !_busy,
                        maxLength: 1200,
                        decoration: const InputDecoration(
                          labelText: 'Search aliases (optional)',
                          hintText: 'RDL, stiff-leg hinge',
                          helperText: 'Separate aliases with commas.',
                          prefixIcon: Icon(Icons.alternate_email_rounded),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _keywordsController,
                        enabled: !_busy,
                        maxLength: 1200,
                        decoration: const InputDecoration(
                          labelText: 'Search keywords (optional)',
                          hintText: 'hamstrings, posterior chain',
                          helperText: 'Separate keywords with commas.',
                          prefixIcon: Icon(Icons.tag_rounded),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<MuscleGroup>(
                        initialValue: _primaryMuscle,
                        decoration: const InputDecoration(
                          labelText: 'Primary muscle group',
                          prefixIcon: Icon(Icons.accessibility_new_rounded),
                        ),
                        items: MuscleGroup.values
                            .map(
                              (group) => DropdownMenuItem(
                                value: group,
                                child: Text(group.label),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: _busy
                            ? null
                            : (value) {
                                if (value == null) return;
                                setState(() {
                                  _primaryMuscle = value;
                                  _secondaryMuscles.remove(value);
                                });
                              },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<ExerciseEquipment>(
                        initialValue: _equipment,
                        decoration: const InputDecoration(
                          labelText: 'Equipment',
                          prefixIcon: Icon(Icons.handyman_outlined),
                        ),
                        items: ExerciseEquipment.values
                            .map(
                              (equipment) => DropdownMenuItem(
                                value: equipment,
                                child: Text(equipment.label),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: _busy
                            ? null
                            : (value) {
                                if (value != null) {
                                  setState(() => _equipment = value);
                                }
                              },
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Secondary muscles (optional)',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: MuscleGroup.values
                            .where((group) => group != _primaryMuscle)
                            .map(
                              (group) => FilterChip(
                                label: Text(group.label),
                                selected: _secondaryMuscles.contains(group),
                                onSelected: _busy
                                    ? null
                                    : (selected) {
                                        setState(() {
                                          if (selected) {
                                            _secondaryMuscles.add(group);
                                          } else {
                                            _secondaryMuscles.remove(group);
                                          }
                                        });
                                      },
                              ),
                            )
                            .toList(growable: false),
                      ),
                      const SizedBox(height: 22),
                      TextFormField(
                        controller: _instructionsController,
                        enabled: !_busy,
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 3,
                        maxLines: 7,
                        maxLength: 8000,
                        decoration: const InputDecoration(
                          labelText: 'Instructions (optional)',
                          hintText: 'Setup and movement cues',
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _notesController,
                        enabled: !_busy,
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 2,
                        maxLines: 5,
                        maxLength: 4000,
                        decoration: const InputDecoration(
                          labelText: 'Personal notes (optional)',
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        child: SwitchListTile.adaptive(
                          value: _isFavourite,
                          onChanged: _busy
                              ? null
                              : (value) {
                                  setState(() => _isFavourite = value);
                                },
                          title: const Text('Favourite'),
                          subtitle: const Text(
                            'Show this movement in the Favourites filter.',
                          ),
                          secondary: Icon(
                            _isFavourite
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: _isFavourite
                                ? const Color(0xFFFFC857)
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                      FilledButton.icon(
                        onPressed: _busy ? null : _save,
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
                              : _editing
                              ? 'Save exercise'
                              : 'Create exercise',
                        ),
                      ),
                      if (_editing) ...[
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: ForgeFitColors.danger,
                          ),
                          onPressed: _busy ? null : _delete,
                          icon: const Icon(Icons.delete_outline_rounded),
                          label: const Text('Delete custom exercise'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<String> _searchTerms(String value) => value
    .split(RegExp(r'[,\n]'))
    .map((term) => term.trim())
    .where((term) => term.isNotEmpty)
    .toList(growable: false);
