import '../models/models.dart';

abstract class ISoapInsertUpdateBuyQuotationDatasource {
  Future<void> insertUpdate({
    required String urlInUse,
    required String crossIdentity,
    required BuyQuotationModel buyQuotation,
  });
}
