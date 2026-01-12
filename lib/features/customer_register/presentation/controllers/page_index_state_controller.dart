import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'page_index_state_controller.g.dart';

@riverpod
class PageIndexStateController extends _$PageIndexStateController {
  @override
  int build() => 0;

  void updateIndex(int index) {
    state = index;
  }
}
