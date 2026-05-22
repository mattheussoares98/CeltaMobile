import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

class SoapCovenantInfoModel extends Equatable {
  final int Code;
  final String PersonalizedCode;
  final String Name;

  const SoapCovenantInfoModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
  });

  @override
  List<Object?> get props => [Code, PersonalizedCode, Name];

  factory SoapCovenantInfoModel.fromJson(Map json) => SoapCovenantInfoModel(
    Code: json['Code'] as int,
    PersonalizedCode: json['PersonalizedCode'] as String,
    Name: json['Name'] as String,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Code': Code,
    'PersonalizedCode': PersonalizedCode,
    'Name': Name,
  };

  factory SoapCovenantInfoModel.fromEntity(CovenantInfoEntity entity) =>
      SoapCovenantInfoModel(
        Code: entity.Code,
        PersonalizedCode: entity.PersonalizedCode,
        Name: entity.Name,
      );

  CovenantInfoEntity toEntity() => CovenantInfoEntity(
    Code: Code,
    PersonalizedCode: PersonalizedCode,
    Name: Name,
  );
}
