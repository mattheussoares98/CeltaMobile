import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

abstract class IPrintSaleRequestRepository {
  Future<void> soapPrint({
    required LastSavedSaleRequestEntity saleRequest,
    required String ip,
    required String userName,
  });

  Future<void> bsfPrint({
    required BSFSaleRequestEntity saleRequest,
    required String ip,
    required String userName,
  });
}
