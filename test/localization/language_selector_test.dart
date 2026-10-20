import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/localization/presentation/widgets/widgets.dart';
import 'package:celta_inventario/localization/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks/mocks.dart';

void main() {
  testWidgets(
    'Changing language saves the preference and rebuilds visible text',
    (tester) async {
      final repository = MockLanguageRepository();
      when(repository.loadLanguage).thenReturn(AppLanguage.portuguese);
      when(
        () => repository.saveLanguage(AppLanguage.english),
      ).thenAnswer((_) async {});
      await tester.pumpWidget(
        ProviderScope(
          overrides: [languageRepositoryProvider.overrideWithValue(repository)],
          child: Consumer(
            builder: (context, ref, _) {
              final language =
                  ref.watch(languageControllerProvider).value ??
                  AppLanguage.portuguese;
              return MaterialApp(
                locale: Locale(language.code),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: Scaffold(
                  body: Builder(
                    builder: (context) => Column(
                      children: [
                        const LanguageSelector(),
                        Text(context.l10n.signIn),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Entrar'), findsOneWidget);
      await tester.tap(find.text('Português').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Inglês').last);
      await tester.pumpAndSettle();
      expect(find.text('Sign in'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      verify(() => repository.saveLanguage(AppLanguage.english)).called(1);
    },
  );
}
