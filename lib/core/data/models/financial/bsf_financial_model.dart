import 'package:celta_inventario/core/data/models/financial/financial.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFFinancialModel extends Equatable {
  final List<BSFPaymentFinalizationWrapperModel>? paymentFinalizations;
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

  const BSFFinancialModel({
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

  factory BSFFinancialModel.fromJson(Map json) => BSFFinancialModel(
    paymentFinalizations: json['PaymentFinalizations'] != null
        ? (json['PaymentFinalizations'] as List)
              .map((i) => BSFPaymentFinalizationWrapperModel.fromJson(i))
              .toList()
        : null,
    paybackValue: (json['PaybackValue'] as num?)?.toDouble(),
    code: json['Code'] as int?,
    representabilityType: json['RepresentabilityType'] as int?,
    financialCustomerCreditValue: (json['FinancialCustomerCreditValue'] as num?)
        ?.toDouble(),
    financialIncrementValue: (json['FinancialIncrementValue'] as num?)
        ?.toDouble(),
    financialDiscountValue: (json['FinancialDiscountValue'] as num?)
        ?.toDouble(),
    baseDateFinancial: json['BaseDateFinancial'] != null
        ? DateTime.parse(json['BaseDateFinancial'])
        : null,
    baseDateFinancialWasInformed: json['BaseDateFinancialWasInformed'] as bool?,
    financialDiscountFromREIDInformed:
        json['FinancialDiscountFromREIDInformed'] as bool?,
    administrativeTax: (json['AdministrativeTax'] as num?)?.toDouble(),
    financialTaxes: (json['FinancialTaxes'] as num?)?.toDouble(),
    totalValuePayedBrute: (json['TotalValuePayedBrute'] as num?)?.toDouble(),
    totalValuePayedLiquid: (json['TotalValuePayedLiquid'] as num?)?.toDouble(),
    totalLiquid: (json['TotalLiquid'] as num?)?.toDouble(),
    containsFiscalPart: json['ContainsFiscalPart'] as bool?,
    containsRepresentabilityFactorDifferent:
        json['ContainsRepresentabilityFactorDifferent'] as bool?,
  );

  Map<String, dynamic> toJson() => {
    'PaymentFinalizations': paymentFinalizations
        ?.map((e) => e.toJson())
        .toList(),
    'PaybackValue': paybackValue,
    'Code': code,
    'RepresentabilityType': representabilityType,
    'FinancialCustomerCreditValue': financialCustomerCreditValue,
    'FinancialIncrementValue': financialIncrementValue,
    'FinancialDiscountValue': financialDiscountValue,
    'BaseDateFinancial': baseDateFinancial?.toIso8601String(),
    'BaseDateFinancialWasInformed': baseDateFinancialWasInformed,
    'FinancialDiscountFromREIDInformed': financialDiscountFromREIDInformed,
    'AdministrativeTax': administrativeTax,
    'FinancialTaxes': financialTaxes,
    'TotalValuePayedBrute': totalValuePayedBrute,
    'TotalValuePayedLiquid': totalValuePayedLiquid,
    'TotalLiquid': totalLiquid,
    'ContainsFiscalPart': containsFiscalPart,
    'ContainsRepresentabilityFactorDifferent':
        containsRepresentabilityFactorDifferent,
  };

  factory BSFFinancialModel.fromEntity(BSFFinancialEntity entity) =>
      BSFFinancialModel(
        paymentFinalizations: entity.paymentFinalizations
            ?.map((e) => BSFPaymentFinalizationWrapperModel.fromEntity(e))
            .toList(),
        paybackValue: entity.paybackValue,
        code: entity.code,
        representabilityType: entity.representabilityType,
        financialCustomerCreditValue: entity.financialCustomerCreditValue,
        financialIncrementValue: entity.financialIncrementValue,
        financialDiscountValue: entity.financialDiscountValue,
        baseDateFinancial: entity.baseDateFinancial,
        baseDateFinancialWasInformed: entity.baseDateFinancialWasInformed,
        financialDiscountFromREIDInformed:
            entity.financialDiscountFromREIDInformed,
        administrativeTax: entity.administrativeTax,
        financialTaxes: entity.financialTaxes,
        totalValuePayedBrute: entity.totalValuePayedBrute,
        totalValuePayedLiquid: entity.totalValuePayedLiquid,
        totalLiquid: entity.totalLiquid,
        containsFiscalPart: entity.containsFiscalPart,
        containsRepresentabilityFactorDifferent:
            entity.containsRepresentabilityFactorDifferent,
      );

  BSFFinancialEntity toEntity() => BSFFinancialEntity(
    paymentFinalizations: paymentFinalizations
        ?.map((e) => e.toEntity())
        .toList(),
    paybackValue: paybackValue,
    code: code,
    representabilityType: representabilityType,
    financialCustomerCreditValue: financialCustomerCreditValue,
    financialIncrementValue: financialIncrementValue,
    financialDiscountValue: financialDiscountValue,
    baseDateFinancial: baseDateFinancial,
    baseDateFinancialWasInformed: baseDateFinancialWasInformed,
    financialDiscountFromREIDInformed: financialDiscountFromREIDInformed,
    administrativeTax: administrativeTax,
    financialTaxes: financialTaxes,
    totalValuePayedBrute: totalValuePayedBrute,
    totalValuePayedLiquid: totalValuePayedLiquid,
    totalLiquid: totalLiquid,
    containsFiscalPart: containsFiscalPart,
    containsRepresentabilityFactorDifferent:
        containsRepresentabilityFactorDifferent,
  );
}
