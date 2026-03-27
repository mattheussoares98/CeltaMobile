import '../models/models.dart';

abstract class IPrintBSFSaleRequestDatasource {
  Future<void> print({
    required BSFSaleRequestModel saleRequest,
    required String ip,
    required String userName,
  });
}
