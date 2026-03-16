import '../models/models.dart';

abstract class ISoapProcessCartDatasource {
  Future<SoapProcessedCartModel> process({
    required String crossId,
    required String workingUrl,
    required int enterpriseCode,
    required int requestTypeCode,
    required int customerCode,
    required int? covenantCode,
    required List<SoapSaleRequestProductModel> products,
  });
}
