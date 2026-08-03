import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_product_index_state_controller.g.dart';

@riverpod
class SelectedProductIndeStateController
    extends _$SelectedProductIndeStateController {
  @override
  int? build(int receiptCode) {
    ref.cache(30);
    //enough to avoid loosing the state while is building the products

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
