import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_payment_conditions_controller.g.dart';

@Riverpod(keepAlive: true)
class AllPaymentConditionsController extends _$AllPaymentConditionsController {
  @override
  FutureOr<List<BSFPaymentConditionEntity>> build({
    required int enterpriseCode,
  }) async {
    final params = await ref.watch(ecRequestParamsProvider().future);

    return ref
        .read(ecPaymentFinalizationRepositoryProvider)
        .getPaymentConditions(params: params);
  }
}
