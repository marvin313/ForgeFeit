class AppConfiguration {
  const AppConfiguration._({
    this.supabaseUrl,
    this.supabasePublishableKey,
    this.problem,
  });

  /// Release builds receive these values through `--dart-define`. The mobile
  /// publishable key is intentionally client-safe; privileged Supabase keys
  /// must never be supplied to this application.
  factory AppConfiguration.fromDartDefines() {
    const url = String.fromEnvironment('SUPABASE_URL');
    const key = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
    return AppConfiguration.fromValues(url: url, key: key);
  }

  factory AppConfiguration.fromValues({
    required String url,
    required String key,
  }) {
    final normalizedUrl = url.trim();
    final normalizedKey = key.trim();

    if (normalizedUrl.isEmpty || normalizedKey.isEmpty) {
      return const AppConfiguration._(
        problem:
            'ForgeFit is not connected to Supabase yet. Supply both required '
            'release build values, then reinstall the app.',
      );
    }

    final uri = Uri.tryParse(normalizedUrl);
    final isLocalHost = uri?.host == 'localhost' || uri?.host == '127.0.0.1';
    final hasSupportedScheme =
        uri?.scheme == 'https' || (isLocalHost && uri?.scheme == 'http');
    final looksLikeUrlPlaceholder =
        normalizedUrl.contains('your-project') ||
        normalizedUrl.contains('example.supabase.co');
    final looksLikeKeyPlaceholder =
        normalizedKey.contains('your-publishable-key') ||
        normalizedKey.contains('publishable-key-for-build-only') ||
        normalizedKey.contains('publishable-key-for-local-build-only') ||
        normalizedKey.toLowerCase().contains('replace-me');

    if (uri == null ||
        !uri.hasAuthority ||
        !hasSupportedScheme ||
        looksLikeUrlPlaceholder ||
        looksLikeKeyPlaceholder) {
      return const AppConfiguration._(
        problem:
            'The Supabase release build values are placeholders or are not '
            'valid. Rebuild ForgeFit with your project URL and publishable '
            'key.',
      );
    }

    return AppConfiguration._(
      supabaseUrl: normalizedUrl,
      supabasePublishableKey: normalizedKey,
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
