import 'dart:convert';

import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

class BSFPrintLabelFieldDefinitionModel
    extends BSFPrintLabelFieldDefinitionEntity {
  const BSFPrintLabelFieldDefinitionModel({
    required super.code,
    required super.personalizedCode,
    required super.name,
    required super.content,
    required super.originType,
    required super.fieldType,
    required super.logoExtensionType,
    required super.logo,
    required super.applyToCustomer,
    required super.applyToCovenant,
    required super.applyToProduct,
    required super.applyToCustomerCard,
    required super.applyToSaleBilling,
    required super.applyToTransport,
    required super.applyToSaleRequestProduct,
  });

  factory BSFPrintLabelFieldDefinitionModel.fromJson(Map json) {
    final encodedLogo = json['logo'] as String?;

    return BSFPrintLabelFieldDefinitionModel(
      code: (json['code'] as num).toInt(),
      personalizedCode: (json['personalizedCode'] as num).toInt(),
      name: json['name'] as String,
      content: json['content'] as String,
      originType: BSFPrintLabelFieldOriginType.fromJson(json['originType']),
      fieldType: BSFPrintLabelFieldType.fromJson(json['fieldType']),
      logoExtensionType: BSFPrintLabelFieldImageExtensionType.fromJson(
        json['logoExtensionType'],
      ),
      logo: encodedLogo == null ? null : base64Decode(encodedLogo),
      applyToCustomer: json['applyToCustomer'] as bool,
      applyToCovenant: json['applyToCovenant'] as bool,
      applyToProduct: json['applyToProduct'] as bool,
      applyToCustomerCard: json['applyToCustomerCard'] as bool,
      applyToSaleBilling: json['applyToSaleBilling'] as bool,
      applyToTransport: json['applyToTransport'] as bool,
      applyToSaleRequestProduct: json['applyToSaleRequestProduct'] as bool,
    );
  }

  factory BSFPrintLabelFieldDefinitionModel.fromEntity(
    BSFPrintLabelFieldDefinitionEntity entity,
  ) {
    return BSFPrintLabelFieldDefinitionModel(
      code: entity.code,
      personalizedCode: entity.personalizedCode,
      name: entity.name,
      content: entity.content,
      originType: entity.originType,
      fieldType: entity.fieldType,
      logoExtensionType: entity.logoExtensionType,
      logo: entity.logo,
      applyToCustomer: entity.applyToCustomer,
      applyToCovenant: entity.applyToCovenant,
      applyToProduct: entity.applyToProduct,
      applyToCustomerCard: entity.applyToCustomerCard,
      applyToSaleBilling: entity.applyToSaleBilling,
      applyToTransport: entity.applyToTransport,
      applyToSaleRequestProduct: entity.applyToSaleRequestProduct,
    );
  }

  Map toJson() => {
    'code': code,
    'personalizedCode': personalizedCode,
    'name': name,
    'content': content,
    'originType': originType.toJson(),
    'fieldType': fieldType.toJson(),
    'logoExtensionType': logoExtensionType.toJson(),
    'logo': logo == null ? null : base64Encode(logo!),
    'applyToCustomer': applyToCustomer,
    'applyToCovenant': applyToCovenant,
    'applyToProduct': applyToProduct,
    'applyToCustomerCard': applyToCustomerCard,
    'applyToSaleBilling': applyToSaleBilling,
    'applyToTransport': applyToTransport,
    'applyToSaleRequestProduct': applyToSaleRequestProduct,
  };

  BSFPrintLabelFieldDefinitionEntity toEntity() {
    return BSFPrintLabelFieldDefinitionEntity(
      code: code,
      personalizedCode: personalizedCode,
      name: name,
      content: content,
      originType: originType,
      fieldType: fieldType,
      logoExtensionType: logoExtensionType,
      logo: logo,
      applyToCustomer: applyToCustomer,
      applyToCovenant: applyToCovenant,
      applyToProduct: applyToProduct,
      applyToCustomerCard: applyToCustomerCard,
      applyToSaleBilling: applyToSaleBilling,
      applyToTransport: applyToTransport,
      applyToSaleRequestProduct: applyToSaleRequestProduct,
    );
  }
}
