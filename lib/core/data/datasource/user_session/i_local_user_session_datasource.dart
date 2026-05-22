import 'package:celta_inventario/core/data/models/models.dart';

abstract class ILocalUserSessionDatasource {
  Future<void> save(UserSessionModel session);
  Future<UserSessionModel?> get();
  Future<void> logout();
}
