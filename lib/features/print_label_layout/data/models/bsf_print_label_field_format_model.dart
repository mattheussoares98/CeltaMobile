import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class BSFPrintLabelFieldFormatModel extends BSFPrintLabelFieldFormatEntity {
  const BSFPrintLabelFieldFormatModel({
    required super.code,
    required super.stringType,
    required super.integerType,
    required super.floatType,
    required super.dateTimeType,
    required super.qrCodeType,
    required super.name,
    required super.description,
  });

  factory BSFPrintLabelFieldFormatModel.fromJson(Map json) {
    return BSFPrintLabelFieldFormatModel(
      code: (json['code'] as num).toInt(),
      stringType: json['stringType'] as bool,
      integerType: json['integerType'] as bool,
      floatType: json['floatType'] as bool,
      dateTimeType: json['dateTimeType'] as bool,
      qrCodeType: json['qrCodeType'] as bool,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }

  factory BSFPrintLabelFieldFormatModel.fromEntity(
    BSFPrintLabelFieldFormatEntity entity,
  ) {
    return BSFPrintLabelFieldFormatModel(
      code: entity.code,
      stringType: entity.stringType,
      integerType: entity.integerType,
      floatType: entity.floatType,
      dateTimeType: entity.dateTimeType,
      qrCodeType: entity.qrCodeType,
      name: entity.name,
      description: entity.description,
    );
  }

  Map toJson() => {
    'code': code,
    'stringType': stringType,
    'integerType': integerType,
    'floatType': floatType,
    'dateTimeType': dateTimeType,
    'qrCodeType': qrCodeType,
    'name': name,
    'description': description,
  };

  BSFPrintLabelFieldFormatEntity toEntity() {
    return BSFPrintLabelFieldFormatEntity(
      code: code,
      stringType: stringType,
      integerType: integerType,
      floatType: floatType,
      dateTimeType: dateTimeType,
      qrCodeType: qrCodeType,
      name: name,
      description: description,
    );
  }
}
