import 'package:equatable/equatable.dart';

import '../models.dart';
import '../../../domain/entities/entities.dart';

//TODO create different folders here and in entities to separate inventory, params and getJson
class InventoryProductModel extends Equatable implements ProductModelType {
  final String productName;
  final int codigoInternoProEmb;
  final String plu;
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

  factory InventoryProductModel.fromEntity(InventoryProductEntity entity) =>
      InventoryProductModel(
        productName: entity.productName,
        codigoInternoProEmb: entity.codigoInternoProEmb,
        plu: entity.plu,
        codigoProEmb: entity.codigoProEmb,
        quantidadeInvContProEmb: entity.quantidadeInvContProEmb,
      );

  @override
  InventoryProductEntity toEntity() => InventoryProductEntity(
    productName: productName,
    codigoInternoProEmb: codigoInternoProEmb,
    plu: plu,
    codigoProEmb: codigoProEmb,
    quantidadeInvContProEmb: quantidadeInvContProEmb,
  );
}
