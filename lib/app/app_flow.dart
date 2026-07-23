import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'onboarding_store.dart';

enum WeightUnit {
  kilograms('kg'),
  pounds('lb');

  const WeightUnit(this.symbol);

  final String symbol;

  static WeightUnit fromValue(Object? value) {
    return value == 'lb' ? WeightUnit.pounds : WeightUnit.kilograms;
  }
}

enum AuthMode { register, login }

class AppFlowState {
  const AppFlowState({
    this.hasLoadedOnboarding = false,
    this.hasCompletedOnboarding = false,
    this.displayName = '',
    this.preferredWeightUnit = WeightUnit.kilograms,
    this.authMode = AuthMode.register,
    this.isPasswordRecovery = false,
  });

  final bool hasLoadedOnboarding;
  final bool hasCompletedOnboarding;
  final String displayName;
  final WeightUnit preferredWeightUnit;
  final AuthMode authMode;
  final bool isPasswordRecovery;

  AppFlowState copyWith({
    bool? hasLoadedOnboarding,
    bool? hasCompletedOnboarding,
    String? displayName,
    WeightUnit? preferredWeightUnit,
    AuthMode? authMode,
    bool? isPasswordRecovery,
  }) {
    return AppFlowState(
      hasLoadedOnboarding: hasLoadedOnboarding ?? this.hasLoadedOnboarding,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      displayName: displayName ?? this.displayName,
      preferredWeightUnit: preferredWeightUnit ?? this.preferredWeightUnit,
      authMode: authMode ?? this.authMode,
      isPasswordRecovery: isPasswordRecovery ?? this.isPasswordRecovery,
    );
  }
}

class AppFlowController extends Notifier<AppFlowState> {
  bool _hasRecordedAuthenticatedUser = false;
  Future<void>? _authenticatedUserWrite;

  @override
  AppFlowState build() {
    final stored = ref.watch(storedOnboardingProvider);
    return stored.when(
      data: (preferences) => AppFlowState(
        hasLoadedOnboarding: true,
        hasCompletedOnboarding: preferences.hasCompletedOnboarding,
        displayName: preferences.displayName,
        preferredWeightUnit: WeightUnit.fromValue(
          preferences.preferredWeightUnit,
        ),
        authMode: preferences.hasCompletedOnboarding
            ? AuthMode.login
            : AuthMode.register,
      ),
      // A local preference read failure must not permanently block the app.
      // Falling back to first-launch onboarding is safe and recoverable.
      error: (_, _) => const AppFlowState(hasLoadedOnboarding: true),
      loading: AppFlowState.new,
    );
  }

  Future<void> finishOnboarding({
    required String displayName,
    required WeightUnit preferredWeightUnit,
  }) async {
    final normalizedName = displayName.trim();
    await ref
        .read(onboardingStoreProvider)
        .markCompleted(
          displayName: normalizedName,
          preferredWeightUnit: preferredWeightUnit.symbol,
        );
    state = state.copyWith(
      hasLoadedOnboarding: true,
      hasCompletedOnboarding: true,
      displayName: normalizedName,
      preferredWeightUnit: preferredWeightUnit,
      authMode: AuthMode.register,
    );
  }

  Future<void> useExistingAccount() async {
    await ref
        .read(onboardingStoreProvider)
        .markCompleted(
          displayName: state.displayName,
          preferredWeightUnit: state.preferredWeightUnit.symbol,
        );
    state = state.copyWith(
      hasLoadedOnboarding: true,
      hasCompletedOnboarding: true,
      authMode: AuthMode.login,
    );
  }

  /// Backfills the local marker for users upgrading from an older ForgeFit
  /// version with an already-persisted Supabase session.
  Future<void> rememberAuthenticatedUser({
    required String displayName,
    required WeightUnit preferredWeightUnit,
  }) {
    if (_hasRecordedAuthenticatedUser) return Future<void>.value();
    final running = _authenticatedUserWrite;
    if (running != null) return running;

    late final Future<void> operation;
    operation =
        _writeAuthenticatedUser(
          displayName: displayName,
          preferredWeightUnit: preferredWeightUnit,
        ).whenComplete(() {
          if (identical(_authenticatedUserWrite, operation)) {
            _authenticatedUserWrite = null;
          }
        });
    _authenticatedUserWrite = operation;
    return operation;
  }

  Future<void> _writeAuthenticatedUser({
    required String displayName,
    required WeightUnit preferredWeightUnit,
  }) async {
    try {
      await ref
          .read(onboardingStoreProvider)
          .markCompleted(
            displayName: displayName,
            preferredWeightUnit: preferredWeightUnit.symbol,
          );
      state = state.copyWith(
        hasLoadedOnboarding: true,
        hasCompletedOnboarding: true,
        displayName: displayName.trim(),
        preferredWeightUnit: preferredWeightUnit,
        authMode: AuthMode.login,
      );
      _hasRecordedAuthenticatedUser = true;
    } on Object {
      // Authentication must remain usable even if device preferences are
      // temporarily unavailable. A later auth event can retry the backfill.
    }
  }

  void showLogin() {
    state = state.copyWith(
      hasCompletedOnboarding: true,
      authMode: AuthMode.login,
      isPasswordRecovery: false,
    );
  }

  void showRegistration() {
    state = state.copyWith(
      hasCompletedOnboarding: false,
      authMode: AuthMode.register,
      isPasswordRecovery: false,
    );
  }

  void startPasswordRecovery() {
    state = state.copyWith(isPasswordRecovery: true);
  }

  void finishPasswordRecovery() {
    state = state.copyWith(isPasswordRecovery: false);
  }
}

final appFlowProvider = NotifierProvider<AppFlowController, AppFlowState>(
  AppFlowController.new,
);

final onboardingStoreProvider = Provider<OnboardingStore>((ref) {
  return SharedPreferencesOnboardingStore();
});

final storedOnboardingProvider = FutureProvider<StoredOnboardingPreferences>((
  ref,
) {
  return ref.watch(onboardingStoreProvider).read();
});
