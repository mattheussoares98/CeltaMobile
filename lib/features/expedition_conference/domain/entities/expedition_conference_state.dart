import 'package:equatable/equatable.dart';

import 'package:celta_inventario/features/expedition_conference/domain/entities/expedition_product_entity.dart';

typedef ProductPackingCodeID = int;
typedef QuantityID = double;

class ExpeditionConferenceState extends Equatable {
  final List<ExpeditionProductEntity> initialProducts;
  final Map<ProductPackingCodeID, QuantityID> pendingQuantities;
  final Map<ProductPackingCodeID, QuantityID> scannedQuantities;

  const ExpeditionConferenceState({
    required this.initialProducts,
    required this.pendingQuantities,
    required this.scannedQuantities,
  });

  @override
  List<Object?> get props => [
    initialProducts,
    pendingQuantities,
    scannedQuantities,
  ];

  bool get isComplete => pendingQuantities.values.every((qty) => qty == 0);

  factory ExpeditionConferenceState.initial(
    List<ExpeditionProductEntity> products,
  ) {
    return ExpeditionConferenceState(
      initialProducts: products,
      pendingQuantities: {
        for (var p in products) p.ProductPackingCode: p.Quantity,
      },
      scannedQuantities: const {},
    );
  }

  // A copyWith method makes updating the state much cleaner and safer
  ExpeditionConferenceState copyWith({
    Map<ProductPackingCodeID, QuantityID>? pendingQuantities,
    Map<ProductPackingCodeID, QuantityID>? scannedQuantities,
  }) {
    return ExpeditionConferenceState(
      initialProducts: initialProducts,
      pendingQuantities: pendingQuantities ?? this.pendingQuantities,
      scannedQuantities: scannedQuantities ?? this.scannedQuantities,
    );
  }

  List<ExpeditionProductEntity> get pendingProducts {
    return _getCurrentQuantity(pendingQuantities);
  }

  List<ExpeditionProductEntity> get scannedProducts {
    return _getCurrentQuantity(scannedQuantities);
  }

  List<ExpeditionProductEntity> _getCurrentQuantity(Map<int, double> value) {
    final List<ExpeditionProductEntity> result = [];
    for (final product in initialProducts) {
      // Get the current pending quantity from the map
      final currentPendingQty = value[product.ProductPackingCode] ?? 0;
      // If there is still quantity pending, add it to our list
      if (currentPendingQty > 0) {
        // Create a NEW entity with the UPDATED quantity
        result.add(product.copyWith(Quantity: currentPendingQty));
      }
    }
    return result;
  }
}
