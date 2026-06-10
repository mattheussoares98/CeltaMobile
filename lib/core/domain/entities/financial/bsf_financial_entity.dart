import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/financial/financial.dart';

class BSFFinancialEntity extends Equatable {
  final List<BSFPaymentFinalizationWrapperEntity>? paymentFinalizations;
  final double? paybackValue;
  final int? code;
  final int? representabilityType;
  final double? financialCustomerCreditValue;
  final double? financialIncrementValue;
  final double? financialDiscountValue;
  final DateTime? baseDateFinancial;
  final bool? baseDateFinancialWasInformed;
  final bool? financialDiscountFromREIDInformed;
  final double? administrativeTax;
  final double? financialTaxes;
  final double? totalValuePayedBrute;
  final double? totalValuePayedLiquid;
  final double? totalLiquid;
  final bool? containsFiscalPart;
  final bool? containsRepresentabilityFactorDifferent;

  const BSFFinancialEntity({
    required this.paymentFinalizations,
    required this.paybackValue,
    this.code,
    this.representabilityType,
    this.financialCustomerCreditValue,
    this.financialIncrementValue,
    this.financialDiscountValue,
    this.baseDateFinancial,
    this.baseDateFinancialWasInformed,
    this.financialDiscountFromREIDInformed,
    this.administrativeTax,
    this.financialTaxes,
    this.totalValuePayedBrute,
    this.totalValuePayedLiquid,
    this.totalLiquid,
    this.containsFiscalPart,
    this.containsRepresentabilityFactorDifferent,
  });

  @override
  List<Object?> get props => [
        paymentFinalizations,
        paybackValue,
        code,
        representabilityType,
        financialCustomerCreditValue,
        financialIncrementValue,
        financialDiscountValue,
        baseDateFinancial,
        baseDateFinancialWasInformed,
        financialDiscountFromREIDInformed,
        administrativeTax,
        financialTaxes,
        totalValuePayedBrute,
        totalValuePayedLiquid,
        totalLiquid,
        containsFiscalPart,
        containsRepresentabilityFactorDifferent,
      ];

  BSFFinancialEntity copyWith({
    List<BSFPaymentFinalizationWrapperEntity>? paymentFinalizations,
    double? paybackValue,
    int? code,
    int? representabilityType,
    double? financialCustomerCreditValue,
    double? financialIncrementValue,
    double? financialDiscountValue,
    DateTime? baseDateFinancial,
    bool? baseDateFinancialWasInformed,
    bool? financialDiscountFromREIDInformed,
    double? administrativeTax,
    double? financialTaxes,
    double? totalValuePayedBrute,
    double? totalValuePayedLiquid,
    double? totalLiquid,
    bool? containsFiscalPart,
    bool? containsRepresentabilityFactorDifferent,
  }) {
    return BSFFinancialEntity(
      paymentFinalizations: paymentFinalizations ?? this.paymentFinalizations,
      paybackValue: paybackValue ?? this.paybackValue,
      code: code ?? this.code,
      representabilityType: representabilityType ?? this.representabilityType,
      financialCustomerCreditValue:
          financialCustomerCreditValue ?? this.financialCustomerCreditValue,
      financialIncrementValue:
          financialIncrementValue ?? this.financialIncrementValue,
      financialDiscountValue:
          financialDiscountValue ?? this.financialDiscountValue,
      baseDateFinancial: baseDateFinancial ?? this.baseDateFinancial,
      baseDateFinancialWasInformed:
          baseDateFinancialWasInformed ?? this.baseDateFinancialWasInformed,
      financialDiscountFromREIDInformed: financialDiscountFromREIDInformed ??
          this.financialDiscountFromREIDInformed,
      administrativeTax: administrativeTax ?? this.administrativeTax,
      financialTaxes: financialTaxes ?? this.financialTaxes,
      totalValuePayedBrute: totalValuePayedBrute ?? this.totalValuePayedBrute,
      totalValuePayedLiquid:
          totalValuePayedLiquid ?? this.totalValuePayedLiquid,
      totalLiquid: totalLiquid ?? this.totalLiquid,
      containsFiscalPart: containsFiscalPart ?? this.containsFiscalPart,
      containsRepresentabilityFactorDifferent:
          containsRepresentabilityFactorDifferent ??
              this.containsRepresentabilityFactorDifferent,
    );
  }
}
