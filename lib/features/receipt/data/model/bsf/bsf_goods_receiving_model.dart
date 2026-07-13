import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';

class BSFGoodsReceivingModel extends BSFGoodsReceivingEntity {
  const BSFGoodsReceivingModel({
    super.expeditionControlCode,
    super.isOnExpedition,
    super.shouldHaveExpeditionControl,
  });
  //TODO implement the entire model and entity
  factory BSFGoodsReceivingModel.fromJson(Map json) => BSFGoodsReceivingModel(
    expeditionControlCode: json['ExpeditionControlCode'],
    isOnExpedition: json['IsOnExpedition'],
    shouldHaveExpeditionControl: json['ShouldHaveExpeditionControl'],
  );

  Map toJson() => {
    'ExpeditionControlCode': expeditionControlCode,
    'IsOnExpedition': isOnExpedition,
    'ShouldHaveExpeditionControl': shouldHaveExpeditionControl,
  };

  factory BSFGoodsReceivingModel.fromEntity(BSFGoodsReceivingEntity entity) =>
      BSFGoodsReceivingModel(
        expeditionControlCode: entity.expeditionControlCode,
        isOnExpedition: entity.isOnExpedition,
        shouldHaveExpeditionControl: entity.shouldHaveExpeditionControl,
      );

  BSFGoodsReceivingEntity toEntity() => BSFGoodsReceivingEntity(
    expeditionControlCode: expeditionControlCode,
    isOnExpedition: isOnExpedition,
    shouldHaveExpeditionControl: shouldHaveExpeditionControl,
  );
}
