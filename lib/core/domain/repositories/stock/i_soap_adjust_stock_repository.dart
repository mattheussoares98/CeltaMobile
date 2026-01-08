import '../../entities/entities.dart';

abstract class ISoapAdjustStockRepository {
  Future<void> confirm({
    required String workingUrl,
    required String crossIdentity,
    required List<AdjustStockItemEntity> items,
  });
}
