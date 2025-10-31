import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';
import 'entities.dart';

typedef ProductPackingCode = int;

class PendingSaleRequestEntity extends Equatable {
  final Map<ProductPackingCode, CartProductEntity> cart;
  final CustomerEntity? customer;
  final CustomerCovenantEntity? covenant;

  const PendingSaleRequestEntity({
    required this.cart,
    required this.customer,
    required this.covenant,
  });

  @override
  List<Object?> get props => [cart, customer];

  factory PendingSaleRequestEntity.empty() =>
      const PendingSaleRequestEntity(cart: {}, customer: null, covenant: null);

  PendingSaleRequestEntity copyWith({
    Map<ProductPackingCode, CartProductEntity>? cart,
    CustomerEntity? customer,
    CustomerCovenantEntity? covenant,
  }) => PendingSaleRequestEntity(
    cart: cart ?? this.cart,
    customer: customer ?? this.customer,
    covenant: covenant ?? this.covenant,
  );

  PendingSaleRequestEntity annulValues({
    bool? cart,
    bool? customer,
    bool? covenant,
  }) => PendingSaleRequestEntity(
    cart: cart == true ? {} : this.cart,
    customer: customer == true ? null : this.customer,
    covenant: covenant == true ? null : this.covenant,
  );
}
