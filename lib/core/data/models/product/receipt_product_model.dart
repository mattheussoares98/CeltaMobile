import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';

class ReceiptProductModel extends Equatable implements ProductModelType {
  final String Nome_Produto;
  final String FormatedProduct;
  final int CodigoInterno_Produto;
  final int CodigoInterno_ProEmb;
  final String CodigoPlu_ProEmb;
  final String? Codigo_ProEmb;
  final String PackingQuantity;
  final double? Quantidade_ProcRecebDocProEmb;
  final String? ReferenciaXml_ProcRecebDocProEmb;
  final List<String>? AllEans;
  final DateTime? DataValidade_ProcRecebDocProEmb;

  const ReceiptProductModel({
    required this.Nome_Produto,
    required this.FormatedProduct,
    required this.CodigoInterno_Produto,
    required this.CodigoInterno_ProEmb,
    required this.CodigoPlu_ProEmb,
    required this.Codigo_ProEmb,
    required this.PackingQuantity,
    required this.ReferenciaXml_ProcRecebDocProEmb,
    required this.AllEans,
    required this.DataValidade_ProcRecebDocProEmb,
    required this.Quantidade_ProcRecebDocProEmb,
  });

  @override
  List<Object?> get props => [
    Nome_Produto,
    FormatedProduct,
    CodigoInterno_Produto,
    CodigoInterno_ProEmb,
    CodigoPlu_ProEmb,
    Codigo_ProEmb,
    PackingQuantity,
    ReferenciaXml_ProcRecebDocProEmb,
    AllEans,
    DataValidade_ProcRecebDocProEmb,
    Quantidade_ProcRecebDocProEmb,
  ];

  factory ReceiptProductModel.fromJson(Map json) => ReceiptProductModel(
    Nome_Produto: json["Nome_Produto"],
    FormatedProduct: json["FormatedProduct"],
    CodigoInterno_Produto: int.parse(json["CodigoInterno_Produto"]),
    CodigoInterno_ProEmb: int.parse(json["CodigoInterno_ProEmb"]),
    CodigoPlu_ProEmb: json["CodigoPlu_ProEmb"],
    Codigo_ProEmb: json["Codigo_ProEmb"],
    PackingQuantity: json["PackingQuantity"],
    Quantidade_ProcRecebDocProEmb: json["Quantidade_ProcRecebDocProEmb"] == null
        ? null
        : double.parse(json["Quantidade_ProcRecebDocProEmb"]),
    ReferenciaXml_ProcRecebDocProEmb: json["ReferenciaXml_ProcRecebDocProEmb"],
    AllEans: (json["AllEans"] as String?)
        ?.split('\\r')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(),
    DataValidade_ProcRecebDocProEmb:
        json["DataValidade_ProcRecebDocProEmb"] == null
        ? null
        : DateTime.parse(json["DataValidade_ProcRecebDocProEmb"]),
  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "Nome_Produto": Nome_Produto,
    "FormatedProduct": FormatedProduct,
    "CodigoInterno_Produto": CodigoInterno_Produto.toString(),
    "CodigoInterno_ProEmb": CodigoInterno_ProEmb.toString(),
    "CodigoPlu_ProEmb": CodigoPlu_ProEmb,
    "Codigo_ProEmb": Codigo_ProEmb,
    "PackingQuantity": PackingQuantity,
    "Quantidade_ProcRecebDocProEmb": Quantidade_ProcRecebDocProEmb.toString(),
    "ReferenciaXml_ProcRecebDocProEmb": ReferenciaXml_ProcRecebDocProEmb,
    "AllEans": AllEans?.map((e) => e).join('\\r'),
    "DataValidade_ProcRecebDocProEmb":
        DataValidade_ProcRecebDocProEmb?.toIso8601String(),
  };

  factory ReceiptProductModel.fromEntity(ProductEntity entity) =>
      ReceiptProductModel(
        Nome_Produto: entity.Name!,
        FormatedProduct: entity.FormatedProduct!,
        CodigoInterno_Produto: entity.ProductCode!,
        CodigoInterno_ProEmb: entity.ProductPackingCode!,
        CodigoPlu_ProEmb: entity.PLU!,
        Codigo_ProEmb: entity.codigoInternoProEmb?.toString(),
        PackingQuantity: entity.PackingQuantity!,
        ReferenciaXml_ProcRecebDocProEmb:
            entity.ReferenciaXml_ProcRecebDocProEmb,
        AllEans: entity.EANs,
        DataValidade_ProcRecebDocProEmb: entity.DataValidade_ProcRecebDocProEmb,
        Quantidade_ProcRecebDocProEmb: entity.Quantidade_ProcRecebDocProEmb,
      );

  @override
  ProductEntity toEntity() => ProductEntity.empty().copyWith(
    Name: Nome_Produto,
    FormatedProduct: FormatedProduct,
    ProductCode: CodigoInterno_Produto,
    ProductPackingCode: CodigoInterno_ProEmb,
    PLU: CodigoPlu_ProEmb,
    codigoInternoProEmb: int.tryParse(Codigo_ProEmb ?? ''),
    PackingQuantity: PackingQuantity,
    ReferenciaXml_ProcRecebDocProEmb: ReferenciaXml_ProcRecebDocProEmb,
    EANs: AllEans,
    DataValidade_ProcRecebDocProEmb: DataValidade_ProcRecebDocProEmb,
    Quantidade_ProcRecebDocProEmb: Quantidade_ProcRecebDocProEmb,
  );
}
