class AppConfiguration {
  const AppConfiguration._({
    this.supabaseUrl,
    this.supabasePublishableKey,
    this.problem,
  });

  factory AppConfiguration.fromEnvironment(Map<String, String> environment) {
    return AppConfiguration.fromValues(
      url: environment['SUPABASE_URL'] ?? '',
      key: environment['SUPABASE_PUBLISHABLE_KEY'] ?? '',
    );
  }

  factory AppConfiguration.fromValues({
    required String url,
    required String key,
  }) {
    final trimmedUrl = url.trim();
    final trimmedKey = key.trim();

    if (trimmedUrl.isEmpty || trimmedKey.isEmpty) {
      return const AppConfiguration._(
        problem:
            'ForgeFit is not connected to Supabase yet. Add both required '
            'Supabase values, then restart the app.',
      );
    }

    final uri = Uri.tryParse(trimmedUrl);
    final isLocalHost = uri?.host == 'localhost' || uri?.host == '127.0.0.1';
    final hasSupportedScheme =
        uri?.scheme == 'https' || (isLocalHost && uri?.scheme == 'http');
    final looksLikeUrlPlaceholder =
        trimmedUrl.contains('your-project') ||
        trimmedUrl.contains('example.supabase.co');
    final looksLikeKeyPlaceholder =
        trimmedKey.contains('your-publishable-key') ||
        trimmedKey.contains('publishable-key-for-build-only') ||
        trimmedKey.toLowerCase().contains('replace-me');

    if (uri == null ||
        !uri.hasAuthority ||
        !hasSupportedScheme ||
        looksLikeUrlPlaceholder ||
        looksLikeKeyPlaceholder) {
      return const AppConfiguration._(
        problem:
            'The Supabase Project URL or publishable key is invalid. Check '
            'both values, then restart ForgeFit.',
      );
    }

    return AppConfiguration._(
      supabaseUrl: trimmedUrl,
      supabasePublishableKey: trimmedKey,
    );
  }

  factory AppConfiguration.failure(String problem) {
    return AppConfiguration._(problem: problem);
  }

  final String? supabaseUrl;
  final String? supabasePublishableKey;
  final String? problem;

  bool get isValid =>
      problem == null && supabaseUrl != null && supabasePublishableKey != null;
}
