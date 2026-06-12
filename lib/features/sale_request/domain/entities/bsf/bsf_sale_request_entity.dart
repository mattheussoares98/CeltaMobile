import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

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
  final BSFAddressEntity? deliveryAddress;
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
  final BSFEmployeeEntity? seller;

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
    required this.seller,
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
    seller,
  ];

  factory BSFSaleRequestEntity.empty() => BSFSaleRequestEntity(
    code: null,
    dateOfEmission: null,
    dateOfDelivery: null,
    dateOfExpiration: null,
    dateOfExclusion: null,
    personalizedCode: null,
    instructions: null,
    observations: null,
    financials: null,
    requestType: BSFRequestTypeEntity.empty().copyWith(
      unitValueType: PracticedPriceType.retail,
    ),
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
    seller: null,
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
    BSFAddressEntity? deliveryAddress,
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
    bool? annulIncrement,
    bool? annulDeliveryTax,
    bool? annulCustomer,
    bool? annulSeller,
    bool? annulDiscounts,
    bool? annulProducts,
    bool? annulRequestType,
    BSFEmployeeEntity? seller,
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
      requestType: annulRequestType == true
          ? null
          : requestType ?? this.requestType,
      enterprise: enterprise ?? this.enterprise,
      customer: annulCustomer == true ? null : customer ?? this.customer,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryTax: annulDeliveryTax == true
          ? null
          : deliveryTax ?? this.deliveryTax,
      increment: annulIncrement == true ? null : increment ?? this.increment,
      financialIncrement: financialIncrement ?? this.financialIncrement,
      financialDiscount: financialDiscount ?? this.financialDiscount,
      totalLiquid: totalLiquid ?? this.totalLiquid,
      expeditionControlCode:
          expeditionControlCode ?? this.expeditionControlCode,
      isOnExpedition: isOnExpedition ?? this.isOnExpedition,
      freight: freight ?? this.freight,
      products: annulProducts == true ? null : products ?? this.products,
      discounts: annulDiscounts == true ? null : discounts ?? this.discounts,
      seller: annulSeller == true ? null : seller ?? this.seller,
    );
  }

  double get totalProductsLiquid {
    return products?.fold(0.0, (p, n) {
          return (p ?? 0) + n.totalLiquid;
        }) ??
        0.0;
  }

  double get totalProductsBrut {
    return products?.fold(0.0, (p, n) {
          return (p ?? 0) + ((n.quantity ?? 0) * (n.value ?? 0));
        }) ??
        0;
  }

  double get totalFreight {
    //! total products (liquid) freight + sale request freight
    final totalProductsDeliveryTax =
        products?.fold(0.0, (p, n) {
          return p + n.totalDeliveryTax;
        }) ??
        0.0;

    final totalSaleRequest = deliveryTax?.deliveryTax?.calculateItemValue(
      totalProductsLiquid,
    );

    return totalProductsDeliveryTax + (totalSaleRequest ?? 0.0);
  }

  double get totalIncrement {
    //! total products (brut) increment + total products (liquid) increment
    final totalBrutIncrement =
        products?.fold(0.0, (p, n) {
          return p + n.totalIncrement;
        }) ??
        0;

    final totalLiquidIncrement = increment?.calculateItemValue(
      totalProductsLiquid,
    );

    return totalBrutIncrement + (totalLiquidIncrement ?? 0.0);
  }

  double get totalDiscount {
    //! total products liquid (apply the sale request discount) + total products discount
    final totalProductsDiscount =
        products?.fold(0.0, (p, n) {
          return p + n.totalDiscountValue;
        }) ??
        0;

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

  double get totalPayments {
    if (financials == null || financials!.isEmpty) return 0;
    return financials!.fold(0.0, (total, financial) {
      return total +
          (financial.paymentFinalizations?.fold(
                0.0,
                (p, n) => (p ?? 0) + (n.value ?? 0),
              ) ??
              0);
    });
  }

  int get totalProductsCount => products?.length ?? 0;

  int get totalPaymentsCount =>
      financials?.firstOrNull?.paymentFinalizations?.length ?? 0;

  double get totalLiquidAndPaidDifference {
    // Convert to cents (integers) to prevent double-precision floating-point inaccuracies
    final totalProductsCents = (totalProductsLiquid * 100).round();
    final totalPaymentsCents = (totalPayments.abs() * 100).round();
    final differenceCents = totalProductsCents - totalPaymentsCents;
    return differenceCents / 100.0;
  }

  bool get isPaymentValid {
    final hasGenerateTitle =
        requestType?.generatePendencyFinancialTitle ?? false;

    // Compare in cents to avoid double-precision inaccuracies
    final totalProductsCents = (totalProductsLiquid * 100).round();
    final totalPaymentsCents = (totalPayments * 100).round();
    final isTotalMatching =
        (totalProductsCents - totalPaymentsCents).abs() == 0;

    if (hasGenerateTitle) {
      return totalPayments > 0 && isTotalMatching;
    } else {
      return totalPayments == 0 || isTotalMatching;
    }
  }

  bool needsProcessingComparedTo(BSFSaleRequestEntity? other) {
    if (other == null) return true;

    if (customer?.code == null ||
        (products?.isEmpty ?? true) ||
        requestType?.code == null) {
      return false;
    }

    final changedCustomer = customer?.code != other.customer?.code;
    final changedCovenant =
        customer?.selectedCovenant?.code !=
        other.customer?.selectedCovenant?.code;
    final changedSeller = seller?.code != other.seller?.code;

    bool changedProducts = products?.length != other.products?.length;

    if (!changedProducts) {
      final otherProductsMap = {
        for (final p in other.products ?? <BSFProductItemEntity>[])
          p.productPackingCode: p,
      };

      bool areDoublesDifferent(double? a, double? b) {
        if (a == b) return false;
        if (a == null || b == null) return true;
        return (a - b).abs() >= 0.01;
      }

      changedProducts = (products ?? []).any((product) {
        final correspondent = otherProductsMap[product.productPackingCode];
        return correspondent == null ||
            product.code != correspondent.code ||
            areDoublesDifferent(product.quantity, correspondent.quantity) ||
            areDoublesDifferent(
              product.totalLiquid,
              correspondent.totalLiquid,
            ) ||
            product.increment != correspondent.increment ||
            !const ListEquality().equals(
              product.discounts,
              correspondent.discounts,
            ) ||
            product.deliveryTax != correspondent.deliveryTax ||
            areDoublesDifferent(product.value, correspondent.value);
      });
    }

    return changedCustomer ||
        changedCovenant ||
        changedSeller ||
        changedProducts;
  }

  SaleRequestEntity toSaleRequestEntity() {
    return SaleRequestEntity(
      cart: const {},
      customer: customer != null
          ? SoapCustomerEntity(
              Code: customer!.code,
              Name: customer!.name ?? '',
              PersonalizedCode: customer!.personalizedCode,
              ReducedName: customer!.nameReduced,
              CpfCnpjNumber: customer?.cnpjCpfNumber,
              RegistrationNumber: customer!.inscriptionRgNumber,
              Password: null,
              HasPassword: null,
              DateOfBirth: null,
              SexType: null,
              PersonType: null,
              Emails: null,
              Telephones: null,
              Addresses: null,
              CustomerCovenants: null,
              saleBlockadeInstruction: null,
              saleBlockade: null,
            )
          : null,
      Payments: financials?.firstOrNull?.paymentFinalizations?.map((e) {
        return FinalizationEntity(
          Id: e.paymentFinalization!.code.toString(),
          Name: e.paymentFinalization?.Description ?? '',
          TotalValue: e.value!,
          PortionQuantity: e.quantityOfPortions ?? 0,
        );
      }).toList(),
      observations: observations,
      instructions: instructions,
      Id: code,
      SaleRequestNumber: personalizedCode,
      RequestType: requestType?.code != null
          ? SaleRequestRequestTypeEntity(
              Id: requestType!.code!,
              PersonalizedCode: requestType!.personalizedCode ?? '',
              Name: requestType!.name ?? '',
            )
          : null,
      EnterpriseId: enterprise?.code,
      DateHourOfCreation: dateOfEmission,
      TotalLiquid: totalLiquid,
      DiscountValue: totalDiscount,
      Seller: seller?.code != null
          ? EcSellerEntity(Id: seller!.code!, Name: seller!.name ?? '')
          : null,
    );
  }
}
