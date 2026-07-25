import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/core/settings/appearance_settings.dart';
import 'package:forgefit/core/theme/forgefit_theme.dart';
import 'package:forgefit/features/settings/presentation/settings_screen.dart';

void main() {
  test('the default mint accent and semantic error colour are stable', () {
    final theme = buildForgeFitTheme();

    expect(theme.colorScheme.primary, ForgeFitAppearance.defaultAccent);
    expect(theme.colorScheme.error, ForgeFitColors.danger);
  });

  test(
    'arbitrary accent and haptics settings persist across reconstruction',
    () async {
      final store = _MemoryAppearanceStore();
      final first = _container(store);
      addTearDown(first.dispose);

      await first
          .read(appearanceProvider.notifier)
          .setAccent(const Color(0xFF0066CC));
      await first.read(appearanceProvider.notifier).setHapticsEnabled(false);

      expect(first.read(appearanceProvider).accent, const Color(0xFF0066CC));
      expect(first.read(appearanceProvider).hapticsEnabled, isFalse);

      final restored = _container(store);
      addTearDown(restored.dispose);
      restored.read(appearanceProvider);
      await Future<void>.delayed(Duration.zero);

      expect(restored.read(appearanceProvider).accent, const Color(0xFF0066CC));
      expect(restored.read(appearanceProvider).hapticsEnabled, isFalse);
    },
  );

  test('reset restores mint and accent foregrounds stay readable', () async {
    final store = _MemoryAppearanceStore();
    final container = _container(store);
    addTearDown(container.dispose);

    await container.read(appearanceProvider.notifier).setAccent(Colors.black);
    final darkAccent = ForgeFitAccent.resolve(
      container.read(appearanceProvider).accent,
    );
    expect(ForgeFitAccent.foreground(darkAccent), Colors.white);

    await container.read(appearanceProvider.notifier).setAccent(Colors.white);
    final lightAccent = ForgeFitAccent.resolve(
      container.read(appearanceProvider).accent,
    );
    expect(ForgeFitAccent.foreground(lightAccent), Colors.black);

    await container.read(appearanceProvider.notifier).resetAccent();
    expect(
      container.read(appearanceProvider).accent,
      ForgeFitAppearance.defaultAccent,
    );
  });

  testWidgets('Settings exposes an immediate full accent picker and reset', (
    tester,
  ) async {
    final store = _MemoryAppearanceStore();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appearanceStoreProvider.overrideWithValue(store)],
        child: MaterialApp(
          theme: buildForgeFitTheme(),
          home: const SettingsScreen(
            userId: 'user-1',
            email: 'athlete@example.com',
            weightUnit: 'kg',
            onLogout: _noop,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('settings-accent-color')));
    await tester.pumpAndSettle();

    expect(find.text('Hue'), findsOneWidget);
    expect(find.text('Saturation'), findsOneWidget);
    expect(find.text('Brightness'), findsOneWidget);
    expect(find.byKey(const Key('reset-accent-color')), findsOneWidget);
  });
}

void _noop() {}

ProviderContainer _container(AppearanceStore store) => ProviderContainer(
  overrides: [appearanceStoreProvider.overrideWithValue(store)],
);

class _MemoryAppearanceStore implements AppearanceStore {
  ForgeFitAppearance value = ForgeFitAppearance.defaults;

  @override
  Future<ForgeFitAppearance> read() async => value;

  @override
  Future<void> save(ForgeFitAppearance appearance) async {
    value = appearance;
  }
}
