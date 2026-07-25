import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every configured iOS AppIcon slot uses a valid opaque PNG', () async {
    final source = File('assets/branding/IMG_7960.jpg');
    final contents = File(
      'ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json',
    );

    expect(await source.exists(), isTrue);
    expect(await source.length(), greaterThan(0));
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
