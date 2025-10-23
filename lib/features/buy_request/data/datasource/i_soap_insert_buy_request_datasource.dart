import '../../data/models/models.dart';

abstract class ISoapInsertBuyRequestDatasource {
  Future<String?> insertBuyRequest({
    required String baseUrl,
    required String crossIdentity,
    required int buyerCode,
    required int requestTypeCode,
    required int supplierCode,
    required String? observations,
    required List<int> enterpriseCodes,
    required List<BuyRequestProductItemModel> products,
  });
}
