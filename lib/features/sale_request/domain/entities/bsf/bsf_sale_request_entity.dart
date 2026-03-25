import 'package:equatable/equatable.dart';

import 'bsf.dart';

class BSFSalesRequestEntity extends Equatable {
  final DateTime? dateOfEmission;
  final DateTime? dateOfDelivery;
  final DateTime? dateOfExpiration;
  final DateTime? dateOfExclusion;
  final String? personalizedCode;
  final String? instructions;
  final String? observations;
  final List<BSFFinancialEntity>? financials;
  final BSFRequestTypeEntity? requestType;
  final BSFEnterpriseEntity? enterprise;
  final BSFCustomerEntity? customer;
  final BSFDeliveryAddressEntity? deliveryAddress;
  final BSFDeliveryTaxWrapperEntity? deliveryTax;
  final BSFValueTypeEntity? increment;
  final BSFValueTypeEntity? financialIncrement;
  final BSFValueTypeEntity? financialDiscount;
  final double? totalLiquid;
  final int? expeditionControlCode;
  final bool? isOnExpedition;
  final BSFFreightEntity? freight;
  final List<BSFProductItemEntity>? products;
  final List<dynamic>? discounts;

  const BSFSalesRequestEntity({
    required this.dateOfEmission,
    required this.dateOfDelivery,
    required this.dateOfExpiration,
    required this.dateOfExclusion,
    required this.personalizedCode,
    required this.instructions,
    required this.observations,
    required this.financials,
    required this.requestType,
    required this.enterprise,
    required this.customer,
    required this.deliveryAddress,
    required this.deliveryTax,
    required this.increment,
    required this.financialIncrement,
    required this.financialDiscount,
    required this.totalLiquid,
    required this.expeditionControlCode,
    required this.isOnExpedition,
    required this.freight,
    required this.products,
    required this.discounts,
  });

  @override
  List<Object?> get props => [
    personalizedCode,
    totalLiquid,
    products,
    financials,
  ];
}
