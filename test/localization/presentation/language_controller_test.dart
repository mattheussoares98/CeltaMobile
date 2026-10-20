import 'dart:async';

import 'package:celta_inventario/localization/domain/domain.dart';
import 'package:celta_inventario/localization/presentation/presentation.dart';
import 'package:celta_inventario/localization/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLanguageRepository extends Mock implements ILanguageRepository {}

void main() {
  late MockLanguageRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = MockLanguageRepository();
    when(repository.loadLanguage).thenReturn(AppLanguage.portuguese);
    container = ProviderContainer(
      retry: (retryCount, error) => null,
      overrides: [languageRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  test('setLanguage serializes rapid selections', () async {
    await container.read(languageControllerProvider.future);
    final firstWrite = Completer<void>();
    when(
      () => repository.saveLanguage(AppLanguage.english),
    ).thenAnswer((_) => firstWrite.future);
    when(
      () => repository.saveLanguage(AppLanguage.portuguese),
    ).thenAnswer((_) async {});
    final controller = container.read(languageControllerProvider.notifier);
    final first = controller.setLanguage(AppLanguage.english);
    final last = controller.setLanguage(AppLanguage.portuguese);
    await Future<void>.delayed(Duration.zero);
    verifyNever(() => repository.saveLanguage(AppLanguage.portuguese));
    firstWrite.complete();
    await Future.wait([first, last]);
    expect(
      container.read(languageControllerProvider).requireValue,
      AppLanguage.portuguese,
    );
    verifyInOrder([
      () => repository.saveLanguage(AppLanguage.english),
      () => repository.saveLanguage(AppLanguage.portuguese),
    ]);
  });

  test('build restores the stored language', () async {
    when(repository.loadLanguage).thenReturn(AppLanguage.english);
    expect(
      await container.read(languageControllerProvider.future),
      AppLanguage.english,
    );
  });

  test('build exposes read failures', () async {
    final error = Exception('read failed');
    when(repository.loadLanguage).thenThrow(error);
    await expectLater(
      container.read(languageControllerProvider.future),
      throwsA(same(error)),
    );
  });

  test('setLanguage publishes the language after saving', () async {
    await container.read(languageControllerProvider.future);
    when(
      () => repository.saveLanguage(AppLanguage.english),
    ).thenAnswer((_) async {});
    await container
        .read(languageControllerProvider.notifier)
        .setLanguage(AppLanguage.english);
    expect(
      container.read(languageControllerProvider).requireValue,
      AppLanguage.english,
    );
    verify(() => repository.saveLanguage(AppLanguage.english)).called(1);
  });

  test(
    'setLanguage exposes failures and retains the previous language',
    () async {
      await container.read(languageControllerProvider.future);
      final error = Exception('write failed');
      when(() => repository.saveLanguage(AppLanguage.english)).thenThrow(error);
      await container
          .read(languageControllerProvider.notifier)
          .setLanguage(AppLanguage.english);
      expect(container.read(languageControllerProvider).error, same(error));
      expect(
        container.read(languageControllerProvider.notifier).language,
        AppLanguage.portuguese,
      );
    },
  );
}
