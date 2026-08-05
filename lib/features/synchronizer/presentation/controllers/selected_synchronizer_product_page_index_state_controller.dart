import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_synchronizer_product_page_index_state_controller.g.dart';

@riverpod
class SelectedSynchronizerProductPageIndexStateController
    extends _$SelectedSynchronizerProductPageIndexStateController {
  @override
  int build() {
    ref.cache();
    return 0;
  }

  void selectPageIndex(int index) => state = index;
}
