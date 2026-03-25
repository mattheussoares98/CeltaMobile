import 'package:equatable/equatable.dart';

import '../ec_complete.dart';

class EcCompletePaymentFinalizationWrapperModel extends Equatable {
  final EcCompletePaymentFinalizationModel? paymentFinalization;
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
  final EcCompleteUserAuthorizationModel? userAuthorization;

  const EcCompletePaymentFinalizationWrapperModel({
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

  factory EcCompletePaymentFinalizationWrapperModel.fromJson(
    Map<String, dynamic> json,
  ) => EcCompletePaymentFinalizationWrapperModel(
    paymentFinalization: json['PaymentFinalization'] != null
        ? EcCompletePaymentFinalizationModel.fromJson(
            json['PaymentFinalization'],
          )
        : null,
    value: (json['Value'] as num?)?.toDouble(),
    financialIncrement: (json['FinancialIncrement'] as num?)?.toDouble(),
    financialDiscount: (json['FinancialDiscount'] as num?)?.toDouble(),
    quantityOfPortions: json['QuantityOfPortions'],
    tefSequencialUniqueNumber: json['TefSequencialUniqueNumber'],
    tefAutorizationCreditCode: json['TefAutorizationCreditCode'],
    devolutionCreditCode: json['DevolutionCreditCode'],
    identificationCode: json['IdentificationCode'],
    paymentCondition: json['PaymentCondition'],
    creditCardNumber: json['CreditCardNumber'],
    creditCardValidate: json['CreditCardValidate'] != null
        ? DateTime.parse(json['CreditCardValidate'])
        : null,
    portions: json['Portions'],
    userAuthorization: json['UserAuthorization'] != null
        ? EcCompleteUserAuthorizationModel.fromJson(json['UserAuthorization'])
        : null,
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
    'PaymentCondition': paymentCondition,
    'CreditCardNumber': creditCardNumber,
    'CreditCardValidate': creditCardValidate?.toIso8601String(),
    'Portions': portions,
    'UserAuthorization': userAuthorization?.toJson(),
  };

  @override
  List<Object?> get props => [value, paymentFinalization];
}
