import '../../data/models/models.dart';

abstract class ILocalSessionRepository {
  Future<void> save(SessionModel session);
  Future<SessionModel?> get();
  Future<void> clear();
}
