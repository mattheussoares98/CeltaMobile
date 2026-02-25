import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'page_index_state_controller.g.dart';

@Riverpod(keepAlive: true)
class PageIndexStateController extends _$PageIndexStateController {
  @override
  int build() => 0;

  void updateIndex(int index) => state = index;
}
