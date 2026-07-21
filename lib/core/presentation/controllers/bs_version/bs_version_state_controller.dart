import 'dart:async';

import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/bs_version/bs_version.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bs_version_state_controller.g.dart';

@riverpod
class BsVersionStateController extends _$BsVersionStateController {
  @override
  FutureOr<DateTime?> build() async {
    Timer? timer;
    final link = ref.keepAlive();
    ref.onCancel(() {
      timer = Timer(const Duration(seconds: 60), () {
        link.close();
      });
    });
    ref.onResume(() {
      timer?.cancel();
    });
    ref.onDispose(() {
      timer?.cancel();
    });

    final userSession = await ref.watch(validatedUserSessionProvider.future);
    final workingUrl = userSession?.enterprise?.workingUrl;
    return await ref.read(soapBsVersionDatasourceProvider).get(workingUrl!);
  }
}
