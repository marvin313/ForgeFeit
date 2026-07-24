import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/features/auth/data/auth_repository.dart';

void main() {
  test('email flows use the registered ForgeFit callback URL', () {
    expect(
      AuthRepository.authCallbackUrl,
      'com.marvin.forgefit://auth/callback',
    );
  });
}
