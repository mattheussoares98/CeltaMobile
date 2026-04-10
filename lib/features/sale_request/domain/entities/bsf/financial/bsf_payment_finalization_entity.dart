import 'package:equatable/equatable.dart';

import 'financial.dart';

class BSFPaymentFinalizationEntity extends Equatable {
  final BSFPaymentFormEntity? paymentForm;
  final String? Description;
  final int? code;
  final bool? isDeactivate;
  final String? isDeactivateString;
  final int? actionCheckType;
  final int? cardTerminalType;
  final String? planCode;
  final double? financialTax;
  final String? identificationCode;
  final String? identificationTefFlagCode;

  const BSFPaymentFinalizationEntity({
    required this.paymentForm,
    required this.Description,
    required this.code,
    required this.isDeactivate,
    required this.isDeactivateString,
    required this.actionCheckType,
    required this.cardTerminalType,
    required this.planCode,
    required this.financialTax,
    required this.identificationCode,
    required this.identificationTefFlagCode,
  });

  @override
  List<Object?> get props => [
    paymentForm,
    Description,
    code,
    isDeactivate,
    isDeactivateString,
    actionCheckType,
    cardTerminalType,
    planCode,
    financialTax,
    identificationCode,
    identificationTefFlagCode,
  ];
}
