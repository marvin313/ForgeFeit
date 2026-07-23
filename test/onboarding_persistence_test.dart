import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/app/app_flow.dart';
import 'package:forgefit/app/onboarding_store.dart';

void main() {
  test('first launch starts with incomplete onboarding', () async {
    final store = _MemoryOnboardingStore();
    final container = _container(store);
    addTearDown(container.dispose);

    final state = await _settledState(container);

    expect(state.hasLoadedOnboarding, isTrue);
    expect(state.hasCompletedOnboarding, isFalse);
    expect(state.authMode, AuthMode.register);
    expect(state.preferredWeightUnit, WeightUnit.kilograms);
  });

  test('completion survives restart, logout, and a later login', () async {
    final store = _MemoryOnboardingStore();
    var container = _container(store);

    await _settledState(container);
    await container
        .read(appFlowProvider.notifier)
        .finishOnboarding(
          displayName: '  Marvin  ',
          preferredWeightUnit: WeightUnit.pounds,
        );
    expect(container.read(appFlowProvider).hasCompletedOnboarding, isTrue);
    container.dispose();

    // A new provider container represents a full app process restart.
    container = _container(store);
    var restarted = await _settledState(container);
    expect(restarted.hasCompletedOnboarding, isTrue);
    expect(restarted.displayName, 'Marvin');
    expect(restarted.preferredWeightUnit, WeightUnit.pounds);
    expect(restarted.authMode, AuthMode.login);

    // Logout selects authentication but deliberately does not clear the
    // device-local completion marker.
    container.read(appFlowProvider.notifier).showLogin();
    expect(container.read(appFlowProvider).hasCompletedOnboarding, isTrue);
    expect(container.read(appFlowProvider).authMode, AuthMode.login);
    container.dispose();

    // Logging in again uses another app launch and still skips onboarding.
    container = _container(store);
    restarted = await _settledState(container);
    expect(restarted.hasCompletedOnboarding, isTrue);
    expect(restarted.authMode, AuthMode.login);
    container.dispose();
  });

  test('existing-account path is persisted without requiring a name', () async {
    final store = _MemoryOnboardingStore();
    var container = _container(store);
    await _settledState(container);

    await container.read(appFlowProvider.notifier).useExistingAccount();
    container.dispose();

    container = _container(store);
    final restarted = await _settledState(container);
    expect(restarted.hasCompletedOnboarding, isTrue);
    expect(restarted.authMode, AuthMode.login);
    container.dispose();
  });

  test(
    'an authenticated upgrade backfills the local completion flag',
    () async {
      final store = _MemoryOnboardingStore();
      var container = _container(store);
      await _settledState(container);

      await container
          .read(appFlowProvider.notifier)
          .rememberAuthenticatedUser(
            displayName: 'Existing Athlete',
            preferredWeightUnit: WeightUnit.kilograms,
          );
      container.dispose();

      container = _container(store);
      final restarted = await _settledState(container);
      expect(restarted.hasCompletedOnboarding, isTrue);
      expect(restarted.displayName, 'Existing Athlete');
      expect(restarted.authMode, AuthMode.login);
      container.dispose();
    },
  );
}

ProviderContainer _container(OnboardingStore store) {
  return ProviderContainer(
    overrides: [onboardingStoreProvider.overrideWithValue(store)],
  );
}

Future<AppFlowState> _settledState(ProviderContainer container) async {
  // Start the notifier so it subscribes to the persisted preference provider.
  container.read(appFlowProvider);
  await container.read(storedOnboardingProvider.future);
  await Future<void>.delayed(Duration.zero);
  return container.read(appFlowProvider);
}

class _MemoryOnboardingStore implements OnboardingStore {
  StoredOnboardingPreferences value = const StoredOnboardingPreferences();

  @override
  Future<StoredOnboardingPreferences> read() async => value;

  @override
  Future<void> markCompleted({
    required String displayName,
    required String preferredWeightUnit,
  }) async {
    value = StoredOnboardingPreferences(
      hasCompletedOnboarding: true,
      displayName: displayName,
      preferredWeightUnit: preferredWeightUnit,
    );
  }
}
