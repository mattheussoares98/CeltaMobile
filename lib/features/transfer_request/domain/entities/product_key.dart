import 'package:equatable/equatable.dart';

class ProductKey extends Equatable {
  final int requestTypeCode;
  final int enterpriseOrigin;
  final int enterpriseDestinyCode;
  final int productPackingCode;

  const ProductKey({
    required this.requestTypeCode,
    required this.enterpriseOrigin,
    required this.enterpriseDestinyCode,
    required this.productPackingCode,
  });

  @override
  List<Object?> get props => [
    requestTypeCode,
    enterpriseOrigin,
    enterpriseDestinyCode,
    productPackingCode,
  ];

  String toMapKey() {
    return '$requestTypeCode-$enterpriseOrigin-$enterpriseDestinyCode-$productPackingCode';
  }

  factory ProductKey.fromMapKey(String key) {
    final parts = key.split('-');
    if (parts.length != 4) {
      throw FormatException('Invalid ProductKey format');
    }
    return ProductKey(
      requestTypeCode: int.parse(parts[0]),
      enterpriseOrigin: int.parse(parts[1]),
      enterpriseDestinyCode: int.parse(parts[2]),
      productPackingCode: int.parse(parts[3]),
    );
  }
}
