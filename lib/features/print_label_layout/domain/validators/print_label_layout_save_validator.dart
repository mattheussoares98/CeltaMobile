import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

abstract final class PrintLabelLayoutSaveValidator {
  static List<String> validate(BSFPrintLabelLayoutEntity layout) {
    final errors = <String>[];
    final capabilities = layout.capabilities;

    if (layout.name.trim().isEmpty) {
      errors.add('Nome: Este campo é de preenchimento obrigatório');
    }
    if (layout.labelPrinter == null) {
      errors.add('Impressora: A impressora não foi informada');
    }
    if (layout.formWidth <= 0) {
      errors.add('Largura do formulário: Informe um valor maior que zero');
    }
    if (capabilities.isFormHeightRequired && layout.formHeight <= 0) {
      errors.add('Altura do formulário: Informe um valor maior que zero');
    }
    if (layout.quantityColumns <= 0) {
      errors.add('Quantidade de colunas: Informe um valor maior que zero');
    }
    if (layout.labelWidth <= 0) {
      errors.add('Largura da etiqueta: Informe um valor maior que zero');
    }
    if (capabilities.isLabelHeightRequired && layout.labelHeight <= 0) {
      errors.add('Altura da etiqueta: Informe um valor maior que zero');
    }
    if (layout.formTopMargin < 0 || layout.formLeftMargin < 0) {
      errors.add('As margens do formulário não podem ser negativas');
    }
    if (layout.labelRightMargin < 0 || layout.labelBottomMargin < 0) {
      errors.add('As margens da etiqueta não podem ser negativas');
    }

    if (!capabilities.isGenericPrinter) {
      if (layout.temperature <= 0) {
        errors.add('Temperatura de impressão: Selecione uma opção');
      }
      if (layout.printSpeed <= 0) {
        errors.add('Velocidade de impressão: Selecione uma opção');
      }
      if (layout.intervalPrintPackage <= 0) {
        errors.add('Intervalo entre pacotes deve ser maior que zero');
      }
      if (!layout.applyFormSizeConfiguration) {
        errors.add('A configuração do tamanho do formulário deve ser aplicada');
      }
    }

    final requiresAddress =
        layout.layoutType == BSFPrintLabelLayoutType.customer ||
        layout.layoutType == BSFPrintLabelLayoutType.customerCard;
    if (requiresAddress &&
        layout.addressType == BSFPrintLabelAddressType.notApplicable) {
      errors.add('Tipo de endereço: Selecione uma opção');
    } else if (!requiresAddress &&
        layout.addressType != BSFPrintLabelAddressType.notApplicable) {
      errors.add('O tipo de endereço não se aplica ao tipo de leiaute');
    }

    if (layout.fields.isEmpty) {
      errors.add('Informe pelo menos um campo para o leiaute');
    } else if (layout.fields.any(
      (field) =>
          field.field == null || !field.field!.appliesTo(layout.layoutType),
    )) {
      errors.add(
        'Existe pelo menos um campo que não se aplica ao tipo de leiaute informado',
      );
    }

    if (layout.quantityColumns > 0 && layout.formWidth > 0) {
      final occupiedWidth =
          (layout.labelWidth * layout.quantityColumns) +
          (layout.labelRightMargin * (layout.quantityColumns - 1));
      if (occupiedWidth > layout.formWidth) {
        errors.add('As etiquetas não cabem na largura do formulário');
      }
    }

    return errors;
  }
}
