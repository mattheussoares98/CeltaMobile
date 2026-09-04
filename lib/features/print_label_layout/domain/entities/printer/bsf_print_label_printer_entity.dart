import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFPrintLabelPrinterEntity extends Equatable {
  final int code;
  final String description;
  final BSFLabelPrinterModelType modelType;
  final bool isGeneric;
  final BSFPrintLabelCoordinateUnit coordinateUnit;
  final List<String> supportedFontTypes;
  final List<int> supportedFontSizes;
  final List<String> supportedPrintSpeeds;
  final List<String> supportedTemperatures;
  final List<BSFPrintLabelDirectionType> supportedDirections;

  const BSFPrintLabelPrinterEntity({
    required this.code,
    required this.description,
    required this.modelType,
    required this.isGeneric,
    required this.coordinateUnit,
    required this.supportedFontTypes,
    required this.supportedFontSizes,
    required this.supportedPrintSpeeds,
    required this.supportedTemperatures,
    required this.supportedDirections,
  });

  @override
  List<Object?> get props => [
    code,
    description,
    modelType,
    isGeneric,
    coordinateUnit,
    supportedFontTypes,
    supportedFontSizes,
    supportedPrintSpeeds,
    supportedTemperatures,
    supportedDirections,
  ];
}
