import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forgefit/features/planning/domain/planning_models.dart';

class TemplateExerciseEditorSheet extends StatefulWidget {
  const TemplateExerciseEditorSheet({
    super.key,
    required this.initial,
    this.exerciseName,
  });

  final TemplateExerciseConfiguration initial;
  final String? exerciseName;

  static Future<TemplateExerciseConfiguration?> show(
    BuildContext context, {
    TemplateExerciseConfiguration initial =
        const TemplateExerciseConfiguration(),
    String? exerciseName,
  }) {
    return showModalBottomSheet<TemplateExerciseConfiguration>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => TemplateExerciseEditorSheet(
        initial: initial,
        exerciseName: exerciseName,
      ),
    );
  }

  @override
  State<TemplateExerciseEditorSheet> createState() =>
      _TemplateExerciseEditorSheetState();
}

class _TemplateExerciseEditorSheetState
    extends State<TemplateExerciseEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _workingSetsController;
  late final TextEditingController _warmupSetsController;
  late final TextEditingController _minimumRepsController;
  late final TextEditingController _maximumRepsController;
  late final TextEditingController _weightController;
  late final TextEditingController _restController;
  late final TextEditingController _rpeController;
  late final TextEditingController _rirController;
  late final TextEditingController _notesController;
  bool _showValidation = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _workingSetsController = TextEditingController(
      text: initial.workingSets.toString(),
    );
    _warmupSetsController = TextEditingController(
      text: initial.warmupSets.toString(),
    );
    _minimumRepsController = TextEditingController(
      text: initial.targetRepsMin.toString(),
    );
    _maximumRepsController = TextEditingController(
      text: initial.targetRepsMax.toString(),
    );
    _weightController = TextEditingController(
      text: _optionalNumber(initial.targetWeight),
    );
    _restController = TextEditingController(
      text: initial.restSeconds.toString(),
    );
    _rpeController = TextEditingController(
      text: _optionalNumber(initial.rpeTarget),
    );
    _rirController = TextEditingController(
      text: _optionalNumber(initial.rirTarget),
    );
    _notesController = TextEditingController(text: initial.notes ?? '');
  }

  @override
  void dispose() {
    _workingSetsController.dispose();
    _warmupSetsController.dispose();
    _minimumRepsController.dispose();
    _maximumRepsController.dispose();
    _weightController.dispose();
    _restController.dispose();
    _rpeController.dispose();
    _rirController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _optionalNumber(double? value) {
    if (value == null) return '';
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  int? _integer(TextEditingController controller) {
    return int.tryParse(controller.text.trim());
  }

  double? _optionalDouble(TextEditingController controller) {
    final text = controller.text.trim().replaceAll(',', '.');
    return text.isEmpty ? null : double.tryParse(text);
  }

  void _submit() {
    setState(() => _showValidation = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      TemplateExerciseConfiguration(
        workingSets: _integer(_workingSetsController)!,
        warmupSets: _integer(_warmupSetsController)!,
        targetRepsMin: _integer(_minimumRepsController)!,
        targetRepsMax: _integer(_maximumRepsController)!,
        targetWeight: _optionalDouble(_weightController),
        restSeconds: _integer(_restController)!,
        rpeTarget: _optionalDouble(_rpeController),
        rirTarget: _optionalDouble(_rirController),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      ),
    );
  }

  String? _requiredInteger(
    String? value, {
    required String label,
    required int minimum,
    required int maximum,
  }) {
    final parsed = int.tryParse((value ?? '').trim());
    if (parsed == null) return 'Enter $label.';
    if (parsed < minimum || parsed > maximum) {
      return 'Use $minimum–$maximum.';
    }
    return null;
  }

  String? _optionalDecimal(
    String? value, {
    required double minimum,
    double? maximum,
    int? decimalPlaces,
  }) {
    final text = (value ?? '').trim().replaceAll(',', '.');
    if (text.isEmpty) return null;
    final parsed = double.tryParse(text);
    if (parsed == null || !parsed.isFinite) return 'Enter a valid number.';
    if (parsed < minimum || (maximum != null && parsed > maximum)) {
      return maximum == null
          ? 'Use $minimum or more.'
          : 'Use $minimum–$maximum.';
    }
    if (decimalPlaces case final places?) {
      var scale = 1.0;
      for (var index = 0; index < places; index++) {
        scale *= 10;
      }
      final scaled = parsed * scale;
      if ((scaled - scaled.round()).abs() > 0.000001) {
        return 'Use no more than $places decimal places.';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.88,
        minChildSize: 0.55,
        maxChildSize: 0.96,
        builder: (context, scrollController) => Form(
          key: _formKey,
          autovalidateMode: _showValidation
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            children: [
              Text(
                widget.exerciseName == null
                    ? 'Exercise targets'
                    : widget.exerciseName!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Only working sets and the rep range are required. Leave optional targets blank.',
                style: TextStyle(color: Color(0xFFAAB2BD), height: 1.4),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _IntegerField(
                      controller: _workingSetsController,
                      label: 'Working sets',
                      validator: (value) => _requiredInteger(
                        value,
                        label: 'working sets',
                        minimum: 1,
                        maximum: 100,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _IntegerField(
                      controller: _warmupSetsController,
                      label: 'Warm-up sets',
                      validator: (value) => _requiredInteger(
                        value,
                        label: 'warm-up sets',
                        minimum: 0,
                        maximum: 100,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _IntegerField(
                      controller: _minimumRepsController,
                      label: 'Minimum reps',
                      validator: (value) => _requiredInteger(
                        value,
                        label: 'minimum reps',
                        minimum: 1,
                        maximum: 1000,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _IntegerField(
                      controller: _maximumRepsController,
                      label: 'Maximum reps',
                      validator: (value) {
                        final basic = _requiredInteger(
                          value,
                          label: 'maximum reps',
                          minimum: 1,
                          maximum: 1000,
                        );
                        if (basic != null) return basic;
                        final minimum = _integer(_minimumRepsController);
                        final maximum = int.parse(value!.trim());
                        if (minimum != null && maximum < minimum) {
                          return 'Must be at least $minimum.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Target weight (profile unit, optional)',
                  hintText: '80',
                  prefixIcon: Icon(Icons.monitor_weight_outlined),
                ),
                validator: (value) => _optionalDecimal(
                  value,
                  minimum: 0,
                  maximum: 9999999.999,
                  decimalPlaces: 3,
                ),
              ),
              const SizedBox(height: 14),
              _IntegerField(
                controller: _restController,
                label: 'Rest time (seconds)',
                icon: Icons.timer_outlined,
                validator: (value) => _requiredInteger(
                  value,
                  label: 'rest time',
                  minimum: 0,
                  maximum: 7200,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _rpeController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'RPE (optional)',
                        hintText: '8',
                      ),
                      validator: (value) => _optionalDecimal(
                        value,
                        minimum: 1,
                        maximum: 10,
                        decimalPlaces: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _rirController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'RIR (optional)',
                        hintText: '2',
                      ),
                      validator: (value) => _optionalDecimal(
                        value,
                        minimum: 0,
                        maximum: 10,
                        decimalPlaces: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _notesController,
                textCapitalization: TextCapitalization.sentences,
                minLines: 2,
                maxLines: 5,
                maxLength: 4000,
                decoration: const InputDecoration(
                  labelText: 'Exercise notes (optional)',
                  hintText: 'Tempo, setup, or progression cue',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check_rounded),
                label: const Text('Apply targets'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntegerField extends StatelessWidget {
  const _IntegerField({
    required this.controller,
    required this.label,
    required this.validator,
    this.icon,
  });

  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String> validator;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon == null ? null : Icon(icon),
      ),
      validator: validator,
    );
  }
}
