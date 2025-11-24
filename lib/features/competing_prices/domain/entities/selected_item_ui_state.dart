import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/entities.dart';

class SelectedItemUIState extends Equatable {
  final int? selectedIndex;
  final SearchProductCompetingPriceType searchType;

  const SelectedItemUIState({
    this.selectedIndex,
    this.searchType = SearchProductCompetingPriceType.all,
  });

  @override
  List<Object?> get props => [selectedIndex, searchType];

  factory SelectedItemUIState.empty() {
    return const SelectedItemUIState(
      selectedIndex: null,
      searchType: SearchProductCompetingPriceType.all,
    );
  }

  SelectedItemUIState copyWith({
    int? selectedIndex,
    SearchProductCompetingPriceType? searchType,
  }) {
    return SelectedItemUIState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      searchType: searchType ?? this.searchType,
    );
  }
}
