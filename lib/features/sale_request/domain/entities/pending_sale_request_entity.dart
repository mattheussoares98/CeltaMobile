import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';
import 'entities.dart';

typedef ProductPackingCode = int;

class PendingSaleRequestEntity extends Equatable {
  final Map<ProductPackingCode, CartProductEntity> cart;
  final CustomerEntity? customer;

  const PendingSaleRequestEntity({required this.cart, required this.customer});

  @override
  List<Object?> get props => [cart, customer];

  factory PendingSaleRequestEntity.empty() =>
      const PendingSaleRequestEntity(cart: {}, customer: null);

  PendingSaleRequestEntity copyWith({
    Map<ProductPackingCode, CartProductEntity>? cart,
    CustomerEntity? customer,
  }) => PendingSaleRequestEntity(
    cart: cart ?? this.cart,
    customer: customer ?? this.customer,
  );
}
