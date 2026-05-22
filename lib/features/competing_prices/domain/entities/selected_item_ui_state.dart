import 'package:equatable/equatable.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';

class SelectedItemUIState extends Equatable {
  final int? selectedIndex;
  final SearchProductCompetingPriceType searchType;
  final bool onlyAssociateds;

  const SelectedItemUIState({
    this.selectedIndex,
    this.onlyAssociateds = true,
    this.searchType = SearchProductCompetingPriceType.all,
  });

  @override
  List<Object?> get props => [selectedIndex, searchType, onlyAssociateds];

  factory SelectedItemUIState.empty() {
    return const SelectedItemUIState(
      selectedIndex: null,
      searchType: SearchProductCompetingPriceType.all,
      onlyAssociateds: true,
    );
  }

  SelectedItemUIState copyWith({
    int? selectedIndex,
    SearchProductCompetingPriceType? searchType,
    bool? onlyAssociateds,
    bool resetSelectedIndex = false,
  }) {
    return SelectedItemUIState(
      selectedIndex: resetSelectedIndex
          ? null
          : (selectedIndex ?? this.selectedIndex),
      searchType: searchType ?? this.searchType,
      onlyAssociateds: onlyAssociateds ?? this.onlyAssociateds,
    );
  }
}
