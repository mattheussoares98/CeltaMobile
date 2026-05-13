import 'package:equatable/equatable.dart';

import '../../entities.dart';

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
  final BsfSaleBlockadeEntity? saleBlockade;
  final BsfSaleBlockadeInstructionEntity? saleBlockadeInstruction;
  final List<BsfCovenantEntity>? covenants;

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
    required this.saleBlockade,
    required this.saleBlockadeInstruction,
    required this.covenants,
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
        saleBlockade,
        saleBlockadeInstruction,
        covenants,
      ];

  BSFCustomerEntity copyWith({
    String? personalizedCode,
    int? code,
    String? name,
    String? nameReduced,
    String? cnpjCpfNumber,
    String? suframaCode,
    double? limitOfPurchase,
    String? inscriptionRgNumber,
    List<BSFPaymentFinalizationEntity>? paymentFinalizations,
    List<BSFPaymentConditionEntity>? paymentConditions,
    BsfSaleBlockadeEntity? saleBlockade,
    BsfSaleBlockadeInstructionEntity? saleBlockadeInstruction,
    List<BsfCovenantEntity>? covenants,
  }) {
    return BSFCustomerEntity(
      personalizedCode: personalizedCode ?? this.personalizedCode,
      code: code ?? this.code,
      name: name ?? this.name,
      nameReduced: nameReduced ?? this.nameReduced,
      cnpjCpfNumber: cnpjCpfNumber ?? this.cnpjCpfNumber,
      suframaCode: suframaCode ?? this.suframaCode,
      limitOfPurchase: limitOfPurchase ?? this.limitOfPurchase,
      inscriptionRgNumber: inscriptionRgNumber ?? this.inscriptionRgNumber,
      paymentFinalizations: paymentFinalizations ?? this.paymentFinalizations,
      paymentConditions: paymentConditions ?? this.paymentConditions,
      saleBlockade: saleBlockade ?? this.saleBlockade,
      saleBlockadeInstruction:
          saleBlockadeInstruction ?? this.saleBlockadeInstruction,
      covenants: covenants ?? this.covenants,
    );
  }
}
