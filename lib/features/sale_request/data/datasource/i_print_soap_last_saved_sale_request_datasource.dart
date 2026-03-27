import '../models/models.dart';

abstract class IPrintSoapLastSavedSaleRequestDatasource {
  Future<void> print({
    required SoapLastSavedSaleRequestModel saleRequest,
    required String ip,
    required String userName,
  });
}
