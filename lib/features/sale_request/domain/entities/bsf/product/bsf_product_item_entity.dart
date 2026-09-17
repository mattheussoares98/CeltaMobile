import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFProductItemEntity extends Equatable {
  final BSFProductEntity? product;
  final BSFFiscalCodeEntity? fiscalCode;
  final dynamic compositionChilds;
  final String? eanCode;
  final BSFProductFreightEntity? freight;
  final List<BSFDiscountEntity>? discounts;
  final DateTime? expectedDeliveryDate;
  final BSFValueTypeEntity? deliveryTax;
  final BSFValueTypeEntity? increment;
  final BSFValueTypeEntity? creditOnOrigin;
  final BSFValueTypeEntity? compensation;
  final int? productPackingCode;
  final double? quantity;
  final double? value;
  final int code;
  final BSFIcmsEntity? icms;
  final BSFIpiEntity? ipi;
  final BSFPriceCostEntity? priceCost;
  final SaleBlockadeDiscountType? saleBlockadeDiscountType;

  const BSFProductItemEntity({
    required this.product,
    required this.fiscalCode,
    required this.compositionChilds,
    required this.eanCode,
    required this.freight,
    required this.discounts,
    required this.expectedDeliveryDate,
    required this.deliveryTax,
    required this.increment,
    required this.creditOnOrigin,
    required this.compensation,
    required this.productPackingCode,
    required this.quantity,
    required this.value,
    required this.code,
    required this.icms,
    required this.ipi,
    required this.priceCost,
    required this.saleBlockadeDiscountType,
  });

  @override
  List<Object?> get props => [
    product,
    fiscalCode,
    compositionChilds,
    eanCode,
    freight,
    discounts,
    expectedDeliveryDate,
    deliveryTax,
    increment,
    creditOnOrigin,
    compensation,
    productPackingCode,
    quantity,
    value,
    code,
    icms,
    ipi,
    priceCost,
    saleBlockadeDiscountType,
  ];

  BSFProductItemEntity copyWith({
    BSFProductEntity? product,
    BSFFiscalCodeEntity? fiscalCode,
    dynamic compositionChilds,
    String? eanCode,
    BSFProductFreightEntity? freight,
    List<BSFDiscountEntity>? discounts,
    DateTime? expectedDeliveryDate,
    BSFValueTypeEntity? deliveryTax,
    BSFValueTypeEntity? increment,
    BSFValueTypeEntity? creditOnOrigin,
    BSFValueTypeEntity? compensation,
    int? productPackingCode,
    double? quantity,
    double? value,
    int? code,
    BSFIcmsEntity? icms,
    BSFIpiEntity? ipi,
    BSFPriceCostEntity? priceCost,
    SaleBlockadeDiscountType? saleBlockadeDiscountType,
    bool? annulIncrement,
    bool? annulDeliveryTax,
    bool? annulDiscounts,
    bool? annulValue,
    bool? annulPriceCost,
  }) {
    return BSFProductItemEntity(
      product: product ?? this.product,
      fiscalCode: fiscalCode ?? this.fiscalCode,
      compositionChilds: compositionChilds ?? this.compositionChilds,
      eanCode: eanCode ?? this.eanCode,
      freight: freight ?? this.freight,
      discounts: annulDiscounts == true ? null : discounts ?? this.discounts,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
      deliveryTax: annulDeliveryTax == true
          ? null
          : deliveryTax ?? this.deliveryTax,
      increment: annulIncrement == true ? null : increment ?? this.increment,
      creditOnOrigin: creditOnOrigin ?? this.creditOnOrigin,
      compensation: compensation ?? this.compensation,
      productPackingCode: productPackingCode ?? this.productPackingCode,
      quantity: quantity ?? this.quantity,
      value: annulValue == true ? null : value ?? this.value,
      code: code ?? this.code,
      icms: icms ?? this.icms,
      ipi: ipi ?? this.ipi,
      priceCost: annulPriceCost == true ? null : priceCost ?? this.priceCost,
      saleBlockadeDiscountType:
          saleBlockadeDiscountType ?? this.saleBlockadeDiscountType,
    );
  }

  factory BSFProductItemEntity.empty() {
    return const BSFProductItemEntity(
      product: null,
      fiscalCode: null,
      compositionChilds: null,
      eanCode: null,
      freight: null,
      discounts: [],
      expectedDeliveryDate: null,
      deliveryTax: null,
      increment: null,
      creditOnOrigin: null,
      compensation: null,
      productPackingCode: null,
      quantity: 1.0,
      value: 0.0,
      code: 0,
      icms: null,
      ipi: null,
      priceCost: null,
      saleBlockadeDiscountType: SaleBlockadeDiscountType.none,
    );
  }

  double get unitDiscountValue {
    var baseValue = value ?? 0;
    var sumDiscountValues = 0.0;
    for (var discount in discounts ?? <BSFDiscountEntity>[]) {
      final itemDiscount = discount.discount!.calculateItemValue(baseValue);
      sumDiscountValues += itemDiscount;
      baseValue -= itemDiscount;
    }
    return sumDiscountValues;
  }

  double get totalDiscountValue {
    return unitDiscountValue * (quantity ?? 0);
  }

  double get unitIncrement {
    return increment?.calculateItemValue(value) ?? 0;
  }

  double get totalIncrement {
    return unitIncrement * (quantity ?? 0);
  }

  double get unitDeliveryTax {
    return deliveryTax?.calculateItemValue(value) ?? 0;
  }

  double get totalDeliveryTax {
    return unitDeliveryTax * (quantity ?? 0);
  }

  double get totalLiquid =>
      (quantity ?? 0) *
      ((value ?? 0) - unitDiscountValue + unitDeliveryTax + unitIncrement);

  double get wholePrice => (priceCost?.wholeSalePricePractice ?? 0) > 0
      ? priceCost!.wholeSalePricePractice!
      : priceCost?.salePracticedInWholeSale ?? 0;

  double get retailPrice => (priceCost?.saleRetailPricePractice ?? 0) > 0
      ? priceCost!.saleRetailPricePractice!
      : priceCost?.salePracticedInSaleRetail ?? 0;

  bool get hasNoPrice => (value ?? 0) <= 0 && retailPrice <= 0;

  PracticedPriceType get practicedPriceType {
    if (value == null || priceCost == null) {
      return PracticedPriceType.manual;
    }

    final pc = priceCost!;
    final retailPrice =
        pc.salePracticedInSaleRetail ?? pc.saleRetailPricePractice ?? 0;

    if (value == retailPrice) {
      return PracticedPriceType.retail;
    }

    final wholePrice =
        pc.salePracticedInWholeSale ?? pc.wholeSalePricePractice ?? 0;

    if (value == wholePrice && wholePrice > 0) {
      return PracticedPriceType.whole;
    }

    return PracticedPriceType.manual;
  }
}
