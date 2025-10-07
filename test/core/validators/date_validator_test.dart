import 'package:celta_intelligence/core/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Define a fixed period to use for all tests
  final startDate = DateTime(2025, 1, 1);
  final endDate = DateTime(2025, 1, 31);

  late DateValidator sut;

  setUp(() {
    // Instantiate the validator with the required period
    sut = DateValidator(minimumDate: startDate, maximumDate: endDate);
  });

  group('DateValidator', () {
    group('Valid Dates', () {
      test('should return true for a date within the allowed period', () {
        expect(sut.isValid('15/01/2025'), true);
      });

      test('should return true for a date exactly on the start date', () {
        expect(sut.isValid('01/01/2025'), true);
      });

      test('should return true for a date exactly on the end date', () {
        expect(sut.isValid('31/01/2025'), true);
      });
    });

    group('Invalid Dates', () {
      test('should return false for a null value', () {
        expect(sut.isValid(null), false);
      });

      test('should return false for an empty string', () {
        expect(sut.isValid(''), false);
      });

      test('should return false for an invalid format', () {
        sut.isValid('not-a-date');
        expect(sut.errorMessage, isNotEmpty);
      });

      test('should return false for an impossible date', () {
        expect(sut.isValid('31/02/2025'), false);
      });

      test('should return false for a date BEFORE the allowed period', () {
        final isValid = sut.isValid('31/12/2024');
        expect(isValid, false);
        expect(sut.errorMessage, isNotEmpty);
      });

      test('should return false for a date AFTER the allowed period', () {
        final isValid = sut.isValid('01/02/2025');
        expect(isValid, false);
        expect(sut.errorMessage, isNotEmpty);
      });
    });
  });
}
