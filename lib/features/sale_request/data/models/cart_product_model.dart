import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class CartProductModel extends Equatable {
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

  const CartProductModel({
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

  factory CartProductModel.fromJson(Map json) => CartProductModel(
    ProductPackingCode: json["ProductPackingCode"],
    Quantity: json["Quantity"],
    Value: json["Value"],
    TotalLiquid: json["TotalLiquid"],
    IncrementPercentageOrValue: json["IncrementPercentageOrValue"],
    IncrementValue: json["IncrementValue"],
    DiscountPercentageOrValue: json["DiscountPercentageOrValue"],
    DiscountValue: json["DiscountValue"],
    DiscountDescription: json["DiscountDescription"],
    AutomaticDiscountPercentageOrValue:
        json["AutomaticDiscountPercentageOrValue"],
    AutomaticDiscountValue: json["AutomaticDiscountValue"],
    ExpectedDeliveryDate: json["ExpectedDeliveryDate"] == null
        ? null
        : DateTime.parse(json["ExpectedDeliveryDate"]),
    Observations: json["Observations"],
  );

  Map<String, dynamic> toJson() => {
    'ProductPackingCode': ProductPackingCode,
    'Quantity': Quantity,
    'Value': Value,
    'TotalLiquid': TotalLiquid,
    'IncrementPercentageOrValue': IncrementPercentageOrValue,
    'IncrementValue': IncrementValue,
    'DiscountPercentageOrValue': DiscountPercentageOrValue,
    'DiscountValue': DiscountValue,
    'DiscountDescription': DiscountDescription,
    'AutomaticDiscountPercentageOrValue': AutomaticDiscountPercentageOrValue,
    'AutomaticDiscountValue': AutomaticDiscountValue,
    'ExpectedDeliveryDate': ExpectedDeliveryDate?.toIso8601String(),
    'Observations': Observations,
  };

  factory CartProductModel.fromEntity(CartProductEntity entity) =>
      CartProductModel(
        ProductPackingCode: entity.ProductPackingCode,
        Quantity: entity.Quantity,
        Value: entity.Value,
        TotalLiquid: entity.TotalLiquid,
        IncrementPercentageOrValue: entity.IncrementPercentageOrValue,
        IncrementValue: entity.IncrementValue,
        DiscountPercentageOrValue: entity.DiscountPercentageOrValue,
        DiscountValue: entity.DiscountValue,
        DiscountDescription: entity.DiscountDescription,
        AutomaticDiscountPercentageOrValue:
            entity.AutomaticDiscountPercentageOrValue,
        AutomaticDiscountValue: entity.AutomaticDiscountValue,
        ExpectedDeliveryDate: entity.ExpectedDeliveryDate,
        Observations: entity.Observations,
      );

  CartProductEntity toEntity() => CartProductEntity(
    ProductPackingCode: ProductPackingCode,
    Quantity: Quantity,
    Value: Value,
    TotalLiquid: TotalLiquid,
    IncrementPercentageOrValue: IncrementPercentageOrValue,
    IncrementValue: IncrementValue,
    DiscountPercentageOrValue: DiscountPercentageOrValue,
    DiscountValue: DiscountValue,
    DiscountDescription: DiscountDescription,
    AutomaticDiscountPercentageOrValue: AutomaticDiscountPercentageOrValue,
    AutomaticDiscountValue: AutomaticDiscountValue,
    ExpectedDeliveryDate: ExpectedDeliveryDate,
    Observations: Observations,
  );
}
