import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../core/providers/request_type/request_type.dart';
import '../../../enterprise_manager/domain/entities/entities.dart';

part 'request_type_state_controller.g.dart';

@riverpod
class RequestTypeStateController extends _$RequestTypeStateController {
  @override
  FutureOr<List<RequestTypeEntity>?> build(Modules module) async {
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
        .read(soapLoadRequestTypeRepositoryProvider)
        .load(
          baseUrl: userSession!.enterprise!.baseUrl!,
          crossIdentity: userSession.user.CrossIdentity_Usuario!,
          inclusiveBuy: true,
          inclusiveTransfer: false,
          inclusiveSale: false,
        );
  }
}
