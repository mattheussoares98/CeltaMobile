import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class BSFPrintLabelFieldEditorOptionsModel
    extends BSFPrintLabelFieldEditorOptionsEntity {
  const BSFPrintLabelFieldEditorOptionsModel({
    required super.fields,
    required super.fieldDrafts,
    required super.formats,
  });

  factory BSFPrintLabelFieldEditorOptionsModel.fromJson(Map json) {
    return BSFPrintLabelFieldEditorOptionsModel(
      fields: (json['fields'] as List)
          .map(
            (item) => BSFPrintLabelFieldDefinitionModel.fromJson(item as Map),
          )
          .toList(),
      fieldDrafts: (json['fieldDrafts'] as List)
          .map((item) => BSFPrintLabelLayoutFieldModel.fromJson(item as Map))
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
      fields: entity.fields
          .map(BSFPrintLabelFieldDefinitionModel.fromEntity)
          .toList(),
      fieldDrafts: entity.fieldDrafts
          .map(BSFPrintLabelLayoutFieldModel.fromEntity)
          .toList(),
      formats: entity.formats
          .map(BSFPrintLabelFieldFormatModel.fromEntity)
          .toList(),
    );
  }

  Map toJson() => {
    'fields': fields
        .map(
          (item) => BSFPrintLabelFieldDefinitionModel.fromEntity(item).toJson(),
        )
        .toList(),
    'fieldDrafts': fieldDrafts
        .map((item) => BSFPrintLabelLayoutFieldModel.fromEntity(item).toJson())
        .toList(),
    'formats': formats
        .map((item) => BSFPrintLabelFieldFormatModel.fromEntity(item).toJson())
        .toList(),
  };

  BSFPrintLabelFieldEditorOptionsEntity toEntity() {
    return BSFPrintLabelFieldEditorOptionsEntity(
      fields: fields
          .map(
            (item) =>
                BSFPrintLabelFieldDefinitionModel.fromEntity(item).toEntity(),
          )
          .toList(),
      fieldDrafts: fieldDrafts
          .map(
            (item) => BSFPrintLabelLayoutFieldModel.fromEntity(item).toEntity(),
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
