import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/app/providers.dart';
import 'package:forgefit/app/startup_diagnostics.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('authenticated scope resolves Supabase consumers from its override', () {
    final root = ProviderContainer();
    final client = SupabaseClient('https://example.supabase.co', 'test-key');
    final authenticated = ProviderContainer(
      parent: root,
      overrides: [supabaseClientProvider.overrideWithValue(client)],
    );
    addTearDown(authenticated.dispose);
    addTearDown(root.dispose);

    expect(authenticated.read(supabaseClientProvider), same(client));
    expect(authenticated.read(authRepositoryProvider), isNotNull);
    expect(authenticated.read(remoteWorkoutDataSourceProvider), isNotNull);
    expect(authenticated.read(remotePlanningDataSourceProvider), isNotNull);
    expect(authenticated.read(remoteSessionDataSourceProvider), isNotNull);
    expect(authenticated.read(workoutRepositoryProvider), isNotNull);
    expect(authenticated.read(planningRepositoryProvider), isNotNull);
    expect(authenticated.read(sessionRepositoryProvider), isNotNull);
  });

  test('startup diagnostics retain the source provider and wrapped type', () {
    final diagnostics = StartupDiagnostics();
    final container = ProviderContainer(
      observers: [ForgeFitStartupProviderObserver(diagnostics)],
    );
    addTearDown(container.dispose);

    expect(
      () => container.read(authRepositoryProvider),
      throwsA(isA<ProviderException>()),
    );
    expect(
      diagnostics.latestProviderFailure?.providerName,
      'supabaseClientProvider',
    );
    expect(diagnostics.latestProviderFailure?.exceptionType, 'StateError');
  });
}
