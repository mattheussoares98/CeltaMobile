import '../entities/entities.dart';

abstract class IPrintLastSavedSaleRequestRepository {
  Future<bool> printReceiptDirectly({
    required LastSavedSaleRequestEntity saleRequest,
    required String ip,
    required String userName,
  });
}
