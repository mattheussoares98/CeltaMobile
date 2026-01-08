import '../entities/entities.dart';

abstract class ISoapSaveSaleRequestRepository {
  Future<String?> save({
    required String urlInUse,
    required String crossIdentity,
    required int enterpriseCode,
    required int requestTypeCode,
    required PendingSaleRequestEntity saleRequest,
  });
}
