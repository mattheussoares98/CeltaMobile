import '../entities/entities.dart';

abstract class ISoapLoadInventoryRepository {
  Future<InventoryEntity> load({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
  });
}
