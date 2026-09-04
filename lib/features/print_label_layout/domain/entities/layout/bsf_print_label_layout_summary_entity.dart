import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFPrintLabelLayoutSummaryEntity extends Equatable {
  final int code;
  final String name;
  final BSFPrintLabelLayoutType layoutType;
  final String layoutTypeDescription;
  final BSFPrintLabelFormType formType;
  final int labelPrinterCode;
  final String? labelPrinterDescription;
  final BSFLabelPrinterModelType labelPrinterModelType;
  final BSFPrintLabelCoordinateUnit coordinateUnit;

  const BSFPrintLabelLayoutSummaryEntity({
    required this.code,
    required this.name,
    required this.layoutType,
    required this.layoutTypeDescription,
    required this.formType,
    required this.labelPrinterCode,
    required this.labelPrinterDescription,
    required this.labelPrinterModelType,
    required this.coordinateUnit,
  });

  @override
  List<Object?> get props => [
    code,
    name,
    layoutType,
    layoutTypeDescription,
    formType,
    labelPrinterCode,
    labelPrinterDescription,
    labelPrinterModelType,
    coordinateUnit,
  ];
}
