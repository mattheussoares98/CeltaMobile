import '../models/models.dart';

abstract class ISoapInsertUpdateBuyQuotationDatasource {
  Future<void> insertUpdate({
    required String baseUrl,
    required String crossIdentity,
    required BuyQuotationModel buyQuotation,
  });
}
