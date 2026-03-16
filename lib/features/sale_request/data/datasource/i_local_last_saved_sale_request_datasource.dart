import '../models/models.dart';

abstract class ILocalLastSavedSaleRequestDatasource {
  Future<void> save({
    required SoapLastSavedSaleRequestModel value,
    required int enterpriseCode,
  });
  Future<SoapLastSavedSaleRequestModel?> load(int enterpriseCode);
}
