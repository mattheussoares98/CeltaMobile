import 'package:equatable/equatable.dart';

import '../../../../domain/entities/entities.dart';
import 'financial.dart';

class BSFPaymentFinalizationModel extends Equatable {
  final BSFPaymentFormModel? paymentForm;
  final String Description;

  const BSFPaymentFinalizationModel({
    required this.paymentForm,
    required this.Description,
  });

  @override
  List<Object?> get props => [paymentForm, Description];

  factory BSFPaymentFinalizationModel.fromJson(Map<String, dynamic> json) =>
      BSFPaymentFinalizationModel(
        paymentForm: json['PaymentForm'] != null
            ? BSFPaymentFormModel.fromJson(json['PaymentForm'])
            : null,
        Description: json['Description'],
      );

  Map<String, dynamic> toJson() => {'PaymentForm': paymentForm?.toJson()};

  factory BSFPaymentFinalizationModel.fromEntity(
    BSFPaymentFinalizationEntity entity,
  ) => BSFPaymentFinalizationModel(
    paymentForm: entity.paymentForm == null
        ? null
        : BSFPaymentFormModel.fromEntity(entity.paymentForm!),
    Description: entity.Description,
  );

  BSFPaymentFinalizationEntity toEntity() => BSFPaymentFinalizationEntity(
    paymentForm: paymentForm?.toEntity(),
    Description: Description,
  );
}
