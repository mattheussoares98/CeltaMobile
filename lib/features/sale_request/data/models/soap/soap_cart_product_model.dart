import 'package:equatable/equatable.dart';

import '../../../../../core/data/models/models.dart';
import '../../../domain/entities/entities.dart';

class SoapCartProductModel extends Equatable {
  final int ProductPackingCode;
  final double Quantity;
  final double Value;
  final double TotalLiquid;
  final PercentageOrValue? IncrementPercentageOrValue;
  final double? IncrementValue;
  final PercentageOrValue? DiscountPercentageOrValue;
  final double? DiscountValue;
  final String? DiscountDescription;
  final PercentageOrValue? AutomaticDiscountPercentageOrValue;
  final double? AutomaticDiscountValue;
  final DateTime? ExpectedDeliveryDate;
  final String? Observations;
  final ProductModel? product;

  const SoapCartProductModel({
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
    required this.product,
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

  factory SoapCartProductModel.fromJson(Map json) => SoapCartProductModel(
    ProductPackingCode: json["ProductPackingCode"],
    Quantity: json["Quantity"],
    Value: json["Value"],
    TotalLiquid: json["TotalLiquid"],
    IncrementPercentageOrValue: json["IncrementPercentageOrValue"] == null
        ? null
        : PercentageOrValue.values.firstWhere(
            (e) => e.symbol == json["IncrementPercentageOrValue"],
          ),
    IncrementValue: json["IncrementValue"],
    DiscountPercentageOrValue: json["DiscountPercentageOrValue"] == null
        ? null
        : PercentageOrValue.values.firstWhere(
            (e) => e.symbol == json["DiscountPercentageOrValue"],
          ),
    DiscountValue: json["DiscountValue"],
    DiscountDescription: json["DiscountDescription"],
    AutomaticDiscountPercentageOrValue:
        json["AutomaticDiscountPercentageOrValue"] == null
        ? null
        : PercentageOrValue.values.firstWhere(
            (e) => e.symbol == json["AutomaticDiscountPercentageOrValue"],
          ),
    AutomaticDiscountValue: json["AutomaticDiscountValue"],
    ExpectedDeliveryDate: json["ExpectedDeliveryDate"] == null
        ? null
        : DateTime.parse(json["ExpectedDeliveryDate"]),
    Observations: json["Observations"],
    product: json["product"] == null
        ? null
        : ProductModel.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    'ProductPackingCode': ProductPackingCode,
    'Quantity': Quantity,
    'Value': Value,
    'TotalLiquid': TotalLiquid,
    'IncrementPercentageOrValue': IncrementPercentageOrValue?.symbol,
    'IncrementValue': IncrementValue ?? 0,
    'DiscountPercentageOrValue': DiscountPercentageOrValue?.symbol,
    'DiscountValue': DiscountValue ?? 0,
    'DiscountDescription': DiscountDescription,
    'AutomaticDiscountPercentageOrValue':
        AutomaticDiscountPercentageOrValue?.symbol,
    'AutomaticDiscountValue': AutomaticDiscountValue ?? 0,
    'ExpectedDeliveryDate': (ExpectedDeliveryDate ?? DateTime.now())
        .toIso8601String(),
    'Observations': Observations,
    'product': product?.toJson(),
  };

  factory SoapCartProductModel.fromEntity(CartProductEntity entity) =>
      SoapCartProductModel(
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
        product: entity.product == null
            ? null
            : ProductModel.fromEntity(entity.product!),
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
    product: product?.toEntity(),
  );
}
