import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class CovenantInfoModel extends Equatable {
  final int Code;
  final String PersonalizedCode;
  final String Name;

  const CovenantInfoModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
  });

  @override
  List<Object?> get props => [Code, PersonalizedCode, Name];

  factory CovenantInfoModel.fromJson(Map json) => CovenantInfoModel(
    Code: json['Code'] as int,
    PersonalizedCode: json['PersonalizedCode'] as String,
    Name: json['Name'] as String,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Code': Code,
    'PersonalizedCode': PersonalizedCode,
    'Name': Name,
  };

  factory CovenantInfoModel.fromEntity(CovenantInfoEntity entity) =>
      CovenantInfoModel(
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
