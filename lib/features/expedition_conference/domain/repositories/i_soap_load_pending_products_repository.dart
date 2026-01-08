import '../entities/entities.dart';

abstract class ISoapLoadPendingProductsRepository {
  Future<List<ExpeditionProductEntity>> load({
    required String workingUrl,
    required String crossIdentity,
    required int expeditionControlCode,
  });
}
