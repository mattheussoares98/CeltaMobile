import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/data/models/financial/financial.dart';

class BSFFinancialModel extends Equatable {
  final List<BSFPaymentFinalizationWrapperModel>? paymentFinalizations;
  final double? paybackValue;

  const BSFFinancialModel({
    required this.paymentFinalizations,
    required this.paybackValue,
  });

  @override
  List<Object?> get props => [paymentFinalizations, paybackValue];

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

  factory BSFFinancialModel.fromEntity(BSFFinancialEntity entity) =>
      BSFFinancialModel(
        paymentFinalizations: entity.paymentFinalizations
            ?.map((e) => BSFPaymentFinalizationWrapperModel.fromEntity(e))
            .toList(),
        paybackValue: entity.paybackValue,
      );

  BSFFinancialEntity toEntity() => BSFFinancialEntity(
    paymentFinalizations: paymentFinalizations
        ?.map((e) => e.toEntity())
        .toList(),
    paybackValue: paybackValue,
  );
}
