// lib/features/process_authorization/domain/entities/sale_request/bsf_sale_request_lucrativity_item_entity.dart
import 'package:equatable/equatable.dart';

class BSFSaleRequestLucrativityItemEntity extends Equatable {
  final String? product;
  final double? quantity;
  final double? replacementCost;
  final double? liquidCost;
  final double? operationalExpense;
  final double? taxValue;
  final double? billingValue;
  final double? profitValue;
  final double? praticedMargin;
  final double? unitMinimumSalePrice;
  final double? unitAppliedPrice;
  final double? unitDifference;
  final double? totalDifference;
  final bool? hasNegativeDifference;

  const BSFSaleRequestLucrativityItemEntity({
    this.product,
    this.quantity,
    this.replacementCost,
    this.liquidCost,
    this.operationalExpense,
    this.taxValue,
    this.billingValue,
    this.profitValue,
    this.praticedMargin,
    this.unitMinimumSalePrice,
    this.unitAppliedPrice,
    this.unitDifference,
    this.totalDifference,
    this.hasNegativeDifference,
  });

  @override
  List<Object?> get props => [
        product,
        quantity,
        replacementCost,
        liquidCost,
        operationalExpense,
        taxValue,
        billingValue,
        profitValue,
        praticedMargin,
        unitMinimumSalePrice,
        unitAppliedPrice,
        unitDifference,
        totalDifference,
        hasNegativeDifference,
      ];
}
