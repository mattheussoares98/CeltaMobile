import 'package:celta_inventario/features/expedition_conference/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class ExpeditionProductModel extends Equatable {
  final int EnterpriseCode;
  final int ProductCode;
  final int ProductPackingCode;
  final double Quantity;
  final String PriceLookUp;
  final String Name;
  final String Packing;

  const ExpeditionProductModel({
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

  factory ExpeditionProductModel.fromJson(Map json) => ExpeditionProductModel(
    EnterpriseCode: json["EnterpriseCode"],
    ProductCode: json["ProductCode"],
    ProductPackingCode: json["ProductPackingCode"],
    Quantity: json["Quantity"],
    PriceLookUp: json["PriceLookUp"],
    Name: json["Name"],
    Packing: json["Packing"],
  );

  Map<String, dynamic> toJson() => {
    "EnterpriseCode": EnterpriseCode,
    "ProductCode": ProductCode,
    "ProductPackingCode": ProductPackingCode,
    "Quantity": Quantity,
    "PriceLookUp": PriceLookUp,
    "Name": Name,
    "Packing": Packing,
  };

  factory ExpeditionProductModel.fromEntity(ExpeditionProductEntity entity) =>
      ExpeditionProductModel(
        EnterpriseCode: entity.EnterpriseCode,
        ProductCode: entity.ProductCode,
        ProductPackingCode: entity.ProductPackingCode,
        Quantity: entity.Quantity,
        PriceLookUp: entity.PriceLookUp,
        Name: entity.Name,
        Packing: entity.Packing,
      );

  ExpeditionProductEntity toEntity() => ExpeditionProductEntity(
    EnterpriseCode: EnterpriseCode,
    ProductCode: ProductCode,
    ProductPackingCode: ProductPackingCode,
    Quantity: Quantity,
    PriceLookUp: PriceLookUp,
    Name: Name,
    Packing: Packing,
  );
}
