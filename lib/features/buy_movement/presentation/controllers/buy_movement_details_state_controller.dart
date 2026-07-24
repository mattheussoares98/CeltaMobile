import 'dart:async';

import 'package:celta_inventario/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_movement/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/ec_request_params/ec_request_params.dart';

part 'buy_movement_details_state_controller.g.dart';

@riverpod
class BuyMovementDetailsStateController
    extends _$BuyMovementDetailsStateController {
  @override
  FutureOr<EcBuyMovementDtoEntity> build(int buyMovementCode) async {
    Timer? timer;
    final link = ref.keepAlive();
    ref.onCancel(() {
      timer = Timer(const Duration(seconds: 20), () {
        link.close();
      });
    });
    ref.onResume(() {
      timer?.cancel();
    });
    ref.onDispose(() {
      timer?.cancel();
    });
    final ecParams = await ref.read(ecRequestParamsProvider().future);

    final params = LoadBuyMovementDetailsParams(
      requestParams: ecParams,
      buyMovementCode: buyMovementCode,
    );

    return await ref.read(ecBuyMovementRepositoryProvider).loadDetails(params);
  }
}
