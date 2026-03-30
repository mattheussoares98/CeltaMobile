import 'package:equatable/equatable.dart';

import '../bsf.dart';

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
  final Map<String, dynamic>? paymentCondition;
  final String? creditCardNumber;
  final DateTime? creditCardValidate;
  final List<dynamic>? portions;
  final BSFUserAuthorizationEntity? userAuthorization;

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
  ];
}
