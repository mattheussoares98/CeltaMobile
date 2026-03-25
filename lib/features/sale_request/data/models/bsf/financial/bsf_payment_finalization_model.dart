import 'package:equatable/equatable.dart';

import '../../../../domain/entities/entities.dart';
import 'financial.dart';

class BSFPaymentFinalizationModel extends Equatable {
  final BSFPaymentFormModel? paymentForm;

  const BSFPaymentFinalizationModel({required this.paymentForm});

  @override
  List<Object?> get props => [paymentForm];

  factory BSFPaymentFinalizationModel.fromJson(Map<String, dynamic> json) =>
      BSFPaymentFinalizationModel(
        paymentForm: json['PaymentForm'] != null
            ? BSFPaymentFormModel.fromJson(json['PaymentForm'])
            : null,
      );

  Map<String, dynamic> toJson() => {'PaymentForm': paymentForm?.toJson()};

  factory BSFPaymentFinalizationModel.fromEntity(
    BSFPaymentFinalizationEntity entity,
  ) => BSFPaymentFinalizationModel(
    paymentForm: entity.paymentForm == null
        ? null
        : BSFPaymentFormModel.fromEntity(entity.paymentForm!),
  );

  BSFPaymentFinalizationEntity toEntity() =>
      BSFPaymentFinalizationEntity(paymentForm: paymentForm?.toEntity());
}
