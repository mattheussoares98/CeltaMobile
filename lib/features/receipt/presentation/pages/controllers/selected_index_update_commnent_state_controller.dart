import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_index_update_commnent_state_controller.g.dart';

@riverpod
class SelectedIndexUpdateCommnentStateController
    extends _$SelectedIndexUpdateCommnentStateController {
  @override
  int? build() {
    return null;
  }

  void update(int index) async {
    if (state == index) {
      state = null;
    } else {
      state = index;
    }
  }
}
