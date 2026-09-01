import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class PrintLabelFieldEditorOptionModel
    extends PrintLabelFieldEditorOptionEntity {
  const PrintLabelFieldEditorOptionModel({
    required super.definition,
    required super.draft,
  });

  factory PrintLabelFieldEditorOptionModel.fromJson(Map json) {
    return PrintLabelFieldEditorOptionModel(
      definition: BSFPrintLabelFieldDefinitionModel.fromJson(
        json['definition'] as Map,
      ),
      draft: BSFPrintLabelLayoutFieldModel.fromJson(json['draft'] as Map),
    );
  }

  factory PrintLabelFieldEditorOptionModel.fromEntity(
    PrintLabelFieldEditorOptionEntity entity,
  ) {
    return PrintLabelFieldEditorOptionModel(
      definition: BSFPrintLabelFieldDefinitionModel.fromEntity(
        entity.definition,
      ),
      draft: BSFPrintLabelLayoutFieldModel.fromEntity(entity.draft),
    );
  }

  Map toJson() => {
    'definition': BSFPrintLabelFieldDefinitionModel.fromEntity(
      definition,
    ).toJson(),
    'draft': BSFPrintLabelLayoutFieldModel.fromEntity(draft).toJson(),
  };

  PrintLabelFieldEditorOptionEntity toEntity() {
    return PrintLabelFieldEditorOptionEntity(
      definition: BSFPrintLabelFieldDefinitionModel.fromEntity(
        definition,
      ).toEntity(),
      draft: BSFPrintLabelLayoutFieldModel.fromEntity(draft).toEntity(),
    );
  }
}
