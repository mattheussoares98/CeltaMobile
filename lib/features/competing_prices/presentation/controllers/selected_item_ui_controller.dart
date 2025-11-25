import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/entities.dart';

part 'selected_item_ui_controller.g.dart';

@riverpod
class SelectedItemUIController extends _$SelectedItemUIController {
  @override
  SelectedItemUIState build() {
    return const SelectedItemUIState();
  }

  void update(SelectedItemUIState value) {
    if (state.selectedIndex != null &&
        state.selectedIndex == value.selectedIndex) {
      state = SelectedItemUIState(searchType: value.searchType);
    } else {
      state = value;
    }
  }
}
