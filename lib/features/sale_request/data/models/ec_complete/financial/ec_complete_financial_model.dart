import 'package:equatable/equatable.dart';

import 'financial.dart';

class EcCompleteFinancialModel extends Equatable {
  final List<EcCompletePaymentFinalizationWrapperModel>? paymentFinalizations;
  final double? paybackValue;

  const EcCompleteFinancialModel({
    required this.paymentFinalizations,
    required this.paybackValue,
  });

  factory EcCompleteFinancialModel.fromJson(Map<String, dynamic> json) =>
      EcCompleteFinancialModel(
        paymentFinalizations: json['PaymentFinalizations'] != null
            ? (json['PaymentFinalizations'] as List)
                  .map(
                    (i) =>
                        EcCompletePaymentFinalizationWrapperModel.fromJson(i),
                  )
                  .toList()
            : null,
        paybackValue: (json['PaybackValue'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    'PaymentFinalizations': paymentFinalizations
        ?.map((e) => e.toJson())
        .toList(),
    'PaybackValue': paybackValue,
  };

  @override
  List<Object?> get props => [paymentFinalizations, paybackValue];
}
