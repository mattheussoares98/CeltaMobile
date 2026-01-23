import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/domain/entities/entities.dart';
import '../../../providers/transfer_justification/transfer_justification.dart';
import '../user_session/user_session.dart';

part 'transfer_justification_state_controller.g.dart';

@Riverpod(keepAlive: true)
class TransferJustificationStateController
    extends _$TransferJustificationStateController {
  @override
  Future<List<TransferJustificationEntity>> build(
    int enterpriseCode,
    TransferJustificationType type,
  ) async {
    final repository = ref.watch(soapTransferJustificationRepositoryProvider);
    final userSession = await ref.watch(validatedUserSessionProvider.future);

    final workingUrl = userSession!.enterprise!.workingUrl!;
    final crossIdentity = userSession.user.CrossIdentity_Usuario!;

    return await repository.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      type: type,
    );
  }
}
