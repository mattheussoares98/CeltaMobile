import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/entities.dart';
import '../../../providers/stock/stock.dart';
import '../user_session/user_session.dart';

part 'confirm_adjust_stock_controller.g.dart';

@riverpod
class ConfirmAdjustStockController extends _$ConfirmAdjustStockController {
  @override
  FutureOr<LastConfirmedAdjustEntity?> build() {
    return null;
  }

  Future<void> confirm(List<AdjustStockItemEntity> items) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(soapAdjustStockRepositoryProvider);
      final userSession = await ref.read(validatedUserSessionProvider.future);

      final workingUrl = userSession!.enterprise!.workingUrl!;
      final crossIdentity = userSession.user.CrossIdentity_Usuario!;

      await repository.confirm(
        workingUrl: workingUrl,
        crossIdentity: crossIdentity,
        items: items,
      );

      if (items.length == 1) {
        //!return only when has one item in the list because is adjustStock feature. If has more than one, is transfer between stocks feature and this feature creates a lot
        return LastConfirmedAdjustEntity(
          productPackingCode: items[0].ProductPackingCode,
          quantity: items[0].Quantity,
        );
      }
      return null;
    });
  }
}
