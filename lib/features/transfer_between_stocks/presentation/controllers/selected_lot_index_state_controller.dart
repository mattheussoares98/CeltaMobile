import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_lot_index_state_controller.g.dart';

@riverpod
class SelectedLotIndexStateController
    extends _$SelectedLotIndexStateController {
  @override
  int? build() => null;

  void updateIndex(int? index) {
    if (state == index) {
      state = null;
    } else {
      state = index;
    }
  }
}
