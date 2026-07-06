import 'package:equatable/equatable.dart';

import 'sale_request.dart';

class BSFSaleRequestErrorEntity extends Equatable {
  final BSFSaleRequestDiscountEntity? discount;
  final BSFSaleRequestLucrativityEntity? lucrativity;

  const BSFSaleRequestErrorEntity({this.discount, this.lucrativity});

  @override
  List<Object?> get props => [discount, lucrativity];
}
