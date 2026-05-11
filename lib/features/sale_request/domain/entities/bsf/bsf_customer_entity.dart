import 'package:equatable/equatable.dart';

import 'bsf.dart';

class BSFCustomerEntity extends Equatable {
  final String? personalizedCode;
  final int? code;
  final String? name;
  final String? nameReduced;
  final String? cnpjCpfNumber;
  final String? suframaCode;
  final double? limitOfPurchase;
  final String? inscriptionRgNumber;
  final List<BSFPaymentFinalizationEntity>? paymentFinalizations;
  final List<BSFPaymentConditionEntity>? paymentConditions;

  const BSFCustomerEntity({
    required this.personalizedCode,
    required this.code,
    required this.name,
    required this.nameReduced,
    required this.cnpjCpfNumber,
    required this.suframaCode,
    required this.limitOfPurchase,
    required this.inscriptionRgNumber,
    required this.paymentFinalizations,
    required this.paymentConditions,
  });

  @override
  List<Object?> get props => [
    cnpjCpfNumber,
    name,
    code,
    personalizedCode,
    nameReduced,
    suframaCode,
    limitOfPurchase,
    inscriptionRgNumber,
    paymentFinalizations,
    paymentConditions,
  ];
}
