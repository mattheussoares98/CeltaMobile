import '../models/models.dart';

abstract class ISoapLoadPendingProductsDatasource {
  Future<List<ExpeditionProductModel>> load({
    required String workingUrl,
    required String crossIdentity,
    required int expeditionControlCode,
  });
}
