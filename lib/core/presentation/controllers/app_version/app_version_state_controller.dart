import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/providers/app_version/app_version.dart';

part 'app_version_state_controller.g.dart';

@Riverpod(keepAlive: true)
class AppVersionStateController extends _$AppVersionStateController {
  @override
  FutureOr<String> build() async {
    return await ref.read(loadAppVersionDatasourceProvider).get();
  }
}
