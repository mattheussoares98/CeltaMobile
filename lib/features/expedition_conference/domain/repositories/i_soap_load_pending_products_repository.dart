import '../entities/entities.dart';

abstract class ISoapLoadPendingProductsRepository {
  Future<List<ExpeditionProductEntity>> load({
    required String urlInUse,
    required String crossIdentity,
    required int expeditionControlCode,
  });
}
