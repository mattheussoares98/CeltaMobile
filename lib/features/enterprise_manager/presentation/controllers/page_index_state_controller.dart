import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'page_index_state_controller.g.dart';

@riverpod
class PageIndexStateController extends _$PageIndexStateController {
  @override
  int build() {
    ref.cache();

    return 0;
  }

  void updateIndex(int index) => state = index;
}
