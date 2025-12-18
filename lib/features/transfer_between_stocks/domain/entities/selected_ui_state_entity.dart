import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';

class SelectedUIStateEntity extends Equatable {
  final TransferJustificationEntity? selectedJustification;
  final StockTypeEntity? selectedOriginStock;
  final StockTypeEntity? selectedDestinyStock;
  final int? productIndex;

  const SelectedUIStateEntity({
    required this.selectedJustification,
    required this.selectedOriginStock,
    required this.selectedDestinyStock,
    required this.productIndex,
  });

  @override
  List<Object?> get props => [
    selectedJustification,
    selectedOriginStock,
    selectedDestinyStock,
    productIndex,
  ];

  SelectedUIStateEntity copyWith({
    TransferJustificationEntity? selectedJustification,
    StockTypeEntity? selectedOriginStock,
    StockTypeEntity? selectedDestinyStock,
    int? productIndex,
  }) {
    return SelectedUIStateEntity(
      selectedJustification:
          selectedJustification ?? this.selectedJustification,
      selectedOriginStock: selectedOriginStock ?? this.selectedOriginStock,
      selectedDestinyStock: selectedDestinyStock ?? this.selectedDestinyStock,
      productIndex: productIndex ?? this.productIndex,
    );
  }

  factory SelectedUIStateEntity.empty() => const SelectedUIStateEntity(
    selectedJustification: null,
    selectedOriginStock: null,
    selectedDestinyStock: null,
    productIndex: null,
  );

  SelectedUIStateEntity annulValues({bool? annulProductIndex}) {
    return SelectedUIStateEntity(
      selectedJustification: selectedJustification,
      selectedOriginStock: selectedOriginStock,
      selectedDestinyStock: selectedDestinyStock,
      productIndex: annulProductIndex == true ? null : productIndex,
    );
  }
}
