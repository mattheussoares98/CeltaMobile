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
            json['enterprisePersonalizedCode'] as String,
        creationDate: DateTime.parse(json['creationDate'] as String),
        finalizationDate: DateTime.parse(json['finalizationDate'] as String),
        ecfPersonalizedCode: json['ecfPersonalizedCode'] as String,
        ecfSerialNumber: json['ecfSerialNumber'] as String,
        userAllowedRead: json['userAllowedRead'] as String,
        description: json['description'] as String,
      );

  Map toJson() => {
    'enterprisePersonalizedCode': enterprisePersonalizedCode,
    'creationDate': creationDate.toIso8601String(),
    'finalizationDate': finalizationDate.toIso8601String(),
    'ecfPersonalizedCode': ecfPersonalizedCode,
    'ecfSerialNumber': ecfSerialNumber,
    'userAllowedRead': userAllowedRead,
    'description': description,
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
