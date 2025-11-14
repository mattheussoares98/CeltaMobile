import '../models/models.dart';

abstract class IPrintLastSavedSaleRequestDatasource {
  Future<void> print({
    required LastSavedSaleRequestModel saleRequest,
    required String ip,
    required String userName,
  });
}
