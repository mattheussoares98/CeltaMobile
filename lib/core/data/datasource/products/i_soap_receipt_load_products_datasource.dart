import '../../models/models.dart';

abstract class ISoapReceiptLoadProductsDatasource {
  Future<List<ProductModelType>> get({
    required String baseUrl,
    required Map<String, dynamic> parametersPayload,
  });
}
