import 'dart:async';

import 'package:riverpod/riverpod.dart';

extension RefCacheExtension on Ref {
  void cache([Duration duration = const Duration(seconds: 20)]) {
    Timer? disposeTimer;
    final link = keepAlive();

    onCancel(() {
      disposeTimer?.cancel();
      disposeTimer = Timer(duration, link.close);
    });
    onResume(() {
      disposeTimer?.cancel();
      disposeTimer = null;
    });
    onDispose(() {
      disposeTimer?.cancel();
    });
  }
}
