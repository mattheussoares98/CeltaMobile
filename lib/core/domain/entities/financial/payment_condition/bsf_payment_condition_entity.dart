import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/financial/payment_condition/payment_condition_entity.dart';
import 'package:celta_inventario/core/domain/entities/financial/payment_condition/payment_condition_fill_type.dart';
import 'package:celta_inventario/core/domain/entities/financial/payment_condition/payment_condition_use_type.dart';
import 'package:celta_inventario/core/domain/entities/financial/payment_condition/utilization_parameters_entity.dart';

class BSFPaymentConditionEntity extends Equatable {
  final bool isShielded;
  final int code;
  final String personalizedCode;
  final bool isFixed;
  final bool isTemporal;
  final PaymentConditionFillType fillType;
  final PaymentConditionUseType useType;
  final int maximumNumberPortions;
  final double minimumValueInPortions;
  final int intervalMinimumBetweenPortions;
  final int intervalMaximumBetweenPortions;
  final bool internalPaymentCondition;
  final double minimumPercentageOfFirstPortion;
  final String description;
  final String smartDescription;
  final PaymentConditionEntity? condition;
  final UtilizationParametersEntity utilizeParameters;
  final bool allowDifferentValues;
  final bool isAtSight;
  final bool isSaleDevolution;
  final bool isReadSale;
  final bool jumpHolidays;

  const BSFPaymentConditionEntity({
    required this.isShielded,
    required this.code,
    required this.personalizedCode,
    required this.isFixed,
    required this.isTemporal,
    required this.fillType,
    required this.useType,
    required this.maximumNumberPortions,
    required this.minimumValueInPortions,
    required this.intervalMinimumBetweenPortions,
    required this.intervalMaximumBetweenPortions,
    required this.internalPaymentCondition,
    required this.minimumPercentageOfFirstPortion,
    required this.description,
    required this.smartDescription,
    required this.condition,
    required this.utilizeParameters,
    required this.allowDifferentValues,
    required this.isAtSight,
    required this.isSaleDevolution,
    required this.isReadSale,
    required this.jumpHolidays,
  });

  @override
  List<Object?> get props => [
    isShielded,
    code,
    personalizedCode,
    isFixed,
    isTemporal,
    fillType,
    useType,
    maximumNumberPortions,
    minimumValueInPortions,
    intervalMinimumBetweenPortions,
    intervalMaximumBetweenPortions,
    internalPaymentCondition,
    minimumPercentageOfFirstPortion,
    description,
    smartDescription,
    condition,
    utilizeParameters,
    allowDifferentValues,
    isAtSight,
    isSaleDevolution,
    isReadSale,
    jumpHolidays,
  ];

  BSFPaymentConditionEntity copyWith({
    bool? isShielded,
    int? code,
    String? personalizedCode,
    bool? isFixed,
    bool? isTemporal,
    PaymentConditionFillType? fillType,
    PaymentConditionUseType? useType,
    int? maximumNumberPortions,
    double? minimumValueInPortions,
    int? intervalMinimumBetweenPortions,
    int? intervalMaximumBetweenPortions,
    bool? internalPaymentCondition,
    double? minimumPercentageOfFirstPortion,
    String? description,
    String? smartDescription,
    PaymentConditionEntity? condition,
    UtilizationParametersEntity? utilizeParameters,
    bool? allowDifferentValues,
    bool? isAtSight,
    bool? isSaleDevolution,
    bool? isReadSale,
    bool? jumpHolidays,
  }) {
    return BSFPaymentConditionEntity(
      isShielded: isShielded ?? this.isShielded,
      code: code ?? this.code,
      personalizedCode: personalizedCode ?? this.personalizedCode,
      isFixed: isFixed ?? this.isFixed,
      isTemporal: isTemporal ?? this.isTemporal,
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
      smartDescription: smartDescription ?? this.smartDescription,
      condition: condition ?? this.condition,
      utilizeParameters: utilizeParameters ?? this.utilizeParameters,
      allowDifferentValues: allowDifferentValues ?? this.allowDifferentValues,
      isAtSight: isAtSight ?? this.isAtSight,
      isSaleDevolution: isSaleDevolution ?? this.isSaleDevolution,
      isReadSale: isReadSale ?? this.isReadSale,
      jumpHolidays: jumpHolidays ?? this.jumpHolidays,
    );
  }
}
