// lib/features/process_authorization/domain/entities/sale_request/bsf_sale_request_discount_item_entity.dart
import 'package:equatable/equatable.dart';

class BSFSaleRequestDiscountItemEntity extends Equatable {
  final String product;
  final double quantity;
  final double bruteValue;
  final double discountValue;
  final double discountPercentage;
  final double liquidValue;
  final double discountConcessionLimitPercentage;
  final double totalDifference;
  final bool hasPositiveDifference;

  const BSFSaleRequestDiscountItemEntity({
    required this.product,
    required this.quantity,
    required this.bruteValue,
    required this.discountValue,
    required this.discountPercentage,
    required this.liquidValue,
    required this.discountConcessionLimitPercentage,
    required this.totalDifference,
    required this.hasPositiveDifference,
  });

  @override
  List<Object> get props => [
    product,
    quantity,
    bruteValue,
    discountValue,
    discountPercentage,
    liquidValue,
    discountConcessionLimitPercentage,
    totalDifference,
    hasPositiveDifference,
  ];
}
