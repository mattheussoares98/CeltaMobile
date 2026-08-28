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
