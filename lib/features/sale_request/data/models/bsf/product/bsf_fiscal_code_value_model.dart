import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

class BSFFiscalCodeValueModel extends BSFFiscalCodeValueEntity {
  const BSFFiscalCodeValueModel({
    required super.code,
    required super.isOldFormat,
    required super.isValid,
  });

  factory BSFFiscalCodeValueModel.fromJson(Map json) => BSFFiscalCodeValueModel(
    code: json['Code']?.toString(),
    isOldFormat: json['IsOldFormat'],
    isValid: json['IsValid'],
  );

  Map<String, dynamic> toJson() => {
    'Code': code,
    'IsOldFormat': isOldFormat,
    'IsValid': isValid,
  };

  factory BSFFiscalCodeValueModel.fromEntity(BSFFiscalCodeValueEntity entity) =>
      BSFFiscalCodeValueModel(
        code: entity.code,
        isOldFormat: entity.isOldFormat,
        isValid: entity.isValid,
      );

  BSFFiscalCodeValueEntity toEntity() => BSFFiscalCodeValueEntity(
    code: code,
    isOldFormat: isOldFormat,
    isValid: isValid,
  );
}
