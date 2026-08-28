import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class BSFPrintLabelLayoutSummaryModel extends BSFPrintLabelLayoutSummaryEntity {
  const BSFPrintLabelLayoutSummaryModel({
    required super.code,
    required super.name,
    required super.layoutType,
    required super.layoutTypeDescription,
    required super.formType,
    required super.labelPrinterCode,
    required super.labelPrinterDescription,
    required super.labelPrinterModelType,
    required super.coordinateUnit,
  });

  factory BSFPrintLabelLayoutSummaryModel.fromJson(Map json) {
    return BSFPrintLabelLayoutSummaryModel(
      code: (json['code'] as num).toInt(),
      name: json['name'] as String,
      layoutType: BSFPrintLabelLayoutType.fromJson(json['layoutType']),
      layoutTypeDescription: json['layoutTypeDescription'] as String,
      formType: BSFPrintLabelFormType.fromJson(json['formType']),
      labelPrinterCode: (json['labelPrinterCode'] as num).toInt(),
      labelPrinterDescription: json['labelPrinterDescription'] as String?,
      labelPrinterModelType: BSFLabelPrinterModelType.fromJson(
        json['labelPrinterModelType'],
      ),
      coordinateUnit: BSFPrintLabelCoordinateUnit.fromJson(
        json['coordinateUnit'],
      ),
    );
  }

  factory BSFPrintLabelLayoutSummaryModel.fromEntity(
    BSFPrintLabelLayoutSummaryEntity entity,
  ) {
    return BSFPrintLabelLayoutSummaryModel(
      code: entity.code,
      name: entity.name,
      layoutType: entity.layoutType,
      layoutTypeDescription: entity.layoutTypeDescription,
      formType: entity.formType,
      labelPrinterCode: entity.labelPrinterCode,
      labelPrinterDescription: entity.labelPrinterDescription,
      labelPrinterModelType: entity.labelPrinterModelType,
      coordinateUnit: entity.coordinateUnit,
    );
  }

  Map toJson() => {
    'code': code,
    'name': name,
    'layoutType': layoutType.toJson(),
    'layoutTypeDescription': layoutTypeDescription,
    'formType': formType.toJson(),
    'labelPrinterCode': labelPrinterCode,
    'labelPrinterDescription': labelPrinterDescription,
    'labelPrinterModelType': labelPrinterModelType.toJson(),
    'coordinateUnit': coordinateUnit.toJson(),
  };

  BSFPrintLabelLayoutSummaryEntity toEntity() {
    return BSFPrintLabelLayoutSummaryEntity(
      code: code,
      name: name,
      layoutType: layoutType,
      layoutTypeDescription: layoutTypeDescription,
      formType: formType,
      labelPrinterCode: labelPrinterCode,
      labelPrinterDescription: labelPrinterDescription,
      labelPrinterModelType: labelPrinterModelType,
      coordinateUnit: coordinateUnit,
    );
  }
}
