import '../models/models.dart';

abstract class ISoapLoadPendingProductsDatasource {
  Future<List<ExpeditionProductModel>> load({
    required String baseUrl,
    required String crossIdentity,
    required int expeditionControlCode,
  });
}
