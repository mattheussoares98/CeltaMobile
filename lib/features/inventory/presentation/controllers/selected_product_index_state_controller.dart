import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_product_index_state_controller.g.dart';

@riverpod
class SelectedProductIndexStateController
    extends _$SelectedProductIndexStateController {
  @override
  int? build() {
    return null;
  }

  void updateIndex(int? value) {
    if (state == value) {
      state = null;
    } else {
      state = value;
    }
  }
}
