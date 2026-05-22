import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

class SaleRequestCartProductEntity extends Equatable {
  final int ProductPackingCode;
  final double Quantity;
  final double Value;
  final double TotalLiquid;
  final PercentageOrValue? IncrementPercentageOrValue; //"R$"" ou "%"
  final double? IncrementValue;
  final PercentageOrValue? DiscountPercentageOrValue; //"R$"" ou "%"
  final double? DiscountValue;
  final String? DiscountDescription;
  final PercentageOrValue? AutomaticDiscountPercentageOrValue; //"R$"" ou "%"
  final double? AutomaticDiscountValue;
  final DateTime? ExpectedDeliveryDate;
  final String? Observations;
  final ProductEntity? product;

  const SaleRequestCartProductEntity({
    required this.ProductPackingCode,
    required this.Quantity,
    required this.Value,
    required this.TotalLiquid,
    required this.product,
    this.IncrementPercentageOrValue,
    this.IncrementValue,
    this.DiscountPercentageOrValue,
    this.DiscountValue,
    this.DiscountDescription,
    this.AutomaticDiscountPercentageOrValue,
    this.AutomaticDiscountValue,
    this.ExpectedDeliveryDate,
    this.Observations,
  });

  @override
  List<Object?> get props => [
    ProductPackingCode,
    Quantity,
    Value,
    TotalLiquid,
    IncrementPercentageOrValue,
    IncrementValue,
    DiscountPercentageOrValue,
    DiscountValue,
    DiscountDescription,
    AutomaticDiscountPercentageOrValue,
    AutomaticDiscountValue,
    ExpectedDeliveryDate,
    Observations,
    product,
  ];

  SaleRequestCartProductEntity copyWith({
    int? ProductPackingCode,
    double? Quantity,
    double? Value,
    double? TotalLiquid,
    PercentageOrValue? IncrementPercentageOrValue,
    double? IncrementValue,
    PercentageOrValue? DiscountPercentageOrValue,
    double? DiscountValue,
    String? DiscountDescription,
    PercentageOrValue? AutomaticDiscountPercentageOrValue,
    double? AutomaticDiscountValue,
    DateTime? ExpectedDeliveryDate,
    String? Observations,
    ProductEntity? product,
  }) {
    return SaleRequestCartProductEntity(
      ProductPackingCode: ProductPackingCode ?? this.ProductPackingCode,
      Quantity: Quantity ?? this.Quantity,
      Value: Value ?? this.Value,
      TotalLiquid: TotalLiquid ?? this.TotalLiquid,
      IncrementPercentageOrValue:
          IncrementPercentageOrValue ?? this.IncrementPercentageOrValue,
      IncrementValue: IncrementValue ?? this.IncrementValue,
      DiscountPercentageOrValue:
          DiscountPercentageOrValue ?? this.DiscountPercentageOrValue,
      DiscountValue: DiscountValue ?? this.DiscountValue,
      DiscountDescription: DiscountDescription ?? this.DiscountDescription,
      AutomaticDiscountPercentageOrValue:
          AutomaticDiscountPercentageOrValue ??
          this.AutomaticDiscountPercentageOrValue,
      AutomaticDiscountValue:
          AutomaticDiscountValue ?? this.AutomaticDiscountValue,
      ExpectedDeliveryDate: ExpectedDeliveryDate ?? this.ExpectedDeliveryDate,
      Observations: Observations ?? this.Observations,
      product: product ?? this.product,
    );
  }

  factory SaleRequestCartProductEntity.create({
    required double quantity,
    required double price,
    required ProductEntity product,
    double? discountByItem,
    PercentageOrValue? discountType,
  }) {
    final double baseTotal = price * quantity;

    double? totalDiscount;
    if ((discountByItem ?? 0) > 0 && discountType != null) {
      if (discountType == PercentageOrValue.percentage) {
        totalDiscount = price * (discountByItem! / 100) * quantity;
      } else {
        totalDiscount = discountByItem! * quantity;
      }
    }

    return SaleRequestCartProductEntity(
      ProductPackingCode: product.ProductPackingCode!,
      product: product,
      Quantity: quantity,
      Value: price,
      TotalLiquid: baseTotal - (totalDiscount ?? 0),
      DiscountValue: totalDiscount,
      DiscountPercentageOrValue: (totalDiscount ?? 0) <= 0
          ? null
          : discountType,
      DiscountDescription: (discountByItem ?? 0) > 0 && discountType != null
          ? 'Desconto manual'
          : null,
    );
  }

  double get getValueLiquid {
    double value = Value;
    if (IncrementValue != null) value += IncrementValue! / Quantity;
    if (DiscountValue != null) value -= DiscountValue! / Quantity;
    if (AutomaticDiscountValue != null) {
      value -= AutomaticDiscountValue! / Quantity;
    }
    return value > 0 ? value : 0;
  }

  double get getTotalLiquid {
    return Quantity * getValueLiquid;
  }

  double? get getValueOrPercentageDiscount {
    if (DiscountValue == null || DiscountPercentageOrValue == null) {
      return null;
    } else if (DiscountPercentageOrValue == PercentageOrValue.percentage) {
      return DiscountValue! / (Quantity * Value) * 100;
    } else {
      return DiscountValue! / Quantity;
    }
  }

  bool get getPriceIsManual {
    final minimumWholeQuantity = product?.MinimumWholeQuantity ?? 0;

    if (minimumWholeQuantity > 0 &&
        (product?.WholePracticedPrice ?? 0) > 0 &&
        Quantity >= minimumWholeQuantity) {
      return Value != product?.WholePracticedPrice;
    } else {
      return Value != product?.RetailPracticedPrice;
    }
  }
}
