import 'package:equatable/equatable.dart';

import '../entities.dart';

class BSFSaleRequestEntity extends Equatable {
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
  final List<BSFDiscountEntity>? discounts;

  const BSFSaleRequestEntity({
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
    dateOfEmission,
    dateOfDelivery,
    dateOfExpiration,
    dateOfExclusion,
    personalizedCode,
    instructions,
    observations,
    financials,
    requestType,
    enterprise,
    customer,
    deliveryAddress,
    deliveryTax,
    increment,
    financialIncrement,
    financialDiscount,
    totalLiquid,
    expeditionControlCode,
    isOnExpedition,
    freight,
    products,
    discounts,
  ];

  double get _totalProductsLiquid {
    if (products == null) return 0;

    return products!.fold(0.0, (p, n) {
      return p + n.totalLiquid;
    });
  }

  double get totalFreight {
    //! total products (liquid) freight + sale request freight
    final totalProductsDeliveryTax = products!.fold(0.0, (p, n) {
      return p + n.totalDeliveryTax;
    });

    final totalSaleRequest = deliveryTax?.deliveryTax?.calculateItemValue(
      _totalProductsLiquid,
      isSum: true,
    );

    return totalProductsDeliveryTax + (totalSaleRequest ?? 0.0);
  }

  double get totalIncrement {
    //! total products (brut) increment + total products (liquid) increment
    final totalBrutIncrement = products!.fold(0.0, (p, n) {
      return p + n.totalIncrement;
    });

    final totalLiquidIncrement = increment?.calculateItemValue(
      _totalProductsLiquid,
    );

    return totalBrutIncrement + (totalLiquidIncrement ?? 0.0);
  }
}
