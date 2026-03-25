import 'package:equatable/equatable.dart';

import 'financial.dart';

class BSFFinancialModel extends Equatable {
  final List<BSFPaymentFinalizationWrapperModel>? paymentFinalizations;
  final double? paybackValue;

  const BSFFinancialModel({
    required this.paymentFinalizations,
    required this.paybackValue,
  });

  factory BSFFinancialModel.fromJson(Map<String, dynamic> json) =>
      BSFFinancialModel(
        paymentFinalizations: json['PaymentFinalizations'] != null
            ? (json['PaymentFinalizations'] as List)
                  .map((i) => BSFPaymentFinalizationWrapperModel.fromJson(i))
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
