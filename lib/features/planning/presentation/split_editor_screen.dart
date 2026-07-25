import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/providers.dart';
import 'package:forgefit/features/planning/domain/planning_models.dart';

class SplitEditorScreen extends ConsumerStatefulWidget {
  const SplitEditorScreen({super.key, required this.userId, this.split});

  final String userId;
  final WorkoutSplit? split;

  @override
  ConsumerState<SplitEditorScreen> createState() => _SplitEditorScreenState();
}

class _SplitEditorScreenState extends ConsumerState<SplitEditorScreen> {
  static const _icons = ['📁', '🏋️', '💪', '⚡', '🔥', '🏠', '🚴', '🎯'];
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
  late final TextEditingController _descriptionController;
  late final TextEditingController _iconController;
  late int _colorValue;
  bool _saving = false;
  bool _showValidation = false;

  bool get _editing => widget.split != null;

  @override
  void initState() {
    super.initState();
    final split = widget.split;
    _nameController = TextEditingController(text: split?.name ?? '');
    _descriptionController = TextEditingController(
      text: split?.description ?? '',
    );
    _iconController = TextEditingController(text: split?.icon ?? '📁');
    _colorValue = split?.colorValue ?? _colors.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _showValidation = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _saving = true);
    try {
      final repository = ref.read(planningRepositoryProvider);
      final WorkoutSplit saved;
      final current = widget.split;
      if (current == null) {
        saved = await repository.createSplit(
          userId: widget.userId,
          name: _nameController.text,
          description: _descriptionController.text,
          icon: _iconController.text,
          colorValue: _colorValue,
        );
      } else {
        saved = await repository.updateSplit(
          userId: widget.userId,
          splitId: current.id,
          name: _nameController.text,
          description: _descriptionController.text,
          icon: _iconController.text,
          colorValue: _colorValue,
        );
      }
      unawaited(_trySync());
      if (mounted) Navigator.of(context).pop(saved);
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      _showError('Split could not be saved on this device: $error');
    }
  }

  Future<void> _trySync() async {
    try {
      await ref
          .read(syncCoordinatorProvider)
          .sync(widget.userId, forceAfterCurrent: true);
    } on Object {
      // The durable outbox and global sync status retain the failure.
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
      canPop: !_saving,
      child: Scaffold(
        appBar: AppBar(title: Text(_editing ? 'Edit split' : 'Create split')),
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
                        'Splits are optional folders. They never control which exercises you can choose.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFFAAB2BD),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 22),
                      TextFormField(
                        controller: _nameController,
                        enabled: !_saving,
                        autofocus: !_editing,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        maxLength: 100,
                        decoration: const InputDecoration(
                          labelText: 'Split name',
                          hintText: 'Current program',
                          prefixIcon: Icon(Icons.folder_outlined),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'Enter a split name.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descriptionController,
                        enabled: !_saving,
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 2,
                        maxLines: 4,
                        maxLength: 1000,
                        decoration: const InputDecoration(
                          labelText: 'Description (optional)',
                          hintText: 'What this group of templates is for',
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _iconController,
                        enabled: !_saving,
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
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _icons
                            .map(
                              (icon) => ChoiceChip(
                                label: Text(icon),
                                selected: _iconController.text == icon,
                                onSelected: _saving
                                    ? null
                                    : (_) {
                                        setState(() {
                                          _iconController.text = icon;
                                        });
                                      },
                              ),
                            )
                            .toList(growable: false),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Colour',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _colors
                            .map((value) {
                              final selected = value == _colorValue;
                              return Semantics(
                                button: true,
                                selected: selected,
                                label: selected
                                    ? 'Selected split colour'
                                    : 'Choose split colour',
                                child: InkWell(
                                  onTap: _saving
                                      ? null
                                      : () =>
                                            setState(() => _colorValue = value),
                                  borderRadius: BorderRadius.circular(18),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 160),
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Color(value),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selected
                                            ? Colors.white
                                            : Colors.transparent,
                                        width: 3,
                                      ),
                                      boxShadow: selected
                                          ? [
                                              BoxShadow(
                                                color: Color(
                                                  value,
                                                ).withValues(alpha: 0.35),
                                                blurRadius: 16,
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: selected
                                        ? const Icon(
                                            Icons.check_rounded,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),
                              );
                            })
                            .toList(growable: false),
                      ),
                      const SizedBox(height: 30),
                      FilledButton.icon(
                        onPressed: _saving ? null : _save,
                        icon: _saving
                            ? const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Icon(Icons.save_outlined),
                        label: Text(
                          _saving
                              ? 'Saving on device...'
                              : _editing
                              ? 'Save split'
                              : 'Create split',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.offline_bolt_outlined,
                            color: Theme.of(context).colorScheme.primary,
                            size: 17,
                          ),
                          SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              'Saved locally first. Sync retries automatically.',
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
      ),
    );
  }
}
