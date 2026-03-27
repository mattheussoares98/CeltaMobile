import '../entities/entities.dart';

abstract class IPrintSaleRequestRepository {
  Future<void> soapPrint({
    required LastSavedSaleRequestEntity saleRequest,
    required String ip,
    required String userName,
  });
}
