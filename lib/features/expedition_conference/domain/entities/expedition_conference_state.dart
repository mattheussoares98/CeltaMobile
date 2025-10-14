import 'expedition_product_entity.dart';

typedef ProductPackingCodeID = int;
typedef QuantityID = int;

class ExpeditionConferenceState {
  final List<ExpeditionProductEntity> initialProducts;
  final Map<ProductPackingCodeID, QuantityID> pendingQuantities;
  final Map<ProductPackingCodeID, QuantityID> scannedQuantities;

  const ExpeditionConferenceState({
    required this.initialProducts,
    required this.pendingQuantities,
    required this.scannedQuantities,
  });

  bool get isComplete => pendingQuantities.values.every((qty) => qty == 0);
}
