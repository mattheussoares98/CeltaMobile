import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_product_index_state_controller.g.dart';

@riverpod
class SelectedProductIndexStateController
    extends _$SelectedProductIndexStateController {
  @override
  int? build(int codigoInternoInvCont) {
    Timer? timer;
    final link = ref.keepAlive();
    ref.onCancel(() {
      timer = Timer(const Duration(seconds: 20), () {
        link.close();
      });
    });
    ref.onResume(() {
      timer?.cancel();
    });
    ref.onDispose(() {
      timer?.cancel();
    });
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
