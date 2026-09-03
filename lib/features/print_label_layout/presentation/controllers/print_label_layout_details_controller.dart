import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/providers.dart';
import 'package:celta_inventario/utils/extensions/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'print_label_layout_details_controller.g.dart';

@riverpod
class PrintLabelLayoutDetailsController
    extends _$PrintLabelLayoutDetailsController {
  @override
  FutureOr<BSFPrintLabelLayoutEntity> build(int code) async {
    ref.cache(60);
    final params = await ref.watch(ecRequestParamsProvider().future);
    return ref
        .read(ecPrintLabelLayoutRepositoryProvider)
        .getDetails(params, code);
  }

  void updateFieldCoordinateX(int fieldIndex, double delta) {
    _updateField(fieldIndex, (field) {
      final updatedValue = _round(
        (field.coordinateX + delta).clamp(0.0, double.infinity),
      );
      return field.copyWith(coordinateX: updatedValue);
    });
  }

  void updateFieldCoordinateY(int fieldIndex, double delta) {
    _updateField(fieldIndex, (field) {
      final updatedValue = _round(
        (field.coordinateY + delta).clamp(0.0, double.infinity),
      );
      return field.copyWith(coordinateY: updatedValue);
    });
  }

  void updateFieldWidth(int fieldIndex, double delta) {
    _updateField(fieldIndex, (field) {
      final updatedValue = _round(
        (field.width + delta).clamp(0.0, double.infinity),
      );
      return field.copyWith(width: updatedValue);
    });
  }

  void updateFieldHeight(int fieldIndex, double delta) {
    _updateField(fieldIndex, (field) {
      final updatedValue = _round(
        (field.height + delta).clamp(0.0, double.infinity),
      );
      return field.copyWith(height: updatedValue);
    });
  }

  void updateFieldRatioBarCode(int fieldIndex, double delta) {
    _updateField(fieldIndex, (field) {
      final updatedValue = _round(
        (field.ratioBarCode + delta).clamp(0.0, double.infinity),
      );
      return field.copyWith(ratioBarCode: updatedValue);
    });
  }

  void updateFieldSize(int fieldIndex, double delta) {
    _updateField(fieldIndex, (field) {
      final size = _round((field.width + delta).clamp(0.0, double.infinity));
      return field.copyWith(width: size, height: size);
    });
  }

  void updateFieldBarcodeSimbologyType(
    int fieldIndex,
    BSFBarcodeSimbologyType barcodeSimbologyType,
  ) {
    _updateField(
      fieldIndex,
      (field) => field.copyWith(barcodeSimbologyType: barcodeSimbologyType),
    );
  }

  void updateFieldForDataBarcode(
    int fieldIndex,
    BSFPrintLabelFieldDefinitionEntity fieldForDataBarcode,
  ) {
    _updateField(
      fieldIndex,
      (field) => field.copyWith(fieldForDataBarcode: fieldForDataBarcode),
    );
  }

  void updateFieldRotateType(
    int fieldIndex,
    BSFPrintElementRotationType rotateType,
  ) {
    _updateField(fieldIndex, (field) {
      return field.copyWith(rotateType: rotateType);
    });
  }

  void updateFieldAlignmentType(
    int fieldIndex,
    BSFPrintElementAlignmentType alignmentType,
  ) {
    _updateField(
      fieldIndex,
      (field) => field.copyWith(alignmentType: alignmentType),
    );
  }

  void updateFieldQuantityDecimalPlaces(int fieldIndex, int delta) {
    _updateField(fieldIndex, (field) {
      return field.copyWith(
        quantityDecimalPlaces: (field.quantityDecimalPlaces + delta).clamp(
          0,
          9999,
        ),
      );
    });
  }

  void updateFieldDrawLabelBelowBarcode(int fieldIndex, bool drawLabel) {
    _updateField(fieldIndex, (field) {
      return field.copyWith(drawLabelBelowBarcode: drawLabel);
    });
  }

  void updateFieldPrefix(int fieldIndex, String prefix) {
    _updateField(fieldIndex, (field) {
      final previewValue = field.previewValue;
      if (previewValue == null) return field.copyWith(prefix: prefix);

      final valueWithoutPrefix =
          field.prefix.isNotEmpty && previewValue.startsWith(field.prefix)
          ? previewValue.substring(field.prefix.length)
          : previewValue;
      return field.copyWith(
        prefix: prefix,
        previewValue: '$prefix$valueWithoutPrefix',
      );
    });
  }

  void updateFieldImageName(int fieldIndex, String imageName) {
    _updateField(fieldIndex, (field) => field.copyWith(imageName: imageName));
  }

  void updateFieldFormat(
    int fieldIndex,
    BSFPrintLabelFieldFormatEntity format,
  ) {
    _updateField(fieldIndex, (field) => field.copyWith(format: format));
  }

  void updateFieldFontType(int fieldIndex, int fontType) {
    _updateField(
      fieldIndex,
      (field) => field.copyWith(fontType: fontType.clamp(1, 6).toString()),
    );
  }

  void changeFieldFontSize(int fieldIndex, bool advance) {
    _updateField(
      fieldIndex,
      (field) =>
          field.copyWith(fontSize: changedFontSize(field.fontSize, advance)),
    );
  }

  static int changedFontSize(int fontSize, bool advance) =>
      (fontSize + (advance ? 1 : -1)).clamp(0, 216);

  void updateFieldIsBold(int fieldIndex, bool isBold) {
    _updateField(fieldIndex, (field) => field.copyWith(isBold: isBold));
  }

  void updateFieldIsReverseText(int fieldIndex, bool isReverseText) {
    _updateField(
      fieldIndex,
      (field) => field.copyWith(isReverseText: isReverseText),
    );
  }

  void updateFieldPositionStartCharacter(int fieldIndex, int delta) {
    _updateField(fieldIndex, (field) {
      return field.copyWith(
        positionStartCharacter: (field.positionStartCharacter + delta).clamp(
          1,
          9999,
        ),
      );
    });
  }

  void updateFieldMaxCharacterSize(int fieldIndex, int delta) {
    _updateField(fieldIndex, (field) {
      return field.copyWith(
        maxCharacterSize: (field.maxCharacterSize + delta).clamp(0, 9999),
      );
    });
  }

  void toggleFieldVisibility(int fieldIndex) {
    _updateField(fieldIndex, (field) {
      return field.copyWith(isVisible: !field.isVisible);
    });
  }

  void addField(BSFPrintLabelLayoutFieldEntity draft) {
    _updateLayout((layout) {
      return layout.copyWith(fields: [...layout.fields, draft]);
    });
  }

  void replaceFieldDefinition(
    int fieldIndex,
    BSFPrintLabelLayoutFieldEntity draft,
  ) {
    _updateField(fieldIndex, (field) => draft.copyWith(prefix: field.prefix));
  }

  void updateName(String name) {
    _updateLayout((layout) => layout.copyWith(name: name));
  }

  void updateTemperature(int value) {
    _updateLayout((layout) {
      final capabilities = layout.capabilities;
      if (!capabilities.canEditTemperature ||
          !capabilities.supportedTemperatures.contains(value.toString())) {
        return layout;
      }
      return layout.copyWith(temperature: value);
    });
  }

  void updatePrintSpeed(int value) {
    _updateLayout((layout) {
      final capabilities = layout.capabilities;
      if (!capabilities.canEditPrintSpeed ||
          !capabilities.supportedPrintSpeeds.contains(value.toString())) {
        return layout;
      }
      return layout.copyWith(printSpeed: value);
    });
  }

  void updateIntervalPrintPackage(int delta) {
    _updateLayout((layout) {
      final updated = (layout.intervalPrintPackage + delta).clamp(0, 9999);
      return layout.copyWith(intervalPrintPackage: updated);
    });
  }

  void updateFormType(BSFPrintLabelFormType formType) {
    _updateLayout((layout) {
      final keepsHeight =
          formType == BSFPrintLabelFormType.continuous ||
          layout.capabilities.isGenericPrinter ||
          layout.capabilities.isZebraGC420t;

      return layout.copyWith(
        formType: formType,
        formHeight: keepsHeight ? layout.formHeight : 0,
        labelHeight: keepsHeight ? layout.labelHeight : 0,
        labelBottomMargin: keepsHeight ? layout.labelBottomMargin : 0,
        directionLabelType: layout.capabilities.isZebraGC420t
            ? layout.directionLabelType
            : BSFPrintLabelDirectionType.top,
        applyFormSizeConfiguration: layout.capabilities.isGenericPrinter
            ? layout.applyFormSizeConfiguration
            : true,
      );
    });
  }

  void updateFormWidth(double delta) {
    _updateLayout((layout) {
      final updated = _round(
        (layout.formWidth + delta).clamp(0.0, double.infinity),
      );
      return layout.copyWith(formWidth: updated);
    });
  }

  void updateFormHeight(double delta) {
    _updateLayout((layout) {
      final updated = _round(
        (layout.formHeight + delta).clamp(0.0, double.infinity),
      );
      return layout.copyWith(formHeight: updated);
    });
  }

  void updateFormTopMargin(double delta) {
    _updateLayout((layout) {
      final updated = _round(
        (layout.formTopMargin + delta).clamp(0.0, double.infinity),
      );
      return layout.copyWith(formTopMargin: updated);
    });
  }

  void updateFormLeftMargin(double delta) {
    _updateLayout((layout) {
      final updated = _round(
        (layout.formLeftMargin + delta).clamp(0.0, double.infinity),
      );
      return layout.copyWith(formLeftMargin: updated);
    });
  }

  void updateQuantityColumns(int delta) {
    _updateLayout((layout) {
      final updated = (layout.quantityColumns + delta).clamp(1, 99);
      return layout.copyWith(quantityColumns: updated);
    });
  }

  void updateApplyFormSizeConfiguration(bool value) {
    _updateLayout(
      (layout) => layout.copyWith(applyFormSizeConfiguration: value),
    );
  }

  void updateAddressType(BSFPrintLabelAddressType value) {
    _updateLayout((layout) => layout.copyWith(addressType: value));
  }

  void updateLabelWidth(double delta) {
    _updateLayout((layout) {
      final updated = _round(
        (layout.labelWidth + delta).clamp(0.0, double.infinity),
      );
      return layout.copyWith(labelWidth: updated);
    });
  }

  void updateLabelHeight(double delta) {
    _updateLayout((layout) {
      final updated = _round(
        (layout.labelHeight + delta).clamp(0.0, double.infinity),
      );
      return layout.copyWith(labelHeight: updated);
    });
  }

  void updateLabelRightMargin(double delta) {
    _updateLayout((layout) {
      final updated = _round(
        (layout.labelRightMargin + delta).clamp(0.0, double.infinity),
      );
      return layout.copyWith(labelRightMargin: updated);
    });
  }

  void updateLabelBottomMargin(double delta) {
    _updateLayout((layout) {
      final updated = _round(
        (layout.labelBottomMargin + delta).clamp(0.0, double.infinity),
      );
      return layout.copyWith(labelBottomMargin: updated);
    });
  }

  void updateDirectionLabelType(BSFPrintLabelDirectionType value) {
    _updateLayout((layout) {
      final capabilities = layout.capabilities;
      if (!capabilities.canEditDirection ||
          !capabilities.supportedDirections.contains(value)) {
        return layout;
      }
      return layout.copyWith(directionLabelType: value);
    });
  }

  void updateConsiderProductPacking(BSFProductPackingSelectionType value) {
    _updateLayout((layout) => layout.copyWith(considerProductPacking: value));
  }

  void updateInformPrintQuantityByProduct(bool value) {
    _updateLayout(
      (layout) => layout.copyWith(informPrintQuantityByProduct: value),
    );
  }

  void updatePrintProductBySoldQuantity(bool value) {
    _updateLayout(
      (layout) => layout.copyWith(printProductBySoldQuantity: value),
    );
  }

  void updateGoesForBalanceAndQuantityInBalance(bool value) {
    _updateLayout(
      (layout) => layout.copyWith(goesForBalanceAndQuantityInBalance: value),
    );
  }

  void _updateLayout(
    BSFPrintLabelLayoutEntity Function(BSFPrintLabelLayoutEntity) updater,
  ) {
    if (state is! AsyncData<BSFPrintLabelLayoutEntity>) return;
    state = AsyncData(updater(state.requireValue));
  }

  void _updateField(
    int fieldIndex,
    BSFPrintLabelLayoutFieldEntity Function(BSFPrintLabelLayoutFieldEntity)
    updater,
  ) {
    if (state is! AsyncData<BSFPrintLabelLayoutEntity>) return;
    final current = state.requireValue;
    if (fieldIndex < 0 || fieldIndex >= current.fields.length) return;
    final updatedFields = [...current.fields];
    updatedFields[fieldIndex] = updater(updatedFields[fieldIndex]);

    state = AsyncData(current.copyWith(fields: updatedFields));
  }

  double _round(num value) => (value * 100).round() / 100;
}
