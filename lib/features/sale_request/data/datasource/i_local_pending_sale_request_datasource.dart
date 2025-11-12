import '../models/models.dart';

abstract class ILocalPendingSaleRequestDatasource {
  Future<void> save(PendingSaleRequestModel value, int enterpriseCode);
  Future<PendingSaleRequestModel?> load(int enterpriseCode);
  Future<void> clear();
}
