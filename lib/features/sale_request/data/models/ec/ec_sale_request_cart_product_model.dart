import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import 'ec_sale_request_product_product_model.dart';

class EcSaleRequestCartProductModel extends Equatable {
  final int Id;
  final double Quantity;
  final double UnitValue;
  final double TotalLiquid;
  final double? TotalDiscountValue;
  final String? Observations;
  final EcSaleRequestProductProductModel? Product;

  const EcSaleRequestCartProductModel({
    required this.Id,
    required this.Quantity,
    required this.UnitValue,
    required this.TotalLiquid,
    required this.TotalDiscountValue,
    required this.Observations,
    required this.Product,
  });

  @override
  List<Object?> get props => [
    Id,
    Quantity,
    UnitValue,
    TotalLiquid,
    TotalDiscountValue,
    Observations,
    Product,
  ];

  factory EcSaleRequestCartProductModel.fromJson(Map json) =>
      EcSaleRequestCartProductModel(
        Id: json["Id"],
        Quantity: json["Quantity"],
        UnitValue: json["UnitValue"],
        TotalLiquid: json["TotalLiquid"],
        TotalDiscountValue: json["TotalDiscountValue"],
        Observations: json["Observations"],
        Product: EcSaleRequestProductProductModel.fromJson(json["Product"]),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Id': Id,
    'Quantity': Quantity,
    'UnitValue': UnitValue,
    'TotalLiquid': TotalLiquid,
    'TotalDiscountValue': TotalDiscountValue,
    'Observations': Observations,
    'Product': Product?.toJson(),
  };

  factory EcSaleRequestCartProductModel.fromEntity(
    SaleRequestCartProductEntity entity,
  ) => EcSaleRequestCartProductModel(
    Id: entity.ProductPackingCode,
    Quantity: entity.Quantity,
    UnitValue: entity.Value,
    TotalLiquid: entity.TotalLiquid,
    TotalDiscountValue: entity.DiscountValue,
    Observations: entity.Observations,
    Product: entity.product == null
        ? null
        : EcSaleRequestProductProductModel.fromEntity(entity.product!),
  );

  SaleRequestCartProductEntity toEntity() => SaleRequestCartProductEntity(
    ProductPackingCode: Id,
    Quantity: Quantity,
    Value: UnitValue,
    TotalLiquid: TotalLiquid,
    DiscountValue: TotalDiscountValue,
    Observations: Observations,
    product: Product?.toEntity(),
  );
}
