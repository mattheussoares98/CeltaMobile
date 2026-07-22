import 'package:equatable/equatable.dart';

class EcBuyRequestProductDtoEntity extends Equatable {
  final String? enterprisePersonalizedCode;
  final String? enterpriseName;
  final String? name;
  final double? packingQuantity;
  final String? priceLookupCode;
  final String? packingName;
  final List<String>? eans;
  final double? quantity;
  final double? value;
  final double? total;

  const EcBuyRequestProductDtoEntity({
    required this.enterprisePersonalizedCode,
    required this.enterpriseName,
    required this.name,
    required this.packingQuantity,
    required this.priceLookupCode,
    required this.packingName,
    required this.eans,
    required this.quantity,
    required this.value,
    required this.total,
  });

  @override
  List<Object?> get props => [
    enterprisePersonalizedCode,
    enterpriseName,
    name,
    packingQuantity,
    priceLookupCode,
    packingName,
    eans,
    quantity,
    value,
    total,
  ];
}
