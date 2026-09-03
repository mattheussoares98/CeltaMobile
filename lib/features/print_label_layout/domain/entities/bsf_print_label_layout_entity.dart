import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFPrintLabelLayoutEntity extends Equatable {
  final int code;
  final String name;
  final BSFPrintLabelLayoutType layoutType;
  final BSFPrintLabelFormType formType;
  final double formWidth;
  final double formHeight;
  final double formTopMargin;
  final double formLeftMargin;
  final int quantityColumns;
  final double labelWidth;
  final double labelHeight;
  final double labelRightMargin;
  final double labelBottomMargin;
  final int temperature;
  final int printSpeed;
  final BSFPrintLabelDirectionType directionLabelType;
  final BSFProductPackingSelectionType considerProductPacking;
  final int intervalPrintPackage;
  final bool applyFormSizeConfiguration;
  final BSFPrintLabelAddressType addressType;
  final bool isConvenePrintLabel;
  final bool informPrintQuantityByProduct;
  final bool printProductBySoldQuantity;
  final bool goesForBalanceAndQuantityInBalance;
  final BSFPrintLabelPrinterEntity? labelPrinter;
  final List<BSFPrintLabelLayoutFieldEntity> fields;

  const BSFPrintLabelLayoutEntity({
    required this.code,
    required this.name,
    required this.layoutType,
    required this.formType,
    required this.formWidth,
    required this.formHeight,
    required this.formTopMargin,
    required this.formLeftMargin,
    required this.quantityColumns,
    required this.labelWidth,
    required this.labelHeight,
    required this.labelRightMargin,
    required this.labelBottomMargin,
    required this.temperature,
    required this.printSpeed,
    required this.directionLabelType,
    required this.considerProductPacking,
    required this.intervalPrintPackage,
    required this.applyFormSizeConfiguration,
    required this.addressType,
    required this.isConvenePrintLabel,
    required this.informPrintQuantityByProduct,
    required this.printProductBySoldQuantity,
    required this.goesForBalanceAndQuantityInBalance,
    required this.labelPrinter,
    required this.fields,
  });

  bool get isGenericPrinter => labelPrinter?.isGeneric ?? true;

  bool get isRabbitOS214 =>
      labelPrinter?.modelType == BSFLabelPrinterModelType.rabbitOS214;

  BSFPrintLabelCoordinateUnit? get coordinateUnit =>
      labelPrinter?.coordinateUnit;

  bool supportsFontType(BSFPrintLabelLayoutFieldEntity field) =>
      field.supportsFontType(isGenericPrinter: isGenericPrinter);

  bool supportsFontSize(BSFPrintLabelLayoutFieldEntity field) =>
      field.usesTextCharacterOptions &&
      (isGenericPrinter ||
          (labelPrinter?.modelType == BSFLabelPrinterModelType.os214Plus &&
              field.fontType == '9'));

  bool supportsBold(BSFPrintLabelLayoutFieldEntity field) =>
      isGenericPrinter && field.usesTextCharacterOptions;

  bool supportsAlignment(BSFPrintLabelLayoutFieldEntity field) =>
      isGenericPrinter && field.usesTextCharacterOptions;

  bool supportsReverseText(BSFPrintLabelLayoutFieldEntity field) =>
      !isGenericPrinter &&
      field.usesTextCharacterOptions &&
      labelPrinter?.modelType != BSFLabelPrinterModelType.os214Plus &&
      labelPrinter?.modelType != BSFLabelPrinterModelType.rabbitOS214;

  bool supportsBarcodeRatio(BSFPrintLabelLayoutFieldEntity field) =>
      !isGenericPrinter && field.isBarcode && !field.isQrCode;

  bool supportsGenericBarcodeControls(BSFPrintLabelLayoutFieldEntity field) =>
      isGenericPrinter && field.isBarcode && !field.isQrCode;

  bool supportsDrawLabelBelowBarcode(BSFPrintLabelLayoutFieldEntity field) =>
      field.isBarcode && !field.isQrCode;

  bool supportsRotation(BSFPrintLabelLayoutFieldEntity field) =>
      field.showsRotationEditor &&
      !(labelPrinter?.modelType == BSFLabelPrinterModelType.os214Plus &&
          (field.fieldType == BSFPrintLabelFieldType.logo || field.isQrCode));

  BSFPrintLabelLayoutEntity copyWith({
    int? code,
    String? name,
    BSFPrintLabelLayoutType? layoutType,
    BSFPrintLabelFormType? formType,
    double? formWidth,
    double? formHeight,
    double? formTopMargin,
    double? formLeftMargin,
    int? quantityColumns,
    double? labelWidth,
    double? labelHeight,
    double? labelRightMargin,
    double? labelBottomMargin,
    int? temperature,
    int? printSpeed,
    BSFPrintLabelDirectionType? directionLabelType,
    BSFProductPackingSelectionType? considerProductPacking,
    int? intervalPrintPackage,
    bool? applyFormSizeConfiguration,
    BSFPrintLabelAddressType? addressType,
    bool? isConvenePrintLabel,
    bool? informPrintQuantityByProduct,
    bool? printProductBySoldQuantity,
    bool? goesForBalanceAndQuantityInBalance,
    BSFPrintLabelPrinterEntity? labelPrinter,
    List<BSFPrintLabelLayoutFieldEntity>? fields,
  }) {
    return BSFPrintLabelLayoutEntity(
      code: code ?? this.code,
      name: name ?? this.name,
      layoutType: layoutType ?? this.layoutType,
      formType: formType ?? this.formType,
      formWidth: formWidth ?? this.formWidth,
      formHeight: formHeight ?? this.formHeight,
      formTopMargin: formTopMargin ?? this.formTopMargin,
      formLeftMargin: formLeftMargin ?? this.formLeftMargin,
      quantityColumns: quantityColumns ?? this.quantityColumns,
      labelWidth: labelWidth ?? this.labelWidth,
      labelHeight: labelHeight ?? this.labelHeight,
      labelRightMargin: labelRightMargin ?? this.labelRightMargin,
      labelBottomMargin: labelBottomMargin ?? this.labelBottomMargin,
      temperature: temperature ?? this.temperature,
      printSpeed: printSpeed ?? this.printSpeed,
      directionLabelType: directionLabelType ?? this.directionLabelType,
      considerProductPacking:
          considerProductPacking ?? this.considerProductPacking,
      intervalPrintPackage: intervalPrintPackage ?? this.intervalPrintPackage,
      applyFormSizeConfiguration:
          applyFormSizeConfiguration ?? this.applyFormSizeConfiguration,
      addressType: addressType ?? this.addressType,
      isConvenePrintLabel: isConvenePrintLabel ?? this.isConvenePrintLabel,
      informPrintQuantityByProduct:
          informPrintQuantityByProduct ?? this.informPrintQuantityByProduct,
      printProductBySoldQuantity:
          printProductBySoldQuantity ?? this.printProductBySoldQuantity,
      goesForBalanceAndQuantityInBalance:
          goesForBalanceAndQuantityInBalance ??
          this.goesForBalanceAndQuantityInBalance,
      labelPrinter: labelPrinter ?? this.labelPrinter,
      fields: fields ?? this.fields,
    );
  }

  @override
  List<Object?> get props => [
    code,
    name,
    layoutType,
    formType,
    formWidth,
    formHeight,
    formTopMargin,
    formLeftMargin,
    quantityColumns,
    labelWidth,
    labelHeight,
    labelRightMargin,
    labelBottomMargin,
    temperature,
    printSpeed,
    directionLabelType,
    considerProductPacking,
    intervalPrintPackage,
    applyFormSizeConfiguration,
    addressType,
    isConvenePrintLabel,
    informPrintQuantityByProduct,
    printProductBySoldQuantity,
    goesForBalanceAndQuantityInBalance,
    labelPrinter,
    fields,
  ];
}
