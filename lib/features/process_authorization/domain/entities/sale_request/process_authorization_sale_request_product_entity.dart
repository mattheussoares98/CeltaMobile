import 'package:equatable/equatable.dart';

class ProcessAuthorizationSaleRequestProductEntity extends Equatable {
  final String name;
  final String packingPriceLookUp;
  final String packingName;
  final double packingQuantity;

  const ProcessAuthorizationSaleRequestProductEntity({
    required this.name,
    required this.packingPriceLookUp,
    required this.packingName,
    required this.packingQuantity,
  });

  @override
  List<Object?> get props => [
    name,
    packingPriceLookUp,
    packingName,
    packingQuantity,
  ];
}
