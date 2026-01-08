import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../core/providers/enterprise/enterprise.dart';
import '../../../../features/enterprises/presentation/controllers/controllers.dart';
import '../../../../core/domain/entities/entities.dart';

part 'enterprises_state_controller.g.dart';

@Riverpod(keepAlive: true)
class EnterprisesStateController extends _$EnterprisesStateController {
  @override
  Future<List<EnterpriseEntity>> build({int? enterpriseCode}) async {
    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    final workingUrl = validatedUser!.enterprise!.remoteHttpUrl!; //TODO fix
    final crossIdentity = validatedUser.user.CrossIdentity_Usuario!;

    final enterprises = await ref
        .watch(enterpriseRepositoryProvider)
        .getSoapEnterprises(
          url: workingUrl,
          crossIdentity: crossIdentity,
          enterpriseOriginCode: enterpriseCode,
          enterpriseIdInSupabase: validatedUser.enterprise!.id!,
          existingCnpjsInSupabase:
              validatedUser.enterprise!.subEnterprises
                  ?.map((e) => e.cnpjNumber)
                  .toSet()
                  .toList() ??
              [],
        );

    if (enterprises.isNotEmpty) {
      ref
          .read(selectedEnterpriseStateControllerProvider.notifier)
          .selectEnterprise(enterprises.first);
    }

    return enterprises;
  }
}
