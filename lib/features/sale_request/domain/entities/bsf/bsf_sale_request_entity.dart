import 'package:equatable/equatable.dart';

import '../../../../../core/domain/entities/entities.dart';
import '../entities.dart';

class BSFSaleRequestEntity extends Equatable {
  final int? code;
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
    required this.code,
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
    code,
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

  factory BSFSaleRequestEntity.empty() => const BSFSaleRequestEntity(
    code: null,
    dateOfEmission: null,
    dateOfDelivery: null,
    dateOfExpiration: null,
    dateOfExclusion: null,
    personalizedCode: null,
    instructions: null,
    observations: null,
    financials: null,
    requestType: null,
    enterprise: null,
    customer: null,
    deliveryAddress: null,
    deliveryTax: null,
    increment: null,
    financialIncrement: null,
    financialDiscount: null,
    totalLiquid: null,
    expeditionControlCode: null,
    isOnExpedition: null,
    freight: null,
    products: null,
    discounts: null,
  );

  BSFSaleRequestEntity copyWith({
    int? code,
    DateTime? dateOfEmission,
    DateTime? dateOfDelivery,
    DateTime? dateOfExpiration,
    DateTime? dateOfExclusion,
    String? personalizedCode,
    String? instructions,
    String? observations,
    List<BSFFinancialEntity>? financials,
    BSFRequestTypeEntity? requestType,
    BSFEnterpriseEntity? enterprise,
    BSFCustomerEntity? customer,
    BSFDeliveryAddressEntity? deliveryAddress,
    BSFDeliveryTaxWrapperEntity? deliveryTax,
    BSFValueTypeEntity? increment,
    BSFValueTypeEntity? financialIncrement,
    BSFValueTypeEntity? financialDiscount,
    double? totalLiquid,
    int? expeditionControlCode,
    bool? isOnExpedition,
    BSFFreightEntity? freight,
    List<BSFProductItemEntity>? products,
    List<BSFDiscountEntity>? discounts,
  }) {
    return BSFSaleRequestEntity(
      code: code ?? this.code,
      dateOfEmission: dateOfEmission ?? this.dateOfEmission,
      dateOfDelivery: dateOfDelivery ?? this.dateOfDelivery,
      dateOfExpiration: dateOfExpiration ?? this.dateOfExpiration,
      dateOfExclusion: dateOfExclusion ?? this.dateOfExclusion,
      personalizedCode: personalizedCode ?? this.personalizedCode,
      instructions: instructions ?? this.instructions,
      observations: observations ?? this.observations,
      financials: financials ?? this.financials,
      requestType: requestType ?? this.requestType,
      enterprise: enterprise ?? this.enterprise,
      customer: customer ?? this.customer,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryTax: deliveryTax ?? this.deliveryTax,
      increment: increment ?? this.increment,
      financialIncrement: financialIncrement ?? this.financialIncrement,
      financialDiscount: financialDiscount ?? this.financialDiscount,
      totalLiquid: totalLiquid ?? this.totalLiquid,
      expeditionControlCode:
          expeditionControlCode ?? this.expeditionControlCode,
      isOnExpedition: isOnExpedition ?? this.isOnExpedition,
      freight: freight ?? this.freight,
      products: products ?? this.products,
      discounts: discounts ?? this.discounts,
    );
  }

  double get totalProductsLiquid {
    if (products == null) return 0;

    return products!.fold(0.0, (p, n) {
      return p + n.totalLiquid;
    });
  }

  double get totalProductsBrut {
    if (products == null) return 0;

    return products!.fold(0.0, (p, n) {
      return p + ((n.quantity ?? 0) * (n.value ?? 0));
    });
  }

  double get totalFreight {
    //! total products (liquid) freight + sale request freight
    final totalProductsDeliveryTax = products!.fold(0.0, (p, n) {
      return p + n.totalDeliveryTax;
    });

    final totalSaleRequest = deliveryTax?.deliveryTax?.calculateItemValue(
      totalProductsLiquid,
    );

    return totalProductsDeliveryTax + (totalSaleRequest ?? 0.0);
  }

  double get totalIncrement {
    //! total products (brut) increment + total products (liquid) increment
    final totalBrutIncrement = products!.fold(0.0, (p, n) {
      return p + n.totalIncrement;
    });

    final totalLiquidIncrement = increment?.calculateItemValue(
      totalProductsLiquid,
    );

    return totalBrutIncrement + (totalLiquidIncrement ?? 0.0);
  }

  double get totalDiscount {
    //! total products liquid (apply the sale request discount) + total products discount
    final totalProductsDiscount = products!.fold(0.0, (p, n) {
      return p + n.totalDiscountValue;
    });

    double totalSaleRequestDiscount = 0;
    double baseValue = totalProductsLiquid;
    for (var discount in discounts ?? <BSFDiscountEntity>[]) {
      final itemDiscount =
          (discount.discount?.calculateItemValue(baseValue) ?? 0);
      baseValue -= itemDiscount;
      totalSaleRequestDiscount += itemDiscount;
    }

    return totalProductsDiscount + totalSaleRequestDiscount;
  }
}
