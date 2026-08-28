import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFPrintLabelLayoutFieldEntity extends Equatable {
  final int code;
  final int quantityDecimalPlaces;
  final double coordinateX;
  final double coordinateY;
  final BSFPrintElementAlignmentType alignmentType;
  final double width;
  final double height;
  final BSFPrintLabelFieldDimensionType dimensionType;
  final String fontType;
  final int fontSize;
  final bool isBold;
  final BSFPrintElementRotationType rotateType;
  final double ratioBarCode;
  final BSFBarcodeSimbologyType barcodeSimbologyType;
  final int positionStartCharacter;
  final int maxCharacterSizeDisplacedQuantity;
  final int maxCharacterSize;
  final bool drawLabelBelowBarcode;
  final bool isReverseText;
  final String prefix;
  final String imageName;
  final BSFPrintLabelFieldDefinitionEntity? field;
  final BSFPrintLabelFieldDefinitionEntity? fieldForDataBarcode;
  final BSFPrintLabelFieldFormatEntity? format;

  const BSFPrintLabelLayoutFieldEntity({
    required this.code,
    required this.quantityDecimalPlaces,
    required this.coordinateX,
    required this.coordinateY,
    required this.alignmentType,
    required this.width,
    required this.height,
    required this.dimensionType,
    required this.fontType,
    required this.fontSize,
    required this.isBold,
    required this.rotateType,
    required this.ratioBarCode,
    required this.barcodeSimbologyType,
    required this.positionStartCharacter,
    required this.maxCharacterSizeDisplacedQuantity,
    required this.maxCharacterSize,
    required this.drawLabelBelowBarcode,
    required this.isReverseText,
    required this.prefix,
    required this.imageName,
    required this.field,
    required this.fieldForDataBarcode,
    required this.format,
  });

  @override
  List<Object?> get props => [
    code,
    quantityDecimalPlaces,
    coordinateX,
    coordinateY,
    alignmentType,
    width,
    height,
    dimensionType,
    fontType,
    fontSize,
    isBold,
    rotateType,
    ratioBarCode,
    barcodeSimbologyType,
    positionStartCharacter,
    maxCharacterSizeDisplacedQuantity,
    maxCharacterSize,
    drawLabelBelowBarcode,
    isReverseText,
    prefix,
    imageName,
    field,
    fieldForDataBarcode,
    format,
  ];
}
