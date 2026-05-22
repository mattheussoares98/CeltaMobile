import 'package:celta_inventario/features/sale_request/data/models/models.dart';

abstract class ILocalLastSavedSaleRequestDatasource {
  Future<void> save({
    required SoapLastSavedSaleRequestModel value,
    required int enterpriseCode,
  });
  Future<SoapLastSavedSaleRequestModel?> load(int enterpriseCode);
}
