import 'package:equatable/equatable.dart';

import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/data/models/ec/ec_sale_request_product_product_model.dart';

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
        Id: json['id'],
        Quantity: (json['quantity'] as num).toDouble(),
        UnitValue: (json['unitValue'] as num).toDouble(),
        TotalLiquid: (json['totalLiquid'] as num).toDouble(),
        TotalDiscountValue: (json['totalDiscountValue'] as num?)?.toDouble(),
        Observations: json['observations'],
        Product: json['product'] == null
            ? null
            : EcSaleRequestProductProductModel.fromJson(json['product']),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': Id,
    'quantity': Quantity,
    'unitValue': UnitValue,
    'totalLiquid': TotalLiquid,
    'totalDiscountValue': TotalDiscountValue,
    'observations': Observations,
    'product': Product?.toJson(),
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

  factory EcSaleRequestCartProductModel.fromBSFProductItemEntity(
    BSFProductItemEntity entity,
  ) => EcSaleRequestCartProductModel(
    Id: entity.product?.code ?? 0,
    Quantity: entity.quantity ?? 0.0,
    UnitValue: entity.value ?? 0.0,
    TotalLiquid: entity.totalLiquid,
    TotalDiscountValue: entity.totalDiscountValue,
    Observations: null,
    Product: entity.product == null
        ? null
        : EcSaleRequestProductProductModel.fromBSFProductDetailsEntity(
            entity.product!,
          ),
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
