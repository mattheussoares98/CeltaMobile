import 'package:celta_intelligence/core/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Allow decimal', () {
    final sut = NumberValidator(
      allowDecimal: true,
      needsBeGreaterThanZero: true,
    );
    //true result
    expect(sut.isValid("1,001"), isTrue);
    expect(sut.isValid("1.001"), isTrue);
    expect(sut.isValid("145619,991"), isTrue);
    expect(sut.isValid("145619.991"), isTrue);
    expect(sut.isValid("145619991"), isTrue);

    //false result
    expect(sut.isValid("145619,99.1"), isFalse);
    expect(sut.isValid("145619.99,1"), isFalse);
  });
  test('Allow decimal with maximum decimal houses', () {
    final sut = NumberValidator(
      allowDecimal: true,
      maxDecimalHouses: 3,
      needsBeGreaterThanZero: true,
    );
    //true result
    expect(sut.isValid("1,001"), isTrue);
    expect(sut.isValid("1.0012"), isFalse);

    //false result
    expect(sut.isValid("145619,99.1"), isFalse);
    expect(sut.isValid("145619.99,1"), isFalse);
  });

  test('Dont allow decimal', () {
    final sut = NumberValidator(
      allowDecimal: false,
      needsBeGreaterThanZero: true,
    );
    //true result
    expect(sut.isValid("1001"), isTrue);

    //false result
    expect(sut.isValid("1,001"), isFalse);
    expect(sut.isValid("1.001"), isFalse);
    expect(sut.isValid("145619,991"), isFalse);
    expect(sut.isValid("145619.991"), isFalse);
    expect(sut.isValid("145619,99.1"), isFalse);
    expect(sut.isValid("145619.99,1"), isFalse);
  });

  test('Needs be greater than zero', () {
    final sut = NumberValidator(
      allowDecimal: false,
      needsBeGreaterThanZero: true,
    );
    expect(sut.isValid("0"), isFalse);
  });

  test('DONT needs be greater than zero', () {
    final sut = NumberValidator(
      allowDecimal: false,
      needsBeGreaterThanZero: false,
    );
    expect(sut.isValid("0"), isTrue);
  });
}
