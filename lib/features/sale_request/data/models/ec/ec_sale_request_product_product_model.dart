import 'package:equatable/equatable.dart';

import '../../../../../core/domain/entities/entities.dart';
import '../../../../../utils/utils.dart';

class EcSaleRequestProductProductModel extends Equatable {
  final int? Id;
  final String? Plu;
  final String? Name;
  final String? PackingAbbreviation;
  final double? PackingQuantity;

  const EcSaleRequestProductProductModel({
    required this.Id,
    required this.Plu,
    required this.Name,
    required this.PackingAbbreviation,
    required this.PackingQuantity,
  });

  @override
  List<Object?> get props => [
    Id,
    Plu,
    Name,
    PackingAbbreviation,
    PackingQuantity,
  ];

  factory EcSaleRequestProductProductModel.fromJson(Map json) =>
      EcSaleRequestProductProductModel(
        Id: json['Id'],
        Plu: json['Plu'],
        Name: json['Name'],
        PackingAbbreviation: json['PackingAbbreviation'],
        PackingQuantity: json['PackingQuantity'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'Id': Id,
    'Plu': Plu,
    'Name': Name,
    'PackingAbbreviation': PackingAbbreviation,
    'PackingQuantity': PackingQuantity,
  };

  factory EcSaleRequestProductProductModel.fromEntity(ProductEntity entity) =>
      EcSaleRequestProductProductModel(
        Id: entity.ProductPackingCode,
        Plu: entity.PLU,
        Name: entity.Name,
        PackingAbbreviation: entity.PackingAbbreviation,
        PackingQuantity: entity.PackingQuantity?.toDouble(),
      );

  ProductEntity toEntity() => ProductEntity.empty().copyWith(
    ProductPackingCode: Id,
    PLU: Plu,
    Name: Name,
    PackingAbbreviation: PackingAbbreviation,
    PackingQuantity: PackingQuantity?.toString(),
  );
}
