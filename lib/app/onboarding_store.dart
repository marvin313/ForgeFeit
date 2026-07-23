import 'package:shared_preferences/shared_preferences.dart';

const _completedKey = 'forgefit.onboarding.completed';
const _displayNameKey = 'forgefit.onboarding.display_name';
const _weightUnitKey = 'forgefit.onboarding.weight_unit';

class StoredOnboardingPreferences {
  const StoredOnboardingPreferences({
    this.hasCompletedOnboarding = false,
    this.displayName = '',
    this.preferredWeightUnit = 'kg',
  });

  final bool hasCompletedOnboarding;
  final String displayName;
  final String preferredWeightUnit;
}

abstract interface class OnboardingStore {
  Future<StoredOnboardingPreferences> read();

  Future<void> markCompleted({
    required String displayName,
    required String preferredWeightUnit,
  });
}

/// Device-local onboarding state. It intentionally survives account logout so
/// returning users go straight to authentication instead of repeating setup.
class SharedPreferencesOnboardingStore implements OnboardingStore {
  SharedPreferencesOnboardingStore({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  @override
  Future<StoredOnboardingPreferences> read() async {
    final values = await Future.wait<Object?>([
      _preferences.getBool(_completedKey),
      _preferences.getString(_displayNameKey),
      _preferences.getString(_weightUnitKey),
    ]);
    return StoredOnboardingPreferences(
      hasCompletedOnboarding: values[0] == true,
      displayName: (values[1] as String? ?? '').trim(),
      preferredWeightUnit: values[2] == 'lb' ? 'lb' : 'kg',
    );
  }

  @override
  Future<void> markCompleted({
    required String displayName,
    required String preferredWeightUnit,
  }) async {
    // Store the profile choices before the completion flag. A process
    // interruption can therefore never expose a partially saved onboarding.
    await _preferences.setString(_displayNameKey, displayName.trim());
    await _preferences.setString(
      _weightUnitKey,
      preferredWeightUnit == 'lb' ? 'lb' : 'kg',
    );
    await _preferences.setBool(_completedKey, true);
  }
}
