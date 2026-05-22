import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

class SelectedProductUIStateEntity extends Equatable {
  final TransferJustificationEntity? selectedJustification;
  final StockTypeEntity? selectedOriginStock;
  final StockTypeEntity? selectedDestinyStock;
  final int? productIndex;
  final int pageIndex;

  const SelectedProductUIStateEntity({
    required this.selectedJustification,
    required this.selectedOriginStock,
    required this.selectedDestinyStock,
    required this.productIndex,
    required this.pageIndex,
  });

  @override
  List<Object?> get props => [
    selectedJustification,
    selectedOriginStock,
    selectedDestinyStock,
    productIndex,
    pageIndex,
  ];

  SelectedProductUIStateEntity copyWith({
    TransferJustificationEntity? selectedJustification,
    StockTypeEntity? selectedOriginStock,
    StockTypeEntity? selectedDestinyStock,
    int? productIndex,
    int? pageIndex,
  }) {
    return SelectedProductUIStateEntity(
      selectedJustification:
          selectedJustification ?? this.selectedJustification,
      selectedOriginStock: selectedOriginStock ?? this.selectedOriginStock,
      selectedDestinyStock: selectedDestinyStock ?? this.selectedDestinyStock,
      productIndex: productIndex ?? this.productIndex,
      pageIndex: pageIndex ?? this.pageIndex,
    );
  }

  factory SelectedProductUIStateEntity.empty() =>
      const SelectedProductUIStateEntity(
        selectedJustification: null,
        selectedOriginStock: null,
        selectedDestinyStock: null,
        productIndex: null,
        pageIndex: 0,
      );

  SelectedProductUIStateEntity annulValues({bool? annulProductIndex}) {
    return SelectedProductUIStateEntity(
      selectedJustification: selectedJustification,
      selectedOriginStock: selectedOriginStock,
      selectedDestinyStock: selectedDestinyStock,
      pageIndex: pageIndex,
      productIndex: annulProductIndex == true ? null : productIndex,
    );
  }
}
