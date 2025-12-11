import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_product_index_state_controller.g.dart';

@riverpod
class SelectedProductIndeStateController
    extends _$SelectedProductIndeStateController {
  @override
  int? build() {
    return null;
  }

  void updateIndex(int? index) {
    if (index == state) {
      state = null;
    } else {
      state = index;
    }
  }
}
