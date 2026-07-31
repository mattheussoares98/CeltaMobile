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
            json['enterprisePersonalizedCode'] as String,
        commerceSite: json['commerceSite'] as String,
        description: json['description'] as String,
        siteCode: json['siteCode'] as String,
        sendDate: json['sendDate'] == null
            ? null
            : DateTime.parse(json['sendDate'] as String),
        error: json['error'] as String,
      );

  Map toJson() => {
    'enterprisePersonalizedCode': enterprisePersonalizedCode,
    'commerceSite': commerceSite,
    'description': description,
    'siteCode': siteCode,
    'sendDate': sendDate?.toIso8601String(),
    'error': error,
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
