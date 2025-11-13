import '../models/models.dart';

abstract class IPrintLastSavedSaleRequestDatasource {
  Future<bool> print({
    required LastSavedSaleRequestModel saleRequest,
    required String ip,
    required String userName,
  });
}
