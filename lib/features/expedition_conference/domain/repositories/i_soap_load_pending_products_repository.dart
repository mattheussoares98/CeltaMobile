import '../entities/entities.dart';

abstract class ISoapLoadPendingProductsRepository {
  Future<List<ExpeditionProductEntity>> load({
    required String baseUrl,
    required String crossIdentity,
    required int expeditionControlCode,
  });
}
