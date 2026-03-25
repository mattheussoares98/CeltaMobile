import 'package:equatable/equatable.dart';

import 'financial.dart';

class EcCompletePaymentFinalizationModel extends Equatable {
  final EcCompletePaymentFormModel? paymentForm;

  const EcCompletePaymentFinalizationModel({required this.paymentForm});

  factory EcCompletePaymentFinalizationModel.fromJson(
    Map<String, dynamic> json,
  ) => EcCompletePaymentFinalizationModel(
    paymentForm: json['PaymentForm'] != null
        ? EcCompletePaymentFormModel.fromJson(json['PaymentForm'])
        : null,
  );

  Map<String, dynamic> toJson() => {'PaymentForm': paymentForm?.toJson()};

  @override
  List<Object?> get props => [paymentForm];
}
