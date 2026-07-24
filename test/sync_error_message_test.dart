import 'package:flutter_test/flutter_test.dart';
import 'package:forgefit/core/sync/sync_coordinator.dart';

void main() {
  test('missing Stage 3 tables produce a safe actionable sync message', () {
    expect(
      readableSyncError(
        StateError('PostgrestException(code: PGRST205, details: hidden)'),
      ),
      'Cloud workout storage is not ready. Apply the Stage 3 Supabase migration, then retry.',
    );
  });
}
