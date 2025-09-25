import 'dart:async';

import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/providers/user_session/user_session.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../exceptions/exceptions.dart';
import '../../../providers/transfer_justification/transfer_justification.dart';

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
    final userSession = await ref.watch(userSessionProvider.future);

    if (userSession == null) {
      throw AppException('Sessão inválida. Efetue o login novamente'.hardcoded);
    }
    final baseUrl = userSession.enterprise.baseUrl!;
    final crossIdentity = userSession.user.CrossIdentity_Usuario!;

    return await repository.load(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      type: type,
    );
  }
}
