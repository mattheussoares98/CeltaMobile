import 'package:equatable/equatable.dart';

import '../../../../../core/domain/entities/entities.dart';

class BSFCountryModel extends Equatable {
  final String? name;
  final bool? isExteriorCountry;
  final String? spedCode;

  const BSFCountryModel({
    required this.name,
    required this.isExteriorCountry,
    required this.spedCode,
  });

  @override
  List<Object?> get props => [name, isExteriorCountry, spedCode];

  factory BSFCountryModel.fromJson(Map<String, dynamic> json) =>
      BSFCountryModel(
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
