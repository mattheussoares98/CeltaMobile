import 'package:equatable/equatable.dart';

import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcCommerceSiteModel extends Equatable {
  final int code;
  final int enterpriseCode;
  final String environmentName;
  final int commerceSiteIdentification;
  final String description;

  const EcCommerceSiteModel({
    required this.code,
    required this.enterpriseCode,
    required this.environmentName,
    required this.commerceSiteIdentification,
    required this.description,
  });

  factory EcCommerceSiteModel.fromJson(Map json) => EcCommerceSiteModel(
    code: json['Code'],
    enterpriseCode: json['EnterpriseCode'],
    environmentName: json['EnvironmentName'],
    commerceSiteIdentification: json['CommerceSiteIdentification'],
    description: json['Description'],
  );

  factory EcCommerceSiteModel.fromEntity(EcCommerceSiteEntity entity) =>
      EcCommerceSiteModel(
        code: entity.code,
        enterpriseCode: entity.enterpriseCode,
        environmentName: entity.environmentName,
        commerceSiteIdentification: entity.commerceSiteIdentification,
        description: entity.description,
      );

  Map toJson() => {
    'Code': code,
    'EnterpriseCode': enterpriseCode,
    'EnvironmentName': environmentName,
    'CommerceSiteIdentification': commerceSiteIdentification,
    'Description': description,
  };

  EcCommerceSiteEntity toEntity() => EcCommerceSiteEntity(
    code: code,
    enterpriseCode: enterpriseCode,
    environmentName: environmentName,
    commerceSiteIdentification: commerceSiteIdentification,
    description: description,
  );

  @override
  List<Object?> get props => [
    code,
    enterpriseCode,
    environmentName,
    commerceSiteIdentification,
    description,
  ];
}
