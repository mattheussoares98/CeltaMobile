import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/providers/services/services.dart';

part 'app_version_state_controller.g.dart';

@Riverpod(keepAlive: true)
class AppVersionStateController extends _$AppVersionStateController {
  @override
  FutureOr<String> build() async {
    return await ref.read(deviceServiceProvider).getAppVersion();
  }
}

