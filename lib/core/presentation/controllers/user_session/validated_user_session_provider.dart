import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/providers/enterprise/enterprise.dart';
import 'package:celta_inventario/core/providers/user_session/user_session.dart';

part 'validated_user_session_provider.g.dart';

@Riverpod(keepAlive: true)
class ValidatedUserSession extends _$ValidatedUserSession {
  @override
  Future<UserSessionModel?> build() async {
    final userSession = await ref.read(userSessionRepositoryProvider).get();

    if (userSession == null ||
        userSession.user.CrossIdentity_Usuario == null ||
        userSession.user.AccessKey == null) {
      throw AppException('Sessão inválida. Efetue o login novamente'.hardcoded);
    }

    final supabaseEnterprise = await ref
        .read(enterpriseRepositoryProvider)
        .getSupabaseEnterpriseByName(userSession.user.enterpriseName!);

    final workingUrl = await ref
        .read(soapUrlValidationRepositoryProvider)
        .findWorkingUrl([
          supabaseEnterprise!.remoteHttpUrl!,
          ?supabaseEnterprise.remoteHttpsUrl,
          ?supabaseEnterprise.localHttpUrl,
          ?supabaseEnterprise.localHttpsUrl,
        ]);

    return UserSessionModel(
      user: userSession.user,
      enterprise: SupabaseEnterpriseModel.fromEntity(
        supabaseEnterprise,
        workingUrl: workingUrl,
      ),
    );
  }
}
