import '../models/models.dart';

abstract class ISoapLoadPendingProductsDatasource {
  Future<List<ExpeditionProductModel>> load({
    required String urlInUse,
    required String crossIdentity,
    required int expeditionControlCode,
  });
}
