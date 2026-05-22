// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

class TransferRequestProductItemEntity extends Equatable {
  final ProductEntity product;
  final double quantity;
  final double value;

  const TransferRequestProductItemEntity({
    required this.product,
    required this.quantity,
    required this.value,
  });

  @override
  List<Object?> get props => [product, quantity, value];

  TransferRequestProductItemEntity copyWith({
    ProductEntity? product,
    double? quantity,
    double? value,
  }) {
    return TransferRequestProductItemEntity(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      value: value ?? this.value,
    );
  }
}
