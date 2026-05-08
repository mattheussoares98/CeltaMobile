import 'package:equatable/equatable.dart';

import 'payment_condition_entity.dart';
import 'payment_condition_fill_type.dart';
import 'payment_condition_use_type.dart';
import 'utilization_parameters_entity.dart';

class BSFPaymentConditionEntity extends Equatable {
  final bool isShielded;
  final int code;
  final String personalizedCode;
  final bool isFixed;
  final PaymentConditionFillType fillType;
  final PaymentConditionUseType useType;
  final int maximumNumberPortions;
  final double minimumValueInPortions;
  final int intervalMinimumBetweenPortions;
  final int intervalMaximumBetweenPortions;
  final bool internalPaymentCondition;
  final double minimumPercentageOfFirstPortion;
  final String description;
  final PaymentConditionEntity? condition;
  final UtilizationParametersEntity utilizeParameters;

  const BSFPaymentConditionEntity({
    required this.isShielded,
    required this.code,
    required this.personalizedCode,
    required this.isFixed,
    required this.fillType,
    required this.useType,
    required this.maximumNumberPortions,
    required this.minimumValueInPortions,
    required this.intervalMinimumBetweenPortions,
    required this.intervalMaximumBetweenPortions,
    required this.internalPaymentCondition,
    required this.minimumPercentageOfFirstPortion,
    required this.description,
    required this.condition,
    required this.utilizeParameters,
  });

  @override
  List<Object?> get props => [
    isShielded,
    code,
    personalizedCode,
    isFixed,
    fillType,
    useType,
    maximumNumberPortions,
    minimumValueInPortions,
    intervalMinimumBetweenPortions,
    intervalMaximumBetweenPortions,
    internalPaymentCondition,
    minimumPercentageOfFirstPortion,
    description,
    condition,
    utilizeParameters,
  ];

  BSFPaymentConditionEntity copyWith({
    bool? isShielded,
    int? code,
    String? personalizedCode,
    bool? isFixed,
    PaymentConditionFillType? fillType,
    PaymentConditionUseType? useType,
    int? maximumNumberPortions,
    double? minimumValueInPortions,
    int? intervalMinimumBetweenPortions,
    int? intervalMaximumBetweenPortions,
    bool? internalPaymentCondition,
    double? minimumPercentageOfFirstPortion,
    String? description,
    PaymentConditionEntity? condition,
    UtilizationParametersEntity? utilizeParameters,
  }) {
    return BSFPaymentConditionEntity(
      isShielded: isShielded ?? this.isShielded,
      code: code ?? this.code,
      personalizedCode: personalizedCode ?? this.personalizedCode,
      isFixed: isFixed ?? this.isFixed,
      fillType: fillType ?? this.fillType,
      useType: useType ?? this.useType,
      maximumNumberPortions:
          maximumNumberPortions ?? this.maximumNumberPortions,
      minimumValueInPortions:
          minimumValueInPortions ?? this.minimumValueInPortions,
      intervalMinimumBetweenPortions:
          intervalMinimumBetweenPortions ?? this.intervalMinimumBetweenPortions,
      intervalMaximumBetweenPortions:
          intervalMaximumBetweenPortions ?? this.intervalMaximumBetweenPortions,
      internalPaymentCondition:
          internalPaymentCondition ?? this.internalPaymentCondition,
      minimumPercentageOfFirstPortion:
          minimumPercentageOfFirstPortion ??
          this.minimumPercentageOfFirstPortion,
      description: description ?? this.description,
      condition: condition ?? this.condition,
      utilizeParameters: utilizeParameters ?? this.utilizeParameters,
    );
  }
}
