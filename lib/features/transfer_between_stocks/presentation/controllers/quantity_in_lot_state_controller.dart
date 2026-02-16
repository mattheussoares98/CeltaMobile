import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'controllers.dart';

part 'quantity_in_lot_state_controller.g.dart';

@riverpod
class QuantityInLotStateController extends _$QuantityInLotStateController {
  @override
  double? build(int enterpriseCode, int productPackingCode) {
    return ref
        .watch(
          lotStateControllerProvider(enterpriseCode).select(
            (asyncLot) => asyncLot.value?.firstWhereOrNull(
              (e) => e.product.ProductPackingCode == productPackingCode,
            ),
          ),
        )
        ?.quantity;
  }
}
