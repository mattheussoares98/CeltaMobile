import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_payment_finalizations_controller.g.dart';

@Riverpod(keepAlive: true)
class AllPaymentFinalizationsController
    extends _$AllPaymentFinalizationsController {
  @override
  FutureOr<List<BSFPaymentFinalizationEntity>> build({
    required int enterpriseCode,
  }) async {
    final params = await ref.watch(ecRequestParamsProvider().future);

    return ref
        .read(ecPaymentFinalizationRepositoryProvider)
        .getPaymentFinalizations(
          enterpriseCode: enterpriseCode,
          params: params,
        );
  }
}
