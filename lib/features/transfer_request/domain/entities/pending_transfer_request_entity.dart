import 'package:equatable/equatable.dart';

import 'entities.dart';

class PendingTransferRequestEntity extends Equatable {
  final List<TransferRequestProductItemEntity>? products;
  final String? lastSavedRequestNumber;

  const PendingTransferRequestEntity({
    required this.products,
    required this.lastSavedRequestNumber,
  });

  @override
  List<Object?> get props => [products];

  PendingTransferRequestEntity copyWith({
    List<TransferRequestProductItemEntity>? products,
    String? lastSavedRequestNumber,
  }) {
    return PendingTransferRequestEntity(
      products: products ?? this.products,
      lastSavedRequestNumber:
          lastSavedRequestNumber ?? this.lastSavedRequestNumber,
    );
  }
}
