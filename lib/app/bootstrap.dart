import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forgefit/core/config/app_configuration.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BootstrapResult {
  const BootstrapResult({required this.configuration, this.client});

  final AppConfiguration configuration;
  final SupabaseClient? client;

  bool get isReady => configuration.isValid && client != null;
}

final bootstrapProvider = FutureProvider<BootstrapResult>((ref) async {
  const definedUrl = String.fromEnvironment('SUPABASE_URL');
  const definedKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  var url = definedUrl.trim();
  var key = definedKey.trim();

  // GitHub release builds receive compile-time dart defines. Local
  // development can continue using the ignored .env file as a fallback.
  if (url.isEmpty || key.isEmpty) {
    try {
      await dotenv.load(fileName: '.env');
      if (url.isEmpty) {
        url = dotenv.env['SUPABASE_URL']?.trim() ?? '';
      }
      if (key.isEmpty) {
        key = dotenv.env['SUPABASE_PUBLISHABLE_KEY']?.trim() ?? '';
      }
    } on Object {
      // AppConfiguration below produces the user-facing validation message.
    }
  }

  final configuration = AppConfiguration.fromValues(url: url, key: key);
  if (!configuration.isValid) {
    return BootstrapResult(configuration: configuration);
  }

  try {
    await Supabase.initialize(
      url: configuration.supabaseUrl!,
      publishableKey: configuration.supabasePublishableKey!,
    );
    return BootstrapResult(
      configuration: configuration,
      client: Supabase.instance.client,
    );
  } on Object {
    return BootstrapResult(
      configuration: AppConfiguration.failure(
        'ForgeFit could not start its secure Supabase connection. Check the '
        'Project URL and publishable key, then restart the app.',
      ),
    );
  }
});
