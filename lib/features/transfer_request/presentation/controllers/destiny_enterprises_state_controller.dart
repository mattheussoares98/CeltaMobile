import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/providers.dart';

part 'destiny_enterprises_state_controller.g.dart';

@Riverpod(keepAlive: true)
class DestinyEnterprisesStateController
    extends _$DestinyEnterprisesStateController {
  @override
  Future<List<EnterpriseEntity>> build({
    required int requestTypeCode,
    required int enterpriseOriginCode,
  }) async {
    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    final enterprises = await ref
        .watch(soapLoadDestinyEnterprisesRepositoryProvider)
        .load(
          workingUrl: validatedUser!.enterprise!.workingUrl!,
          crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
          requestTypeCode: requestTypeCode,
          enterpriseOriginCode: enterpriseOriginCode,
        );

    return enterprises;
  }
}
