import 'package:equatable/equatable.dart';

import 'ec_complete.dart';

class EcCompleteSalesRequestModel extends Equatable {
  final DateTime? dateOfEmission;
  final DateTime? dateOfDelivery;
  final DateTime? dateOfExpiration;
  final DateTime? dateOfExclusion;
  final String? personalizedCode;
  final String? instructions;
  final String? observations;
  final List<EcCompleteFinancialModel>? financials;
  final EcCompleteRequestTypeModel? requestType;
  final EcCompleteEnterpriseModel? enterprise;
  final EcCompleteCustomerModel? customer;
  final EcCompleteDeliveryAddressModel? deliveryAddress;
  final EcCompleteDeliveryTaxWrapperModel? deliveryTax;
  final EcCompleteValueTypeModel? increment;
  final EcCompleteValueTypeModel? financialIncrement;
  final EcCompleteValueTypeModel? financialDiscount;
  final double? totalLiquid;
  final int? expeditionControlCode;
  final bool? isOnExpedition;
  final EcCompleteFreightModel? freight;
  final List<EcCompleteProductItemModel>? products;
  final List<dynamic>? discounts;

  const EcCompleteSalesRequestModel({
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

  factory EcCompleteSalesRequestModel.fromJson(Map<String, dynamic> json) {
    return EcCompleteSalesRequestModel(
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
                .map((i) => EcCompleteFinancialModel.fromJson(i))
                .toList()
          : null,
      requestType: json['RequestType'] != null
          ? EcCompleteRequestTypeModel.fromJson(json['RequestType'])
          : null,
      enterprise: json['Enterprise'] != null
          ? EcCompleteEnterpriseModel.fromJson(json['Enterprise'])
          : null,
      customer: json['Customer'] != null
          ? EcCompleteCustomerModel.fromJson(json['Customer'])
          : null,
      deliveryAddress: json['DeliveryAddress'] != null
          ? EcCompleteDeliveryAddressModel.fromJson(json['DeliveryAddress'])
          : null,
      deliveryTax: json['DeliveryTax'] != null
          ? EcCompleteDeliveryTaxWrapperModel.fromJson(json['DeliveryTax'])
          : null,
      increment: json['Increment'] != null
          ? EcCompleteValueTypeModel.fromJson(json['Increment'])
          : null,
      financialIncrement: json['FinancialIncrement'] != null
          ? EcCompleteValueTypeModel.fromJson(json['FinancialIncrement'])
          : null,
      financialDiscount: json['FinancialDiscount'] != null
          ? EcCompleteValueTypeModel.fromJson(json['FinancialDiscount'])
          : null,
      totalLiquid: (json['TotalLiquid'] as num?)?.toDouble(),
      expeditionControlCode: json['ExpeditionControlCode'],
      isOnExpedition: json['IsOnExpedition'],
      freight: json['Freight'] != null
          ? EcCompleteFreightModel.fromJson(json['Freight'])
          : null,
      products: json['Products'] != null
          ? (json['Products'] as List)
                .map((i) => EcCompleteProductItemModel.fromJson(i))
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
