import 'package:celta_inventario/features/process_authorization/domain/entities/sale_request/sale_request.dart';
import 'package:equatable/equatable.dart';

class BSFSaleRequestDiscountEntity extends Equatable {
  final List<BSFSaleRequestDiscountItemEntity>? items;
  final BSFSaleRequestDiscountTotalsEntity? totals;

  const BSFSaleRequestDiscountEntity({this.items, this.totals});

  @override
  List<Object?> get props => [items, totals];
}
