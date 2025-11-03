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
    );
  }

  double get getValueLiquid {
    double value = Value;
    if (IncrementValue != null) value += IncrementValue!;
    if (DiscountValue != null) value -= DiscountValue!;
    if (AutomaticDiscountValue != null) {
      value -= AutomaticDiscountValue!;
    }
    return value;
  }

  double get getTotalLiquid {
    return Quantity * getValueLiquid;
  }
}
