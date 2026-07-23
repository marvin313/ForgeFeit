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
  try {
    await dotenv.load(fileName: '.env');
  } on Object {
    return BootstrapResult(
      configuration: AppConfiguration.failure(
        'ForgeFit could not load its .env configuration file. Copy '
        '.env.example to .env, add your Supabase values, and restart the app.',
      ),
    );
  }

  final configuration = AppConfiguration.fromEnvironment(dotenv.env);
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
        'URL and publishable key in .env, then restart the app.',
      ),
    );
  }
});
