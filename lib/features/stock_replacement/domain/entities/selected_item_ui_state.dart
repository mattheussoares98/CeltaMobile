// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';

class SelectedItemUIState extends Equatable {
  final StockTypeEntity? selectedStockType;
  final int? selectedIndex;

  const SelectedItemUIState({
    required this.selectedStockType,
    required this.selectedIndex,
  });

  @override
  List<Object?> get props => [selectedStockType, selectedIndex];

  SelectedItemUIState copyWith({
    StockTypeEntity? selectedStockType,
    int? selectedIndex,
  }) {
    return SelectedItemUIState(
      selectedStockType: selectedStockType ?? this.selectedStockType,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  factory SelectedItemUIState.empty() =>
      const SelectedItemUIState(selectedStockType: null, selectedIndex: null);

  SelectedItemUIState annulValues({bool? annulSelectedIndex}) {
    return SelectedItemUIState(
      selectedStockType: selectedStockType,
      selectedIndex: annulSelectedIndex == true ? null : this.selectedIndex,
    );
  }
}
