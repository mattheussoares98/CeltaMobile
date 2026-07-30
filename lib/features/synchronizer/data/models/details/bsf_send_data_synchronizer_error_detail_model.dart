import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFSendDataSynchronizerErrorDetailModel
    extends BSFSendDataSynchronizerErrorDetailEntity {
  const BSFSendDataSynchronizerErrorDetailModel({
    required super.enterprisePersonalizedCode,
    required super.commerceSite,
    required super.description,
    required super.siteCode,
    required super.sendDate,
    required super.error,
  });

  factory BSFSendDataSynchronizerErrorDetailModel.fromJson(Map json) =>
      BSFSendDataSynchronizerErrorDetailModel(
        enterprisePersonalizedCode:
            json['EnterprisePersonalizedCode'] as String,
        commerceSite: json['CommerceSite'] as String,
        description: json['Description'] as String,
        siteCode: json['SiteCode'] as String,
        sendDate: json['SendDate'] == null
            ? null
            : DateTime.parse(json['SendDate'] as String),
        error: json['Error'] as String,
      );

  Map toJson() => {
    'EnterprisePersonalizedCode': enterprisePersonalizedCode,
    'CommerceSite': commerceSite,
    'Description': description,
    'SiteCode': siteCode,
    'SendDate': sendDate?.toIso8601String(),
    'Error': error,
  };

  factory BSFSendDataSynchronizerErrorDetailModel.fromEntity(
    BSFSendDataSynchronizerErrorDetailEntity entity,
  ) => BSFSendDataSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    commerceSite: entity.commerceSite,
    description: entity.description,
    siteCode: entity.siteCode,
    sendDate: entity.sendDate,
    error: entity.error,
  );

  BSFSendDataSynchronizerErrorDetailEntity toEntity() =>
      BSFSendDataSynchronizerErrorDetailEntity(
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        commerceSite: commerceSite,
        description: description,
        siteCode: siteCode,
        sendDate: sendDate,
        error: error,
      );
}
