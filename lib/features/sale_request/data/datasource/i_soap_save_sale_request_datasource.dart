import '../models/models.dart';

abstract class ISoapSaveSaleRequestDatasource {
  Future<String?> save({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required int requestTypeCode,
    required SoapPendingSaleRequestModel saleRequest,
  });
}
