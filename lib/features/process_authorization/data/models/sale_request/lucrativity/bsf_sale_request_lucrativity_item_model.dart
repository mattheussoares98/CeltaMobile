// lib/features/process_authorization/data/models/sale_request/lucrativity/bsf_sale_request_lucrativity_item_model.dart
import 'package:celta_inventario/features/process_authorization/data/models/models.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BSFSaleRequestLucrativityItemModel
    extends BSFSaleRequestLucrativityItemEntity {
  const BSFSaleRequestLucrativityItemModel({
    required super.product,
    required super.quantity,
    required super.replacementCost,
    required super.liquidCost,
    required super.operationalExpense,
    required super.taxValue,
    required super.billingValue,
    required super.profitValue,
    required super.praticedMargin,
    required super.unitMinimumSalePrice,
    required super.unitAppliedPrice,
    required super.unitDifference,
    required super.totalDifference,
    required super.hasNegativeDifference,
  });

  factory BSFSaleRequestLucrativityItemModel.fromJson(Map json) =>
      BSFSaleRequestLucrativityItemModel(
        product: ProcessAuthorizationSaleRequestProductModel.fromJson(
          json['Product'],
        ),
        quantity: (json['Quantity'] as num).toDouble(),
        replacementCost: (json['ReplacementCost'] as num).toDouble(),
        liquidCost: (json['LiquidCost'] as num).toDouble(),
        operationalExpense: (json['OperationalExpense'] as num).toDouble(),
        taxValue: (json['TaxValue'] as num).toDouble(),
        billingValue: (json['BillingValue'] as num).toDouble(),
        profitValue: (json['ProfitValue'] as num).toDouble(),
        praticedMargin: (json['PraticedMargin'] as num).toDouble(),
        unitMinimumSalePrice: (json['UnitMinimumSalePrice'] as num).toDouble(),
        unitAppliedPrice: (json['UnitAppliedPrice'] as num).toDouble(),
        unitDifference: (json['UnitDifference'] as num).toDouble(),
        totalDifference: (json['TotalDifference'] as num).toDouble(),
        hasNegativeDifference: json['HasNegativeDifference'] ?? false,
      );

  Map<String, dynamic> toJson() => {
    'Product': ProcessAuthorizationSaleRequestProductModel.fromEntity(
      product,
    ).toJson(),
    'Quantity': quantity,
    'ReplacementCost': replacementCost,
    'LiquidCost': liquidCost,
    'OperationalExpense': operationalExpense,
    'TaxValue': taxValue,
    'BillingValue': billingValue,
    'ProfitValue': profitValue,
    'PraticedMargin': praticedMargin,
    'UnitMinimumSalePrice': unitMinimumSalePrice,
    'UnitAppliedPrice': unitAppliedPrice,
    'UnitDifference': unitDifference,
    'TotalDifference': totalDifference,
    'HasNegativeDifference': hasNegativeDifference,
  };

  factory BSFSaleRequestLucrativityItemModel.fromEntity(
    BSFSaleRequestLucrativityItemEntity entity,
  ) => BSFSaleRequestLucrativityItemModel(
    product: entity.product,
    quantity: entity.quantity,
    replacementCost: entity.replacementCost,
    liquidCost: entity.liquidCost,
    operationalExpense: entity.operationalExpense,
    taxValue: entity.taxValue,
    billingValue: entity.billingValue,
    profitValue: entity.profitValue,
    praticedMargin: entity.praticedMargin,
    unitMinimumSalePrice: entity.unitMinimumSalePrice,
    unitAppliedPrice: entity.unitAppliedPrice,
    unitDifference: entity.unitDifference,
    totalDifference: entity.totalDifference,
    hasNegativeDifference: entity.hasNegativeDifference,
  );

  BSFSaleRequestLucrativityItemEntity toEntity() =>
      BSFSaleRequestLucrativityItemEntity(
        product: product,
        quantity: quantity,
        replacementCost: replacementCost,
        liquidCost: liquidCost,
        operationalExpense: operationalExpense,
        taxValue: taxValue,
        billingValue: billingValue,
        profitValue: profitValue,
        praticedMargin: praticedMargin,
        unitMinimumSalePrice: unitMinimumSalePrice,
        unitAppliedPrice: unitAppliedPrice,
        unitDifference: unitDifference,
        totalDifference: totalDifference,
        hasNegativeDifference: hasNegativeDifference,
      );
}
