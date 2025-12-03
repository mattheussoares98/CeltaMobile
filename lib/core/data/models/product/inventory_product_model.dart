import 'package:equatable/equatable.dart';

import '../models.dart';
import '../../../domain/entities/entities.dart';

//TODO create different folders here and in entities to separate inventory, params and getJson
class InventoryProductModel extends Equatable implements ProductModelType {
  final String productName;
  final String plu;
  final int codigoInternoProEmb;
  final String codigoProEmb;
  final double? quantidadeInvContProEmb;

  const InventoryProductModel({
    required this.productName,
    required this.codigoInternoProEmb,
    required this.plu,
    required this.codigoProEmb,
    required this.quantidadeInvContProEmb,
  });

  @override
  List<Object?> get props => [
    productName,
    codigoInternoProEmb,
    plu,
    codigoProEmb,
    quantidadeInvContProEmb,
  ];

  factory InventoryProductModel.fromJson(Map json) => InventoryProductModel(
    productName: json['Nome_Produto'],
    codigoInternoProEmb: int.parse(json['CodigoInterno_ProEmb']),
    plu: json['CodigoPlu_ProEmb'],
    codigoProEmb: json['Codigo_ProEmb'] ?? "",
    quantidadeInvContProEmb: double.tryParse(
      json['Quantidade_InvContProEmb'] ?? '',
    ),
  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'Nome_Produto': productName,
    'CodigoInterno_ProEmb': codigoInternoProEmb.toString(),
    'CodigoPlu_ProEmb': plu,
    'Codigo_ProEmb': codigoProEmb,
    'Quantidade_InvContProEmb': quantidadeInvContProEmb?.toString(),
  };

  factory InventoryProductModel.fromEntity(ProductEntity entity) =>
      InventoryProductModel(
        productName: entity.Name!,
        plu: entity.PLU!,
        codigoInternoProEmb: entity.codigoInternoProEmb!,
        codigoProEmb: entity.codigoProEmb!,
        quantidadeInvContProEmb: entity.quantidadeInvContProEmb,
      );

  @override
  ProductEntity toEntity() => ProductEntity.empty().copyWith(
    Name: productName,
    codigoInternoProEmb: codigoInternoProEmb,
    PLU: plu,
    codigoProEmb: codigoProEmb,
    quantidadeInvContProEmb: quantidadeInvContProEmb,
  );
}
