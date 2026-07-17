import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sellers_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SellersStateController extends _$SellersStateController {
  @override
  FutureOr<List<EcSellerEntity>> build() async {
    final params = await ref.watch(ecRequestParamsProvider().future);

    return await ref.read(ecSellerRepositoryProvider).get(params);
  }
}
