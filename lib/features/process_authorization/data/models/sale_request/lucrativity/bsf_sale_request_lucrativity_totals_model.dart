// lib/features/process_authorization/data/models/sale_request/lucrativity/bsf_sale_request_lucrativity_totals_model.dart
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

class BSFSaleRequestLucrativityTotalsModel
    extends BSFSaleRequestLucrativityTotalsEntity {
  const BSFSaleRequestLucrativityTotalsModel({
    super.quantity,
    super.replacementCost,
    super.liquidCost,
    super.operationalExpense,
    super.taxValue,
    super.billingValue,
    super.profitValue,
    super.praticedMargin,
    super.totalDifference,
  });

  factory BSFSaleRequestLucrativityTotalsModel.fromJson(Map json) =>
      BSFSaleRequestLucrativityTotalsModel(
        quantity: (json['Quantity'] as num?)?.toDouble(),
        replacementCost: (json['ReplacementCost'] as num?)?.toDouble(),
        liquidCost: (json['LiquidCost'] as num?)?.toDouble(),
        operationalExpense: (json['OperationalExpense'] as num?)?.toDouble(),
        taxValue: (json['TaxValue'] as num?)?.toDouble(),
        billingValue: (json['BillingValue'] as num?)?.toDouble(),
        profitValue: (json['ProfitValue'] as num?)?.toDouble(),
        praticedMargin: (json['PraticedMargin'] as num?)?.toDouble(),
        totalDifference: (json['TotalDifference'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'Quantity': quantity,
        'ReplacementCost': replacementCost,
        'LiquidCost': liquidCost,
        'OperationalExpense': operationalExpense,
        'TaxValue': taxValue,
        'BillingValue': billingValue,
        'ProfitValue': profitValue,
        'PraticedMargin': praticedMargin,
        'TotalDifference': totalDifference,
      };

  factory BSFSaleRequestLucrativityTotalsModel.fromEntity(
          BSFSaleRequestLucrativityTotalsEntity entity) =>
      BSFSaleRequestLucrativityTotalsModel(
        quantity: entity.quantity,
        replacementCost: entity.replacementCost,
        liquidCost: entity.liquidCost,
        operationalExpense: entity.operationalExpense,
        taxValue: entity.taxValue,
        billingValue: entity.billingValue,
        profitValue: entity.profitValue,
        praticedMargin: entity.praticedMargin,
        totalDifference: entity.totalDifference,
      );

  BSFSaleRequestLucrativityTotalsEntity toEntity() =>
      BSFSaleRequestLucrativityTotalsEntity(
        quantity: quantity,
        replacementCost: replacementCost,
        liquidCost: liquidCost,
        operationalExpense: operationalExpense,
        taxValue: taxValue,
        billingValue: billingValue,
        profitValue: profitValue,
        praticedMargin: praticedMargin,
        totalDifference: totalDifference,
      );
}
