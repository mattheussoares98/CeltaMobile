// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

class ProductLotInfoEntity extends Equatable {
  final ProductEntity product;
  final TransferJustificationEntity selectedJustification;
  final StockTypeEntity selectedOriginStock;
  final StockTypeEntity selectedDestinyStock;
  final double quantity;

  const ProductLotInfoEntity({
    required this.product,
    required this.selectedJustification,
    required this.selectedOriginStock,
    required this.selectedDestinyStock,
    required this.quantity,
  });

  @override
  List<Object?> get props => [
    product,
    selectedJustification,
    selectedOriginStock,
    selectedDestinyStock,
    quantity,
  ];

  ProductLotInfoEntity copyWith({
    ProductEntity? product,
    TransferJustificationEntity? selectedJustification,
    StockTypeEntity? selectedOriginStock,
    StockTypeEntity? selectedDestinyStock,
    double? quantity,
  }) {
    return ProductLotInfoEntity(
      product: product ?? this.product,
      selectedJustification:
          selectedJustification ?? this.selectedJustification,
      selectedOriginStock: selectedOriginStock ?? this.selectedOriginStock,
      selectedDestinyStock: selectedDestinyStock ?? this.selectedDestinyStock,
      quantity: quantity ?? this.quantity,
    );
  }
}
