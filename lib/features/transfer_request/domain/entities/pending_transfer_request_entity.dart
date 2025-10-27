import 'package:equatable/equatable.dart';

import 'entities.dart';

class PendingTransferRequestEntity extends Equatable {
  final Map<DraftKey, TransferRequestProductItemEntity>? products;

  const PendingTransferRequestEntity({required this.products});

  @override
  List<Object?> get props => [products];

  PendingTransferRequestEntity copyWith({
    Map<DraftKey, TransferRequestProductItemEntity>? products,
  }) {
    return PendingTransferRequestEntity(products: products ?? this.products);
  }
}
