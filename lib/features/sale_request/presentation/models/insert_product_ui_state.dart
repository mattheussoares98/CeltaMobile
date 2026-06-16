import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class InsertProductUIState extends Equatable {
  final double quantity;
  final double price;
  final double deliveryTaxValue;
  final PercentageOrValue deliveryTaxType;
  final double incrementValue;
  final PercentageOrValue incrementType;
  final List<BSFDiscountEntity> discounts;
  final PercentageOrValue discountType;

  const InsertProductUIState({
    required this.quantity,
    required this.price,
    required this.deliveryTaxValue,
    required this.deliveryTaxType,
    required this.incrementValue,
    required this.incrementType,
    required this.discounts,
    required this.discountType,
  });

  factory InsertProductUIState.fromProduct(BSFProductItemEntity product) {
    return InsertProductUIState(
      quantity: product.quantity ?? 1,
      price: product.value ?? 0,
      deliveryTaxValue: product.deliveryTax?.value ?? 0,
      deliveryTaxType: product.deliveryTax?.type ?? PercentageOrValue.reais,
      incrementValue: product.increment?.value ?? 0,
      incrementType: product.increment?.type ?? PercentageOrValue.reais,
      discounts: product.discounts ?? [],
      discountType:
          product.discounts?.firstOrNull?.discount?.type ??
          PercentageOrValue.reais,
    );
  }

  @override
  List<Object?> get props => [
    quantity,
    price,
    deliveryTaxValue,
    deliveryTaxType,
    incrementValue,
    incrementType,

    discounts,
    discountType,
  ];

  InsertProductUIState copyWith({
    double? quantity,
    double? price,
    double? deliveryTaxValue,
    PercentageOrValue? deliveryTaxType,
    double? incrementValue,
    PercentageOrValue? incrementType,
    List<BSFDiscountEntity>? discounts,
    PercentageOrValue? discountType,
  }) {
    return InsertProductUIState(
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      deliveryTaxValue: deliveryTaxValue ?? this.deliveryTaxValue,
      deliveryTaxType: deliveryTaxType ?? this.deliveryTaxType,
      incrementValue: incrementValue ?? this.incrementValue,
      incrementType: incrementType ?? this.incrementType,
      discounts: discounts ?? this.discounts,
      discountType: discountType ?? this.discountType,
    );
  }

  BSFProductItemEntity applyTo(BSFProductItemEntity product) {
    return BSFProductItemEntity(
      product: product.product,
      fiscalCode: product.fiscalCode,
      compositionChilds: product.compositionChilds,
      eanCode: product.eanCode,
      freight: product.freight,
      discounts: discounts,
      saleBlockadeDiscountType: product.saleBlockadeDiscountType,
      expectedDeliveryDate: product.expectedDeliveryDate,
      deliveryTax: deliveryTaxValue > 0
          ? BSFValueTypeEntity(type: deliveryTaxType, value: deliveryTaxValue)
          : null,
      increment: incrementValue > 0
          ? BSFValueTypeEntity(type: incrementType, value: incrementValue)
          : null,
      creditOnOrigin: product.creditOnOrigin,
      compensation: product.compensation,
      productPackingCode: product.productPackingCode,
      quantity: quantity,
      value: price,
      code: product.code,
      icms: product.icms,
      ipi: product.ipi,
      priceCost: product.priceCost,
    );
  }
}
