import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/app_flow.dart';
import 'package:forgefit/app/branding.dart';
import 'package:forgefit/features/auth/presentation/auth_controller.dart';
import 'package:forgefit/features/auth/presentation/auth_validation.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late AuthMode _mode;
  bool _passwordVisible = false;
  bool _showValidation = false;
  String? _confirmationEmail;

  @override
  void initState() {
    super.initState();
    _mode = ref.read(appFlowProvider).authMode;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _setMode(AuthMode mode) {
    setState(() {
      _mode = mode;
      _confirmationEmail = null;
      _showValidation = false;
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  Future<void> _submit() async {
    setState(() => _showValidation = true);
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    try {
      if (_mode == AuthMode.register) {
        final flow = ref.read(appFlowProvider);
        final result = await ref
            .read(authControllerProvider.notifier)
            .register(
              email: _emailController.text,
              password: _passwordController.text,
              displayName: flow.displayName,
              preferredWeightUnit: flow.preferredWeightUnit.symbol,
            );
        if (mounted && result.needsEmailConfirmation) {
          setState(() => _confirmationEmail = _emailController.text.trim());
        }
      } else {
        await ref
            .read(authControllerProvider.notifier)
            .login(
              email: _emailController.text,
              password: _passwordController.text,
            );
      }
    } on Object catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(describeAuthError(error))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = ref.watch(authControllerProvider).isLoading;
    final flow = ref.watch(appFlowProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back to welcome',
          onPressed: isBusy
              ? null
              : ref.read(appFlowProvider.notifier).showRegistration,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: _confirmationEmail == null
                  ? Form(
                      key: _formKey,
                      autovalidateMode: _showValidation
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: ForgeFitBrand(compact: true),
                          ),
                          const SizedBox(height: 36),
                          Text(
                            _mode == AuthMode.register
                                ? 'Create your account'
                                : 'Welcome back',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _mode == AuthMode.register
                                ? 'Your workouts stay available offline and sync to your private account.'
                                : 'Log in to restore your workout history on this device.',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: const Color(0xFFAAB2BD),
                                  height: 1.45,
                                ),
                          ),
                          if (_mode == AuthMode.register) ...[
                            const SizedBox(height: 20),
                            _ProfilePreview(flow: flow),
                          ],
                          const SizedBox(height: 28),
                          SegmentedButton<AuthMode>(
                            segments: const [
                              ButtonSegment(
                                value: AuthMode.register,
                                label: Text('Register'),
                              ),
                              ButtonSegment(
                                value: AuthMode.login,
                                label: Text('Log in'),
                              ),
                            ],
                            selected: {_mode},
                            showSelectedIcon: false,
                            onSelectionChanged: isBusy
                                ? null
                                : (selection) => _setMode(selection.first),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _emailController,
                            enabled: !isBusy,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            autofillHints: const [AutofillHints.email],
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'you@example.com',
                              prefixIcon: Icon(Icons.mail_outline_rounded),
                            ),
                            validator: validateEmail,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            enabled: !isBusy,
                            obscureText: !_passwordVisible,
                            textInputAction: _mode == AuthMode.register
                                ? TextInputAction.next
                                : TextInputAction.done,
                            autofillHints: [
                              _mode == AuthMode.register
                                  ? AutofillHints.newPassword
                                  : AutofillHints.password,
                            ],
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                              ),
                              suffixIcon: IconButton(
                                tooltip: _passwordVisible
                                    ? 'Hide password'
                                    : 'Show password',
                                onPressed: () => setState(
                                  () => _passwordVisible = !_passwordVisible,
                                ),
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                              ),
                            ),
                            validator: (value) => validatePassword(
                              value,
                              requireMinimumLength: _mode == AuthMode.register,
                            ),
                            onFieldSubmitted: _mode == AuthMode.login
                                ? (_) => _submit()
                                : null,
                          ),
                          if (_mode == AuthMode.register) ...[
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _confirmPasswordController,
                              enabled: !isBusy,
                              obscureText: !_passwordVisible,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.newPassword],
                              decoration: const InputDecoration(
                                labelText: 'Confirm password',
                                prefixIcon: Icon(Icons.lock_outline_rounded),
                              ),
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match.';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) => _submit(),
                            ),
                          ],
                          if (_mode == AuthMode.login) ...[
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: isBusy
                                    ? null
                                    : () => _showResetSheet(context),
                                child: const Text('Forgot password?'),
                              ),
                            ),
                          ] else
                            const SizedBox(height: 26),
                          FilledButton(
                            onPressed: isBusy ? null : _submit,
                            child: isBusy
                                ? const SizedBox.square(
                                    dimension: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    _mode == AuthMode.register
                                        ? 'Register securely'
                                        : 'Log in',
                                  ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'ForgeFit uses your Supabase account only for secure authentication and workout backup.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: const Color(0xFF7F8995)),
                          ),
                        ],
                      ),
                    )
                  : _EmailConfirmation(
                      email: _confirmationEmail!,
                      onLogin: () => _setMode(AuthMode.login),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showResetSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) =>
          PasswordResetSheet(initialEmail: _emailController.text),
    );
  }
}

class _ProfilePreview extends StatelessWidget {
  const _ProfilePreview({required this.flow});

  final AppFlowState flow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_rounded),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${flow.displayName}  •  ${flow.preferredWeightUnit.symbol}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmailConfirmation extends StatelessWidget {
  const _EmailConfirmation({required this.email, required this.onLogin});

  final String email;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ForgeFitBrand(compact: true),
        const SizedBox(height: 52),
        Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.mark_email_read_outlined,
            size: 36,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Check your email',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        Text(
          'We sent a confirmation link to $email. Open it to activate your account, then return here and log in.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: const Color(0xFFAAB2BD),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        FilledButton(
          onPressed: onLogin,
          child: const Text('Continue to login'),
        ),
      ],
    );
  }
}

class PasswordResetSheet extends ConsumerStatefulWidget {
  const PasswordResetSheet({super.key, this.initialEmail = ''});

  final String initialEmail;

  @override
  ConsumerState<PasswordResetSheet> createState() => _PasswordResetSheetState();
}

class _PasswordResetSheetState extends ConsumerState<PasswordResetSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail.trim());
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await ref
          .read(authControllerProvider.notifier)
          .sendPasswordReset(_emailController.text);
      if (mounted) setState(() => _sent = true);
    } on Object catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(describeAuthError(error))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = ref.watch(authControllerProvider).isLoading;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF4B545F),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              _sent ? 'Reset link sent' : 'Reset your password',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Text(
              _sent
                  ? 'Check ${_emailController.text.trim()} and open the link on this device to choose a new password.'
                  : 'Enter your account email and we’ll send a secure reset link.',
              style: const TextStyle(color: Color(0xFFAAB2BD), height: 1.45),
            ),
            const SizedBox(height: 24),
            if (!_sent) ...[
              TextFormField(
                controller: _emailController,
                autofocus: widget.initialEmail.trim().isEmpty,
                enabled: !isBusy,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.mail_outline_rounded),
                ),
                validator: validateEmail,
                onFieldSubmitted: (_) => _send(),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: isBusy ? null : _send,
                child: isBusy
                    ? const SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : const Text('Send reset link'),
              ),
            ] else
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              ),
          ],
        ),
      ),
    );
  }
}
