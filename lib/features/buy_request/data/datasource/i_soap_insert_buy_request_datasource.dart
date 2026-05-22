import 'package:celta_inventario/features/buy_request/data/models/models.dart';

abstract class ISoapInsertBuyRequestDatasource {
  Future<String?> insertBuyRequest({
    required String workingUrl,
    required String crossIdentity,
    required int buyerCode,
    required int requestTypeCode,
    required int supplierCode,
    required String? observations,
    required List<int> enterpriseCodes,
    required List<BuyRequestProductItemModel> products,
  });
}
