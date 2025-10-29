import 'package:equatable/equatable.dart';

class CartProductEntity extends Equatable {
  final int ProductPackingCode;
  final double Quantity;
  final double Value;
  final double TotalLiquid;
  final String? IncrementPercentageOrValue;
  final double? IncrementValue;
  final String? DiscountPercentageOrValue;
  final double? DiscountValue;
  final String? DiscountDescription;
  final String? AutomaticDiscountPercentageOrValue;
  final double? AutomaticDiscountValue;
  final DateTime? ExpectedDeliveryDate;
  final String? Observations;

  const CartProductEntity({
    required this.ProductPackingCode,
    required this.Quantity,
    required this.Value,
    required this.TotalLiquid,
    required this.IncrementPercentageOrValue,
    required this.IncrementValue,
    required this.DiscountPercentageOrValue,
    required this.DiscountValue,
    required this.DiscountDescription,
    required this.AutomaticDiscountPercentageOrValue,
    required this.AutomaticDiscountValue,
    required this.ExpectedDeliveryDate,
    required this.Observations,
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
    String? IncrementPercentageOrValue,
    double? IncrementValue,
    String? DiscountPercentageOrValue,
    double? DiscountValue,
    String? DiscountDescription,
    String? AutomaticDiscountPercentageOrValue,
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
}
