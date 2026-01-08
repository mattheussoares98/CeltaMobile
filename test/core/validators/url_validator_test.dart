import 'package:celta_intelligence/core/validators/validators.dart';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:faker/faker.dart';

void main() {
  late UrlValidator sut;

  setUp(() {
    sut = UrlValidator();
  });

  group('UrlValidator', () {
    test('should return true for valid http and https URLs', () {
      // Use faker to generate dynamic valid URLs
      final httpsUrl = faker.internet.httpsUrl();
      final httpUrl = faker.internet.httpUrl();

      expect(sut.isValid(httpsUrl), isTrue);
      expect(sut.isValid(httpUrl), isTrue);
      expect(sut.errorMessage, isEmpty);
    });

    test('should return false for empty or null values', () {
      // Act & Assert for empty string
      expect(sut.isValid(''), isFalse);
      expect(sut.errorMessage, 'Campo obrigatório'.hardcoded);

      // Act & Assert for null value
      expect(sut.isValid(null), isFalse);
      expect(sut.errorMessage, 'Campo obrigatório'.hardcoded);
    });

    test('should return false for malformed strings that are not URLs', () {
      final invalidInput = faker.lorem.word();

      expect(sut.isValid(invalidInput), isFalse);
      expect(sut.errorMessage, 'URL inválida'.hardcoded);
    });

    test('should return false for URLs without a scheme (protocol)', () {
      // Common mistake: missing http://
      const noSchemeUrl = 'www.google.com';

      expect(sut.isValid(noSchemeUrl), isFalse);
      expect(sut.errorMessage, 'URL inválida'.hardcoded);
    });

    test(
      'should return false for non-web schemes (e.g., mailto, ftp, tel)',
      () {
        const mailto = 'mailto:test@example.com';
        const ftp = 'ftp://files.server.com';

        expect(sut.isValid(mailto), isFalse);
        expect(sut.isValid(ftp), isFalse);
        expect(sut.errorMessage, 'URL inválida'.hardcoded);
      },
    );

    test('should return false for URLs with scheme but no host', () {
      const noHost = 'https://';

      expect(sut.isValid(noHost), isFalse);
      expect(sut.errorMessage, 'URL inválida'.hardcoded);
    });

    test('should return true for URLs with query parameters or paths', () {
      final complexUrl =
          '${faker.internet.httpsUrl()}/path/to/resource?query=123&auth=true';

      expect(sut.isValid(complexUrl), isTrue);
      expect(sut.errorMessage, isEmpty);
    });
  });

  group('Obligatory https', () {
    test('should return true when is https', () {
      // Use faker to generate dynamic valid URLs
      final httpsUrl = faker.internet.httpsUrl();

      expect(sut.isValid(httpsUrl, shouldBeHttps: true), isTrue);
      expect(sut.errorMessage, isEmpty);
    });
    test('should return false when is https and pass http url', () {
      // Use faker to generate dynamic valid URLs
      final httpUrl = faker.internet.httpUrl();

      expect(sut.isValid(httpUrl, shouldBeHttps: true), isFalse);
      expect(sut.errorMessage, isNotEmpty);
    });
  });
}
