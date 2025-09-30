import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';

class ProductLotInfoEntity extends Equatable {
  final ProductEntity product;
  final TransferJustificationEntity selectedJustification;
  final StockTypeEntity selectedOriginStock;
  final StockTypeEntity selectedDestinyStock;

  const ProductLotInfoEntity({
    required this.product,
    required this.selectedJustification,
    required this.selectedOriginStock,
    required this.selectedDestinyStock,
  });

  @override
  List<Object?> get props => [
    product,
    selectedJustification,
    selectedOriginStock,
    selectedDestinyStock,
  ];
}
