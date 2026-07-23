import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/app_flow.dart';
import 'package:forgefit/app/branding.dart';
import 'package:forgefit/core/theme/forgefit_theme.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  WeightUnit _unit = WeightUnit.kilograms;
  bool _showValidation = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    setState(() => _showValidation = true);
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isSaving = true);
    try {
      await ref
          .read(appFlowProvider.notifier)
          .finishOnboarding(
            displayName: _nameController.text,
            preferredWeightUnit: _unit,
          );
    } on Object {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save setup on this device. Try again.'),
        ),
      );
    }
  }

  Future<void> _useExistingAccount() async {
    setState(() => _isSaving = true);
    try {
      await ref.read(appFlowProvider.notifier).useExistingAccount();
    } on Object {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save setup on this device. Try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Form(
                key: _formKey,
                autovalidateMode: _showValidation
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: ForgeFitBrand(),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      'Train offline.\nKeep every rep.',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Start with the basics. ForgeFit saves your workout on '
                      'this device first, then securely syncs it when it can.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFFAAB2BD),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 36),
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Your name',
                        hintText: 'Marvin',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                      validator: (value) {
                        final name = value?.trim() ?? '';
                        if (name.isEmpty) {
                          return 'Enter the name you want ForgeFit to use.';
                        }
                        if (name.length < 2) {
                          return 'Name must be at least 2 characters.';
                        }
                        if (name.length > 60) {
                          return 'Name must be 60 characters or fewer.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _continue(),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Preferred weight unit',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<WeightUnit>(
                      segments: const [
                        ButtonSegment(
                          value: WeightUnit.kilograms,
                          label: Text('Kilograms (kg)'),
                        ),
                        ButtonSegment(
                          value: WeightUnit.pounds,
                          label: Text('Pounds (lb)'),
                        ),
                      ],
                      selected: {_unit},
                      showSelectedIcon: false,
                      style: ButtonStyle(
                        minimumSize: const WidgetStatePropertyAll(
                          Size.fromHeight(52),
                        ),
                        backgroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? ForgeFitColors.electricBlue.withValues(
                                  alpha: 0.18,
                                )
                              : ForgeFitColors.surface,
                        ),
                      ),
                      onSelectionChanged: (selection) {
                        setState(() => _unit = selection.first);
                      },
                    ),
                    const SizedBox(height: 32),
                    FilledButton(
                      onPressed: _isSaving ? null : _continue,
                      child: _isSaving
                          ? const SizedBox.square(
                              dimension: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text('Create my account'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _isSaving ? null : _useExistingAccount,
                      child: const Text('I already have an account'),
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
