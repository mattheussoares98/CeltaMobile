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

  void updateName(String name) {
    _updateLayout((layout) => layout.copyWith(name: name));
  }

  void updateTemperature(int delta) {
    _updateLayout((layout) {
      final updated = (layout.temperature + delta).clamp(1, 16);
      return layout.copyWith(temperature: updated);
    });
  }

  void updatePrintSpeed(int delta) {
    _updateLayout((layout) {
      final updated = (layout.printSpeed + delta).clamp(1, 5);
      return layout.copyWith(printSpeed: updated);
    });
  }

  void updateIntervalPrintPackage(int delta) {
    _updateLayout((layout) {
      final updated = (layout.intervalPrintPackage + delta).clamp(0, 9999);
      return layout.copyWith(intervalPrintPackage: updated);
    });
  }

  void updateFormType(BSFPrintLabelFormType formType) {
    _updateLayout((layout) => layout.copyWith(formType: formType));
  }

  void updateFormWidth(double delta) {
    _updateLayout((layout) {
      final updated = _round(
        (layout.formWidth + delta).clamp(0.0, double.infinity),
      );
      return layout.copyWith(formWidth: updated);
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

  void updateApplyFormSizeConfiguration(bool value) {
    _updateLayout(
      (layout) => layout.copyWith(applyFormSizeConfiguration: value),
    );
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

  void updateConsiderProductPacking(BSFProductPackingSelectionType value) {
    _updateLayout((layout) => layout.copyWith(considerProductPacking: value));
  }

  void updateInformPrintQuantityByProduct(bool value) {
    _updateLayout(
      (layout) => layout.copyWith(informPrintQuantityByProduct: value),
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
