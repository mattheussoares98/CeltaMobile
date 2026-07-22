import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';

class EcBuyRequestProductDtoModel extends EcBuyRequestProductDtoEntity {
  const EcBuyRequestProductDtoModel({
    required super.enterprisePersonalizedCode,
    required super.enterpriseName,
    required super.name,
    required super.packingQuantity,
    required super.priceLookupCode,
    required super.eans,
    required super.quantity,
    required super.value,
    required super.total,
  });

  factory EcBuyRequestProductDtoModel.fromJson(Map json) {
    return EcBuyRequestProductDtoModel(
      enterprisePersonalizedCode: json['enterprisePersonalizedCode'] as String?,
      enterpriseName: json['enterpriseName'] as String?,
      name: json['name'] as String?,
      packingQuantity: (json['packingQuantity'] as num?)?.toDouble(),
      priceLookupCode: json['priceLookupCode'] as String?,
      eans: (json['eans'] as List?)?.map((ean) => ean as String).toList(),
      quantity: (json['quantity'] as num?)?.toDouble(),
      value: (json['value'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
    );
  }

  Map toJson() {
    return {
      'enterprisePersonalizedCode': enterprisePersonalizedCode,
      'enterpriseName': enterpriseName,
      'name': name,
      'packingQuantity': packingQuantity,
      'priceLookupCode': priceLookupCode,
      'eans': eans,
      'quantity': quantity,
      'value': value,
      'total': total,
    };
  }

  factory EcBuyRequestProductDtoModel.fromEntity(
    EcBuyRequestProductDtoEntity entity,
  ) {
    return EcBuyRequestProductDtoModel(
      enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
      enterpriseName: entity.enterpriseName,
      name: entity.name,
      packingQuantity: entity.packingQuantity,
      priceLookupCode: entity.priceLookupCode,
      eans: entity.eans,
      quantity: entity.quantity,
      value: entity.value,
      total: entity.total,
    );
  }

  EcBuyRequestProductDtoEntity toEntity() {
    return EcBuyRequestProductDtoEntity(
      enterprisePersonalizedCode: enterprisePersonalizedCode,
      enterpriseName: enterpriseName,
      name: name,
      packingQuantity: packingQuantity,
      priceLookupCode: priceLookupCode,
      eans: eans,
      quantity: quantity,
      value: value,
      total: total,
    );
  }
}
