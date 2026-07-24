import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/app/providers.dart';
import 'package:forgefit/features/auth/data/auth_repository.dart';

class AuthController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<RegistrationResult> register({
    required String email,
    required String password,
    required String displayName,
    required String preferredWeightUnit,
  }) async {
    state = const AsyncLoading();
    try {
      final result = await ref
          .read(authRepositoryProvider)
          .register(
            email: email,
            password: password,
            displayName: displayName,
            preferredWeightUnit: preferredWeightUnit,
          );
      state = const AsyncData(null);
      return result;
    } on Object catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> login({required String email, required String password}) async {
    await _run(() async {
      await ref
          .read(authRepositoryProvider)
          .login(email: email, password: password);
    });
  }

  Future<void> logout() async {
    await _run(ref.read(authRepositoryProvider).logout);
  }

  Future<void> sendPasswordReset(String email) async {
    await _run(() => ref.read(authRepositoryProvider).sendPasswordReset(email));
  }

  Future<void> updatePassword(String password) async {
    await _run(() => ref.read(authRepositoryProvider).updatePassword(password));
  }

  Future<void> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
    } on Object catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
  dependencies: [authRepositoryProvider],
  name: 'authControllerProvider',
);
