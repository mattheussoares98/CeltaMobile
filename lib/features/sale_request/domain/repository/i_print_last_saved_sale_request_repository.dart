import '../entities/entities.dart';

abstract class IPrintLastSavedSaleRequestRepository {
  Future<bool> print({
    required LastSavedSaleRequestEntity saleRequest,
    required String ip,
    required String userName,
  });
}
