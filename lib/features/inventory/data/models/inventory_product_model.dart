import 'package:equatable/equatable.dart';

class InventoryProductModel extends Equatable {
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
    quantidadeInvContProEmb: double.tryParse(json['Quantidade_InvContProEmb']),
  );
}
