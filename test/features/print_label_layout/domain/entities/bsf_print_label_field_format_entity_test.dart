import 'package:flutter_test/flutter_test.dart';

import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
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

  test('should identify whether the format supports a field type', () {
    final format = EntityFactory.makeBSFPrintLabelFieldFormatEntity(
      stringType: false,
      integerType: true,
    );

    expect(format.supports(BSFPrintLabelFieldType.integer), isTrue);
    expect(format.supports(BSFPrintLabelFieldType.string), isFalse);
    expect(format.supports(BSFPrintLabelFieldType.barcode), isFalse);
    expect(format.supports(null), isFalse);
  });

  test('should support every text field type when format is QR code', () {
    final format = EntityFactory.makeBSFPrintLabelFieldFormatEntity(
      stringType: false,
      integerType: false,
      floatType: false,
      dateTimeType: false,
      qrCodeType: true,
    );

    expect(format.supports(BSFPrintLabelFieldType.string), isTrue);
    expect(format.supports(BSFPrintLabelFieldType.integer), isTrue);
    expect(format.supports(BSFPrintLabelFieldType.float), isTrue);
    expect(format.supports(BSFPrintLabelFieldType.dateTime), isTrue);
    expect(format.supports(BSFPrintLabelFieldType.barcode), isFalse);
    expect(format.supports(BSFPrintLabelFieldType.boxOrLine), isFalse);
    expect(format.supports(BSFPrintLabelFieldType.logo), isFalse);
    expect(format.supports(null), isFalse);
  });
}
