import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sale_request_details_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SaleRequestDetailsStateController
    extends _$SaleRequestDetailsStateController {
  @override
  FutureOr<BSFSaleRequestEntity> build(SaleRequestArgs args) async {
    if (args.isInserting) {
      return BSFSaleRequestEntity.empty();
    }
    ref.cache();

    final params = await ref.watch(ecRequestParamsProvider().future);
    ref
        .read(appUsageStateControllerProvider.notifier)
        .addUsage(UsageType.completeSearchSaleRequest);

    return await ref
        .read(ecSaleRequestsRepositoryProvider)
        .getComplete(
          params: params,
          customerCode: args.customerCode,
          enterpriseCode: args.enterpriseCode,
          saleRequestCode: args.saleRequestId,
        );
  }
}
