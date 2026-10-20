import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Portuguese and English catalogs contain the same complete messages',
    () {
      final pt =
          jsonDecode(File('lib/localization/arb/app_pt.arb').readAsStringSync())
              as Map;
      final en =
          jsonDecode(File('lib/localization/arb/app_en.arb').readAsStringSync())
              as Map;
      final ptKeys = pt.keys
          .where((key) => !key.toString().startsWith('@'))
          .toSet();
      final enKeys = en.keys
          .where((key) => !key.toString().startsWith('@'))
          .toSet();
      expect(enKeys, ptKeys);
      for (final key in ptKeys) {
        expect(pt[key], isA<String>(), reason: key.toString());
        expect(en[key], isA<String>(), reason: key.toString());
        expect((pt[key] as String).trim(), isNotEmpty, reason: key.toString());
        expect((en[key] as String).trim(), isNotEmpty, reason: key.toString());
        final placeholders = (pt['@$key'] as Map?)?['placeholders'] as Map?;
        for (final name in placeholders?.keys ?? []) {
          expect(
            RegExp('\\{$name(?:[,}])').hasMatch(en[key] as String),
            isTrue,
            reason: '$key must preserve the $name placeholder',
          );
        }
      }
    },
  );
}
