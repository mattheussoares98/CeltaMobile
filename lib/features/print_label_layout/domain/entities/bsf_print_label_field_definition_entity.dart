import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFPrintLabelFieldDefinitionEntity extends Equatable {
  final int code;
  final int personalizedCode;
  final String name;
  final String content;
  final BSFPrintLabelFieldOriginType originType;
  final BSFPrintLabelFieldType fieldType;
  final BSFPrintLabelFieldImageExtensionType logoExtensionType;
  final List<int>? logo;
  final bool applyToCustomer;
  final bool applyToCovenant;
  final bool applyToProduct;
  final bool applyToCustomerCard;
  final bool applyToSaleBilling;
  final bool applyToTransport;
  final bool applyToSaleRequestProduct;

  const BSFPrintLabelFieldDefinitionEntity({
    required this.code,
    required this.personalizedCode,
    required this.name,
    required this.content,
    required this.originType,
    required this.fieldType,
    required this.logoExtensionType,
    required this.logo,
    required this.applyToCustomer,
    required this.applyToCovenant,
    required this.applyToProduct,
    required this.applyToCustomerCard,
    required this.applyToSaleBilling,
    required this.applyToTransport,
    required this.applyToSaleRequestProduct,
  });

  @override
  List<Object?> get props => [
    code,
    personalizedCode,
    name,
    content,
    originType,
    fieldType,
    logoExtensionType,
    logo,
    applyToCustomer,
    applyToCovenant,
    applyToProduct,
    applyToCustomerCard,
    applyToSaleBilling,
    applyToTransport,
    applyToSaleRequestProduct,
  ];
}
