import 'package:celta_inventario/core/domain/errors/errors.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/localization/localization.dart';
import 'package:faker/faker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final pt = lookupAppLocalizations(const Locale('pt'));
  final en = lookupAppLocalizations(const Locale('en'));
  final faker = Faker();

  test('Each typed failure retains its Portuguese diagnostic fallback', () {
    for (final failure in CoreFailure.values.where(
      (e) => e != CoreFailure.cannotOpenUrl,
    )) {
      final exception = AppException.localized(failure);
      expect(parseErrorMessage(exception, translations: pt), exception.message);
      expect(
        parseErrorMessage(exception, translations: en),
        isNot(exception.message),
      );
    }
  });

  test('URL failure retains the URL in both languages', () {
    final url = faker.internet.httpsUrl();
    final exception = AppException.localized(CoreFailure.cannotOpenUrl, [url]);
    expect(
      parseErrorMessage(exception, translations: en),
      en.cannotOpenUrl(url),
    );
    expect(
      parseErrorMessage(exception, translations: pt),
      pt.cannotOpenUrl(url),
    );
  });

  test('HTTP failures preserve server details in both languages', () {
    final details = faker.lorem.word();
    final constructors = [
      HttpError.badRequest,
      HttpError.notFound,
      HttpError.serverError,
      HttpError.unauthorized,
      HttpError.forbidden,
      HttpError.invalidData,
    ];
    for (final create in constructors) {
      final error = create(details);
      expect(parseErrorMessage(error, translations: pt), error.message);
      expect(
        parseErrorMessage(error, translations: en),
        '${en.coreFailure(error.failure!)}: $details',
      );
      expect(
        parseErrorMessage(create, translations: en),
        en.coreFailure(error.failure!),
      );
    }
  });

  test(
    'SOAP failures resolve at display time and preserve diagnostic text',
    () {
      final error = BsError.localized(CoreFailure.invalidResponseStructure);
      expect(
        parseErrorMessage(error, translations: en),
        en.invalidResponseStructure,
      );
      expect(
        parseErrorMessage(error, translations: pt),
        pt.invalidResponseStructure,
      );
      expect(error.toString(), pt.invalidResponseStructure);
    },
  );

  test('Unrecognized backend text is preserved', () {
    final message = faker.lorem.word();
    expect(parseErrorMessage(BsError(message), translations: en), message);
    expect(parseErrorMessage(AppException(message), translations: en), message);
  });
}
