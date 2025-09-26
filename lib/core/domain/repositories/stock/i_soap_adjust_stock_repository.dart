import '../../entities/entities.dart';

abstract class ISoapAdjustStockRepository {
  Future<void> confirm({
    required String baseUrl,
    required String crossIdentity,
    required List<AdjustStockItemEntity> items,
  });
}
