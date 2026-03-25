import 'package:equatable/equatable.dart';

import 'bsf.dart';

class BSFSalesRequestModel extends Equatable {
  final DateTime? dateOfEmission;
  final DateTime? dateOfDelivery;
  final DateTime? dateOfExpiration;
  final DateTime? dateOfExclusion;
  final String? personalizedCode;
  final String? instructions;
  final String? observations;
  final List<BSFFinancialModel>? financials;
  final BSFRequestTypeModel? requestType;
  final BSFEnterpriseModel? enterprise;
  final BSFCustomerModel? customer;
  final BSFDeliveryAddressModel? deliveryAddress;
  final BSFDeliveryTaxWrapperModel? deliveryTax;
  final BSFValueTypeModel? increment;
  final BSFValueTypeModel? financialIncrement;
  final BSFValueTypeModel? financialDiscount;
  final double? totalLiquid;
  final int? expeditionControlCode;
  final bool? isOnExpedition;
  final BSFFreightModel? freight;
  final List<BSFProductItemModel>? products;
  final List<dynamic>? discounts;

  const BSFSalesRequestModel({
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

  factory BSFSalesRequestModel.fromJson(Map<String, dynamic> json) {
    return BSFSalesRequestModel(
      dateOfEmission: json['DateOfEmission'] != null
          ? DateTime.parse(json['DateOfEmission'])
          : null,
      dateOfDelivery: json['DateOfDelivery'] != null
          ? DateTime.parse(json['DateOfDelivery'])
          : null,
      dateOfExpiration: json['DateOfExpiration'] != null
          ? DateTime.parse(json['DateOfExpiration'])
          : null,
      dateOfExclusion: json['DateOfExclusion'] != null
          ? DateTime.parse(json['DateOfExclusion'])
          : null,
      personalizedCode: json['PersonalizedCode'],
      instructions: json['Instructions'],
      observations: json['Observations'],
      financials: json['Financials'] != null
          ? (json['Financials'] as List)
                .map((i) => BSFFinancialModel.fromJson(i))
                .toList()
          : null,
      requestType: json['RequestType'] != null
          ? BSFRequestTypeModel.fromJson(json['RequestType'])
          : null,
      enterprise: json['Enterprise'] != null
          ? BSFEnterpriseModel.fromJson(json['Enterprise'])
          : null,
      customer: json['Customer'] != null
          ? BSFCustomerModel.fromJson(json['Customer'])
          : null,
      deliveryAddress: json['DeliveryAddress'] != null
          ? BSFDeliveryAddressModel.fromJson(json['DeliveryAddress'])
          : null,
      deliveryTax: json['DeliveryTax'] != null
          ? BSFDeliveryTaxWrapperModel.fromJson(json['DeliveryTax'])
          : null,
      increment: json['Increment'] != null
          ? BSFValueTypeModel.fromJson(json['Increment'])
          : null,
      financialIncrement: json['FinancialIncrement'] != null
          ? BSFValueTypeModel.fromJson(json['FinancialIncrement'])
          : null,
      financialDiscount: json['FinancialDiscount'] != null
          ? BSFValueTypeModel.fromJson(json['FinancialDiscount'])
          : null,
      totalLiquid: (json['TotalLiquid'] as num?)?.toDouble(),
      expeditionControlCode: json['ExpeditionControlCode'],
      isOnExpedition: json['IsOnExpedition'],
      freight: json['Freight'] != null
          ? BSFFreightModel.fromJson(json['Freight'])
          : null,
      products: json['Products'] != null
          ? (json['Products'] as List)
                .map((i) => BSFProductItemModel.fromJson(i))
                .toList()
          : null,
      discounts: json['Discounts'],
    );
  }

  Map<String, dynamic> toJson() => {
    'DateOfEmission': dateOfEmission?.toIso8601String(),
    'DateOfDelivery': dateOfDelivery?.toIso8601String(),
    'DateOfExpiration': dateOfExpiration?.toIso8601String(),
    'DateOfExclusion': dateOfExclusion?.toIso8601String(),
    'PersonalizedCode': personalizedCode,
    'Instructions': instructions,
    'Observations': observations,
    'Financials': financials?.map((e) => e.toJson()).toList(),
    'RequestType': requestType?.toJson(),
    'Enterprise': enterprise?.toJson(),
    'Customer': customer?.toJson(),
    'DeliveryAddress': deliveryAddress?.toJson(),
    'DeliveryTax': deliveryTax?.toJson(),
    'Increment': increment?.toJson(),
    'FinancialIncrement': financialIncrement?.toJson(),
    'FinancialDiscount': financialDiscount?.toJson(),
    'TotalLiquid': totalLiquid,
    'ExpeditionControlCode': expeditionControlCode,
    'IsOnExpedition': isOnExpedition,
    'Freight': freight?.toJson(),
    'Products': products?.map((e) => e.toJson()).toList(),
    'Discounts': discounts,
  };

  @override
  List<Object?> get props => [
    personalizedCode,
    totalLiquid,
    products,
    financials,
  ];
}
