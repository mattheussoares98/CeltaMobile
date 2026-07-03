// lib/core/data/models/address/bsf/bsf_city_model.dart
import 'package:celta_inventario/core/domain/entities/entities.dart';

class BSFCityModel extends BSFCityEntity {
  const BSFCityModel({
    required super.code,
    required super.description,
    required super.ibgeCode,
    required super.isValid,
  });

  factory BSFCityModel.fromJson(Map json) => BSFCityModel(
        code: json['Code'],
        description: json['Description'],
        ibgeCode: json['IBGECode']?.toString(),
        isValid: json['IsValid'],
      );

  Map<String, dynamic> toJson() => {
        'Code': code,
        'Description': description,
        'IBGECode': ibgeCode,
        'IsValid': isValid,
      };

  factory BSFCityModel.fromEntity(BSFCityEntity entity) => BSFCityModel(
        code: entity.code,
        description: entity.description,
        ibgeCode: entity.ibgeCode,
        isValid: entity.isValid,
      );

  BSFCityEntity toEntity() => BSFCityEntity(
        code: code,
        description: description,
        ibgeCode: ibgeCode,
        isValid: isValid,
      );
}
