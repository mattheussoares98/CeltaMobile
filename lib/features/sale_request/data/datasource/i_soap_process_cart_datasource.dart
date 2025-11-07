import '../models/models.dart';

abstract class ISoapProcessCartDatasource {
  Future<ProcessedCartModel> process({
    required String crossId,
    required String baseUrl,
    required int enterpriseCode,
    required int requestTypeCode,
    required int customerCode,
    required int? covenantCode,
    required List<CartProductModel> products,
  });
}
