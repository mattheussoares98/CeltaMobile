import 'package:equatable/equatable.dart';

import 'financial.dart';

class BSFPaymentFinalizationEntity extends Equatable {
  final BSFPaymentFormEntity? paymentForm;

  const BSFPaymentFinalizationEntity({required this.paymentForm});

  @override
  List<Object?> get props => [paymentForm];
}
