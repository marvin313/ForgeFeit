import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/providers.dart';
import 'package:intl/intl.dart';

class WorkoutFormScreen extends ConsumerStatefulWidget {
  const WorkoutFormScreen({
    super.key,
    required this.userId,
    required this.weightUnit,
    this.initialExerciseName,
  });

  final String userId;
  final String weightUnit;
  final String? initialExerciseName;

  @override
  ConsumerState<WorkoutFormScreen> createState() => _WorkoutFormScreenState();
}

class _WorkoutFormScreenState extends ConsumerState<WorkoutFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _exerciseController;
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  DateTime _performedAt = DateTime.now();
  bool _isSaving = false;
  bool _showValidation = false;

  @override
  void initState() {
    super.initState();
    _exerciseController = TextEditingController(
      text: widget.initialExerciseName?.trim() ?? '',
    );
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  Future<void> _chooseDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _performedAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (selected == null || !mounted) return;
    setState(() {
      _performedAt = DateTime(
        selected.year,
        selected.month,
        selected.day,
        _performedAt.hour,
        _performedAt.minute,
      );
    });
  }

  Future<void> _chooseTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_performedAt),
    );
    if (selected == null || !mounted) return;
    setState(() {
      _performedAt = DateTime(
        _performedAt.year,
        _performedAt.month,
        _performedAt.day,
        selected.hour,
        selected.minute,
      );
    });
  }

  Future<void> _save() async {
    setState(() => _showValidation = true);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final weight = double.parse(_weightController.text.replaceAll(',', '.'));
    final reps = int.parse(_repsController.text);
    try {
      await ref
          .read(workoutRepositoryProvider)
          .saveWorkout(
            userId: widget.userId,
            exerciseName: _exerciseController.text.trim(),
            weight: weight,
            reps: reps,
            performedAt: _performedAt,
          );
      unawaited(_trySync());
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Workout could not be saved on this device: $error'),
        ),
      );
    }
  }

  Future<void> _trySync() async {
    try {
      await ref
          .read(syncCoordinatorProvider)
          .sync(widget.userId, forceAfterCurrent: true);
    } on Object {
      // The coordinator exposes the failure and pending count in its status.
    }
  }

  @override
  Widget build(BuildContext context) {
    final unit = widget.weightUnit == 'lb' ? 'lb' : 'kg';
    return Scaffold(
      appBar: AppBar(title: const Text('Log workout')),
      body: SafeArea(
        top: false,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
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
                      'One exercise. One set. Saved offline first.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFFAAB2BD),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _exerciseController,
                      enabled: !_isSaving,
                      autofocus: _exerciseController.text.isEmpty,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Exercise name',
                        hintText: 'Bench press',
                        prefixIcon: Icon(Icons.fitness_center_rounded),
                      ),
                      validator: (value) {
                        final exercise = value?.trim() ?? '';
                        if (exercise.isEmpty) {
                          return 'Enter an exercise name.';
                        }
                        if (exercise.length > 100) {
                          return 'Exercise name must be 100 characters or fewer.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _weightController,
                            enabled: !_isSaving,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.,]'),
                              ),
                            ],
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Weight ($unit)',
                              hintText: '80',
                            ),
                            validator: (value) {
                              final weight = double.tryParse(
                                (value ?? '').replaceAll(',', '.'),
                              );
                              if (weight == null) {
                                return 'Enter a weight.';
                              }
                              if (weight < 0 || weight > 5000) {
                                return 'Use 0-5000.';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: TextFormField(
                            controller: _repsController,
                            enabled: !_isSaving,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              labelText: 'Reps',
                              hintText: '8',
                            ),
                            validator: (value) {
                              final reps = int.tryParse(value ?? '');
                              if (reps == null) {
                                return 'Enter reps.';
                              }
                              if (reps < 1 || reps > 1000) {
                                return 'Use 1-1000.';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => _save(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Date and time',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isSaving ? null : _chooseDate,
                            icon: const Icon(Icons.calendar_today_outlined),
                            label: Text(
                              DateFormat.yMMMd().format(_performedAt),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isSaving ? null : _chooseTime,
                            icon: const Icon(Icons.schedule_rounded),
                            label: Text(DateFormat.jm().format(_performedAt)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    FilledButton.icon(
                      onPressed: _isSaving ? null : _save,
                      icon: _isSaving
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        _isSaving ? 'Saving on device...' : 'Save workout',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.offline_bolt_outlined,
                          size: 16,
                          color: Color(0xFF87919D),
                        ),
                        SizedBox(width: 7),
                        Flexible(
                          child: Text(
                            'Internet is not required to save.',
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
}
