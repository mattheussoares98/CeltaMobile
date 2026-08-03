import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/transfer_request/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'destiny_enterprises_state_controller.g.dart';

@riverpod
class DestinyEnterprisesStateController
    extends _$DestinyEnterprisesStateController {
  @override
  Future<List<EnterpriseEntity>> build({
    required int requestTypeCode,
    required int enterpriseOriginCode,
  }) async {
    ref.cache(60);

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
