// lib/features/process_authorization/data/models/bsf_defendant_model.dart
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/receipt/data/model/model.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/features/sale_request/data/models/bsf/bsf_sale_request_model.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

sealed class BSFDefendantModel extends BSFDefendantEntity {
  const BSFDefendantModel();

  static BSFDefendantModel? fromJson(Map json, TypeAccordingToTheCode? type) {
    switch (type) {
      case TypeAccordingToTheCode.saleRequestDiscount ||
          TypeAccordingToTheCode.saleRequestLucrativity:
        return BSFSaleRequestDefendantModel.fromJson(json);
      case TypeAccordingToTheCode.goodsReceivingLiberateDocument ||
          TypeAccordingToTheCode.goodsReceivingCancelDocument ||
          TypeAccordingToTheCode.goodsReceivingValidateDocumentXml:
        return BSFGoodsReceivingDefendantModel.fromJson(json);
      case TypeAccordingToTheCode.goodsReceivingValueDocument:
      case TypeAccordingToTheCode.goodsReceivingValidatePaymentCondition:
        return throw AppException('Process type not implemented');
      case null:
        return null;
    }
  }

  Map toJson();

  factory BSFDefendantModel.fromEntity(BSFDefendantEntity entity) {
    return switch (entity) {
      BSFSaleRequestDefendantEntity sale =>
        BSFSaleRequestDefendantModel.fromEntity(sale),
      BSFGoodsReceivingDefendantEntity expedition =>
        BSFGoodsReceivingDefendantModel.fromEntity(expedition),
      _ => throw UnimplementedError('Unknown defendant entity type: $entity'),
    };
  }

  BSFDefendantEntity toEntity();
}

class BSFSaleRequestDefendantModel extends BSFDefendantModel
    implements BSFSaleRequestDefendantEntity {
  @override
  final BSFSaleRequestEntity saleRequest;

  const BSFSaleRequestDefendantModel({required this.saleRequest});

  factory BSFSaleRequestDefendantModel.fromJson(Map json) {
    return BSFSaleRequestDefendantModel(
      saleRequest: BSFSaleRequestModel.fromJson(json).toEntity(),
    );
  }

  @override
  Map toJson() {
    return BSFSaleRequestModel.fromEntity(saleRequest).toJson();
  }

  factory BSFSaleRequestDefendantModel.fromEntity(
    BSFSaleRequestDefendantEntity entity,
  ) {
    return BSFSaleRequestDefendantModel(saleRequest: entity.saleRequest);
  }

  @override
  BSFSaleRequestDefendantEntity toEntity() =>
      BSFSaleRequestDefendantEntity(saleRequest: saleRequest);
}

class BSFGoodsReceivingDefendantModel extends BSFDefendantModel
    implements BSFGoodsReceivingDefendantEntity {
  @override
  final BSFGoodsReceivingEntity goodsReceiving;

  const BSFGoodsReceivingDefendantModel({required this.goodsReceiving});

  factory BSFGoodsReceivingDefendantModel.fromJson(Map json) {
    return BSFGoodsReceivingDefendantModel(
      goodsReceiving: BSFGoodsReceivingModel.fromJson(json).toEntity(),
    );
  }

  @override
  Map toJson() => BSFGoodsReceivingModel.fromEntity(goodsReceiving).toJson();

  factory BSFGoodsReceivingDefendantModel.fromEntity(
    BSFGoodsReceivingDefendantEntity entity,
  ) => BSFGoodsReceivingDefendantModel(goodsReceiving: entity.goodsReceiving);

  @override
  BSFGoodsReceivingDefendantEntity toEntity() =>
      BSFGoodsReceivingDefendantEntity(goodsReceiving: goodsReceiving);
}
