import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/app_flow.dart';
import 'package:forgefit/app/providers.dart';
import 'package:forgefit/features/auth/presentation/auth_screen.dart';
import 'package:forgefit/features/auth/presentation/password_recovery_screen.dart';
import 'package:forgefit/features/dashboard/presentation/authenticated_shell.dart';
import 'package:forgefit/features/onboarding/presentation/onboarding_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (_, next) {
      next.whenData((state) {
        if (state.event == AuthChangeEvent.passwordRecovery) {
          ref.read(appFlowProvider.notifier).startPasswordRecovery();
        }
      });
    });

    final flow = ref.watch(appFlowProvider);
    final authRepository = ref.watch(authRepositoryProvider);
    final authUpdate = ref.watch(authStateProvider);
    final streamedSession = authUpdate.asData?.value.session;
    final session = streamedSession ?? authRepository.currentSession;

    if (flow.isPasswordRecovery) {
      return const PasswordRecoveryScreen();
    }
    if (session != null) {
      return AuthenticatedShell(
        key: ValueKey(session.user.id),
        user: session.user,
      );
    }
    if (authUpdate.hasError) {
      return _AuthStartupError(
        onRetry: () => ref.invalidate(authStateProvider),
      );
    }
    if (!flow.hasLoadedOnboarding) {
      return const Scaffold(
        body: SafeArea(
          child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
        ),
      );
    }
    if (!flow.hasCompletedOnboarding) {
      return const OnboardingScreen();
    }
    return const AuthScreen();
  }
}

class _AuthStartupError extends StatelessWidget {
  const _AuthStartupError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 58,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Your saved session could not be checked.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Your workouts are still safe on this device. Check your connection and try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF9CA6B2), height: 1.45),
                  ),
                  const SizedBox(height: 22),
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try again'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
