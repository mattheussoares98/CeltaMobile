import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'expedition_conference_controller.g.dart';

@riverpod
class ExpeditionConferenceController extends _$ExpeditionConferenceController {
  @override
  FutureOr<List<ExpeditionProductEntity>?> build(
    int expeditionControlCode,
    String enterpriseName,
  ) async {
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
        .read(soapLoadPendingProductsRepositoryProvider)
        .load(
          baseUrl: userSession!.enterprise!.baseUrl!,
          crossIdentity: userSession.user.CrossIdentity_Usuario!,
          expeditionControlCode: expeditionControlCode,
        );
  }
}
