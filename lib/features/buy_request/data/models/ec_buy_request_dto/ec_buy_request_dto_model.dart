import 'package:celta_inventario/features/buy_request/data/models/ec_buy_request_dto/ec_buy_request_dto.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';

class EcBuyRequestDtoModel extends EcBuyRequestDtoEntity {
  const EcBuyRequestDtoModel({
    required super.code,
    required super.personalizedCode,
    required super.observations,
    required super.buyer,
    required super.requestType,
    required super.supplier,
    required super.enterprises,
    required super.products,
    required super.totalLiquid,
    required super.deliveryDate,
    required super.dateOfCreation,
  });

  factory EcBuyRequestDtoModel.fromJson(Map json) {
    return EcBuyRequestDtoModel(
      code: json['code'],
      personalizedCode: json['personalizedCode'],
      observations: json['observations'],
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
      products: json['products'] != null
          ? (json['products'] as List)
                .map((e) => EcBuyRequestProductDtoModel.fromJson(e as Map))
                .toList()
          : null,
      totalLiquid: (json['totalLiquid'] as num?)?.toDouble(),
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'] as String)
          : null,
      dateOfCreation: json['dateOfCreation'] != null
          ? DateTime.parse(json['dateOfCreation'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'personalizedCode': personalizedCode,
      'observations': observations,
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
      'products': products
          ?.map((e) => EcBuyRequestProductDtoModel.fromEntity(e).toJson())
          .toList(),
      'totalLiquid': totalLiquid,
      'deliveryDate': deliveryDate?.toIso8601String(),
      'dateOfCreation': dateOfCreation?.toIso8601String(),
    };
  }

  factory EcBuyRequestDtoModel.fromEntity(EcBuyRequestDtoEntity entity) {
    return EcBuyRequestDtoModel(
      code: entity.code,
      personalizedCode: entity.personalizedCode,
      observations: entity.observations,
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
      products: entity.products
          ?.map((e) => EcBuyRequestProductDtoModel.fromEntity(e))
          .toList(),
      totalLiquid: entity.totalLiquid,
      deliveryDate: entity.deliveryDate,
      dateOfCreation: entity.dateOfCreation,
    );
  }

  EcBuyRequestDtoEntity toEntity() {
    return EcBuyRequestDtoEntity(
      code: code,
      personalizedCode: personalizedCode,
      observations: observations,
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
          ?.map(
            (e) => EcBuyRequestEnterpriseItemDtoModel.fromEntity(e).toEntity(),
          )
          .toList(),
      products: products
          ?.map((e) => EcBuyRequestProductDtoModel.fromEntity(e).toEntity())
          .toList(),
      totalLiquid: totalLiquid,
      deliveryDate: deliveryDate,
      dateOfCreation: dateOfCreation,
    );
  }
}
