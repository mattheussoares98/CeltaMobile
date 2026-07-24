import 'dart:async';

import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_movement/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shallow_buy_movement_state_controller.g.dart';

@riverpod
class ShallowBuyMovementStateController
    extends _$ShallowBuyMovementStateController {
  @override
  FutureOr<List<EcBuyMovementDtoEntity>?> build(int enterpriseCode) {
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

    return null;
  }

  Future<void> load(DateTime date) async {
    final ecParams = await ref.read(ecRequestParamsProvider().future);

    LoadShallowBuyMovementParams params = LoadShallowBuyMovementParams(
      requestParams: ecParams,
      selectedDate: date,
      enterpriseCode: enterpriseCode,
    );

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await ref
          .read(ecBuyMovementRepositoryProvider)
          .loadShallow(params);

      return result;
    });
  }
}
