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

  String toMapKey() {
    return '$enterpriseCode-$productPackingCode';
  }

  factory ProductKey.fromMapKey(String key) {
    final parts = key.split('-');
    if (parts.length != 2) {
      throw const FormatException('Invalid ProductKey format');
    }
    return ProductKey(
      enterpriseCode: int.parse(parts[0]),
      productPackingCode: int.parse(parts[1]),
    );
  }
}
