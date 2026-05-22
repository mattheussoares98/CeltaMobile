import 'package:celta_inventario/features/sale_request/data/models/models.dart';

abstract class IPrintSoapLastSavedSaleRequestDatasource {
  Future<void> print({
    required SoapLastSavedSaleRequestModel saleRequest,
    required String ip,
    required String userName,
  });
}
