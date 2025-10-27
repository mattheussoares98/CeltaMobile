import 'package:equatable/equatable.dart';

import '../../../../core/data/models/models.dart';
import '../../domain/entities/entities.dart';

class TransferRequestProductItemModel extends Equatable {
  final ProductModel product;
  final double quantity;
  final double value;

  const TransferRequestProductItemModel({
    required this.product,
    required this.quantity,
    required this.value,
  });

  @override
  List<Object?> get props => [product, quantity, value];

  factory TransferRequestProductItemModel.fromJson(Map json) =>
      TransferRequestProductItemModel(
        product: ProductModel.fromJson(json['product']),
        quantity: json['quantity'].toDouble(),
        value: json['value'].toDouble(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'product': product.toJson(),
    'quantity': quantity,
    'value': value,
  };

  factory TransferRequestProductItemModel.fromEntity(
    TransferRequestProductItemEntity entity,
  ) => TransferRequestProductItemModel(
    product: ProductModel.fromEntity(entity.product),
    quantity: entity.quantity,
    value: entity.value,
  );

  TransferRequestProductItemEntity toEntity() =>
      TransferRequestProductItemEntity(
        product: product.toEntity(),
        quantity: quantity,
        value: value,
      );
}
