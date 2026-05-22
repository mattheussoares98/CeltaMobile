import 'package:celta_inventario/utils/extensions/string_modifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringModifier - toBrazilianNumber', () {
    test('should respect decimalHouses when showDecimalUntilLastNumber is true (User Reported Bug)', () {
      expect("0.100000000000009".toBrazilianNumber(3, true), "0,1");
      expect("0,100000000000009".toBrazilianNumber(3, true), "0,1");
    });

    test('should handle standard English inputs correctly', () {
      expect("1234.567".toBrazilianNumber(2, false), "1.234,57");
      expect("1000".toBrazilianNumber(2, true), "1.000");
      expect("1000.5".toBrazilianNumber(2, true), "1.000,5");
      expect("1000.5".toBrazilianNumber(2, false), "1.000,50");
    });

    test('should handle standard Portuguese inputs correctly', () {
      expect("1234,567".toBrazilianNumber(2, false), "1.234,57");
      expect("1000,5".toBrazilianNumber(2, true), "1.000,5");
    });

    test('should handle large numbers correctly', () {
      expect("1000000.123".toBrazilianNumber(2, false), "1.000.000,12");
    });

    test('should handle edge cases and invalid inputs correctly', () {
      expect("invalid".toBrazilianNumber(2, false), "invalid");
      expect("1.234.567,89".toBrazilianNumber(2, false), "1.234.567,89");
    });
  });
}
