class AppConfiguration {
  const AppConfiguration._({
    this.supabaseUrl,
    this.supabasePublishableKey,
    this.problem,
  });

  factory AppConfiguration.fromEnvironment(Map<String, String> environment) {
    final url = environment['SUPABASE_URL']?.trim() ?? '';
    final key = environment['SUPABASE_PUBLISHABLE_KEY']?.trim() ?? '';

    return AppConfiguration.fromValues(url: url, key: key);
  }

  factory AppConfiguration.fromValues({
    required String url,
    required String key,
  }) {
    if (url.isEmpty || key.isEmpty) {
      return const AppConfiguration._(
        problem:
            'ForgeFit is not connected to Supabase yet. Add both required '
            'Supabase values, then restart the app.',
      );
    }

    final uri = Uri.tryParse(url);
    final isLocalHost = uri?.host == 'localhost' || uri?.host == '127.0.0.1';
    final hasSupportedScheme =
        uri?.scheme == 'https' || (isLocalHost && uri?.scheme == 'http');

    final looksLikeUrlPlaceholder =
        url.contains('your-project') || url.contains('example.supabase.co');

    final looksLikeKeyPlaceholder =
        key.contains('your-publishable-key') ||
        key.contains('publishable-key-for-local-build-only') ||
        key.toLowerCase().contains('replace-me');

    if (uri == null ||
        !uri.hasAuthority ||
        !hasSupportedScheme ||
        looksLikeUrlPlaceholder ||
        looksLikeKeyPlaceholder) {
      return const AppConfiguration._(
        problem:
            'The Supabase values are placeholders or invalid. Check the '
            'Project URL and publishable key, then restart ForgeFit.',
      );
    }

    return AppConfiguration._(
      supabaseUrl: url,
      supabasePublishableKey: key,
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