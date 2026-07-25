import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Device-local visual preferences. They deliberately do not contain account
/// credentials or cloud data, and apply immediately across the app.
class ForgeFitAppearance {
  const ForgeFitAppearance({
    required this.accent,
    required this.hapticsEnabled,
  });

  static const defaultAccent = Color(0xFF9AC7AB);
  static const defaults = ForgeFitAppearance(
    accent: defaultAccent,
    hapticsEnabled: true,
  );

  final Color accent;
  final bool hapticsEnabled;

  ForgeFitAppearance copyWith({Color? accent, bool? hapticsEnabled}) =>
      ForgeFitAppearance(
        accent: accent ?? this.accent,
        hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      );
}

abstract interface class AppearanceStore {
  Future<ForgeFitAppearance> read();

  Future<void> save(ForgeFitAppearance appearance);
}

class SharedPreferencesAppearanceStore implements AppearanceStore {
  SharedPreferencesAppearanceStore({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const _accentKey = 'forgefit.appearance.accent';
  static const _hapticsKey = 'forgefit.appearance.haptics';

  final SharedPreferencesAsync _preferences;

  @override
  Future<ForgeFitAppearance> read() async {
    final values = await Future.wait<Object?>([
      _preferences.getInt(_accentKey),
      _preferences.getBool(_hapticsKey),
    ]);
    final accentValue = values[0] as int?;
    return ForgeFitAppearance(
      accent: accentValue == null
          ? ForgeFitAppearance.defaultAccent
          : Color(accentValue),
      hapticsEnabled: values[1] is bool ? values[1]! as bool : true,
    );
  }

  @override
  Future<void> save(ForgeFitAppearance appearance) async {
    await _preferences.setInt(_accentKey, appearance.accent.toARGB32());
    await _preferences.setBool(_hapticsKey, appearance.hapticsEnabled);
  }
}

final appearanceStoreProvider = Provider<AppearanceStore>((ref) {
  try {
    return SharedPreferencesAppearanceStore();
  } on StateError {
    // Widget tests and unsupported host platforms can still render and use
    // ForgeFit safely; only device-local preference persistence is skipped.
    return _MemoryAppearanceStore();
  }
}, name: 'appearanceStoreProvider');

class _MemoryAppearanceStore implements AppearanceStore {
  ForgeFitAppearance _value = ForgeFitAppearance.defaults;

  @override
  Future<ForgeFitAppearance> read() async => _value;

  @override
  Future<void> save(ForgeFitAppearance appearance) async {
    _value = appearance;
  }
}

final appearanceProvider =
    NotifierProvider<AppearanceController, ForgeFitAppearance>(
      AppearanceController.new,
      name: 'appearanceProvider',
    );

class AppearanceController extends Notifier<ForgeFitAppearance> {
  late AppearanceStore _store;
  var _hasLocalChange = false;
  var _disposed = false;

  @override
  ForgeFitAppearance build() {
    _store = ref.watch(appearanceStoreProvider);
    ref.onDispose(() => _disposed = true);
    unawaited(_load());
    return ForgeFitAppearance.defaults;
  }

  Future<void> _load() async {
    final saved = await _store.read();
    if (!_disposed && !_hasLocalChange) state = saved;
  }

  Future<void> setAccent(Color accent) =>
      _save(state.copyWith(accent: Color(accent.toARGB32())));

  Future<void> setHapticsEnabled(bool enabled) =>
      _save(state.copyWith(hapticsEnabled: enabled));

  Future<void> resetAccent() =>
      _save(state.copyWith(accent: ForgeFitAppearance.defaultAccent));

  Future<void> _save(ForgeFitAppearance next) async {
    _hasLocalChange = true;
    state = next;
    await _store.save(next);
  }
}

abstract final class ForgeFitHaptics {
  static void _dispatch(Future<void> feedback) {
    unawaited(feedback.catchError((Object _) {}));
  }

  static void selection(bool enabled) {
    if (enabled) _dispatch(HapticFeedback.selectionClick());
  }

  static void light(bool enabled) {
    if (enabled) _dispatch(HapticFeedback.lightImpact());
  }

  static void success(bool enabled) {
    if (enabled) _dispatch(HapticFeedback.mediumImpact());
  }

  static void warning(bool enabled) {
    if (enabled) _dispatch(HapticFeedback.heavyImpact());
  }
}
