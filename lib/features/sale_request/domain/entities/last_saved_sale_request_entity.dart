import 'package:equatable/equatable.dart';

import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

class LastSavedSaleRequestEntity extends Equatable {
  final SaleRequestEntity saleRequestEntity;
  final String saleRequestNumber;

  const LastSavedSaleRequestEntity({
    required this.saleRequestEntity,
    required this.saleRequestNumber,
  });

  @override
  List<Object?> get props => [saleRequestEntity, saleRequestNumber];
}
