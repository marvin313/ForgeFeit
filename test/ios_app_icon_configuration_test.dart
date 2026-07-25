import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every configured iOS AppIcon slot uses a valid opaque PNG', () async {
    final inAppMark = File('assets/branding/forgefit_logo_mark.png');
    final iconSource = File('assets/branding/forgefit_app_icon_source.png');
    final contents = File(
      'ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json',
    );

    expect(await inAppMark.exists(), isTrue);
    expect(await inAppMark.length(), greaterThan(0));
    expect(await iconSource.exists(), isTrue);
    expect(await iconSource.length(), greaterThan(0));
    final markPng = Uint8List.fromList(await inAppMark.readAsBytes());
    final iconPng = Uint8List.fromList(await iconSource.readAsBytes());
    expect(
      markPng[25],
      isNot(2),
      reason: 'The in-app logo must be transparent',
    );
    expect(iconPng[25], 2, reason: 'The iOS source must be opaque');
    expect(_readUint32(iconPng, 16), 1024);
    expect(_readUint32(iconPng, 20), 1024);
    final manifest =
        jsonDecode(await contents.readAsString()) as Map<String, dynamic>;
    final slots = (manifest['images'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    expect(slots, hasLength(19));

    for (final slot in slots) {
      final filename = slot['filename']! as String;
      final asset = File(
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/$filename',
      );
      expect(await asset.exists(), isTrue, reason: '$filename is missing');
      final png = Uint8List.fromList(await asset.readAsBytes());
      expect(png.length, greaterThan(25), reason: '$filename is not a PNG');
      expect(
        png.sublist(0, 8),
        equals(const [137, 80, 78, 71, 13, 10, 26, 10]),
        reason: '$filename has an invalid PNG signature',
      );
      final expected = _expectedPixels(
        slot['size']! as String,
        slot['scale']! as String,
      );
      expect(_readUint32(png, 16), expected, reason: '$filename width');
      expect(_readUint32(png, 20), expected, reason: '$filename height');
      expect(png[25], 2, reason: '$filename must not contain transparency');
    }
  });
}

int _expectedPixels(String size, String scale) {
  final logical = double.parse(size.split('x').first);
  final multiplier = double.parse(scale.replaceAll('x', ''));
  return (logical * multiplier).round();
}

int _readUint32(Uint8List bytes, int offset) =>
    ByteData.sublistView(bytes).getUint32(offset, Endian.big);
