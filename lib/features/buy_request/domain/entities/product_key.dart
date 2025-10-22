import 'package:equatable/equatable.dart';

class ProductKey extends Equatable {
  final int enterpriseCode;
  final int productPackingCode;

  const ProductKey({
    required this.enterpriseCode,
    required this.productPackingCode,
  });

  @override
  List<Object?> get props => [enterpriseCode, productPackingCode];
}
