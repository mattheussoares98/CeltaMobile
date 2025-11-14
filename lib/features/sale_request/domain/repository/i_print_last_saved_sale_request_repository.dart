import '../entities/entities.dart';

abstract class IPrintLastSavedSaleRequestRepository {
  Future<void> print({
    required LastSavedSaleRequestEntity saleRequest,
    required String ip,
    required String userName,
  });
}
