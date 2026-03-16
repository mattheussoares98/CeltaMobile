import '../models/models.dart';

abstract class ILocalPendingSaleRequestDatasource {
  Future<void> save(SoapPendingSaleRequestModel value, int enterpriseCode);
  Future<SoapPendingSaleRequestModel?> load(int enterpriseCode);
  Future<void> clear(int enterpriseCode);
}
