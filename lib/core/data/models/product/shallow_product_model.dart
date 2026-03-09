import 'package:equatable/equatable.dart';

import '../../../../utils/utils.dart';
import '../models.dart';
import '../../../domain/entities/entities.dart';

class ShallowProductModel extends Equatable implements ProductModelType {
  final String Name;
  final String PriceLookupCode;
  final String PackingAbbreviation;
  final double PackingQuantity;

  const ShallowProductModel({
    required this.Name,
    required this.PriceLookupCode,
    required this.PackingAbbreviation,
    required this.PackingQuantity,
  });

  @override
  List<Object?> get props => [
    Name,
    PriceLookupCode,
    PackingAbbreviation,
    PackingQuantity,
  ];

  factory ShallowProductModel.fromJson(Map json) => ShallowProductModel(
    Name: json['name'],
    PriceLookupCode: json['priceLookupCode'],
    PackingAbbreviation: json['packingAbbreviation'],
    PackingQuantity: json['packingQuantity'],
  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': Name,
    'priceLookupCode': PriceLookupCode,
    'packingAbbreviation': PackingAbbreviation,
    'packingQuantity': PackingQuantity,
  };

  factory ShallowProductModel.fromEntity(ProductEntity entity) =>
      ShallowProductModel(
        Name: entity.Name!,
        PriceLookupCode: entity.PLU!,
        PackingAbbreviation: entity.PackingAbbreviation!,
        PackingQuantity: entity.PackingQuantity!.toDouble()!,
      );

  @override
  ProductEntity toEntity() => ProductEntity.empty().copyWith(
    Name: Name,
    PLU: PriceLookupCode,
    PackingAbbreviation: PackingAbbreviation,
    PackingQuantity: PackingQuantity.toString(),
  );
}
