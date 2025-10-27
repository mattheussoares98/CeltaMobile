import 'package:equatable/equatable.dart';

import '../../../../core/data/models/models.dart';
import '../../domain/entities/entities.dart';

class TransferRequestProductItemModel extends Equatable {
  final ProductModel product;
  final double quantity;
  final double price;

  const TransferRequestProductItemModel({
    required this.product,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object?> get props => [product, quantity, price];

  factory TransferRequestProductItemModel.fromJson(Map json) =>
      TransferRequestProductItemModel(
        product: ProductModel.fromJson(json['product']),
        quantity: json['quantity'].toDouble(),
        price: json['price'].toDouble(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'product': product.toJson(),
    'quantity': quantity,
    'price': price,
  };

  factory TransferRequestProductItemModel.fromEntity(
    TransferRequestProductItemEntity entity,
  ) => TransferRequestProductItemModel(
    product: ProductModel.fromEntity(entity.product),
    quantity: entity.quantity,
    price: entity.price,
  );

  TransferRequestProductItemEntity toEntity() =>
      TransferRequestProductItemEntity(
        product: product.toEntity(),
        quantity: quantity,
        price: price,
      );
}
