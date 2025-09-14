import 'package:celta_intelligence/core/data/models/user_session_model.dart';
import 'package:hive/hive.dart';

import '../../../constants/database_keys.dart';
import 'user_session.dart';

class LocalUserSessionDataSource implements ILocalUserSessionDataSource {
  final Box box;
  LocalUserSessionDataSource(this.box);

  @override
  Future<void> clear() async {
    await box.delete(DatabaseKeys.userSession.name);
  }

  @override
  Future<UserSessionModel?> get() async {
    final localSession = await box.get(DatabaseKeys.userSession.name);

    if (localSession == null) {
      return null;
    } else {
      return UserSessionModel.fromJson(Map<String, dynamic>.from(localSession));
    }
  }

  @override
  Future<void> save(UserSessionModel session) async {
    await box.delete(DatabaseKeys.userSession.name);
    await box.put(DatabaseKeys.userSession.name, session.toJson());
  }
}
