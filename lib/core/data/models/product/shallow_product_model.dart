import 'package:equatable/equatable.dart';

import '../../../../utils/utils.dart';
import '../../../domain/entities/entities.dart';
import '../models.dart';

class ShallowProductModel extends Equatable implements ProductModelType {
  final String Name;
  final String PriceLookupCode;
  final String PackingAbbreviation;
  final double PackingQuantity;
  final int codigoInternoProEmb;

  const ShallowProductModel({
    required this.Name,
    required this.PriceLookupCode,
    required this.PackingAbbreviation,
    required this.PackingQuantity,
    required this.codigoInternoProEmb,
  });

  @override
  List<Object?> get props => [
    Name,
    PriceLookupCode,
    PackingAbbreviation,
    PackingQuantity,
    codigoInternoProEmb,
  ];

  factory ShallowProductModel.fromJson(Map json) => ShallowProductModel(
    Name: json['name'],
    PriceLookupCode: json['priceLookupCode'],
    PackingAbbreviation: json['packingAbbreviation'],
    PackingQuantity: json['packingQuantity'],
    codigoInternoProEmb: json['id'],
  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': Name,
    'priceLookupCode': PriceLookupCode,
    'packingAbbreviation': PackingAbbreviation,
    'packingQuantity': PackingQuantity,
    'id': codigoInternoProEmb,
  };

  factory ShallowProductModel.fromEntity(ProductEntity entity) =>
      ShallowProductModel(
        Name: entity.Name!,
        PriceLookupCode: entity.PLU!,
        PackingAbbreviation: entity.PackingAbbreviation!,
        codigoInternoProEmb: entity.codigoInternoProEmb!,
        PackingQuantity: entity.PackingQuantity!.toDouble()!,
      );

  @override
  ProductEntity toEntity() => ProductEntity.empty().copyWith(
    Name: Name,
    PLU: PriceLookupCode,
    PackingAbbreviation: PackingAbbreviation,
    codigoInternoProEmb: codigoInternoProEmb,
    PackingQuantity: PackingQuantity.toString(),
  );
}
