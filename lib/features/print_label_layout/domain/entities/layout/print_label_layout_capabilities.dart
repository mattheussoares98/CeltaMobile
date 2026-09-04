import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class PrintLabelLayoutCapabilities {
  final BSFPrintLabelLayoutEntity layout;

  const PrintLabelLayoutCapabilities(this.layout);

  BSFPrintLabelPrinterEntity? get printer => layout.labelPrinter;

  bool get isExistingLayout => layout.code > 0;
  bool get isGenericPrinter => printer?.isGeneric ?? true;
  bool get isZebraGC420t =>
      printer?.modelType == BSFLabelPrinterModelType.zebraGC420t;
  bool get isContinuousForm =>
      layout.formType == BSFPrintLabelFormType.continuous;

  bool get canEditName => true;
  bool get canEditLayoutType => !isExistingLayout;
  bool get canEditPrinter => !isExistingLayout && layout.fields.isEmpty;

  bool get showsAddressType =>
      layout.layoutType == BSFPrintLabelLayoutType.customer ||
      layout.layoutType == BSFPrintLabelLayoutType.customerCard;
  bool get canEditAddressType =>
      showsAddressType &&
      (!isExistingLayout ||
          layout.layoutType == BSFPrintLabelLayoutType.customer);

  bool get canEditFormType => !isGenericPrinter;
  bool get canEditFormWidth => true;
  bool get canEditFormHeight =>
      isContinuousForm || isGenericPrinter || isZebraGC420t;
  bool get isFormHeightRequired => canEditFormHeight;
  bool get canEditFormMargins => true;
  bool get canEditQuantityColumns => true;
  bool get canEditFormSizeConfiguration => isGenericPrinter;

  bool get canEditLabelWidth => true;
  bool get canEditLabelHeight => canEditFormHeight;
  bool get isLabelHeightRequired => canEditLabelHeight;
  bool get canEditLabelRightMargin => true;
  bool get canEditLabelBottomMargin => canEditLabelHeight;
  bool get canEditDirection => isZebraGC420t;

  bool get showsProductPacking =>
      layout.layoutType == BSFPrintLabelLayoutType.product ||
      layout.layoutType == BSFPrintLabelLayoutType.saleRequestProduct;
  bool get showsQuantityPerProduct => showsProductPacking;
  bool get showsPrintBySoldQuantity =>
      layout.layoutType == BSFPrintLabelLayoutType.saleRequestProduct;
  bool get showsBalanceBehavior => showsPrintBySoldQuantity;

  bool get canEditTemperature => !isGenericPrinter;
  bool get canEditPrintSpeed => !isGenericPrinter;
  bool get canEditPackageInterval => !isGenericPrinter;

  List<String> get supportedTemperatures =>
      printer?.supportedTemperatures ?? const [];
  List<String> get supportedPrintSpeeds =>
      printer?.supportedPrintSpeeds ?? const [];
  List<BSFPrintLabelDirectionType> get supportedDirections =>
      printer?.supportedDirections ?? const [];
}
