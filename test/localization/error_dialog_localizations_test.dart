import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/errors/errors.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/localization/localization.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final code in ['pt', 'en']) {
    testWidgets('Exception dialogs resolve typed failures in $code', (
      tester,
    ) async {
      final translations = lookupAppLocalizations(Locale(code));
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(code),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showExceptionAlertDialog(
                  context: context,
                  title: context.l10n.error,
                  exception: AppException.localized(CoreFailure.invalidSession),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text(translations.invalidSession), findsOneWidget);
    });
  }
}
