import '../../../../domain/entities/entities.dart';
import 'financial.dart';

class BSFPaymentFinalizationModel extends BSFPaymentFinalizationEntity {
  const BSFPaymentFinalizationModel({
    required super.paymentForm,
    required super.Description,
    required super.code,
    required super.isDeactivate,
    required super.isDeactivateString,
    required super.actionCheckType,
    required super.cardTerminalType,
    required super.planCode,
    required super.financialTax,
    required super.identificationCode,
    required super.identificationTefFlagCode,
    required super.action,
  });

  factory BSFPaymentFinalizationModel.fromJson(Map<String, dynamic> json) =>
      BSFPaymentFinalizationModel(
        paymentForm: json['PaymentForm'] != null
            ? BSFPaymentFormModel.fromJson(json['PaymentForm'])
            : null,
        Description: json['Description'],
        code: json['Code'],
        isDeactivate: json['IsDeactivate'],
        isDeactivateString: json['IsDeactivateString'],
        actionCheckType: ActionCheckType.fromValue(json['ActionCheckType']),
        cardTerminalType: CardTerminalType.fromValue(json['CardTerminalType']),
        planCode: json['PlanCode'],
        financialTax: (json['FinancialTax'] as num?)?.toDouble(),
        identificationCode: json['IdentificationCode'],
        identificationTefFlagCode: json['IdentificationTefFlagCode'],
        action: json['Action'] != null
            ? BSFPaymentActionModel.fromJson(json['Action'])
            : null,
      );

  Map<String, dynamic> toJson() => {
    'PaymentForm': paymentForm == null
        ? null
        : BSFPaymentFormModel.fromEntity(paymentForm!),
    'Description': Description,
    'Code': code,
    'IsDeactivate': isDeactivate,
    'IsDeactivateString': isDeactivateString,
    'ActionCheckType': actionCheckType?.value,
    'CardTerminalType': cardTerminalType?.value,
    'PlanCode': planCode,
    'FinancialTax': financialTax,
    'IdentificationCode': identificationCode,
    'IdentificationTefFlagCode': identificationTefFlagCode,
    'Action': action == null ? null : BSFPaymentActionModel.fromEntity(action!),
  };

  factory BSFPaymentFinalizationModel.fromEntity(
    BSFPaymentFinalizationEntity entity,
  ) => BSFPaymentFinalizationModel(
    paymentForm: entity.paymentForm == null
        ? null
        : BSFPaymentFormModel.fromEntity(entity.paymentForm!),
    Description: entity.Description,
    code: entity.code,
    isDeactivate: entity.isDeactivate,
    isDeactivateString: entity.isDeactivateString,
    actionCheckType: entity.actionCheckType,
    cardTerminalType: entity.cardTerminalType,
    planCode: entity.planCode,
    financialTax: entity.financialTax,
    identificationCode: entity.identificationCode,
    identificationTefFlagCode: entity.identificationTefFlagCode,
    action: entity.action == null
        ? null
        : BSFPaymentActionModel.fromEntity(entity.action!),
  );

  BSFPaymentFinalizationEntity toEntity() => BSFPaymentFinalizationEntity(
    paymentForm: paymentForm == null
        ? null
        : BSFPaymentFormModel.fromEntity(paymentForm!),
    Description: Description,
    code: code,
    isDeactivate: isDeactivate,
    isDeactivateString: isDeactivateString,
    actionCheckType: actionCheckType,
    cardTerminalType: cardTerminalType,
    planCode: planCode,
    financialTax: financialTax,
    identificationCode: identificationCode,
    identificationTefFlagCode: identificationTefFlagCode,
    action: action == null ? null : BSFPaymentActionModel.fromEntity(action!),
  );
}
