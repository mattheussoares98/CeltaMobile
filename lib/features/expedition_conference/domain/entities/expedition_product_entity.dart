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

  ExpeditionProductEntity copyWith({
    int? EnterpriseCode,
    int? ProductCode,
    int? ProductPackingCode,
    double? Quantity,
    String? PriceLookUp,
    String? Name,
    String? Packing,
  }) {
    return ExpeditionProductEntity(
      EnterpriseCode: EnterpriseCode ?? this.EnterpriseCode,
      ProductCode: ProductCode ?? this.ProductCode,
      ProductPackingCode: ProductPackingCode ?? this.ProductPackingCode,
      Quantity: Quantity ?? this.Quantity,
      PriceLookUp: PriceLookUp ?? this.PriceLookUp,
      Name: Name ?? this.Name,
      Packing: Packing ?? this.Packing,
    );
  }
}
