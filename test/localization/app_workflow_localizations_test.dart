import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/domain/validators/validators.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/localization/localization.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/localization/localization.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/features/receipt/presentation/localization/localization.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/localization/localization.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/localization/localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final pt = lookupAppLocalizations(const Locale('pt'));
  final en = lookupAppLocalizations(const Locale('en'));

  test(
    'Authorization, receipt, and sales enums resolve in the selected language',
    () {
      for (final value in BSFProcessAuthorizationJudgementStatus.values) {
        expect(pt.authorizationStatus(value), value.label);
        expect(en.authorizationStatus(value), isNot(value.label));
      }
      for (final value in Status.values) {
        expect(pt.receiptStatusName(value), value.description);
        expect(en.receiptStatusName(value), isNot(value.description));
      }
      for (final value in BSFSaleRequestSanitizationType.values) {
        expect(pt.sanitizationMessage(value), value.message);
        expect(en.sanitizationMessage(value), isNot(value.message));
      }
    },
  );

  test(
    'Label enums and validation failures have Portuguese and English messages',
    () {
      expect(
        pt.labelLayoutTypeName(BSFPrintLabelLayoutType.customerCard),
        'Cartão de cliente',
      );
      expect(
        en.labelLayoutTypeName(BSFPrintLabelLayoutType.customerCard),
        'Customer card',
      );
      expect(
        en.fieldDimensionName(BSFPrintLabelFieldDimensionType.printerDot),
        'dots',
      );
      for (final failure in PrintLabelReportValidationFailure.values) {
        expect(pt.reportValidationMessage(failure), isNotEmpty);
        expect(en.reportValidationMessage(failure), isNotEmpty);
        expect(
          pt.reportValidationMessage(failure),
          isNot(en.reportValidationMessage(failure)),
        );
      }
    },
  );

  test('Dynamic messages preserve values and apply English plural rules', () {
    expect(en.customersCount(1), '1 customer');
    expect(en.customersCount(2), '2 customers');
    expect(en.requestsCount(1), '1 request');
    expect(en.requestsCount(3), '3 requests');
    expect(en.printedCustomer('José {name}'), 'Customer: José {name}');
    expect(en.fromStock('Estoque A'), 'From "Estoque A"');
    expect(en.layoutFieldsCount(4), 'Fields (4)');
  });

  test('Recognized transport errors use the requested locale', () {
    final error = Exception('request timed out');
    expect(
      parseErrorMessage(error, translations: pt),
      pt.requestTimedOutPleaseTryAgain,
    );
    expect(
      parseErrorMessage(error, translations: en),
      en.requestTimedOutPleaseTryAgain,
    );
    expect(
      parseErrorMessage(Exception('failed host lookup'), translations: en),
      en.connectionErrorCheckYourInternetConnection,
    );
  });
}
