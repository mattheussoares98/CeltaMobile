// lib/features/process_authorization/data/models/sale_request/discount/bsf_sale_request_discount_item_model.dart
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BSFSaleRequestDiscountItemModel extends BSFSaleRequestDiscountItemEntity {
  const BSFSaleRequestDiscountItemModel({
    super.product,
    super.quantity,
    super.bruteValue,
    super.discountValue,
    super.discountPercentage,
    super.liquidValue,
    super.discountConcessionLimitPercentage,
    super.totalDifference,
    super.hasPositiveDifference,
  });

  factory BSFSaleRequestDiscountItemModel.fromJson(Map json) =>
      BSFSaleRequestDiscountItemModel(
        product: json['Product']?.toString(),
        quantity: (json['Quantity'] as num?)?.toDouble(),
        bruteValue: (json['BruteValue'] as num?)?.toDouble(),
        discountValue: (json['DiscountValue'] as num?)?.toDouble(),
        discountPercentage: (json['DiscountPercentage'] as num?)?.toDouble(),
        liquidValue: (json['LiquidValue'] as num?)?.toDouble(),
        discountConcessionLimitPercentage:
            (json['DiscountConcessionLimitPercentage'] as num?)?.toDouble(),
        totalDifference: (json['TotalDifference'] as num?)?.toDouble(),
        hasPositiveDifference: json['HasPositiveDifference'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'Product': product,
        'Quantity': quantity,
        'BruteValue': bruteValue,
        'DiscountValue': discountValue,
        'DiscountPercentage': discountPercentage,
        'LiquidValue': liquidValue,
        'DiscountConcessionLimitPercentage':
            discountConcessionLimitPercentage,
        'TotalDifference': totalDifference,
        'HasPositiveDifference': hasPositiveDifference,
      };

  factory BSFSaleRequestDiscountItemModel.fromEntity(
          BSFSaleRequestDiscountItemEntity entity) =>
      BSFSaleRequestDiscountItemModel(
        product: entity.product,
        quantity: entity.quantity,
        bruteValue: entity.bruteValue,
        discountValue: entity.discountValue,
        discountPercentage: entity.discountPercentage,
        liquidValue: entity.liquidValue,
        discountConcessionLimitPercentage:
            entity.discountConcessionLimitPercentage,
        totalDifference: entity.totalDifference,
        hasPositiveDifference: entity.hasPositiveDifference,
      );

  BSFSaleRequestDiscountItemEntity toEntity() =>
      BSFSaleRequestDiscountItemEntity(
        product: product,
        quantity: quantity,
        bruteValue: bruteValue,
        discountValue: discountValue,
        discountPercentage: discountPercentage,
        liquidValue: liquidValue,
        discountConcessionLimitPercentage:
            discountConcessionLimitPercentage,
        totalDifference: totalDifference,
        hasPositiveDifference: hasPositiveDifference,
      );
}
