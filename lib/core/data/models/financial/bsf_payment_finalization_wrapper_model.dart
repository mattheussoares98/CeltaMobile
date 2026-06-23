import 'package:celta_inventario/core/data/models/financial/financial.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFPaymentFinalizationWrapperModel extends Equatable {
  final BSFPaymentFinalizationModel? paymentFinalization;
  final double? value;
  final double? financialIncrement;
  final double? financialDiscount;
  final int? quantityOfPortions;
  final String? tefSequencialUniqueNumber;
  final String? tefAutorizationCreditCode;
  final String? devolutionCreditCode;
  final String? identificationCode;
  final BSFPaymentConditionModel? paymentCondition;
  final String? creditCardNumber;
  final DateTime? creditCardValidate;
  final List<dynamic>? portions;
  final BSFUserAuthorizationModel? userAuthorization;
  final int? code;
  final double? liquidValue;
  final double? totalFinancialTax;
  final String? creditCardSecurityCode;
  final String? observations;

  const BSFPaymentFinalizationWrapperModel({
    required this.paymentFinalization,
    required this.value,
    required this.financialIncrement,
    required this.financialDiscount,
    required this.quantityOfPortions,
    required this.tefSequencialUniqueNumber,
    required this.tefAutorizationCreditCode,
    required this.devolutionCreditCode,
    required this.identificationCode,
    required this.paymentCondition,
    required this.creditCardNumber,
    required this.creditCardValidate,
    required this.portions,
    required this.userAuthorization,
    this.code,
    this.liquidValue,
    this.totalFinancialTax,
    this.creditCardSecurityCode,
    this.observations,
  });

  @override
  List<Object?> get props => [
    paymentFinalization,
    value,
    financialIncrement,
    financialDiscount,
    quantityOfPortions,
    tefSequencialUniqueNumber,
    tefAutorizationCreditCode,
    devolutionCreditCode,
    identificationCode,
    paymentCondition,
    creditCardNumber,
    creditCardValidate,
    portions,
    userAuthorization,
    code,
    liquidValue,
    totalFinancialTax,
    creditCardSecurityCode,
    observations,
  ];

  factory BSFPaymentFinalizationWrapperModel.fromJson(Map json) =>
      BSFPaymentFinalizationWrapperModel(
        paymentFinalization: json['PaymentFinalization'] != null
            ? BSFPaymentFinalizationModel.fromJson(json['PaymentFinalization'])
            : null,
        value: (json['Value'] as num?)?.toDouble(),
        financialIncrement: (json['FinancialIncrement'] as num?)?.toDouble(),
        financialDiscount: (json['FinancialDiscount'] as num?)?.toDouble(),
        quantityOfPortions: json['QuantityOfPortions'] as int?,
        tefSequencialUniqueNumber: json['TefSequencialUniqueNumber'] as String?,
        tefAutorizationCreditCode: json['TefAutorizationCreditCode'] as String?,
        devolutionCreditCode: json['DevolutionCreditCode'] as String?,
        identificationCode: json['IdentificationCode'] as String?,
        paymentCondition: json['PaymentCondition'] != null
            ? BSFPaymentConditionModel.fromJson(json['PaymentCondition'])
            : null,
        creditCardNumber: json['CreditCardNumber'] as String?,
        creditCardValidate: json['CreditCardValidate'] != null
            ? DateTime.parse(json['CreditCardValidate'])
            : null,
        portions: json['Portions'] as List<dynamic>?,
        userAuthorization: json['UserAuthorization'] != null
            ? BSFUserAuthorizationModel.fromJson(json['UserAuthorization'])
            : null,
        code: json['Code'] as int?,
        liquidValue: (json['LiquidValue'] as num?)?.toDouble(),
        totalFinancialTax: (json['TotalFinancialTax'] as num?)?.toDouble(),
        creditCardSecurityCode: json['CreditCardSecurityCode'] as String?,
        observations: json['Observations'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'PaymentFinalization': paymentFinalization?.toJson(),
    'Value': value,
    'FinancialIncrement': financialIncrement,
    'FinancialDiscount': financialDiscount,
    'QuantityOfPortions': quantityOfPortions,
    'TefSequencialUniqueNumber': tefSequencialUniqueNumber,
    'TefAutorizationCreditCode': tefAutorizationCreditCode,
    'DevolutionCreditCode': devolutionCreditCode,
    'IdentificationCode': identificationCode,
    'PaymentCondition': paymentCondition?.toJson(),
    'CreditCardNumber': creditCardNumber,
    'CreditCardValidate': creditCardValidate?.toIso8601String(),
    'Portions': portions,
    'UserAuthorization': userAuthorization?.toJson(),
    'Code': code,
    'LiquidValue': liquidValue,
    'TotalFinancialTax': totalFinancialTax,
    'CreditCardSecurityCode': creditCardSecurityCode,
    'Observations': observations,
  };

  factory BSFPaymentFinalizationWrapperModel.fromEntity(
    BSFPaymentFinalizationWrapperEntity entity,
  ) => BSFPaymentFinalizationWrapperModel(
    paymentFinalization: entity.paymentFinalization == null
        ? null
        : BSFPaymentFinalizationModel.fromEntity(entity.paymentFinalization!),
    value: entity.value,
    financialIncrement: entity.financialIncrement,
    financialDiscount: entity.financialDiscount,
    quantityOfPortions: entity.quantityOfPortions,
    tefSequencialUniqueNumber: entity.tefSequencialUniqueNumber,
    tefAutorizationCreditCode: entity.tefAutorizationCreditCode,
    devolutionCreditCode: entity.devolutionCreditCode,
    identificationCode: entity.identificationCode,
    paymentCondition: entity.paymentCondition == null
        ? null
        : BSFPaymentConditionModel.fromEntity(entity.paymentCondition!),
    creditCardNumber: entity.creditCardNumber,
    creditCardValidate: entity.creditCardValidate,
    portions: entity.portions,
    userAuthorization: entity.userAuthorization == null
        ? null
        : BSFUserAuthorizationModel.fromEntity(entity.userAuthorization!),
    code: entity.code,
    liquidValue: entity.liquidValue,
    totalFinancialTax: entity.totalFinancialTax,
    creditCardSecurityCode: entity.creditCardSecurityCode,
    observations: entity.observations,
  );

  BSFPaymentFinalizationWrapperEntity toEntity() =>
      BSFPaymentFinalizationWrapperEntity(
        paymentFinalization: paymentFinalization?.toEntity(),
        value: value,
        financialIncrement: financialIncrement,
        financialDiscount: financialDiscount,
        quantityOfPortions: quantityOfPortions,
        tefSequencialUniqueNumber: tefSequencialUniqueNumber,
        tefAutorizationCreditCode: tefAutorizationCreditCode,
        devolutionCreditCode: devolutionCreditCode,
        identificationCode: identificationCode,
        paymentCondition: paymentCondition?.toEntity(),
        creditCardNumber: creditCardNumber,
        creditCardValidate: creditCardValidate,
        portions: portions,
        userAuthorization: userAuthorization?.toEntity(),
        code: code,
        liquidValue: liquidValue,
        totalFinancialTax: totalFinancialTax,
        creditCardSecurityCode: creditCardSecurityCode,
        observations: observations,
      );
}
