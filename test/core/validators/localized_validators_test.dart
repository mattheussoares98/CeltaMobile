import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/localization/localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final en = lookupAppLocalizations(const Locale('en'));

  test(
    'Non-empty validation supports English without changing empty rules',
    () {
      final validator = NonEmptyValidator(translations: en);
      expect(validator.isValid(''), isFalse);
      expect(validator.errorMessage, en.requiredField);
      expect(validator.isValid(' '), isTrue);
    },
  );

  test(
    'Number validation localizes required, integer, precision and positive errors',
    () {
      final validator = NumberValidator(translations: en, allowDecimal: true);
      expect(validator.isValid(null), isFalse);
      expect(validator.errorMessage, en.requiredField);
      expect(validator.isValid('x'), isFalse);
      expect(validator.errorMessage, en.invalidFormat);
      expect(validator.isValid('1.234'), isFalse);
      expect(validator.errorMessage, en.maxDecimalPlaces(2));
      expect(validator.isValid('0'), isFalse);
      expect(validator.errorMessage, en.greaterThanZero);
      final integer = NumberValidator(translations: en, allowDecimal: false);
      expect(integer.isValid('1.5'), isFalse);
      expect(integer.errorMessage, en.integersOnly);
    },
  );

  test('CPF/CNPJ validation localizes each failure branch', () {
    final validator = CpfCnpjValidator(translations: en);
    expect(validator.isValid(''), isFalse);
    expect(validator.errorMessage, en.requiredField);
    expect(validator.isValid('x'), isFalse);
    expect(validator.errorMessage, en.digitsOnly);
    expect(validator.isValid('1'), isFalse);
    expect(validator.errorMessage, en.fieldTooShort);
    expect(validator.isValid('11111111111'), isFalse);
    expect(validator.errorMessage, en.invalidCpf);
    expect(validator.isValid('11111111111111'), isFalse);
    expect(validator.errorMessage, en.invalidCnpj);
  });

  test('URL validation localizes required, format and HTTPS rules', () {
    final validator = UrlValidator(translations: en, shouldBeHttps: true);
    expect(validator.isValid(''), isFalse);
    expect(validator.errorMessage, en.requiredField);
    expect(validator.isValid('x'), isFalse);
    expect(validator.errorMessage, en.invalidUrl);
    expect(validator.isValid('http://example.com'), isFalse);
    expect(validator.errorMessage, en.httpsRequired);
  });

  test(
    'Date validation localizes invalid input and interpolates date limits',
    () {
      final validator = DateValidator(
        translations: en,
        minimumDate: DateTime(2020),
        maximumDate: DateTime(2021),
      );
      expect(validator.isValid('x'), isFalse);
      expect(validator.errorMessage, en.invalidDate);
      expect(validator.isValid('01/01/2019'), isFalse);
      expect(
        validator.errorMessage,
        en.invalidDateRange('01/01/2020', '01/01/2021'),
      );
    },
  );

  test('Email, area code, IP and minimum length expose English messages', () {
    expect(EmailValidator(translations: en).errorMessage, en.invalidEmail);
    expect(DddValidator(translations: en).errorMessage, en.invalidAreaCode);
    final ip = IpValidator(translations: en);
    expect(ip.isValid('x'), isFalse);
    expect(ip.errorMessage, en.invalidIp);
    expect(
      MinLengthValidator(3, translations: en).errorMessage,
      en.minimumLength(3),
    );
  });
}
