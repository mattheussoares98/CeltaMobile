import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class CovenantModel extends Equatable {
  final int Code;
  final String PersonalizedCode;
  final String Name;

  const CovenantModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
  });

  @override
  List<Object?> get props => [Code, PersonalizedCode, Name];

  factory CovenantModel.fromJson(Map json) => CovenantModel(
    Code: json['Code'] as int,
    PersonalizedCode: json['PersonalizedCode'] as String,
    Name: json['Name'] as String,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Code': Code,
    'PersonalizedCode': PersonalizedCode,
    'Name': Name,
  };

  factory CovenantModel.fromEntity(CovenantEntity entity) => CovenantModel(
    Code: entity.Code,
    PersonalizedCode: entity.PersonalizedCode,
    Name: entity.Name,
  );

  CovenantEntity toEntity() => CovenantEntity(
    Code: Code,
    PersonalizedCode: PersonalizedCode,
    Name: Name,
  );
}
