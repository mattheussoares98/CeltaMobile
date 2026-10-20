import 'package:celta_inventario/localization/data/data.dart';
import 'package:celta_inventario/localization/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalLanguageDatasource extends Mock
    implements ILocalLanguageDatasource {}

void main() {
  late MockLocalLanguageDatasource datasource;
  late LanguageRepositoryImpl repository;

  setUp(() {
    datasource = MockLocalLanguageDatasource();
    repository = LanguageRepositoryImpl(datasource);
  });

  for (final code in [null, 'pt', 'zh', '']) {
    test('loadLanguage defaults to Portuguese for $code', () {
      when(datasource.loadLanguageCode).thenReturn(code);
      expect(repository.loadLanguage(), AppLanguage.portuguese);
    });
  }

  test('loadLanguage restores English', () {
    when(datasource.loadLanguageCode).thenReturn('en');
    expect(repository.loadLanguage(), AppLanguage.english);
  });

  test('loadLanguage propagates storage errors', () {
    final error = Exception('read failed');
    when(datasource.loadLanguageCode).thenThrow(error);
    expect(repository.loadLanguage, throwsA(same(error)));
  });

  test('saveLanguage writes the selected language code', () async {
    when(() => datasource.saveLanguageCode('en')).thenAnswer((_) async {});
    await repository.saveLanguage(AppLanguage.english);
    verify(() => datasource.saveLanguageCode('en')).called(1);
  });

  test('saveLanguage propagates write errors', () async {
    final error = Exception('write failed');
    when(
      () => datasource.saveLanguageCode('en'),
    ).thenAnswer((_) async => throw error);
    await expectLater(
      repository.saveLanguage(AppLanguage.english),
      throwsA(same(error)),
    );
  });
}
