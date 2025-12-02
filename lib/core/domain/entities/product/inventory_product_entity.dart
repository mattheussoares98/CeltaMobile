import 'package:equatable/equatable.dart';

import '../entities.dart';

class InventoryProductEntity extends Equatable implements ProductEntityType {
  final String productName;
  final int codigoInternoProEmb;
  final String plu;
  final String codigoProEmb;
  final double? quantidadeInvContProEmb;

  const InventoryProductEntity({
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

  @override
  InventoryProductEntity copyWith({
    String? productName,
    int? codigoInternoProEmb,
    String? plu,
    String? codigoProEmb,
    double? quantidadeInvContProEmb,
  }) {
    return InventoryProductEntity(
      productName: productName ?? this.productName,
      codigoInternoProEmb: codigoInternoProEmb ?? this.codigoInternoProEmb,
      plu: plu ?? this.plu,
      codigoProEmb: codigoProEmb ?? this.codigoProEmb,
      quantidadeInvContProEmb:
          quantidadeInvContProEmb ?? this.quantidadeInvContProEmb,
    );
  }
}
