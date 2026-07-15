// lib/features/process_authorization/data/models/sale_request/discount/bsf_sale_request_discount_item_model.dart
import 'package:celta_inventario/features/process_authorization/data/models/models.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BSFSaleRequestDiscountItemModel extends BSFSaleRequestDiscountItemEntity {
  const BSFSaleRequestDiscountItemModel({
    required super.product,
    required super.quantity,
    required super.bruteValue,
    required super.discountValue,
    required super.discountPercentage,
    required super.liquidValue,
    required super.discountConcessionLimitPercentage,
    required super.totalDifference,
    required super.hasPositiveDifference,
  });

  factory BSFSaleRequestDiscountItemModel.fromJson(Map json) =>
      BSFSaleRequestDiscountItemModel(
        product: ProcessAuthorizationSaleRequestProductModel.fromJson(
          json['Product'],
        ),
        quantity: json['Quantity'],
        bruteValue: json['BruteValue'],
        discountValue: json['DiscountValue'],
        discountPercentage: json['DiscountPercentage'],
        liquidValue: json['LiquidValue'],
        discountConcessionLimitPercentage:
            json['DiscountConcessionLimitPercentage'],
        totalDifference: json['TotalDifference'],
        hasPositiveDifference: json['HasPositiveDifference'] ?? false,
      );

  Map<String, dynamic> toJson() => {
    'Product': ProcessAuthorizationSaleRequestProductModel.fromEntity(
      product,
    ).toJson(),
    'Quantity': quantity,
    'BruteValue': bruteValue,
    'DiscountValue': discountValue,
    'DiscountPercentage': discountPercentage,
    'LiquidValue': liquidValue,
    'DiscountConcessionLimitPercentage': discountConcessionLimitPercentage,
    'TotalDifference': totalDifference,
    'HasPositiveDifference': hasPositiveDifference,
  };

  factory BSFSaleRequestDiscountItemModel.fromEntity(
    BSFSaleRequestDiscountItemEntity entity,
  ) => BSFSaleRequestDiscountItemModel(
    product: entity.product,
    quantity: entity.quantity,
    bruteValue: entity.bruteValue,
    discountValue: entity.discountValue,
    discountPercentage: entity.discountPercentage,
    liquidValue: entity.liquidValue,
    discountConcessionLimitPercentage: entity.discountConcessionLimitPercentage,
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
        discountConcessionLimitPercentage: discountConcessionLimitPercentage,
        totalDifference: totalDifference,
        hasPositiveDifference: hasPositiveDifference,
      );
}
