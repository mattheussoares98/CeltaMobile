import 'package:equatable/equatable.dart';

import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/data/models/models.dart';

class ShallowProductModel extends Equatable implements ProductModelType {
  final String Name;
  final String PriceLookupCode;
  final String PackingAbbreviation;
  final double PackingQuantity;
  final int codigoInternoProEmb;
  final int ProductCode;

  const ShallowProductModel({
    required this.Name,
    required this.PriceLookupCode,
    required this.PackingAbbreviation,
    required this.PackingQuantity,
    required this.codigoInternoProEmb,
    required this.ProductCode,
  });

  @override
  List<Object?> get props => [
    Name,
    PriceLookupCode,
    PackingAbbreviation,
    PackingQuantity,
    codigoInternoProEmb,
    ProductCode,
  ];

  factory ShallowProductModel.fromJson(Map json) => ShallowProductModel(
    Name: json['name'],
    PriceLookupCode: json['priceLookupCode'],
    PackingAbbreviation: json['packingAbbreviation'],
    PackingQuantity: json['packingQuantity'],
    codigoInternoProEmb: json['id'],
    ProductCode: json['productCode'],
  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': Name,
    'priceLookupCode': PriceLookupCode,
    'packingAbbreviation': PackingAbbreviation,
    'packingQuantity': PackingQuantity,
    'id': codigoInternoProEmb,
    'productCode': ProductCode,
  };

  factory ShallowProductModel.fromEntity(ProductEntity entity) =>
      ShallowProductModel(
        Name: entity.Name!,
        PriceLookupCode: entity.PLU!,
        PackingAbbreviation: entity.PackingAbbreviation!,
        codigoInternoProEmb: entity.codigoInternoProEmb!,
        ProductCode: entity.ProductCode!,
        PackingQuantity: entity.PackingQuantity!.toDouble()!,
      );

  @override
  ProductEntity toEntity() => ProductEntity.empty().copyWith(
    Name: Name,
    PLU: PriceLookupCode,
    PackingAbbreviation: PackingAbbreviation,
    codigoInternoProEmb: codigoInternoProEmb,
    ProductCode: ProductCode,
    PackingQuantity: PackingQuantity.toString(),
  );
}
