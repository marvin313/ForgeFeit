import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/auth_gate.dart';
import 'package:forgefit/app/bootstrap.dart';
import 'package:forgefit/app/branding.dart';
import 'package:forgefit/app/providers.dart';
import 'package:forgefit/app/startup_diagnostics.dart';
import 'package:forgefit/core/settings/appearance_settings.dart';
import 'package:forgefit/core/theme/forgefit_theme.dart';

class ForgeFitApp extends ConsumerWidget {
  const ForgeFitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(bootstrapProvider);
    final appearance = ref.watch(appearanceProvider);
    return bootstrap.when(
      loading: () => _materialApp(const _SplashScreen(), appearance),
      error: (_, _) => _materialApp(
        _ConfigurationScreen(
          message:
              'ForgeFit could not read its release build configuration. Reinstall a build made with valid Supabase values.',
          onRetry: () => ref.invalidate(bootstrapProvider),
        ),
        appearance,
      ),
      data: (result) {
        if (!result.isReady) {
          return _materialApp(
            _ConfigurationScreen(
              message:
                  result.configuration.problem ??
                  'ForgeFit needs valid Supabase configuration values.',
              onRetry: () => ref.invalidate(bootstrapProvider),
            ),
            appearance,
          );
        }
        // The override must sit above MaterialApp so every Navigator route,
        // dialog, and bottom sheet sees the configured client and repositories.
        return ProviderScope(
          overrides: [supabaseClientProvider.overrideWithValue(result.client!)],
          observers: [startupProviderObserver],
          child: _materialApp(const AuthGate(), appearance),
        );
      },
    );
  }
}

MaterialApp _materialApp(Widget home, ForgeFitAppearance appearance) {
  return MaterialApp(
    title: 'ForgeFit',
    debugShowCheckedModeBanner: false,
    theme: buildForgeFitTheme(accent: appearance.accent),
    home: home,
  );
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ForgeFitBrand(),
              SizedBox(height: 34),
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
              SizedBox(height: 16),
              Text(
                'Preparing your training log',
                style: TextStyle(color: Color(0xFF929CA8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfigurationScreen extends StatelessWidget {
  const _ConfigurationScreen({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ForgeFitBrand(),
                  const SizedBox(height: 48),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: ForgeFitColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF2B323B)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.settings_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          size: 34,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'One setup step remains',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          message,
                          style: const TextStyle(
                            color: Color(0xFFA7B0BB),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Required values',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        const SelectableText(
                          'SUPABASE_URL\nSUPABASE_PUBLISHABLE_KEY',
                          style: TextStyle(
                            color: Color(0xFF79D3FF),
                            fontFamily: 'monospace',
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Check configuration again'),
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
