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
  final String? previewValue;
  final List<int>? previewImage;
  final BSFPrintLabelFieldDefinitionEntity? field;
  final BSFPrintLabelFieldDefinitionEntity? fieldForDataBarcode;
  final BSFPrintLabelFieldFormatEntity? format;
  final bool isVisible;

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
    required this.previewValue,
    required this.previewImage,
    required this.field,
    required this.fieldForDataBarcode,
    required this.format,
    this.isVisible = true,
  });

  BSFPrintLabelFieldType? get fieldType => field?.fieldType;

  bool get isBarcode => fieldType == BSFPrintLabelFieldType.barcode;

  bool get isQrCode =>
      (isBarcode && barcodeSimbologyType == BSFBarcodeSimbologyType.qrCode) ||
      format?.qrCodeType == true;

  bool get isBoxOrLine => fieldType == BSFPrintLabelFieldType.boxOrLine;

  bool get isTextField => switch (fieldType) {
    BSFPrintLabelFieldType.string ||
    BSFPrintLabelFieldType.integer ||
    BSFPrintLabelFieldType.float ||
    BSFPrintLabelFieldType.dateTime => true,
    _ => false,
  };

  int get fontTypeNumber => int.tryParse(fontType) ?? 1;

  int get editorFontType => fontTypeNumber.clamp(1, 6);

  double get minimumEditorWidth {
    if (isBoxOrLine && ratioBarCode > 0) return ratioBarCode;
    return dimensionType == BSFPrintLabelFieldDimensionType.centimeter
        ? 0.1
        : 1.0;
  }

  double get minimumEditorHeight => minimumEditorWidth;

  double get minimumEditorStrokeThickness => 1.0;

  bool get showsRotationEditor => !isBoxOrLine;

  bool get usesTextCharacterOptions => isTextField && !isQrCode;

  List<BSFPrintLabelFieldFormatEntity> applicableFormats(
    Iterable<BSFPrintLabelFieldFormatEntity> formats,
  ) => formats.where((format) => format.supports(fieldType)).toList();

  bool supportsFontType({required bool isGenericPrinter}) =>
      !isGenericPrinter && usesTextCharacterOptions;

  BSFPrintLabelLayoutFieldEntity copyWith({
    int? code,
    int? quantityDecimalPlaces,
    double? coordinateX,
    double? coordinateY,
    BSFPrintElementAlignmentType? alignmentType,
    double? width,
    double? height,
    BSFPrintLabelFieldDimensionType? dimensionType,
    String? fontType,
    int? fontSize,
    bool? isBold,
    BSFPrintElementRotationType? rotateType,
    double? ratioBarCode,
    BSFBarcodeSimbologyType? barcodeSimbologyType,
    int? positionStartCharacter,
    int? maxCharacterSizeDisplacedQuantity,
    int? maxCharacterSize,
    bool? drawLabelBelowBarcode,
    bool? isReverseText,
    String? prefix,
    String? imageName,
    String? previewValue,
    List<int>? previewImage,
    BSFPrintLabelFieldDefinitionEntity? field,
    BSFPrintLabelFieldDefinitionEntity? fieldForDataBarcode,
    BSFPrintLabelFieldFormatEntity? format,
    bool? isVisible,
  }) {
    return BSFPrintLabelLayoutFieldEntity(
      code: code ?? this.code,
      quantityDecimalPlaces:
          quantityDecimalPlaces ?? this.quantityDecimalPlaces,
      coordinateX: coordinateX ?? this.coordinateX,
      coordinateY: coordinateY ?? this.coordinateY,
      alignmentType: alignmentType ?? this.alignmentType,
      width: width ?? this.width,
      height: height ?? this.height,
      dimensionType: dimensionType ?? this.dimensionType,
      fontType: fontType ?? this.fontType,
      fontSize: fontSize ?? this.fontSize,
      isBold: isBold ?? this.isBold,
      rotateType: rotateType ?? this.rotateType,
      ratioBarCode: ratioBarCode ?? this.ratioBarCode,
      barcodeSimbologyType: barcodeSimbologyType ?? this.barcodeSimbologyType,
      positionStartCharacter:
          positionStartCharacter ?? this.positionStartCharacter,
      maxCharacterSizeDisplacedQuantity:
          maxCharacterSizeDisplacedQuantity ??
          this.maxCharacterSizeDisplacedQuantity,
      maxCharacterSize: maxCharacterSize ?? this.maxCharacterSize,
      drawLabelBelowBarcode:
          drawLabelBelowBarcode ?? this.drawLabelBelowBarcode,
      isReverseText: isReverseText ?? this.isReverseText,
      prefix: prefix ?? this.prefix,
      imageName: imageName ?? this.imageName,
      previewValue: previewValue ?? this.previewValue,
      previewImage: previewImage ?? this.previewImage,
      field: field ?? this.field,
      fieldForDataBarcode: fieldForDataBarcode ?? this.fieldForDataBarcode,
      format: format ?? this.format,
      isVisible: isVisible ?? this.isVisible,
    );
  }

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
    previewValue,
    previewImage,
    field,
    fieldForDataBarcode,
    format,
    isVisible,
  ];
}
