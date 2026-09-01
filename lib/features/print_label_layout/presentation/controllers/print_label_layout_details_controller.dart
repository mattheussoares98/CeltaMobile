import 'dart:math' as math;

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

  void updateFieldCoordinateX(int fieldCode, double delta) {
    _updateField(fieldCode, (field) {
      final updatedValue = _round(
        (field.coordinateX + delta).clamp(0.0, double.infinity),
      );
      return field.copyWith(coordinateX: updatedValue);
    });
  }

  void updateFieldCoordinateY(int fieldCode, double delta) {
    _updateField(fieldCode, (field) {
      final updatedValue = _round(
        (field.coordinateY + delta).clamp(0.0, double.infinity),
      );
      return field.copyWith(coordinateY: updatedValue);
    });
  }

  void updateFieldWidth(int fieldCode, double delta) {
    _updateField(fieldCode, (field) {
      final updatedValue = _round(
        (field.width + delta).clamp(0.0, double.infinity),
      );
      final isFilledBox =
          field.field?.fieldType == BSFPrintLabelFieldType.boxOrLine &&
          field.ratioBarCode * 2 >= math.min(field.width, field.height);
      final updatedRatio = isFilledBox
          ? _round(math.max(field.ratioBarCode, updatedValue / 2))
          : field.ratioBarCode;

      return field.copyWith(width: updatedValue, ratioBarCode: updatedRatio);
    });
  }

  void updateFieldHeight(int fieldCode, double delta) {
    _updateField(fieldCode, (field) {
      final updatedValue = _round(
        (field.height + delta).clamp(0.0, double.infinity),
      );
      final isFilledBox =
          field.field?.fieldType == BSFPrintLabelFieldType.boxOrLine &&
          field.ratioBarCode * 2 >= math.min(field.width, field.height);
      final updatedRatio = isFilledBox
          ? _round(math.max(field.ratioBarCode, updatedValue / 2))
          : field.ratioBarCode;

      return field.copyWith(height: updatedValue, ratioBarCode: updatedRatio);
    });
  }

  void toggleFieldVisibility(int fieldCode) {
    _updateField(fieldCode, (field) {
      return field.copyWith(isVisible: !field.isVisible);
    });
  }

  void _updateField(
    int fieldCode,
    BSFPrintLabelLayoutFieldEntity Function(BSFPrintLabelLayoutFieldEntity)
    updater,
  ) {
    if (state is! AsyncData<BSFPrintLabelLayoutEntity>) return;
    final current = state.requireValue;

    final updatedFields = current.fields.map((f) {
      if (f.code == fieldCode) {
        return updater(f);
      }
      return f;
    }).toList();

    state = AsyncData(current.copyWith(fields: updatedFields));
  }

  double _round(num value) => (value * 100).round() / 100;
}
