import 'package:celta_inventario/features/sale_request/data/models/models.dart';

abstract class IPrintBSFSaleRequestDatasource {
  Future<void> print({
    required BSFSaleRequestModel saleRequest,
    required String ip,
    required String userName,
  });
}
