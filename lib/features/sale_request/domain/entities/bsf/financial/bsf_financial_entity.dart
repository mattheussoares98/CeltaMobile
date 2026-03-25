import 'package:equatable/equatable.dart';

import 'financial.dart';

class BSFFinancialEntity extends Equatable {
  final List<BSFPaymentFinalizationWrapperEntity>? paymentFinalizations;
  final double? paybackValue;

  const BSFFinancialEntity({
    required this.paymentFinalizations,
    required this.paybackValue,
  });

  @override
  List<Object?> get props => [paymentFinalizations, paybackValue];
}
