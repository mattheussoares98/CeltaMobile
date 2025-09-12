import 'package:celta_intelligence/core/data/models/session_model.dart';
import 'package:hive/hive.dart';

import '../../../constants/database_keys.dart';
import 'session.dart';

class LocalSessionDataSource implements ILocalSessionDataSource {
  final Box box;
  LocalSessionDataSource(this.box);

  @override
  Future<void> clear() async {
    await box.delete(DatabaseKeys.session.name);
  }

  @override
  Future<SessionModel?> get() async {
    final localSession = await box.get(DatabaseKeys.session.name);

    if (localSession == null) {
      return null;
    } else {
      return SessionModel.fromJson(localSession);
    }
  }

  @override
  Future<void> save(SessionModel session) async {
    await box.put(DatabaseKeys.session.name, session.toJson());
  }
}
