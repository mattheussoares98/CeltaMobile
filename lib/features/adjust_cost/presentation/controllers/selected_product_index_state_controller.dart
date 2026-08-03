import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_product_index_state_controller.g.dart';

@riverpod
class SelectedProductIndexStateController
    extends _$SelectedProductIndexStateController {
  @override
  int? build(int enterpriseCode) {
    ref.cache(30);

    return null;
  }

  void updateIndex(int? index, {bool annulWhenIsSame = true}) {
    if (index == state && annulWhenIsSame) {
      state = null;
    } else {
      state = index;
    }
  }
}
