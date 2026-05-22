import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

class BuyRequestProductItemEntity extends Equatable {
  final ProductEntity product;
  final double quantity;
  final double cost;

  const BuyRequestProductItemEntity({
    required this.product,
    required this.quantity,
    required this.cost,
  });

  @override
  List<Object?> get props => [product, quantity, cost];
}
