import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  test('should resolve date-time patterns by format code', () {
    const patterns = {
      7: 'dd/MM/yy',
      8: 'dd/MM/yyyy',
      9: 'MM/dd/yy',
      10: 'MM/dd/yyyy',
      11: 'yy/MM/dd',
      12: 'yyyy/MM/dd',
      13: 'ddMMyy',
      14: 'ddMMyyyy',
      15: 'MMddyy',
      16: 'MMddyyyy',
      17: 'yyMMdd',
      18: 'yyyyMMdd',
      19: 'HH:mm:ss',
      20: 'HH:mm',
      21: 'HHmmss',
      22: 'HHmm',
    };

    for (final entry in patterns.entries) {
      final format = EntityFactory.makeBSFPrintLabelFieldFormatEntity(
        code: entry.key,
      );

      expect(format.dateTimePattern, entry.value);
    }
  });

  test('should not resolve a pattern for an unsupported code', () {
    final format = EntityFactory.makeBSFPrintLabelFieldFormatEntity(code: 1);

    expect(format.dateTimePattern, isNull);
  });
}
