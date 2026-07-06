// lib/features/process_authorization/domain/entities/sale_request/bsf_sale_request_discount_totals_entity.dart
import 'package:equatable/equatable.dart';

class BSFSaleRequestDiscountTotalsEntity extends Equatable {
  final double? quantity;
  final double? bruteValue;
  final double? discountValue;
  final double? discountPercentage;
  final double? liquidValue;
  final double? discountConcessionLimitPercentage;
  final double? totalDifference;

  const BSFSaleRequestDiscountTotalsEntity({
    this.quantity,
    this.bruteValue,
    this.discountValue,
    this.discountPercentage,
    this.liquidValue,
    this.discountConcessionLimitPercentage,
    this.totalDifference,
  });

  @override
  List<Object?> get props => [
        quantity,
        bruteValue,
        discountValue,
        discountPercentage,
        liquidValue,
        discountConcessionLimitPercentage,
        totalDifference,
      ];
}
