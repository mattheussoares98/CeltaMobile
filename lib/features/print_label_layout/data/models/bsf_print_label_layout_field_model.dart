import 'dart:convert';

import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class BSFPrintLabelLayoutFieldModel extends BSFPrintLabelLayoutFieldEntity {
  const BSFPrintLabelLayoutFieldModel({
    required super.code,
    required super.quantityDecimalPlaces,
    required super.coordinateX,
    required super.coordinateY,
    required super.alignmentType,
    required super.width,
    required super.height,
    required super.dimensionType,
    required super.fontType,
    required super.fontSize,
    required super.isBold,
    required super.rotateType,
    required super.ratioBarCode,
    required super.barcodeSimbologyType,
    required super.positionStartCharacter,
    required super.maxCharacterSizeDisplacedQuantity,
    required super.maxCharacterSize,
    required super.drawLabelBelowBarcode,
    required super.isReverseText,
    required super.prefix,
    required super.imageName,
    required super.previewValue,
    required super.previewImage,
    required super.field,
    required super.fieldForDataBarcode,
    required super.format,
  });

  factory BSFPrintLabelLayoutFieldModel.fromJson(Map json) {
    final fieldJson = json['field'] as Map?;
    final dataBarcodeFieldJson = json['fieldForDataBarcode'] as Map?;
    final formatJson = json['format'] as Map?;

    return BSFPrintLabelLayoutFieldModel(
      code: (json['code'] as num).toInt(),
      quantityDecimalPlaces: (json['quantityDecimalPlaces'] as num).toInt(),
      coordinateX: (json['coordinateX'] as num).toDouble(),
      coordinateY: (json['coordinateY'] as num).toDouble(),
      alignmentType: BSFPrintElementAlignmentType.fromJson(
        json['alignmentType'],
      ),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      dimensionType: BSFPrintLabelFieldDimensionType.fromJson(
        json['dimensionType'],
      ),
      fontType: json['fontType'] as String,
      fontSize: (json['fontSize'] as num).toInt(),
      isBold: json['isBold'] as bool,
      rotateType: BSFPrintElementRotationType.fromJson(json['rotateType']),
      ratioBarCode: (json['ratioBarCode'] as num).toDouble(),
      barcodeSimbologyType: BSFBarcodeSimbologyType.fromJson(
        json['barcodeSimbologyType'],
      ),
      positionStartCharacter: (json['positionStartCharacter'] as num).toInt(),
      maxCharacterSizeDisplacedQuantity:
          (json['maxCharacterSizeDisplacedQuantity'] as num).toInt(),
      maxCharacterSize: (json['maxCharacterSize'] as num).toInt(),
      drawLabelBelowBarcode: json['drawLabelBelowBarcode'] as bool,
      isReverseText: json['isReverseText'] as bool,
      prefix: json['prefix'] as String,
      imageName: json['imageName'] as String,
      previewValue: json['previewValue'] as String?,
      previewImage: json['previewImage'] == null
          ? null
          : base64Decode(json['previewImage'] as String),
      field: fieldJson == null
          ? null
          : BSFPrintLabelFieldDefinitionModel.fromJson(fieldJson),
      fieldForDataBarcode: dataBarcodeFieldJson == null
          ? null
          : BSFPrintLabelFieldDefinitionModel.fromJson(dataBarcodeFieldJson),
      format: formatJson == null
          ? null
          : BSFPrintLabelFieldFormatModel.fromJson(formatJson),
    );
  }

  factory BSFPrintLabelLayoutFieldModel.fromEntity(
    BSFPrintLabelLayoutFieldEntity entity,
  ) {
    return BSFPrintLabelLayoutFieldModel(
      code: entity.code,
      quantityDecimalPlaces: entity.quantityDecimalPlaces,
      coordinateX: entity.coordinateX,
      coordinateY: entity.coordinateY,
      alignmentType: entity.alignmentType,
      width: entity.width,
      height: entity.height,
      dimensionType: entity.dimensionType,
      fontType: entity.fontType,
      fontSize: entity.fontSize,
      isBold: entity.isBold,
      rotateType: entity.rotateType,
      ratioBarCode: entity.ratioBarCode,
      barcodeSimbologyType: entity.barcodeSimbologyType,
      positionStartCharacter: entity.positionStartCharacter,
      maxCharacterSizeDisplacedQuantity:
          entity.maxCharacterSizeDisplacedQuantity,
      maxCharacterSize: entity.maxCharacterSize,
      drawLabelBelowBarcode: entity.drawLabelBelowBarcode,
      isReverseText: entity.isReverseText,
      prefix: entity.prefix,
      imageName: entity.imageName,
      previewValue: entity.previewValue,
      previewImage: entity.previewImage,
      field: entity.field == null
          ? null
          : BSFPrintLabelFieldDefinitionModel.fromEntity(entity.field!),
      fieldForDataBarcode: entity.fieldForDataBarcode == null
          ? null
          : BSFPrintLabelFieldDefinitionModel.fromEntity(
              entity.fieldForDataBarcode!,
            ),
      format: entity.format == null
          ? null
          : BSFPrintLabelFieldFormatModel.fromEntity(entity.format!),
    );
  }

  Map toJson() => {
    'code': code,
    'quantityDecimalPlaces': quantityDecimalPlaces,
    'coordinateX': coordinateX,
    'coordinateY': coordinateY,
    'alignmentType': alignmentType.toJson(),
    'width': width,
    'height': height,
    'dimensionType': dimensionType.toJson(),
    'fontType': fontType,
    'fontSize': fontSize,
    'isBold': isBold,
    'rotateType': rotateType.toJson(),
    'ratioBarCode': ratioBarCode,
    'barcodeSimbologyType': barcodeSimbologyType.toJson(),
    'positionStartCharacter': positionStartCharacter,
    'maxCharacterSizeDisplacedQuantity': maxCharacterSizeDisplacedQuantity,
    'maxCharacterSize': maxCharacterSize,
    'drawLabelBelowBarcode': drawLabelBelowBarcode,
    'isReverseText': isReverseText,
    'prefix': prefix,
    'imageName': imageName,
    'previewValue': previewValue,
    'previewImage': previewImage == null ? null : base64Encode(previewImage!),
    'field': field == null
        ? null
        : BSFPrintLabelFieldDefinitionModel.fromEntity(field!).toJson(),
    'fieldForDataBarcode': fieldForDataBarcode == null
        ? null
        : BSFPrintLabelFieldDefinitionModel.fromEntity(
            fieldForDataBarcode!,
          ).toJson(),
    'format': format == null
        ? null
        : BSFPrintLabelFieldFormatModel.fromEntity(format!).toJson(),
  };

  BSFPrintLabelLayoutFieldEntity toEntity() {
    return BSFPrintLabelLayoutFieldEntity(
      code: code,
      quantityDecimalPlaces: quantityDecimalPlaces,
      coordinateX: coordinateX,
      coordinateY: coordinateY,
      alignmentType: alignmentType,
      width: width,
      height: height,
      dimensionType: dimensionType,
      fontType: fontType,
      fontSize: fontSize,
      isBold: isBold,
      rotateType: rotateType,
      ratioBarCode: ratioBarCode,
      barcodeSimbologyType: barcodeSimbologyType,
      positionStartCharacter: positionStartCharacter,
      maxCharacterSizeDisplacedQuantity: maxCharacterSizeDisplacedQuantity,
      maxCharacterSize: maxCharacterSize,
      drawLabelBelowBarcode: drawLabelBelowBarcode,
      isReverseText: isReverseText,
      prefix: prefix,
      imageName: imageName,
      previewValue: previewValue,
      previewImage: previewImage,
      field: field == null
          ? null
          : BSFPrintLabelFieldDefinitionModel.fromEntity(field!).toEntity(),
      fieldForDataBarcode: fieldForDataBarcode == null
          ? null
          : BSFPrintLabelFieldDefinitionModel.fromEntity(
              fieldForDataBarcode!,
            ).toEntity(),
      format: format == null
          ? null
          : BSFPrintLabelFieldFormatModel.fromEntity(format!).toEntity(),
    );
  }
}
