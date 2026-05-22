import 'package:celta_inventario/core/data/models/models.dart';

abstract class ISoapGetProductsJsonDatasource {
  Future<List<ProductModelType>> get({
    required String workingUrl,
    required Map<String, dynamic> parametersPayload,
    required bool isCompetingPrices,
  });
}
