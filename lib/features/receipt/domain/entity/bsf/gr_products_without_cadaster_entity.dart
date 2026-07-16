// lib/features/receipt/domain/entity/bsf/gr_products_without_cadaster_entity.dart
import 'package:equatable/equatable.dart';

class GRProductsWithoutCadasterEntity extends Equatable {
  final dynamic document;
  final int? code;
  final double? quantity;
  final double? quantityOfXml;
  final double? unitLiquidValue;
  final double? unitValue;
  final String? reference;
  final String? ean;
  final String? observations;

  const GRProductsWithoutCadasterEntity({
    this.document,
    this.code,
    this.quantity,
    this.quantityOfXml,
    this.unitLiquidValue,
    this.unitValue,
    this.reference,
    this.ean,
    this.observations,
  });

  @override
  List<Object?> get props => [
        document,
        code,
        quantity,
        quantityOfXml,
        unitLiquidValue,
        unitValue,
        reference,
        ean,
        observations,
      ];
}
