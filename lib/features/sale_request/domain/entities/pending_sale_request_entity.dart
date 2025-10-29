import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';

typedef ProductPackingCode = int;

class PendingSaleRequestEntity extends Equatable {
  final Map<ProductPackingCode, ProductEntity> cart;
  final CustomerEntity? customer;

  const PendingSaleRequestEntity({required this.cart, required this.customer});

  @override
  List<Object?> get props => [cart, customer];
}
