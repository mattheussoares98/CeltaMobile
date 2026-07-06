// lib/features/process_authorization/data/models/sale_request/discount/bsf_sale_request_discount_totals_model.dart
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BSFSaleRequestDiscountTotalsModel
    extends BSFSaleRequestDiscountTotalsEntity {
  const BSFSaleRequestDiscountTotalsModel({
    required super.quantity,
    required super.bruteValue,
    required super.discountValue,
    required super.discountPercentage,
    required super.liquidValue,
    required super.discountConcessionLimitPercentage,
    required super.totalDifference,
  });

  factory BSFSaleRequestDiscountTotalsModel.fromJson(Map json) =>
      BSFSaleRequestDiscountTotalsModel(
        quantity: json['Quantity'],
        bruteValue: json['BruteValue'],
        discountValue: json['DiscountValue'],
        discountPercentage: json['DiscountPercentage'],
        liquidValue: json['LiquidValue'],
        discountConcessionLimitPercentage:
            json['DiscountConcessionLimitPercentage'],
        totalDifference: json['TotalDifference'],
      );

  Map<String, dynamic> toJson() => {
    'Quantity': quantity,
    'BruteValue': bruteValue,
    'DiscountValue': discountValue,
    'DiscountPercentage': discountPercentage,
    'LiquidValue': liquidValue,
    'DiscountConcessionLimitPercentage': discountConcessionLimitPercentage,
    'TotalDifference': totalDifference,
  };

  factory BSFSaleRequestDiscountTotalsModel.fromEntity(
    BSFSaleRequestDiscountTotalsEntity entity,
  ) => BSFSaleRequestDiscountTotalsModel(
    quantity: entity.quantity,
    bruteValue: entity.bruteValue,
    discountValue: entity.discountValue,
    discountPercentage: entity.discountPercentage,
    liquidValue: entity.liquidValue,
    discountConcessionLimitPercentage: entity.discountConcessionLimitPercentage,
    totalDifference: entity.totalDifference,
  );

  BSFSaleRequestDiscountTotalsEntity toEntity() =>
      BSFSaleRequestDiscountTotalsEntity(
        quantity: quantity,
        bruteValue: bruteValue,
        discountValue: discountValue,
        discountPercentage: discountPercentage,
        liquidValue: liquidValue,
        discountConcessionLimitPercentage: discountConcessionLimitPercentage,
        totalDifference: totalDifference,
      );
}
