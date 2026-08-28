import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class BSFPrintLabelPrinterModel extends BSFPrintLabelPrinterEntity {
  const BSFPrintLabelPrinterModel({
    required super.code,
    required super.description,
    required super.modelType,
    required super.isGeneric,
    required super.coordinateUnit,
    required super.supportedFontTypes,
    required super.supportedFontSizes,
    required super.supportedPrintSpeeds,
    required super.supportedTemperatures,
    required super.supportedDirections,
  });

  factory BSFPrintLabelPrinterModel.fromJson(Map json) {
    return BSFPrintLabelPrinterModel(
      code: (json['code'] as num).toInt(),
      description: json['description'] as String,
      modelType: BSFLabelPrinterModelType.fromJson(json['modelType']),
      isGeneric: json['isGeneric'] as bool,
      coordinateUnit: BSFPrintLabelCoordinateUnit.fromJson(
        json['coordinateUnit'],
      ),
      supportedFontTypes: List<String>.from(json['supportedFontTypes'] as List),
      supportedFontSizes: (json['supportedFontSizes'] as List)
          .map((value) => (value as num).toInt())
          .toList(),
      supportedPrintSpeeds: List<String>.from(
        json['supportedPrintSpeeds'] as List,
      ),
      supportedTemperatures: List<String>.from(
        json['supportedTemperatures'] as List,
      ),
      supportedDirections: (json['supportedDirections'] as List)
          .map(BSFPrintLabelDirectionType.fromJson)
          .toList(),
    );
  }

  factory BSFPrintLabelPrinterModel.fromEntity(
    BSFPrintLabelPrinterEntity entity,
  ) {
    return BSFPrintLabelPrinterModel(
      code: entity.code,
      description: entity.description,
      modelType: entity.modelType,
      isGeneric: entity.isGeneric,
      coordinateUnit: entity.coordinateUnit,
      supportedFontTypes: entity.supportedFontTypes,
      supportedFontSizes: entity.supportedFontSizes,
      supportedPrintSpeeds: entity.supportedPrintSpeeds,
      supportedTemperatures: entity.supportedTemperatures,
      supportedDirections: entity.supportedDirections,
    );
  }

  Map toJson() => {
    'code': code,
    'description': description,
    'modelType': modelType.toJson(),
    'isGeneric': isGeneric,
    'coordinateUnit': coordinateUnit.toJson(),
    'supportedFontTypes': supportedFontTypes,
    'supportedFontSizes': supportedFontSizes,
    'supportedPrintSpeeds': supportedPrintSpeeds,
    'supportedTemperatures': supportedTemperatures,
    'supportedDirections': supportedDirections
        .map((direction) => direction.toJson())
        .toList(),
  };

  BSFPrintLabelPrinterEntity toEntity() {
    return BSFPrintLabelPrinterEntity(
      code: code,
      description: description,
      modelType: modelType,
      isGeneric: isGeneric,
      coordinateUnit: coordinateUnit,
      supportedFontTypes: supportedFontTypes,
      supportedFontSizes: supportedFontSizes,
      supportedPrintSpeeds: supportedPrintSpeeds,
      supportedTemperatures: supportedTemperatures,
      supportedDirections: supportedDirections,
    );
  }
}
