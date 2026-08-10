import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcSendDataSynchronizerErrorDetailModel
    extends EcSendDataSynchronizerErrorDetailEntity {
  const EcSendDataSynchronizerErrorDetailModel({
    required super.enterprisePersonalizedCode,
    required super.commerceSite,
    required super.description,
    required super.siteCode,
    required super.sendDate,
    required super.error,
    required super.sendDataType,
    required super.internalCode,
    required super.enterpriseCommerceSiteCode,
    required super.enterpriseCode,
    required super.isSent,
    required super.isToResend,
  });

  factory EcSendDataSynchronizerErrorDetailModel.fromJson(Map json) =>
      EcSendDataSynchronizerErrorDetailModel(
        enterprisePersonalizedCode:
            json['EnterprisePersonalizedCode'] as String,
        commerceSite: json['CommerceSite'] as String,
        description: json['Description'] as String,
        siteCode: json['SiteCode'] as String,
        sendDate: json['SendDate'] == null
            ? null
            : DateTime.parse(json['SendDate'] as String),
        error: json['Error'] as String,
        sendDataType: EcSendDataType.fromValue(json['SendDataType'] as int),
        internalCode: json['InternalCode'] as int,
        enterpriseCommerceSiteCode: json['EnterpriseCommerceSiteCode'] as int,
        enterpriseCode: json['EnterpriseCode'] as int,
        isSent: json['IsSent'] as bool,
        isToResend: json['IsToResend'] as bool,
      );

  Map toJson() => {
    'EnterprisePersonalizedCode': enterprisePersonalizedCode,
    'CommerceSite': commerceSite,
    'Description': description,
    'SiteCode': siteCode,
    'SendDate': sendDate?.toIso8601String(),
    'Error': error,
    'SendDataType': sendDataType.value,
    'InternalCode': internalCode,
    'EnterpriseCommerceSiteCode': enterpriseCommerceSiteCode,
    'EnterpriseCode': enterpriseCode,
    'IsSent': isSent,
    'IsToResend': isToResend,
  };

  factory EcSendDataSynchronizerErrorDetailModel.fromEntity(
    EcSendDataSynchronizerErrorDetailEntity entity,
  ) => EcSendDataSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    commerceSite: entity.commerceSite,
    description: entity.description,
    siteCode: entity.siteCode,
    sendDate: entity.sendDate,
    error: entity.error,
    sendDataType: entity.sendDataType,
    internalCode: entity.internalCode,
    enterpriseCommerceSiteCode: entity.enterpriseCommerceSiteCode,
    enterpriseCode: entity.enterpriseCode,
    isSent: entity.isSent,
    isToResend: entity.isToResend,
  );

  EcSendDataSynchronizerErrorDetailEntity toEntity() =>
      EcSendDataSynchronizerErrorDetailEntity(
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        commerceSite: commerceSite,
        description: description,
        siteCode: siteCode,
        sendDate: sendDate,
        error: error,
        sendDataType: sendDataType,
        internalCode: internalCode,
        enterpriseCommerceSiteCode: enterpriseCommerceSiteCode,
        enterpriseCode: enterpriseCode,
        isSent: isSent,
        isToResend: isToResend,
      );
}
