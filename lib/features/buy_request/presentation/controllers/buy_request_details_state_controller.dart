import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/ec_request_params/ec_request_params.dart';

part 'buy_request_details_state_controller.g.dart';

@riverpod
class BuyRequestDetailsStateController
    extends _$BuyRequestDetailsStateController {
  @override
  FutureOr<EcBuyRequestDtoEntity> build(int buyRequestCode) async {
    ref.cache();
    final ecParams = await ref.read(ecRequestParamsProvider().future);

    final params = LoadBuyRequestDetailsParams(
      requestParams: ecParams,
      buyRequestCode: buyRequestCode,
    );

    return await ref.read(ecBuyRequestRepositoryProvider).loadDetails(params);
  }
}
