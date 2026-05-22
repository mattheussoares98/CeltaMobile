import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/competing_prices/domain/entities/entities.dart';

part 'selected_item_ui_controller.g.dart';

@riverpod
class SelectedItemUIController extends _$SelectedItemUIController {
  @override
  SelectedItemUIState build() {
    return const SelectedItemUIState();
  }

  void updateSelectedIndex(int? index) {
    if (state.selectedIndex != null && state.selectedIndex == index) {
      state = state.copyWith(resetSelectedIndex: true);
    } else {
      state = state.copyWith(
        selectedIndex: index,
        resetSelectedIndex: index == null,
      );
    }
  }

  void updateSearchType(SearchProductCompetingPriceType searchType) {
    state = state.copyWith(searchType: searchType);
  }

  void updateOnlyAssociateds(bool onlyAssociateds) {
    state = state.copyWith(onlyAssociateds: onlyAssociateds);
  }
}
