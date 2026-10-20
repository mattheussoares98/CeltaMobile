import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/localization/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocaleRepository extends Mock implements ILanguageRepository {}

void main() {
  late MockLocaleRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = MockLocaleRepository();
    when(repository.loadLanguage).thenReturn(AppLanguage.english);
    container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [languageRepositoryProvider.overrideWithValue(repository)],
    );
    container.listen(appLocalizationsProvider, (_, _) {});
  });

  tearDown(() => container.dispose());

  test('Translations follow the restored language', () async {
    await container.read(languageControllerProvider.future);
    expect(container.read(appLocalizationsProvider).localeName, 'en');
  });

  test('Translations follow a successfully saved language change', () async {
    await container.read(languageControllerProvider.future);
    when(
      () => repository.saveLanguage(AppLanguage.portuguese),
    ).thenAnswer((_) async {});
    await container
        .read(languageControllerProvider.notifier)
        .setLanguage(AppLanguage.portuguese);
    expect(container.read(appLocalizationsProvider).localeName, 'pt');
  });

  test('Translations retain the current language when saving fails', () async {
    await container.read(languageControllerProvider.future);
    when(
      () => repository.saveLanguage(AppLanguage.portuguese),
    ).thenAnswer((_) async => throw Exception('write failed'));
    await container
        .read(languageControllerProvider.notifier)
        .setLanguage(AppLanguage.portuguese);
    expect(container.read(appLocalizationsProvider).localeName, 'en');
  });
}
