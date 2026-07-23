import 'package:supabase_flutter/supabase_flutter.dart';

class RegistrationResult {
  const RegistrationResult({required this.user, required this.session});

  final User? user;
  final Session? session;

  bool get needsEmailConfirmation => user != null && session == null;
}

class AuthRepository {
  const AuthRepository(this._client);

  final SupabaseClient _client;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Session? get currentSession => _client.auth.currentSession;

  User? get currentUser => _client.auth.currentUser;

  Future<RegistrationResult> register({
    required String email,
    required String password,
    required String displayName,
    required String preferredWeightUnit,
  }) async {
    final response = await _client.auth.signUp(
      email: email.trim(),
      password: password,
      data: <String, Object>{
        'display_name': displayName.trim(),
        'preferred_weight_unit': preferredWeightUnit,
      },
    );

    if (response.session != null && response.user != null) {
      await ensureProfile(
        user: response.user,
        displayName: displayName,
        preferredWeightUnit: preferredWeightUnit,
      );
    }

    return RegistrationResult(user: response.user, session: response.session);
  }

  Future<Session> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
    final session = response.session;
    final user = response.user;
    if (session == null || user == null) {
      throw AuthException('Login did not return an authenticated session.');
    }
    await ensureProfile(user: user);
    return session;
  }

  Future<void> logout() => _client.auth.signOut(scope: SignOutScope.local);

  Future<void> sendPasswordReset(String email) {
    return _client.auth.resetPasswordForEmail(
      email.trim(),
      redirectTo: 'com.marvin.forgefit://reset-password',
    );
  }

  Future<void> updatePassword(String password) async {
    await _client.auth.updateUser(UserAttributes(password: password));
  }

  Future<void> ensureProfile({
    User? user,
    String? displayName,
    String? preferredWeightUnit,
  }) async {
    final resolvedUser = user ?? currentUser;
    if (resolvedUser == null || currentSession == null) {
      return;
    }

    final metadata = resolvedUser.userMetadata ?? const <String, dynamic>{};
    final resolvedDisplayName =
        (displayName ?? metadata['display_name'] as String?)?.trim();
    final resolvedUnit =
        preferredWeightUnit ??
        metadata['preferred_weight_unit'] as String? ??
        'kg';

    await _client.from('profiles').upsert(<String, Object?>{
      'user_id': resolvedUser.id,
      'display_name': resolvedDisplayName?.isNotEmpty == true
          ? resolvedDisplayName
          : _fallbackName(resolvedUser.email),
      'preferred_weight_unit': resolvedUnit == 'lb' ? 'lb' : 'kg',
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }, onConflict: 'user_id');
  }

  String _fallbackName(String? email) {
    final prefix = email?.split('@').first.trim();
    return prefix?.isNotEmpty == true ? prefix! : 'Athlete';
  }
}
