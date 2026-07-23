import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/core/config/app_configuration.dart';

void main() {
  test('accepts valid Supabase values', () {
    final configuration = AppConfiguration.fromValues(
      url: 'https://project-ref.supabase.co',
      key: 'sb_publishable_valid_client_key',
    );

    expect(configuration.isValid, isTrue);
    expect(configuration.supabaseUrl, 'https://project-ref.supabase.co');
    expect(
      configuration.supabasePublishableKey,
      'sb_publishable_valid_client_key',
    );
  });

  test('rejects missing values', () {
    final configuration = AppConfiguration.fromValues(url: '', key: '');

    expect(configuration.isValid, isFalse);
    expect(configuration.problem, isNotEmpty);
  });

  test('rejects placeholder values', () {
    final configuration = AppConfiguration.fromValues(
      url: 'https://example.supabase.co',
      key: 'publishable-key-for-build-only',
    );

    expect(configuration.isValid, isFalse);
  });

  test('trims valid values', () {
    final configuration = AppConfiguration.fromEnvironment({
      'SUPABASE_URL': '  https://project-ref.supabase.co  ',
      'SUPABASE_PUBLISHABLE_KEY': '  sb_publishable_valid_client_key  ',
    });

    expect(configuration.isValid, isTrue);
    expect(configuration.supabaseUrl, 'https://project-ref.supabase.co');
    expect(
      configuration.supabasePublishableKey,
      'sb_publishable_valid_client_key',
    );
  });
}
