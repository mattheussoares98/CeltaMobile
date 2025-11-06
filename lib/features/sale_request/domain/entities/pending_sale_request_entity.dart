import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';
import 'entities.dart';

typedef ProductPackingCode = int;

class PendingSaleRequestEntity extends Equatable {
  final Map<ProductPackingCode, CartProductEntity> cart;
  final CustomerEntity? customer;
  final CustomerCovenantEntity? covenant;
  final String? observations;
  final String? instructions;

  const PendingSaleRequestEntity({
    required this.cart,
    required this.customer,
    required this.covenant,
    required this.observations,
    required this.instructions,
  });

  @override
  List<Object?> get props => [cart, customer, observations, instructions];

  factory PendingSaleRequestEntity.empty() => const PendingSaleRequestEntity(
    cart: {},
    customer: null,
    covenant: null,
    observations: null,
    instructions: null,
  );

  PendingSaleRequestEntity copyWith({
    Map<ProductPackingCode, CartProductEntity>? cart,
    CustomerEntity? customer,
    CustomerCovenantEntity? covenant,
    String? observations,
    String? instructions,
  }) => PendingSaleRequestEntity(
    cart: cart ?? this.cart,
    customer: customer ?? this.customer,
    covenant: covenant ?? this.covenant,
    observations: observations ?? this.observations,
    instructions: instructions ?? this.instructions,
  );

  PendingSaleRequestEntity annulValues({
    bool? cart,
    bool? customer,
    bool? covenant,
    bool? observations,
    bool? instructions,
  }) => PendingSaleRequestEntity(
    cart: cart == true ? {} : this.cart,
    customer: customer == true ? null : this.customer,
    covenant: covenant == true ? null : this.covenant,
    observations: observations == true ? null : this.observations,
    instructions: instructions == true ? null : this.instructions,
  );
}
