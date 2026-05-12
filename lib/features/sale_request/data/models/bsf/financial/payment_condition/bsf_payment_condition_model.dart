import '../../../../../../../core/domain/entities/entities.dart';
import 'payment_condition.dart';

class BSFPaymentConditionModel extends BSFPaymentConditionEntity {
  const BSFPaymentConditionModel({
    required super.isShielded,
    required super.code,
    required super.personalizedCode,
    required super.isFixed,
    required super.fillType,
    required super.useType,
    required super.maximumNumberPortions,
    required super.minimumValueInPortions,
    required super.intervalMinimumBetweenPortions,
    required super.intervalMaximumBetweenPortions,
    required super.internalPaymentCondition,
    required super.minimumPercentageOfFirstPortion,
    required super.description,
    required super.smartDescription,
    required super.condition,
    required super.utilizeParameters,
    required super.allowDifferentValues,
    required super.isAtSight,
    required super.isSaleDevolution,
    required super.isReadSale,
    required super.jumpHolidays,
    required super.isTemporal,
  });

  factory BSFPaymentConditionModel.fromJson(
    Map<String, dynamic> json,
  ) => BSFPaymentConditionModel(
    isShielded: json['IsShielded'] ?? false,
    code: json['Code'] ?? 0,
    personalizedCode: json['PersonalizedCode'] ?? '',
    isFixed: json['IsFixed'] ?? false,
    isTemporal: json['IsTemporal'] ?? false,
    fillType: PaymentConditionFillType.fromValue(json['FillType']),
    useType: PaymentConditionUseType.fromValue(json['UseType']),
    maximumNumberPortions: json['MaximumNumberPortions'] ?? 0,
    minimumValueInPortions:
        (json['MinimumValueInPortions'] as num?)?.toDouble() ?? 0.0,
    intervalMinimumBetweenPortions: json['IntervalMinimumBetweenPortions'] ?? 0,
    intervalMaximumBetweenPortions: json['IntervalMaximumBetweenPortions'] ?? 0,
    internalPaymentCondition: json['InternalPaymentCondition'] ?? false,
    minimumPercentageOfFirstPortion:
        (json['MinimumPercentageOfFirstPortion'] as num?)?.toDouble() ?? 0.0,
    description: json['Description'] ?? '',
    smartDescription: json['SmartDescription'] ?? '',
    condition: json['Condition'] != null
        ? PaymentConditionModel.fromJson(json['Condition'])
        : null,
    utilizeParameters: UtilizationParametersModel.fromJson(
      json['UtilizeParameters'] ?? {},
    ),
    allowDifferentValues: json['AllowDifferentValues'] ?? false,
    isAtSight: json['IsAtSight'] ?? false,
    isSaleDevolution: json['IsSaleDevolution'] ?? false,
    isReadSale: json['IsReadSale'] ?? false,
    jumpHolidays: json['JumpHolidays'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'IsShielded': isShielded,
    'Code': code,
    'PersonalizedCode': personalizedCode,
    'IsFixed': isFixed,
    'IsTemporal': isTemporal,
    'FillType': fillType.value,
    'UseType': useType.value,
    'MaximumNumberPortions': maximumNumberPortions,
    'MinimumValueInPortions': minimumValueInPortions,
    'IntervalMinimumBetweenPortions': intervalMinimumBetweenPortions,
    'IntervalMaximumBetweenPortions': intervalMaximumBetweenPortions,
    'InternalPaymentCondition': internalPaymentCondition,
    'MinimumPercentageOfFirstPortion': minimumPercentageOfFirstPortion,
    'Description': description,
    'SmartDescription': smartDescription,
    'Condition': condition == null
        ? null
        : PaymentConditionModel.fromEntity(condition!).toJson(),
    'UtilizeParameters': UtilizationParametersModel.fromEntity(
      utilizeParameters,
    ).toJson(),
    'AllowDifferentValues': allowDifferentValues,
    'IsAtSight': isAtSight,
    'IsSaleDevolution': isSaleDevolution,
    'IsReadSale': isReadSale,
    'JumpHolidays': jumpHolidays,
  };

  factory BSFPaymentConditionModel.fromEntity(
    BSFPaymentConditionEntity entity,
  ) => BSFPaymentConditionModel(
    isShielded: entity.isShielded,
    code: entity.code,
    personalizedCode: entity.personalizedCode,
    isFixed: entity.isFixed,
    fillType: entity.fillType,
    useType: entity.useType,
    maximumNumberPortions: entity.maximumNumberPortions,
    minimumValueInPortions: entity.minimumValueInPortions,
    intervalMinimumBetweenPortions: entity.intervalMinimumBetweenPortions,
    intervalMaximumBetweenPortions: entity.intervalMaximumBetweenPortions,
    internalPaymentCondition: entity.internalPaymentCondition,
    minimumPercentageOfFirstPortion: entity.minimumPercentageOfFirstPortion,
    description: entity.description,
    smartDescription: entity.smartDescription,
    condition: entity.condition == null
        ? null
        : PaymentConditionModel.fromEntity(entity.condition!),
    utilizeParameters: UtilizationParametersModel.fromEntity(
      entity.utilizeParameters,
    ),
    allowDifferentValues: entity.allowDifferentValues,
    isAtSight: entity.isAtSight,
    isSaleDevolution: entity.isSaleDevolution,
    isReadSale: entity.isReadSale,
    jumpHolidays: entity.jumpHolidays,
    isTemporal: entity.isTemporal,
  );

  BSFPaymentConditionEntity toEntity() => BSFPaymentConditionEntity(
    isShielded: isShielded,
    code: code,
    personalizedCode: personalizedCode,
    isFixed: isFixed,
    fillType: fillType,
    useType: useType,
    maximumNumberPortions: maximumNumberPortions,
    minimumValueInPortions: minimumValueInPortions,
    intervalMinimumBetweenPortions: intervalMinimumBetweenPortions,
    intervalMaximumBetweenPortions: intervalMaximumBetweenPortions,
    internalPaymentCondition: internalPaymentCondition,
    minimumPercentageOfFirstPortion: minimumPercentageOfFirstPortion,
    description: description,
    smartDescription: smartDescription,
    condition: condition,
    utilizeParameters: utilizeParameters,
    allowDifferentValues: allowDifferentValues,
    isAtSight: isAtSight,
    isSaleDevolution: isSaleDevolution,
    isReadSale: isReadSale,
    jumpHolidays: jumpHolidays,
    isTemporal: isTemporal,
  );
}
