import 'package:equatable/equatable.dart';

class ExpeditionProductEntity extends Equatable {
  final int EnterpriseCode;
  final int ProductCode;
  final int ProductPackingCode;
  final double Quantity;
  final String PriceLookUp;
  final String Name;
  final String Packing;

  const ExpeditionProductEntity({
    required this.EnterpriseCode,
    required this.ProductCode,
    required this.ProductPackingCode,
    required this.Quantity,
    required this.PriceLookUp,
    required this.Name,
    required this.Packing,
  });

  @override
  List<Object?> get props => [
    EnterpriseCode,
    ProductCode,
    ProductPackingCode,
    Quantity,
    PriceLookUp,
    Name,
    Packing,
  ];
}
