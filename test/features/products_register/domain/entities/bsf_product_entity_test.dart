import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  group('BsfProductDetailEntity.toSearchIndex', () {
    test('must contain one entry for every field', () {
      final entity = EntityFactory.makeBsfProductEntity();

      final index = entity.toSearchIndex();

      // Update this number every time you add a new field
      expect(index.length, equals(4));
    });

    test('all entries must have non-empty labelPt and displayValue', () {
      final entity = EntityFactory.makeBsfProductEntity();

      for (final property in entity.toSearchIndex()) {
        expect(
          property.labelPt,
          isNotEmpty,
          reason: 'labelPt must not be empty',
        );
        expect(
          property.displayValue,
          isNotEmpty,
          reason: 'displayValue must not be empty',
        );
      }
    });
  });
}
