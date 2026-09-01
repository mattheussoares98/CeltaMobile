import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class BSFPrintLabelFieldEditorOptionsModel
    extends BSFPrintLabelFieldEditorOptionsEntity {
  const BSFPrintLabelFieldEditorOptionsModel({
    required super.fieldOptions,
    required super.formats,
  });

  factory BSFPrintLabelFieldEditorOptionsModel.fromJson(Map json) {
    return BSFPrintLabelFieldEditorOptionsModel(
      fieldOptions: (json['fieldOptions'] as List)
          .map((item) => PrintLabelFieldEditorOptionModel.fromJson(item as Map))
          .toList(),
      formats: (json['formats'] as List)
          .map((item) => BSFPrintLabelFieldFormatModel.fromJson(item as Map))
          .toList(),
    );
  }

  factory BSFPrintLabelFieldEditorOptionsModel.fromEntity(
    BSFPrintLabelFieldEditorOptionsEntity entity,
  ) {
    return BSFPrintLabelFieldEditorOptionsModel(
      fieldOptions: entity.fieldOptions
          .map(PrintLabelFieldEditorOptionModel.fromEntity)
          .toList(),
      formats: entity.formats
          .map(BSFPrintLabelFieldFormatModel.fromEntity)
          .toList(),
    );
  }

  Map toJson() => {
    'fieldOptions': fieldOptions
        .map(
          (item) => PrintLabelFieldEditorOptionModel.fromEntity(item).toJson(),
        )
        .toList(),
    'formats': formats
        .map((item) => BSFPrintLabelFieldFormatModel.fromEntity(item).toJson())
        .toList(),
  };

  BSFPrintLabelFieldEditorOptionsEntity toEntity() {
    return BSFPrintLabelFieldEditorOptionsEntity(
      fieldOptions: fieldOptions
          .map(
            (item) =>
                PrintLabelFieldEditorOptionModel.fromEntity(item).toEntity(),
          )
          .toList(),
      formats: formats
          .map(
            (item) => BSFPrintLabelFieldFormatModel.fromEntity(item).toEntity(),
          )
          .toList(),
    );
  }
}
