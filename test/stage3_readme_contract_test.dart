import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late String readme;

  setUpAll(() {
    readme = File('README.md').readAsStringSync();
  });

  test('documents the Stage 3 data and calculation contracts', () {
    expect(readme, contains('**283** read-only built-in exercises'));
    expect(readme, contains('aliases, keywords'));
    expect(readme, contains('estimated_1rm_kg = weight_kg'));
    expect(readme, contains('(1 + repetitions / 30)'));
    expect(readme, contains('rounded to three decimal'));
    expect(readme, contains('Legacy Stage 1 quick logs'));
    expect(readme, contains('500-row'));
    expect(readme, contains('UUID-ordered pages'));
    expect(readme, contains('starting at 2'));
    expect(readme, contains('seconds, doubling'));
    expect(readme, contains('capped at 5 minutes'));
  });

  test('documents the additive migration and owner isolation checks', () {
    expect(readme, contains('0003_stage_3_active_workouts.sql'));
    expect(readme, contains('Run only Stage 3 in Supabase SQL Editor'));
    expect(readme, contains('Do not paste or run `0001` or `0002` again'));
    expect(readme, contains('Account A creates a split'));
    expect(readme, contains('Log into Account B'));
    expect(readme, contains('must not be reported as passed'));
    expect(readme, contains('until it has actually run'));
  });

  test('documents configuration and iOS verification boundaries', () {
    expect(readme, contains('SUPABASE_PUBLISHABLE_KEY'));
    expect(readme, contains('`.env.*` remain ignored by Git'));
    expect(readme, contains('--dart-define'));
    expect(readme, contains('bundle `.env`.'));
    expect(readme, contains('Build unsigned iOS IPA'));
    expect(
      readme,
      contains('iOS Release compile and IPA packaging remain unverified'),
    );
  });
}
