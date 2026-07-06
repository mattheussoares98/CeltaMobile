import 'package:celta_inventario/features/process_authorization/domain/entities/sale_request/sale_request.dart';
import 'package:equatable/equatable.dart';

class BSFSaleRequestLucrativityEntity extends Equatable {
  final List<BSFSaleRequestLucrativityItemEntity>? items;
  final BSFSaleRequestLucrativityTotalsEntity? totals;

  const BSFSaleRequestLucrativityEntity({this.items, this.totals});

  @override
  List<Object?> get props => [items, totals];
}
