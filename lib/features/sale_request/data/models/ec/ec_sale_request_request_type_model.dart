import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class EcSaleRequestRequestTypeModel extends Equatable {
  final int Id;
  final String PersonalizedCode;
  final String Name;

  const EcSaleRequestRequestTypeModel({
    required this.Id,
    required this.PersonalizedCode,
    required this.Name,
  });

  @override
  List<Object?> get props => [Id, PersonalizedCode, Name];

  factory EcSaleRequestRequestTypeModel.fromJson(Map json) {
    return EcSaleRequestRequestTypeModel(
      Id: json['Id'],
      PersonalizedCode: json['PersonalizedCode'],
      Name: json['Name'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Id': Id,
    'PersonalizedCode': PersonalizedCode,
    'Name': Name,
  };

  factory EcSaleRequestRequestTypeModel.fromEntity(
    SaleRequestRequestTypeEntity entity,
  ) {
    return EcSaleRequestRequestTypeModel(
      Id: entity.Id,
      PersonalizedCode: entity.PersonalizedCode,
      Name: entity.Name,
    );
  }

  SaleRequestRequestTypeEntity toEntity() => SaleRequestRequestTypeEntity(
    Id: Id,
    PersonalizedCode: PersonalizedCode,
    Name: Name,
  );
}
