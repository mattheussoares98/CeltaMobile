import '../models/models.dart';

abstract class ISoapSaveSaleRequestDatasource {
  Future<String?> save({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required int requestTypeCode,
    required PendingSaleRequestModel saleRequest,
  });
}
