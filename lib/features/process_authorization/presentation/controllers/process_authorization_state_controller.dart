import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/process_authorization/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'process_authorization_state_controller.g.dart';

@Riverpod(keepAlive: true)
class ProcessAuthorizationStateController
    extends _$ProcessAuthorizationStateController {
  @override
  FutureOr<dynamic> build() async {
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

    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    final repository = ref.read(ecProcessAuthorizationRepositoryProvider);
    final ecParams = EcRequestParams(
      workingUrl: validatedUser!.enterprise!.workingUrl!,
      user: validatedUser.user.name!,
      accessKey: validatedUser.user.AccessKey!,
    );
    //TODO create tests
    final response = await Future.wait([
      repository.getStatistics(ecParams),
      repository.getJudgments(ecParams),
    ]);
    return response;
  }
}
