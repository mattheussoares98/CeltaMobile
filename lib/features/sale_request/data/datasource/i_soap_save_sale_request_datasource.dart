import '../models/models.dart';

abstract class ISoapSaveSaleRequestDatasource {
  Future<String?> save({
    required String urlInUse,
    required String crossIdentity,
    required int enterpriseCode,
    required int requestTypeCode,
    required PendingSaleRequestModel saleRequest,
  });
}
