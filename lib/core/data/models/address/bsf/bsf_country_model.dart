import 'package:celta_inventario/core/domain/entities/entities.dart';

class BSFCountryModel extends BSFCountryEntity {
  const BSFCountryModel({
    required super.name,
    required super.isExteriorCountry,
    required super.spedCode,
  });

  factory BSFCountryModel.fromJson(Map json) => BSFCountryModel(
    name: json['Name'],
    isExteriorCountry: json['IsExteriorCountry'],
    spedCode: json['SpedCode'],
  );

  Map<String, dynamic> toJson() => {
    'Name': name,
    'IsExteriorCountry': isExteriorCountry,
    'SpedCode': spedCode,
  };

  factory BSFCountryModel.fromEntity(BSFCountryEntity entity) =>
      BSFCountryModel(
        name: entity.name,
        isExteriorCountry: entity.isExteriorCountry,
        spedCode: entity.spedCode,
      );

  BSFCountryEntity toEntity() => BSFCountryEntity(
    name: name,
    isExteriorCountry: isExteriorCountry,
    spedCode: spedCode,
  );
}
