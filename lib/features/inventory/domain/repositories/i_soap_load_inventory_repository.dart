import '../entities/entities.dart';

abstract class ISoapLoadInventoryRepository {
  Future<InventoryEntity> load({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
  });
}
