import '../../models/models.dart';

abstract class ISoapGetProductsJsonDatasource {
  Future<List<ProductModelType>> get({
    required String urlInUse,
    required Map<String, dynamic> parametersPayload,
    required bool isCompetingPrices,
  });
}
