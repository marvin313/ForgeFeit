import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('unsigned iOS workflow keeps every required compile gate', () {
    final workflow = File(
      '.github/workflows/ios-ipa-build.yml',
    ).readAsStringSync();

    final dependencyIndex = workflow.indexOf('flutter pub get');
    final generationIndex = workflow.indexOf(
      'dart run build_runner build --delete-conflicting-outputs',
    );
    final formattingIndex = workflow.indexOf(
      'dart format --output=none --set-exit-if-changed lib test',
    );
    final testIndex = workflow.indexOf('flutter test');
    final analysisIndex = workflow.indexOf('flutter analyze');
    final buildIndex = workflow.indexOf(
      'flutter build ios --release --no-codesign',
    );

    expect(workflow, contains('workflow_dispatch:'));
    expect(workflow, contains('runs-on: macos-latest'));
    expect(workflow, contains('channel: stable'));
    expect(dependencyIndex, greaterThanOrEqualTo(0));
    expect(generationIndex, greaterThan(dependencyIndex));
    expect(formattingIndex, greaterThan(generationIndex));
    expect(testIndex, greaterThan(formattingIndex));
    expect(analysisIndex, greaterThan(formattingIndex));
    expect(workflow, contains('pod install --repo-update'));
    expect(buildIndex, greaterThan(testIndex));
    expect(buildIndex, greaterThan(analysisIndex));
    expect(workflow, contains('build/ios/ipa/Payload'));
    expect(workflow, contains('ForgeFit-unsigned.ipa'));
    expect(workflow, contains('actions/upload-artifact@v4'));
    expect(
      workflow,
      contains('--dart-define=SUPABASE_URL="\$SUPABASE_URL"'),
    );
    expect(
      workflow,
      contains(
        '--dart-define=SUPABASE_PUBLISHABLE_KEY="\$SUPABASE_PUBLISHABLE_KEY"',
      ),
    );
    expect(
      workflow,
      contains('Missing SUPABASE_URL or SUPABASE_PUBLISHABLE_KEY'),
    );
  });
}
