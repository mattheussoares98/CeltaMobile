import '../models/models.dart';

abstract class IPrintLastSavedSaleRequestDatasource {
  Future<void> print({
    required SoapLastSavedSaleRequestModel saleRequest,
    required String ip,
    required String userName,
  });
}
