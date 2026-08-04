import 'package:equatable/equatable.dart';

class BSFSaleRequestProductNotFoundDetailEntity extends Equatable {
  final int code;
  final String eCommerceCode;
  final String name;
  final double price;

  const BSFSaleRequestProductNotFoundDetailEntity({
    required this.code,
    required this.eCommerceCode,
    required this.name,
    required this.price,
  });

  @override
  List<Object?> get props => [code, eCommerceCode, name, price];
}
