import 'package:celta_inventario/features/buy_request/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/ec_request_params/ec_request_params.dart';

part 'shallow_buy_request_state_controller.g.dart';

@Riverpod(keepAlive: true)
class ShallowBuyRequestStateController
    extends _$ShallowBuyRequestStateController {
  @override
  FutureOr<List<dynamic>> build(int enterpriseCode) {
    return [];
  }
  //TODO create tests

  Future<void> load(DateTime date) async {
    final ecParams = await ref.read(ecRequestParamsProvider().future);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await ref
          .read(ecBuyRequestRepositoryProvider)
          .loadShallow(
            ecParams,
            selectedDate: date,
            enterpriseCode: enterpriseCode,
          );

      return result;
    });
  }
}
