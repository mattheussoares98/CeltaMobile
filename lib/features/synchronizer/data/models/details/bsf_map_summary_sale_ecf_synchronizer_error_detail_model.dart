import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFMapSummarySaleEcfSynchronizerErrorDetailModel
    extends BSFMapSummarySaleEcfSynchronizerErrorDetailEntity {
  const BSFMapSummarySaleEcfSynchronizerErrorDetailModel({
    required super.enterprisePersonalizedCode,
    required super.creationDate,
    required super.finalizationDate,
    required super.ecfPersonalizedCode,
    required super.ecfSerialNumber,
    required super.userAllowedRead,
    required super.description,
  });

  factory BSFMapSummarySaleEcfSynchronizerErrorDetailModel.fromJson(Map json) =>
      BSFMapSummarySaleEcfSynchronizerErrorDetailModel(
        enterprisePersonalizedCode:
            json['EnterprisePersonalizedCode'] as String,
        creationDate: DateTime.parse(json['CreationDate'] as String),
        finalizationDate: DateTime.parse(json['FinalizationDate'] as String),
        ecfPersonalizedCode: json['EcfPersonalizedCode'] as String,
        ecfSerialNumber: json['EcfSerialNumber'] as String,
        userAllowedRead: json['UserAllowedRead'] as String,
        description: json['Description'] as String,
      );

  Map toJson() => {
    'EnterprisePersonalizedCode': enterprisePersonalizedCode,
    'CreationDate': creationDate.toIso8601String(),
    'FinalizationDate': finalizationDate.toIso8601String(),
    'EcfPersonalizedCode': ecfPersonalizedCode,
    'EcfSerialNumber': ecfSerialNumber,
    'UserAllowedRead': userAllowedRead,
    'Description': description,
  };

  factory BSFMapSummarySaleEcfSynchronizerErrorDetailModel.fromEntity(
    BSFMapSummarySaleEcfSynchronizerErrorDetailEntity entity,
  ) => BSFMapSummarySaleEcfSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    creationDate: entity.creationDate,
    finalizationDate: entity.finalizationDate,
    ecfPersonalizedCode: entity.ecfPersonalizedCode,
    ecfSerialNumber: entity.ecfSerialNumber,
    userAllowedRead: entity.userAllowedRead,
    description: entity.description,
  );

  BSFMapSummarySaleEcfSynchronizerErrorDetailEntity toEntity() =>
      BSFMapSummarySaleEcfSynchronizerErrorDetailEntity(
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        creationDate: creationDate,
        finalizationDate: finalizationDate,
        ecfPersonalizedCode: ecfPersonalizedCode,
        ecfSerialNumber: ecfSerialNumber,
        userAllowedRead: userAllowedRead,
        description: description,
      );
}
