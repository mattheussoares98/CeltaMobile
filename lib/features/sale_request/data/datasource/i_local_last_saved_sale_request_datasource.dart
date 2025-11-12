import '../models/models.dart';

abstract class ILocalLastSavedSaleRequestDatasource {
  Future<void> save({
    required LastSavedSaleRequestModel value,
    required int enterpriseCode,
  });
  Future<LastSavedSaleRequestModel?> load(int enterpriseCode);
}
