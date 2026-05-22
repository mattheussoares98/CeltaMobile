import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class ISoapAdjustStockRepository {
  Future<void> confirm({
    required String workingUrl,
    required String crossIdentity,
    required List<AdjustStockItemEntity> items,
  });
}
