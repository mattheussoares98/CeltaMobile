import 'package:celta_inventario/core/domain/entities/entities.dart';

class BSFCountryModel extends BSFCountryEntity {
  const BSFCountryModel({
    super.code,
    required super.name,
    required super.isExteriorCountry,
    required super.spedCode,
  });

  factory BSFCountryModel.fromJson(Map json) => BSFCountryModel(
    code: json['Code'],
    name: json['Name'],
    isExteriorCountry: json['IsExteriorCountry'],
    spedCode: json['SpedCode']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    'Code': code,
    'Name': name,
    'IsExteriorCountry': isExteriorCountry,
    'SpedCode': spedCode,
  };

  factory BSFCountryModel.fromEntity(BSFCountryEntity entity) =>
      BSFCountryModel(
        code: entity.code,
        name: entity.name,
        isExteriorCountry: entity.isExteriorCountry,
        spedCode: entity.spedCode,
      );

  BSFCountryEntity toEntity() => BSFCountryEntity(
    code: code,
    name: name,
    isExteriorCountry: isExteriorCountry,
    spedCode: spedCode,
  );
}
