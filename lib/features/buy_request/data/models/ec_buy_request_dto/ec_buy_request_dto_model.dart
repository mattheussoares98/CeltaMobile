import 'package:celta_inventario/features/buy_request/data/models/ec_buy_request_dto/ec_buy_request_dto.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';

class EcBuyRequestDtoModel extends EcBuyRequestDtoEntity {
  const EcBuyRequestDtoModel({
    required super.personalizedCode,
    required super.buyer,
    required super.requestType,
    required super.supplier,
    required super.enterprises,
    required super.totalLiquid,
  });

  factory EcBuyRequestDtoModel.fromJson(Map json) {
    return EcBuyRequestDtoModel(
      personalizedCode: json['personalizedCode'],
      buyer: json['buyer'] != null
          ? EcBuyRequestBuyerDtoModel.fromJson(json['buyer'] as Map)
          : null,
      requestType: json['requestType'] != null
          ? EcBuyRequestTypeDtoModel.fromJson(json['requestType'] as Map)
          : null,
      supplier: json['supplier'] != null
          ? EcBuyRequestSupplierDtoModel.fromJson(json['supplier'] as Map)
          : null,
      enterprises: json['enterprises'] != null
          ? (json['enterprises'] as List)
                .map(
                  (e) => EcBuyRequestEnterpriseItemDtoModel.fromJson(e as Map),
                )
                .toList()
          : null,
      totalLiquid: (json['totalLiquid'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personalizedCode': personalizedCode,
      'buyer': buyer == null
          ? null
          : EcBuyRequestBuyerDtoModel.fromEntity(buyer!).toJson(),
      'requestType': requestType == null
          ? null
          : EcBuyRequestTypeDtoModel.fromEntity(requestType!).toJson(),
      'supplier': supplier == null
          ? null
          : EcBuyRequestSupplierDtoModel.fromEntity(supplier!).toJson(),
      'enterprises': enterprises
          ?.map(
            (e) => EcBuyRequestEnterpriseItemDtoModel.fromEntity(e).toJson(),
          )
          .toList(),
      'totalLiquid': totalLiquid,
    };
  }

  factory EcBuyRequestDtoModel.fromEntity(EcBuyRequestDtoEntity entity) {
    return EcBuyRequestDtoModel(
      personalizedCode: entity.personalizedCode,
      buyer: entity.buyer != null
          ? EcBuyRequestBuyerDtoModel.fromEntity(entity.buyer!)
          : null,
      requestType: entity.requestType != null
          ? EcBuyRequestTypeDtoModel.fromEntity(entity.requestType!)
          : null,
      supplier: entity.supplier != null
          ? EcBuyRequestSupplierDtoModel.fromEntity(entity.supplier!)
          : null,
      enterprises: entity.enterprises
          ?.map((e) => EcBuyRequestEnterpriseItemDtoModel.fromEntity(e))
          .toList(),
      totalLiquid: entity.totalLiquid,
    );
  }

  EcBuyRequestDtoEntity toEntity() {
    return EcBuyRequestDtoEntity(
      personalizedCode: personalizedCode,
      buyer: buyer == null
          ? null
          : EcBuyRequestBuyerDtoModel.fromEntity(buyer!).toEntity(),
      requestType: requestType == null
          ? null
          : EcBuyRequestTypeDtoModel.fromEntity(requestType!).toEntity(),
      supplier: supplier == null
          ? null
          : EcBuyRequestSupplierDtoModel.fromEntity(supplier!).toEntity(),
      enterprises: enterprises
          ?.map((e) => EcBuyRequestEnterpriseItemDtoModel.fromEntity(e))
          .toList(),
      totalLiquid: totalLiquid,
    );
  }
}
