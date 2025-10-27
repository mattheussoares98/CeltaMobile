import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';

class TransferRequestProductItemEntity extends Equatable {
  final ProductEntity product;
  final double quantity;
  final double price;

  const TransferRequestProductItemEntity({
    required this.product,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object?> get props => [product, quantity, price];
}
