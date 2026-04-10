import '../../../domain/entities/entities.dart';

class BSFPaymentFinalizationModel
    extends BSFRequestTypePaymentFinalizationEntity {
  const BSFPaymentFinalizationModel({
    super.code,
    super.description,
    super.planCode,
    super.identificationCode,
    super.identificationTefFlagCode,
    super.isDeactivated,
    super.actionCheckType,
    super.cardTerminalType,
    super.financialTax,
  });

  factory BSFPaymentFinalizationModel.fromJson(Map<String, dynamic> json) {
    return BSFPaymentFinalizationModel(
      code: json['Code'],
      description: json['Description'],
      planCode: json['PlanCode'],
      identificationCode: json['IdentificationCode'],
      identificationTefFlagCode: json['IdentificationTefFlagCode'],
      isDeactivated: json['IsDeactivated'] ?? json['IsDeactivate'],
      actionCheckType: json['ActionCheckType'],
      cardTerminalType: json['CardTerminalType'],
      financialTax: json['FinancialTax']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Code': code,
      'Description': description,
      'PlanCode': planCode,
      'IdentificationCode': identificationCode,
      'IdentificationTefFlagCode': identificationTefFlagCode,
      'IsDeactivated': isDeactivated,
      'ActionCheckType': actionCheckType,
      'CardTerminalType': cardTerminalType,
      'FinancialTax': financialTax,
    };
  }

  factory BSFPaymentFinalizationModel.fromEntity(
    BSFRequestTypePaymentFinalizationEntity entity,
  ) {
    return BSFPaymentFinalizationModel(
      code: entity.code,
      description: entity.description,
      planCode: entity.planCode,
      identificationCode: entity.identificationCode,
      identificationTefFlagCode: entity.identificationTefFlagCode,
      isDeactivated: entity.isDeactivated,
      actionCheckType: entity.actionCheckType,
      cardTerminalType: entity.cardTerminalType,
      financialTax: entity.financialTax,
    );
  }

  BSFRequestTypePaymentFinalizationEntity toEntity() {
    return BSFRequestTypePaymentFinalizationEntity(
      code: code,
      description: description,
      planCode: planCode,
      identificationCode: identificationCode,
      identificationTefFlagCode: identificationTefFlagCode,
      isDeactivated: isDeactivated,
      actionCheckType: actionCheckType,
      cardTerminalType: cardTerminalType,
      financialTax: financialTax,
    );
  }
}
