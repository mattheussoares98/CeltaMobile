// lib/features/process_authorization/data/models/sale_request/discount/bsf_sale_request_discount_totals_model.dart
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BSFSaleRequestDiscountTotalsModel extends BSFSaleRequestDiscountTotalsEntity {
  const BSFSaleRequestDiscountTotalsModel({
    super.quantity,
    super.bruteValue,
    super.discountValue,
    super.discountPercentage,
    super.liquidValue,
    super.discountConcessionLimitPercentage,
    super.totalDifference,
  });

  factory BSFSaleRequestDiscountTotalsModel.fromJson(Map json) =>
      BSFSaleRequestDiscountTotalsModel(
        quantity: (json['Quantity'] as num?)?.toDouble(),
        bruteValue: (json['BruteValue'] as num?)?.toDouble(),
        discountValue: (json['DiscountValue'] as num?)?.toDouble(),
        discountPercentage: (json['DiscountPercentage'] as num?)?.toDouble(),
        liquidValue: (json['LiquidValue'] as num?)?.toDouble(),
        discountConcessionLimitPercentage:
            (json['DiscountConcessionLimitPercentage'] as num?)?.toDouble(),
        totalDifference: (json['TotalDifference'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'Quantity': quantity,
        'BruteValue': bruteValue,
        'DiscountValue': discountValue,
        'DiscountPercentage': discountPercentage,
        'LiquidValue': liquidValue,
        'DiscountConcessionLimitPercentage':
            discountConcessionLimitPercentage,
        'TotalDifference': totalDifference,
      };

  factory BSFSaleRequestDiscountTotalsModel.fromEntity(
          BSFSaleRequestDiscountTotalsEntity entity) =>
      BSFSaleRequestDiscountTotalsModel(
        quantity: entity.quantity,
        bruteValue: entity.bruteValue,
        discountValue: entity.discountValue,
        discountPercentage: entity.discountPercentage,
        liquidValue: entity.liquidValue,
        discountConcessionLimitPercentage:
            entity.discountConcessionLimitPercentage,
        totalDifference: entity.totalDifference,
      );

  BSFSaleRequestDiscountTotalsEntity toEntity() =>
      BSFSaleRequestDiscountTotalsEntity(
        quantity: quantity,
        bruteValue: bruteValue,
        discountValue: discountValue,
        discountPercentage: discountPercentage,
        liquidValue: liquidValue,
        discountConcessionLimitPercentage:
            discountConcessionLimitPercentage,
        totalDifference: totalDifference,
      );
}
