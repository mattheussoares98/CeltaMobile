import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/financial/financial.dart';

class BSFPaymentFinalizationWrapperEntity extends Equatable {
  final BSFPaymentFinalizationEntity? paymentFinalization;
  final double? value;
  final double? financialIncrement;
  final double? financialDiscount;
  final int? quantityOfPortions;
  final String? tefSequencialUniqueNumber;
  final String? tefAutorizationCreditCode;
  final String? devolutionCreditCode;
  final String? identificationCode;
  final BSFPaymentConditionEntity? paymentCondition;
  final String? creditCardNumber;
  final DateTime? creditCardValidate;
  final List<dynamic>? portions;
  final BSFUserAuthorizationEntity? userAuthorization;
  final int? code;
  final double? liquidValue;
  final double? totalFinancialTax;
  final String? creditCardSecurityCode;
  final String? observations;

  const BSFPaymentFinalizationWrapperEntity({
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

  BSFPaymentFinalizationWrapperEntity copyWith({
    BSFPaymentFinalizationEntity? paymentFinalization,
    double? value,
    double? financialIncrement,
    double? financialDiscount,
    int? quantityOfPortions,
    String? tefSequencialUniqueNumber,
    String? tefAutorizationCreditCode,
    String? devolutionCreditCode,
    String? identificationCode,
    BSFPaymentConditionEntity? paymentCondition,
    String? creditCardNumber,
    DateTime? creditCardValidate,
    List<dynamic>? portions,
    BSFUserAuthorizationEntity? userAuthorization,
    int? code,
    double? liquidValue,
    double? totalFinancialTax,
    String? creditCardSecurityCode,
    String? observations,
  }) {
    return BSFPaymentFinalizationWrapperEntity(
      paymentFinalization: paymentFinalization ?? this.paymentFinalization,
      value: value ?? this.value,
      financialIncrement: financialIncrement ?? this.financialIncrement,
      financialDiscount: financialDiscount ?? this.financialDiscount,
      quantityOfPortions: quantityOfPortions ?? this.quantityOfPortions,
      tefSequencialUniqueNumber:
          tefSequencialUniqueNumber ?? this.tefSequencialUniqueNumber,
      tefAutorizationCreditCode:
          tefAutorizationCreditCode ?? this.tefAutorizationCreditCode,
      devolutionCreditCode: devolutionCreditCode ?? this.devolutionCreditCode,
      identificationCode: identificationCode ?? this.identificationCode,
      paymentCondition: paymentCondition ?? this.paymentCondition,
      creditCardNumber: creditCardNumber ?? this.creditCardNumber,
      creditCardValidate: creditCardValidate ?? this.creditCardValidate,
      portions: portions ?? this.portions,
      userAuthorization: userAuthorization ?? this.userAuthorization,
      code: code ?? this.code,
      liquidValue: liquidValue ?? this.liquidValue,
      totalFinancialTax: totalFinancialTax ?? this.totalFinancialTax,
      creditCardSecurityCode:
          creditCardSecurityCode ?? this.creditCardSecurityCode,
      observations: observations ?? this.observations,
    );
  }
}
