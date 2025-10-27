import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';

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
}
