import 'package:equatable/equatable.dart';

import 'financial.dart';

class BSFPaymentFinalizationModel extends Equatable {
  final BSFPaymentFormModel? paymentForm;

  const BSFPaymentFinalizationModel({required this.paymentForm});

  factory BSFPaymentFinalizationModel.fromJson(Map<String, dynamic> json) =>
      BSFPaymentFinalizationModel(
        paymentForm: json['PaymentForm'] != null
            ? BSFPaymentFormModel.fromJson(json['PaymentForm'])
            : null,
      );

  Map<String, dynamic> toJson() => {'PaymentForm': paymentForm?.toJson()};

  @override
  List<Object?> get props => [paymentForm];
}
