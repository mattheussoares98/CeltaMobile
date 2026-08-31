import 'package:celta_inventario/features/print_label_layout/presentation/pages/components/components.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const encoder = PrintLabelEan13Encoder();

  test('should encode a valid EAN-13 using its guard modules', () {
    final encoded = encoder.encode('7891000379103');

    expect(encoded, hasLength(95));
    expect(encoded, startsWith('101'));
    expect(encoded?.substring(45, 50), '01010');
    expect(encoded, endsWith('101'));
  });

  test('should reject an EAN-13 with an invalid checksum', () {
    expect(encoder.encode('7891000379104'), isNull);
  });

  test('should reject non-EAN content', () {
    expect(encoder.encode('ABC'), isNull);
  });
}
