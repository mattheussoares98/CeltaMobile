import 'package:equatable/equatable.dart';

import '../../../../domain/entities/entities.dart';
import '../bsf.dart';

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
  final Map<String, dynamic>? paymentCondition;
  final String? creditCardNumber;
  final DateTime? creditCardValidate;
  final List<dynamic>? portions;
  final BSFUserAuthorizationModel? userAuthorization;

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

  factory BSFPaymentFinalizationWrapperModel.fromJson(
    Map<String, dynamic> json,
  ) => BSFPaymentFinalizationWrapperModel(
    paymentFinalization: json['PaymentFinalization'] != null
        ? BSFPaymentFinalizationModel.fromJson(json['PaymentFinalization'])
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
        ? BSFUserAuthorizationModel.fromJson(json['UserAuthorization'])
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
    paymentCondition: entity.paymentCondition,
    creditCardNumber: entity.creditCardNumber,
    creditCardValidate: entity.creditCardValidate,
    portions: entity.portions,
    userAuthorization: entity.userAuthorization == null
        ? null
        : BSFUserAuthorizationModel.fromEntity(entity.userAuthorization!),
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
        paymentCondition: paymentCondition,
        creditCardNumber: creditCardNumber,
        creditCardValidate: creditCardValidate,
        portions: portions,
        userAuthorization: userAuthorization?.toEntity(),
      );
}
