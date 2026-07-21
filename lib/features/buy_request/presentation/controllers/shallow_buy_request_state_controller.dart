import 'dart:async';

import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/ec_request_params/ec_request_params.dart';

part 'shallow_buy_request_state_controller.g.dart';

@riverpod
class ShallowBuyRequestStateController
    extends _$ShallowBuyRequestStateController {
  @override
  FutureOr<List<EcBuyRequestDtoEntity>?> build(int enterpriseCode) {
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

    LoadShallowBuyRequestParams params = LoadShallowBuyRequestParams(
      requestParams: ecParams,
      selectedDate: date,
      enterpriseCode: enterpriseCode,
    );

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await ref
          .read(ecBuyRequestRepositoryProvider)
          .loadShallow(params);

      return result;
    });
  }
}
