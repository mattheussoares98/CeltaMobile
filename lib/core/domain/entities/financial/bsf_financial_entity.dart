import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/financial/financial.dart';

class BSFFinancialEntity extends Equatable {
  final List<BSFPaymentFinalizationWrapperEntity>? paymentFinalizations;
  final double? paybackValue;

  const BSFFinancialEntity({
    required this.paymentFinalizations,
    required this.paybackValue,
  });

  @override
  List<Object?> get props => [paymentFinalizations, paybackValue];

  BSFFinancialEntity copyWith({
    List<BSFPaymentFinalizationWrapperEntity>? paymentFinalizations,
    double? paybackValue,
  }) {
    return BSFFinancialEntity(
      paymentFinalizations: paymentFinalizations ?? this.paymentFinalizations,
      paybackValue: paybackValue ?? this.paybackValue,
    );
  }
}
