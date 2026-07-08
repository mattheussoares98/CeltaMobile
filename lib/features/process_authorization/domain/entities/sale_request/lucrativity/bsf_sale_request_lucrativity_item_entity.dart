import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFSaleRequestLucrativityItemEntity extends Equatable {
  final ProcessAuthorizationSaleRequestProductEntity product;
  final double quantity;
  final double replacementCost;
  final double liquidCost;
  final double operationalExpense;
  final double taxValue;
  final double billingValue;
  final double profitValue;
  final double praticedMargin;
  final double unitMinimumSalePrice;
  final double unitAppliedPrice;
  final double unitDifference;
  final double totalDifference;
  final bool hasNegativeDifference;

  const BSFSaleRequestLucrativityItemEntity({
    required this.product,
    required this.quantity,
    required this.replacementCost,
    required this.liquidCost,
    required this.operationalExpense,
    required this.taxValue,
    required this.billingValue,
    required this.profitValue,
    required this.praticedMargin,
    required this.unitMinimumSalePrice,
    required this.unitAppliedPrice,
    required this.unitDifference,
    required this.totalDifference,
    required this.hasNegativeDifference,
  });

  @override
  List<Object> get props => [
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
