// lib/features/process_authorization/data/models/bsf_defendant_model.dart
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/data/models/bsf/bsf_sale_request_model.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

sealed class BSFDefendantModel extends BSFDefendantEntity {
  const BSFDefendantModel();

  static BSFDefendantModel? fromJson(Map json, TypeAccordingToTheCode? type) {
    switch (type) {
      case TypeAccordingToTheCode.saleRequestDiscount ||
          TypeAccordingToTheCode.saleRequestLucrativity:
        return BSFSaleRequestDefendantModel.fromJson(json);
      case TypeAccordingToTheCode.receiptLiberateDocument:
        return BSFExpeditionDefendantModel.fromJson(json);
      default:
        return null;
    }
  }

  Map toJson();

  factory BSFDefendantModel.fromEntity(BSFDefendantEntity entity) {
    return switch (entity) {
      BSFSaleRequestDefendantEntity sale =>
        BSFSaleRequestDefendantModel.fromEntity(sale),
      BSFExpeditionDefendantEntity expedition =>
        BSFExpeditionDefendantModel.fromEntity(expedition),
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

class BSFExpeditionDefendantModel extends BSFDefendantModel
    implements BSFExpeditionDefendantEntity {
  @override
  final int? expeditionControlCode;
  @override
  final bool? isOnExpedition;
  @override
  final bool? shouldHaveExpeditionControl;

  const BSFExpeditionDefendantModel({
    this.expeditionControlCode,
    this.isOnExpedition,
    this.shouldHaveExpeditionControl,
  });

  factory BSFExpeditionDefendantModel.fromJson(Map json) {
    return BSFExpeditionDefendantModel(
      expeditionControlCode: json['ExpeditionControlCode'],
      isOnExpedition: json['IsOnExpedition'],
      shouldHaveExpeditionControl: json['ShouldHaveExpeditionControl'],
    );
  }

  @override
  Map toJson() => {
    'ExpeditionControlCode': expeditionControlCode,
    'IsOnExpedition': isOnExpedition,
    'ShouldHaveExpeditionControl': shouldHaveExpeditionControl,
  };

  factory BSFExpeditionDefendantModel.fromEntity(
    BSFExpeditionDefendantEntity entity,
  ) {
    return BSFExpeditionDefendantModel(
      expeditionControlCode: entity.expeditionControlCode,
      isOnExpedition: entity.isOnExpedition,
      shouldHaveExpeditionControl: entity.shouldHaveExpeditionControl,
    );
  }

  @override
  BSFExpeditionDefendantEntity toEntity() => BSFExpeditionDefendantEntity(
    expeditionControlCode: expeditionControlCode,
    isOnExpedition: isOnExpedition,
    shouldHaveExpeditionControl: shouldHaveExpeditionControl,
  );
}
