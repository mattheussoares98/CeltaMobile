import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_product_index_state_controller.g.dart';

@riverpod
class SelectedProductIndexStateController
    extends _$SelectedProductIndexStateController {
  @override
  int? build(int enterpriseCode) {
    Timer? timer;
    final link = ref.keepAlive();
    ref.onCancel(() {
      timer = Timer(const Duration(seconds: 30), () {
        //enough to avoid loosing the state while is building the products
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

  void updateIndex(int? index, {bool annulWhenIsSame = true}) {
    if (index == state && annulWhenIsSame) {
      state = null;
    } else {
      state = index;
    }
  }
}
