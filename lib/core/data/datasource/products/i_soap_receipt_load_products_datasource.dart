import '../../models/models.dart';

abstract class ISoapReceiptLoadProductsDatasource {
  Future<List<ProductModelType>> get({
    required String workingUrl,
    required Map<String, dynamic> parametersPayload,
  });
}
