import '../../models/models.dart';

abstract class ISoapReceiptLoadProductsDatasource {
  Future<List<ProductModelType>> get({
    required String urlInUse,
    required Map<String, dynamic> parametersPayload,
  });
}
