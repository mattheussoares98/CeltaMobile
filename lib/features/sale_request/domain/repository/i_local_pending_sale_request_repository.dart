import '../entities/entities.dart';

abstract class ILocalPendingSaleRequestRepository {
  Future<void> save(PendingSaleRequestEntity value, int enterpriseCode);
  Future<PendingSaleRequestEntity?> load(int enterpriseCode);
  Future<void> clear(int enterpriseCode);
}
