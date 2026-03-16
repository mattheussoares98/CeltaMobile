import 'package:equatable/equatable.dart';

import 'ec_sale_request_product_product_model.dart';

class EcSaleRequestProductModel extends Equatable {
  final int Id;
  final double Quantity;
  final double UnitValue;
  final double TotalLiquid;
  final double TotalDiscountValue;
  final String Observations;
  final EcSaleRequestProductProductModel Product;

  const EcSaleRequestProductModel({
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
}
