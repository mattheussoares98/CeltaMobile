import 'package:celta_inventario/features/buy_quotation/data/models/models.dart';

abstract class ISoapInsertUpdateBuyQuotationDatasource {
  Future<void> insertUpdate({
    required String workingUrl,
    required String crossIdentity,
    required BuyQuotationModel buyQuotation,
  });
}
