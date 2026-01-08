import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/domain/entities/entities.dart';
import '../../../providers/transfer_justification/transfer_justification.dart';
import '../user_session/user_session.dart';

part 'transfer_justification_state_controller.g.dart';

@riverpod
class TransferJustificationStateController
    extends _$TransferJustificationStateController {
  @override
  Future<List<TransferJustificationEntity>> build(
    int enterpriseCode,
    TransferJustificationType type,
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

    final repository = ref.watch(soapTransferJustificationRepositoryProvider);
    final userSession = await ref.watch(validatedUserSessionProvider.future);

    final urlInUse = userSession!.enterprise!.urlInUse!;
    final crossIdentity = userSession.user.CrossIdentity_Usuario!;

    return await repository.load(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      type: type,
    );
  }
}
