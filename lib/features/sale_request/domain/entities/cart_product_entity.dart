import 'package:equatable/equatable.dart';

import 'entities.dart';

class CartProductEntity extends Equatable {
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
  final String? Name;
  final String? Plu;
  final String? PackingQuantity;

  const CartProductEntity({
    required this.ProductPackingCode,
    required this.Quantity,
    required this.Value,
    required this.TotalLiquid,
    this.IncrementPercentageOrValue,
    this.IncrementValue,
    this.DiscountPercentageOrValue,
    this.DiscountValue,
    this.DiscountDescription,
    this.AutomaticDiscountPercentageOrValue,
    this.AutomaticDiscountValue,
    this.ExpectedDeliveryDate,
    this.Observations,
    this.Name,
    this.Plu,
    this.PackingQuantity,
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
    Name,
    Plu,
    PackingQuantity,
  ];

  CartProductEntity copyWith({
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
    String? Name,
    String? Plu,
    String? PackingQuantity,
  }) {
    return CartProductEntity(
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
      Name: Name ?? this.Name,
      Plu: Plu ?? this.Plu,
      PackingQuantity: PackingQuantity ?? this.PackingQuantity,
    );
  }

  factory CartProductEntity.create({
    required int productPackingCode,
    required double quantity,
    required double price,
    String? name,
    String? plu,
    String? packingQuantity,
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

    return CartProductEntity(
      ProductPackingCode: productPackingCode,
      Name: name,
      Plu: plu,
      PackingQuantity: packingQuantity,
      Quantity: quantity,
      Value: price,
      TotalLiquid: baseTotal - (totalDiscount ?? 0),
      DiscountValue: totalDiscount,
      DiscountPercentageOrValue: (totalDiscount ?? 0) <= 0
          ? null
          : discountType,
      DiscountDescription: discountByItem != null && discountType != null
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
    return value;
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
}
