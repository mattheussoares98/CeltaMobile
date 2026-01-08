import '../../entities/entities.dart';

abstract class ISoapAdjustStockRepository {
  Future<void> confirm({
    required String urlInUse,
    required String crossIdentity,
    required List<AdjustStockItemEntity> items,
  });
}
