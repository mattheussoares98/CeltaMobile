import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class BSFPrintLabelLayoutCreateOptionsModel
    extends BSFPrintLabelLayoutCreateOptionsEntity {
  const BSFPrintLabelLayoutCreateOptionsModel({
    required super.draft,
    required super.printers,
  });

  factory BSFPrintLabelLayoutCreateOptionsModel.fromJson(Map json) {
    return BSFPrintLabelLayoutCreateOptionsModel(
      draft: BSFPrintLabelLayoutModel.fromJson(json['draft'] as Map),
      printers: (json['printers'] as List)
          .map((value) => BSFPrintLabelPrinterModel.fromJson(value as Map))
          .toList(),
    );
  }

  factory BSFPrintLabelLayoutCreateOptionsModel.fromEntity(
    BSFPrintLabelLayoutCreateOptionsEntity entity,
  ) {
    return BSFPrintLabelLayoutCreateOptionsModel(
      draft: BSFPrintLabelLayoutModel.fromEntity(entity.draft),
      printers: entity.printers
          .map(BSFPrintLabelPrinterModel.fromEntity)
          .toList(),
    );
  }

  Map toJson() => {
    'draft': BSFPrintLabelLayoutModel.fromEntity(draft).toJson(),
    'printers': printers
        .map(
          (printer) => BSFPrintLabelPrinterModel.fromEntity(printer).toJson(),
        )
        .toList(),
  };

  BSFPrintLabelLayoutCreateOptionsEntity toEntity() {
    return BSFPrintLabelLayoutCreateOptionsEntity(
      draft: BSFPrintLabelLayoutModel.fromEntity(draft).toEntity(),
      printers: printers
          .map(
            (printer) =>
                BSFPrintLabelPrinterModel.fromEntity(printer).toEntity(),
          )
          .toList(),
    );
  }
}
