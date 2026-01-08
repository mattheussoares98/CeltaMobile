import '../entities/entities.dart';

abstract class ISoapLoadInventoryRepository {
  Future<InventoryEntity> load({
    required String urlInUse,
    required String crossIdentity,
    required int enterpriseCode,
  });
}
