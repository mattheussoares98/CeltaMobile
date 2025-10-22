import 'package:equatable/equatable.dart';

import '../../../../core/data/models/models.dart';
import '../../domain/entities/entities.dart';

class BuyRequestProductItemModel extends Equatable {
  final ProductModel product;
  final double quantity;
  final double cost;

  const BuyRequestProductItemModel({
    required this.product,
    required this.quantity,
    required this.cost,
  });

  @override
  List<Object?> get props => [product, quantity, cost];

  factory BuyRequestProductItemModel.fromJson(Map json) =>
      BuyRequestProductItemModel(
        product: ProductModel.fromJson(json['product']),
        quantity: json['quantity'].toDouble(),
        cost: json['cost'].toDouble(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'product': product.toJson(),
    'quantity': quantity,
    'cost': cost,
  };

  factory BuyRequestProductItemModel.fromEntity(
    BuyRequestProductItemEntity entity,
  ) => BuyRequestProductItemModel(
    product: ProductModel.fromEntity(entity.product),
    quantity: entity.quantity,
    cost: entity.cost,
  );

  BuyRequestProductItemEntity toEntity() => BuyRequestProductItemEntity(
    product: product.toEntity(),
    quantity: quantity,
    cost: cost,
  );
}
