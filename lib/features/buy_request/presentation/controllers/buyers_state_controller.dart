import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'buyers_state_controller.g.dart';

@riverpod
class BuyersStateController extends _$BuyersStateController {
  @override
  FutureOr<List<BuyerEntity>?> build() async {
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

    final userSession = await ref.watch(validatedUserSessionProvider.future);

    return await ref
        .read(soapLoadBuyersRepositoryProvider)
        .load(
          baseUrl: userSession!.enterprise!.baseUrl!,
          crossIdentity: userSession.user.CrossIdentity_Usuario!,
        );
  }
}
