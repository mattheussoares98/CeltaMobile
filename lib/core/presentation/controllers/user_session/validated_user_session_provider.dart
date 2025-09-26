import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../exceptions/exceptions.dart';
import '../../../data/models/models.dart';
import '../../../providers/user_session/user_session.dart';

part 'validated_user_session_provider.g.dart';

@Riverpod(keepAlive: true)
class ValidatedUserSession extends _$ValidatedUserSession {
  @override
  Future<UserSessionModel?> build() async {
    final userSession = await ref
        .read(localUserSessionRepositoryProvider)
        .get();

    if (userSession == null ||
        userSession.user.CrossIdentity_Usuario == null ||
        userSession.user.AccessKey == null ||
        userSession.enterprise?.baseUrl == null) {
      throw AppException('Sessão inválida. Efetue o login novamente'.hardcoded);
    }

    return userSession;
  }
}
