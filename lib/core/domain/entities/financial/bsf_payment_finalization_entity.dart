import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/financial/financial.dart';

class BSFPaymentFinalizationEntity extends Equatable {
  final BSFPaymentFormEntity? paymentForm;
  final String? Description;
  final int? code;
  final bool? isDeactivate;
  final String? isDeactivateString;
  final ActionCheckType? actionCheckType;
  final CardTerminalType? cardTerminalType;
  final String? planCode;
  final double? financialTax;
  final String? identificationCode;
  final String? identificationTefFlagCode;
  final BSFPaymentActionEntity? action;

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
    required this.action,
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
    action,
  ];

  BSFPaymentFinalizationEntity copyWith({
    BSFPaymentFormEntity? paymentForm,
    String? Description,
    int? code,
    bool? isDeactivate,
    String? isDeactivateString,
    ActionCheckType? actionCheckType,
    CardTerminalType? cardTerminalType,
    String? planCode,
    double? financialTax,
    String? identificationCode,
    String? identificationTefFlagCode,
    BSFPaymentActionEntity? action,
  }) {
    return BSFPaymentFinalizationEntity(
      paymentForm: paymentForm ?? this.paymentForm,
      Description: Description ?? this.Description,
      code: code ?? this.code,
      isDeactivate: isDeactivate ?? this.isDeactivate,
      isDeactivateString: isDeactivateString ?? this.isDeactivateString,
      actionCheckType: actionCheckType ?? this.actionCheckType,
      cardTerminalType: cardTerminalType ?? this.cardTerminalType,
      planCode: planCode ?? this.planCode,
      financialTax: financialTax ?? this.financialTax,
      identificationCode: identificationCode ?? this.identificationCode,
      identificationTefFlagCode:
          identificationTefFlagCode ?? this.identificationTefFlagCode,
      action: action ?? this.action,
    );
  }
}
