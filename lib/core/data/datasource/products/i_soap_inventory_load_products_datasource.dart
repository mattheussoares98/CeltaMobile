import '../../models/models.dart';

abstract class ISoapInventoryLoadProductsDatasource {
  Future<List<ProductModelType>> get({
    required String urlInUse,
    required Map<String, dynamic> parametersPayload,
  });
}
