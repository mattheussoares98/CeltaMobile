import 'package:celta_inventario/core/data/models/user_session_model.dart';
import 'package:hive/hive.dart';

import '../../../../features/auth/data/models/models.dart';
import '../../../infraestructure/infrastructure.dart';
import 'user_session.dart';

class LocalUserSessionDatasource implements ILocalUserSessionDatasource {
  final Box box;
  LocalUserSessionDatasource(this.box);

  @override
  Future<void> logout() async {
    final localUser = await box.get(DatabaseConstants.userSession.name);
    await box.delete(DatabaseConstants.userSession.name);

    if (localUser != null) {
      final userSession = UserSessionModel.fromJson(
        Map<String, dynamic>.from(localUser),
      );
      await box.put(
        DatabaseConstants.userSession.name,
        UserSessionModel(
          user: UserModel(
            name: userSession.user.name,
            enterpriseName: userSession.user.enterpriseName,
            AccessKey: null,
            CrossIdentity_Usuario: null,
          ),
          enterprise: null,
          selectedEnterprise: null,
        ).toJson(),
      );
    }
  }

  @override
  Future<UserSessionModel?> get() async {
    final localSession = await box.get(DatabaseConstants.userSession.name);

    if (localSession == null) {
      return null;
    } else {
      return UserSessionModel.fromJson(localSession);
    }
  }

  @override
  Future<void> save(UserSessionModel session) async {
    await box.delete(DatabaseConstants.userSession.name);
    await box.put(DatabaseConstants.userSession.name, session.toJson());
  }
}
