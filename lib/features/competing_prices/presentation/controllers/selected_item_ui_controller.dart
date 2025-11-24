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
    state = value;
  }
}
