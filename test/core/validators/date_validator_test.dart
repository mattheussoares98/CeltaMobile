import 'package:celta_intelligence/core/validators/validators.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DateValidator sut;

  setUp(() {
    sut = DateValidator();
  });

  group('DateValidator', () {
    group('Valid Dates', () {
      test('should return true for a valid Brazilian date (dd/MM/yyyy)', () {
        expect(sut.isValid('31/03/1998'), true);
      });

      // test('should return true for a valid American date (MM/dd/yyyy)', () {
      //   expect(sut.isValid('03/31/1998'), true);
      // });

      // test('should return true for a valid ISO date (yyyy-MM-dd)', () {
      //   expect(sut.isValid('1998-03-31'), true);
      // });
    });

    group('Invalid Dates', () {
      test('should return false for a null value', () {
        expect(sut.isValid(null), false);
      });

      test('should return false for an empty string', () {
        expect(sut.isValid(''), false);
      });

      test('should return false for a non-date string', () {
        expect(sut.isValid('not a date'), false);
      });

      test('should return false for an incomplete date', () {
        expect(sut.isValid('31/03/'), false);
      });

      test('should return false for an impossible date (e.g., month 13)', () {
        expect(sut.isValid('31/13/1998'), false);
      });

      test('should return false for an impossible date (e.g., Feb 30)', () {
        expect(sut.isValid('30/02/2024'), false);
      });

      test('should return false and have the correct error message', () {
        final isValid = sut.isValid('invalid date');
        expect(isValid, false);
        // The error message is static, so we can check it on any failure.
        expect(sut.errorMessage, 'Data inválida'.hardcoded);
      });
    });
  });
}
