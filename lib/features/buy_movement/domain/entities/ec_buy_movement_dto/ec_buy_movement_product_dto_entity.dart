import 'package:equatable/equatable.dart';

class EcBuyMovementProductDtoEntity extends Equatable {
  final String? name;
  final String? priceLookupCode;
  final String? fiscalCode;
  final double? packingQuantity;
  final String? packingName;
  final double? quantity;
  final double? totalLiquid;

  const EcBuyMovementProductDtoEntity({
    required this.name,
    required this.priceLookupCode,
    required this.fiscalCode,
    required this.packingQuantity,
    required this.packingName,
    required this.quantity,
    required this.totalLiquid,
  });

  @override
  List<Object?> get props => [
    name,
    priceLookupCode,
    fiscalCode,
    packingQuantity,
    packingName,
    quantity,
    totalLiquid,
  ];
}
