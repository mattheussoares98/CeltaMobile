// lib/features/process_authorization/domain/entities/sale_request/bsf_sale_request_lucrativity_totals_entity.dart
import 'package:equatable/equatable.dart';

class BSFSaleRequestLucrativityTotalsEntity extends Equatable {
  final double? quantity;
  final double? replacementCost;
  final double? liquidCost;
  final double? operationalExpense;
  final double? taxValue;
  final double? billingValue;
  final double? profitValue;
  final double? praticedMargin;
  final double? totalDifference;

  const BSFSaleRequestLucrativityTotalsEntity({
    this.quantity,
    this.replacementCost,
    this.liquidCost,
    this.operationalExpense,
    this.taxValue,
    this.billingValue,
    this.profitValue,
    this.praticedMargin,
    this.totalDifference,
  });

  @override
  List<Object?> get props => [
        quantity,
        replacementCost,
        liquidCost,
        operationalExpense,
        taxValue,
        billingValue,
        profitValue,
        praticedMargin,
        totalDifference,
      ];
}
