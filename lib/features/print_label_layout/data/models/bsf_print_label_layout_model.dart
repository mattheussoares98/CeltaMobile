import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class BSFPrintLabelLayoutModel extends BSFPrintLabelLayoutEntity {
  const BSFPrintLabelLayoutModel({
    required super.code,
    required super.name,
    required super.layoutType,
    required super.formType,
    required super.formWidth,
    required super.formHeight,
    required super.formTopMargin,
    required super.formLeftMargin,
    required super.quantityColumns,
    required super.labelWidth,
    required super.labelHeight,
    required super.labelRightMargin,
    required super.labelBottomMargin,
    required super.temperature,
    required super.printSpeed,
    required super.directionLabelType,
    required super.considerProductPacking,
    required super.intervalPrintPackage,
    required super.applyFormSizeConfiguration,
    required super.addressType,
    required super.isConvenePrintLabel,
    required super.informPrintQuantityByProduct,
    required super.printProductBySoldQuantity,
    required super.goesForBalanceAndQuantityInBalance,
    required super.labelPrinter,
    required super.fields,
  });

  factory BSFPrintLabelLayoutModel.fromJson(Map json) {
    final printerJson = json['labelPrinter'] as Map?;

    return BSFPrintLabelLayoutModel(
      code: (json['code'] as num).toInt(),
      name: json['name'] as String,
      layoutType: BSFPrintLabelLayoutType.fromJson(json['layoutType']),
      formType: BSFPrintLabelFormType.fromJson(json['formType']),
      formWidth: (json['formWidth'] as num).toDouble(),
      formHeight: (json['formHeight'] as num).toDouble(),
      formTopMargin: (json['formTopMargin'] as num).toDouble(),
      formLeftMargin: (json['formLeftMargin'] as num).toDouble(),
      quantityColumns: (json['quantityColumns'] as num).toInt(),
      labelWidth: (json['labelWidth'] as num).toDouble(),
      labelHeight: (json['labelHeight'] as num).toDouble(),
      labelRightMargin: (json['labelRightMargin'] as num).toDouble(),
      labelBottomMargin: (json['labelBottomMargin'] as num).toDouble(),
      temperature: (json['temperature'] as num).toInt(),
      printSpeed: (json['printSpeed'] as num).toInt(),
      directionLabelType: BSFPrintLabelDirectionType.fromJson(
        json['directionLabelType'],
      ),
      considerProductPacking: BSFProductPackingSelectionType.fromJson(
        json['considerProductPacking'],
      ),
      intervalPrintPackage: (json['intervalPrintPackage'] as num).toInt(),
      applyFormSizeConfiguration: json['applyFormSizeConfiguration'] as bool,
      addressType: BSFPrintLabelAddressType.fromJson(json['addressType']),
      isConvenePrintLabel: json['isConvenePrintLabel'] as bool,
      informPrintQuantityByProduct:
          json['informPrintQuantityByProduct'] as bool,
      printProductBySoldQuantity: json['printProductBySoldQuantity'] as bool,
      goesForBalanceAndQuantityInBalance:
          json['goesForBalanceAndQuantityInBalance'] as bool,
      labelPrinter: printerJson == null
          ? null
          : BSFPrintLabelPrinterModel.fromJson(printerJson),
      fields: (json['fields'] as List)
          .map((field) => BSFPrintLabelLayoutFieldModel.fromJson(field as Map))
          .toList(),
    );
  }

  factory BSFPrintLabelLayoutModel.fromEntity(
    BSFPrintLabelLayoutEntity entity,
  ) {
    return BSFPrintLabelLayoutModel(
      code: entity.code,
      name: entity.name,
      layoutType: entity.layoutType,
      formType: entity.formType,
      formWidth: entity.formWidth,
      formHeight: entity.formHeight,
      formTopMargin: entity.formTopMargin,
      formLeftMargin: entity.formLeftMargin,
      quantityColumns: entity.quantityColumns,
      labelWidth: entity.labelWidth,
      labelHeight: entity.labelHeight,
      labelRightMargin: entity.labelRightMargin,
      labelBottomMargin: entity.labelBottomMargin,
      temperature: entity.temperature,
      printSpeed: entity.printSpeed,
      directionLabelType: entity.directionLabelType,
      considerProductPacking: entity.considerProductPacking,
      intervalPrintPackage: entity.intervalPrintPackage,
      applyFormSizeConfiguration: entity.applyFormSizeConfiguration,
      addressType: entity.addressType,
      isConvenePrintLabel: entity.isConvenePrintLabel,
      informPrintQuantityByProduct: entity.informPrintQuantityByProduct,
      printProductBySoldQuantity: entity.printProductBySoldQuantity,
      goesForBalanceAndQuantityInBalance:
          entity.goesForBalanceAndQuantityInBalance,
      labelPrinter: entity.labelPrinter == null
          ? null
          : BSFPrintLabelPrinterModel.fromEntity(entity.labelPrinter!),
      fields: entity.fields
          .map(BSFPrintLabelLayoutFieldModel.fromEntity)
          .toList(),
    );
  }

  Map toJson() => {
    'code': code,
    'name': name,
    'layoutType': layoutType.toJson(),
    'formType': formType.toJson(),
    'formWidth': formWidth,
    'formHeight': formHeight,
    'formTopMargin': formTopMargin,
    'formLeftMargin': formLeftMargin,
    'quantityColumns': quantityColumns,
    'labelWidth': labelWidth,
    'labelHeight': labelHeight,
    'labelRightMargin': labelRightMargin,
    'labelBottomMargin': labelBottomMargin,
    'temperature': temperature,
    'printSpeed': printSpeed,
    'directionLabelType': directionLabelType.toJson(),
    'considerProductPacking': considerProductPacking.toJson(),
    'intervalPrintPackage': intervalPrintPackage,
    'applyFormSizeConfiguration': applyFormSizeConfiguration,
    'addressType': addressType.toJson(),
    'isConvenePrintLabel': isConvenePrintLabel,
    'informPrintQuantityByProduct': informPrintQuantityByProduct,
    'printProductBySoldQuantity': printProductBySoldQuantity,
    'goesForBalanceAndQuantityInBalance': goesForBalanceAndQuantityInBalance,
    'labelPrinter': labelPrinter == null
        ? null
        : BSFPrintLabelPrinterModel.fromEntity(labelPrinter!).toJson(),
    'fields': fields
        .map(
          (field) => BSFPrintLabelLayoutFieldModel.fromEntity(field).toJson(),
        )
        .toList(),
  };

  BSFPrintLabelLayoutEntity toEntity() {
    return BSFPrintLabelLayoutEntity(
      code: code,
      name: name,
      layoutType: layoutType,
      formType: formType,
      formWidth: formWidth,
      formHeight: formHeight,
      formTopMargin: formTopMargin,
      formLeftMargin: formLeftMargin,
      quantityColumns: quantityColumns,
      labelWidth: labelWidth,
      labelHeight: labelHeight,
      labelRightMargin: labelRightMargin,
      labelBottomMargin: labelBottomMargin,
      temperature: temperature,
      printSpeed: printSpeed,
      directionLabelType: directionLabelType,
      considerProductPacking: considerProductPacking,
      intervalPrintPackage: intervalPrintPackage,
      applyFormSizeConfiguration: applyFormSizeConfiguration,
      addressType: addressType,
      isConvenePrintLabel: isConvenePrintLabel,
      informPrintQuantityByProduct: informPrintQuantityByProduct,
      printProductBySoldQuantity: printProductBySoldQuantity,
      goesForBalanceAndQuantityInBalance: goesForBalanceAndQuantityInBalance,
      labelPrinter: labelPrinter == null
          ? null
          : BSFPrintLabelPrinterModel.fromEntity(labelPrinter!).toEntity(),
      fields: fields
          .map(
            (field) =>
                BSFPrintLabelLayoutFieldModel.fromEntity(field).toEntity(),
          )
          .toList(),
    );
  }
}
