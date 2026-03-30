import 'package:equatable/equatable.dart';

import 'financial.dart';

class BSFPaymentFinalizationEntity extends Equatable {
  final BSFPaymentFormEntity? paymentForm;
  final String Description;

  const BSFPaymentFinalizationEntity({
    required this.paymentForm,
    required this.Description,
  });

  @override
  List<Object?> get props => [paymentForm, Description];
}
