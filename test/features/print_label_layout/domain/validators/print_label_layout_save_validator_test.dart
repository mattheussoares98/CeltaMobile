import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/domain/validators/validators.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../mocks/mocks.dart';

void main() {
  BSFPrintLabelLayoutEntity validLayout() =>
      EntityFactory.makeBSFPrintLabelLayoutEntity(
        formWidth: 100,
        formHeight: 50,
        formTopMargin: 0,
        formLeftMargin: 0,
        quantityColumns: 1,
        labelWidth: 90,
        labelHeight: 40,
        labelRightMargin: 0,
        labelBottomMargin: 0,
        temperature: 10,
        printSpeed: 2,
        intervalPrintPackage: 1,
        applyFormSizeConfiguration: true,
      );

  test('should accept a valid layout', () {
    expect(PrintLabelLayoutSaveValidator.validate(validLayout()), isEmpty);
  });

  test('should validate the main required layout values', () {
    final layout = validLayout().copyWith(
      name: ' ',
      formWidth: 0,
      formHeight: 0,
      quantityColumns: 0,
      labelWidth: 0,
      labelHeight: 0,
      temperature: 0,
      printSpeed: 0,
    );

    final errors = PrintLabelLayoutSaveValidator.validate(layout);

    expect(errors, contains(startsWith('Nome:')));
    expect(errors, contains(startsWith('Largura do formulário:')));
    expect(errors, contains(startsWith('Altura do formulário:')));
    expect(errors, contains(startsWith('Quantidade de colunas:')));
    expect(errors, contains(startsWith('Largura da etiqueta:')));
    expect(errors, contains(startsWith('Altura da etiqueta:')));
    expect(errors, contains(startsWith('Temperatura de impressão:')));
    expect(errors, contains(startsWith('Velocidade de impressão:')));
  });

  test('should reject fields that do not apply to the layout type', () {
    final layout = validLayout().copyWith(
      layoutType: BSFPrintLabelLayoutType.customer,
      addressType: BSFPrintLabelAddressType.principal,
    );

    expect(
      PrintLabelLayoutSaveValidator.validate(layout),
      contains(contains('não se aplica ao tipo de leiaute')),
    );
  });

  test('should preserve valid zero margins and package interval', () {
    final layout = validLayout().copyWith(
      formTopMargin: 0,
      formLeftMargin: 0,
      labelRightMargin: 0,
      labelBottomMargin: 0,
    );

    expect(PrintLabelLayoutSaveValidator.validate(layout), isEmpty);
  });
}
