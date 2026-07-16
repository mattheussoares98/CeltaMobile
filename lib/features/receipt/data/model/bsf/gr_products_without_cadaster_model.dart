// lib/features/receipt/data/model/bsf/gr_products_without_cadaster_model.dart
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';

class GRProductsWithoutCadasterModel extends GRProductsWithoutCadasterEntity {
  const GRProductsWithoutCadasterModel({
    super.document,
    super.code,
    super.quantity,
    super.quantityOfXml,
    super.unitLiquidValue,
    super.unitValue,
    super.reference,
    super.ean,
    super.observations,
  });

  factory GRProductsWithoutCadasterModel.fromJson(Map json) =>
      GRProductsWithoutCadasterModel(
        document: json['Document'],
        code: json['Code'],
        quantity: json['Quantity'] != null
            ? double.tryParse(json['Quantity'].toString())
            : null,
        quantityOfXml: json['QuantityOfXml'] != null
            ? double.tryParse(json['QuantityOfXml'].toString())
            : null,
        unitLiquidValue: json['UnitLiquidValue'] != null
            ? double.tryParse(json['UnitLiquidValue'].toString())
            : null,
        unitValue: json['UnitValue'] != null
            ? double.tryParse(json['UnitValue'].toString())
            : null,
        reference: json['Reference']?.toString(),
        ean: json['EAN']?.toString(),
        observations: json['Observations']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'Document': document,
        'Code': code,
        'Quantity': quantity,
        'QuantityOfXml': quantityOfXml,
        'UnitLiquidValue': unitLiquidValue,
        'UnitValue': unitValue,
        'Reference': reference,
        'EAN': ean,
        'Observations': observations,
      };

  factory GRProductsWithoutCadasterModel.fromEntity(
          GRProductsWithoutCadasterEntity entity) =>
      GRProductsWithoutCadasterModel(
        document: entity.document,
        code: entity.code,
        quantity: entity.quantity,
        quantityOfXml: entity.quantityOfXml,
        unitLiquidValue: entity.unitLiquidValue,
        unitValue: entity.unitValue,
        reference: entity.reference,
        ean: entity.ean,
        observations: entity.observations,
      );

  GRProductsWithoutCadasterEntity toEntity() => GRProductsWithoutCadasterEntity(
        document: document,
        code: code,
        quantity: quantity,
        quantityOfXml: quantityOfXml,
        unitLiquidValue: unitLiquidValue,
        unitValue: unitValue,
        reference: reference,
        ean: ean,
        observations: observations,
      );
}
