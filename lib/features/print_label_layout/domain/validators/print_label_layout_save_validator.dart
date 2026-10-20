import 'package:celta_inventario/core/domain/errors/errors.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

abstract final class PrintLabelLayoutSaveValidator {
  static List<String> validate(BSFPrintLabelLayoutEntity layout) =>
      validateFailures(layout).map((failure) => failure.fallback).toList();

  static List<CoreFailure> validateFailures(BSFPrintLabelLayoutEntity layout) {
    final errors = <CoreFailure>[];
    final capabilities = layout.capabilities;

    if (layout.name.trim().isEmpty) {
      errors.add(CoreFailure.layoutNameRequired);
    }
    if (layout.labelPrinter == null) {
      errors.add(CoreFailure.layoutPrinterRequired);
    }
    if (layout.formWidth <= 0) {
      errors.add(CoreFailure.layoutFormWidthInvalid);
    }
    if (capabilities.isFormHeightRequired && layout.formHeight <= 0) {
      errors.add(CoreFailure.layoutFormHeightInvalid);
    }
    if (layout.quantityColumns <= 0) {
      errors.add(CoreFailure.layoutColumnsInvalid);
    }
    if (layout.labelWidth <= 0) {
      errors.add(CoreFailure.layoutWidthInvalid);
    }
    if (capabilities.isLabelHeightRequired && layout.labelHeight <= 0) {
      errors.add(CoreFailure.layoutHeightInvalid);
    }
    if (layout.formTopMargin < 0 || layout.formLeftMargin < 0) {
      errors.add(CoreFailure.layoutFormMarginsInvalid);
    }
    if (layout.labelRightMargin < 0 || layout.labelBottomMargin < 0) {
      errors.add(CoreFailure.layoutLabelMarginsInvalid);
    }

    if (!capabilities.isGenericPrinter) {
      if (layout.temperature <= 0) {
        errors.add(CoreFailure.layoutTemperatureRequired);
      }
      if (layout.printSpeed <= 0) {
        errors.add(CoreFailure.layoutSpeedRequired);
      }
      if (layout.intervalPrintPackage <= 0) {
        errors.add(CoreFailure.layoutIntervalInvalid);
      }
      if (!layout.applyFormSizeConfiguration) {
        errors.add(CoreFailure.layoutFormSizeRequired);
      }
    }

    final requiresAddress =
        layout.layoutType == BSFPrintLabelLayoutType.customer ||
        layout.layoutType == BSFPrintLabelLayoutType.customerCard;
    if (requiresAddress &&
        layout.addressType == BSFPrintLabelAddressType.notApplicable) {
      errors.add(CoreFailure.layoutAddressRequired);
    } else if (!requiresAddress &&
        layout.addressType != BSFPrintLabelAddressType.notApplicable) {
      errors.add(CoreFailure.layoutAddressInapplicable);
    }

    if (layout.fields.isEmpty) {
      errors.add(CoreFailure.layoutFieldRequired);
    } else if (layout.fields.any(
      (field) =>
          field.field == null || !field.field!.appliesTo(layout.layoutType),
    )) {
      errors.add(CoreFailure.layoutFieldInapplicable);
    }

    if (layout.quantityColumns > 0 && layout.formWidth > 0) {
      final occupiedWidth =
          (layout.labelWidth * layout.quantityColumns) +
          (layout.labelRightMargin * (layout.quantityColumns - 1));
      if (occupiedWidth > layout.formWidth) {
        errors.add(CoreFailure.layoutLabelsExceedForm);
      }
    }

    return errors;
  }
}
