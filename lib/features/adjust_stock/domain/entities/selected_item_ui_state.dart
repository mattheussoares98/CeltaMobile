// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

class SelectedItemUIState extends Equatable {
  final TransferJustificationEntity? selectedJustification;
  final StockTypeEntity? selectedStockType;
  final int? selectedIndex;

  const SelectedItemUIState({
    required this.selectedJustification,
    required this.selectedStockType,
    required this.selectedIndex,
  });

  @override
  List<Object?> get props => [
    selectedJustification,
    selectedStockType,
    selectedIndex,
  ];

  SelectedItemUIState copyWith({
    TransferJustificationEntity? selectedJustification,
    StockTypeEntity? selectedStockType,
    int? selectedIndex,
  }) {
    return SelectedItemUIState(
      selectedJustification:
          selectedJustification ?? this.selectedJustification,
      selectedStockType: selectedStockType ?? this.selectedStockType,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  factory SelectedItemUIState.empty() => const SelectedItemUIState(
    selectedJustification: null,
    selectedStockType: null,
    selectedIndex: null,
  );

  SelectedItemUIState annulValues({bool? annulSelectedIndex}) {
    return SelectedItemUIState(
      selectedJustification: selectedJustification,
      selectedStockType: selectedStockType,
      selectedIndex: annulSelectedIndex == true ? null : this.selectedIndex,
    );
  }
}
