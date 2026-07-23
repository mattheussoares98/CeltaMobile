import 'package:celta_inventario/features/buy_movement/domain/entities/entities.dart';

class EcBuyMovementProductDtoModel extends EcBuyMovementProductDtoEntity {
  const EcBuyMovementProductDtoModel({
    required super.name,
    required super.priceLookupCode,
    required super.fiscalCode,
    required super.packingQuantity,
    required super.packingName,
    required super.quantity,
    required super.totalLiquid,
  });

  factory EcBuyMovementProductDtoModel.fromJson(Map json) =>
      EcBuyMovementProductDtoModel(
        name: json['name'] as String?,
        priceLookupCode: json['priceLookupCode']?.toString(),
        fiscalCode: json['fiscalCode']?.toString(),
        packingQuantity: (json['packingQuantity'] as num?)?.toDouble(),
        packingName: json['packingName'] as String?,
        quantity: (json['quantity'] as num?)?.toDouble(),
        totalLiquid: (json['totalLiquid'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'priceLookupCode': priceLookupCode,
    'fiscalCode': fiscalCode,
    'packingQuantity': packingQuantity,
    'packingName': packingName,
    'quantity': quantity,
    'totalLiquid': totalLiquid,
  };

  factory EcBuyMovementProductDtoModel.fromEntity(
    EcBuyMovementProductDtoEntity entity,
  ) => EcBuyMovementProductDtoModel(
    name: entity.name,
    priceLookupCode: entity.priceLookupCode,
    fiscalCode: entity.fiscalCode,
    packingQuantity: entity.packingQuantity,
    packingName: entity.packingName,
    quantity: entity.quantity,
    totalLiquid: entity.totalLiquid,
  );

  EcBuyMovementProductDtoEntity toEntity() => EcBuyMovementProductDtoEntity(
    name: name,
    priceLookupCode: priceLookupCode,
    fiscalCode: fiscalCode,
    packingQuantity: packingQuantity,
    packingName: packingName,
    quantity: quantity,
    totalLiquid: totalLiquid,
  );
}
