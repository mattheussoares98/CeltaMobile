import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/process_authorization/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'process_authorization_sale_request_errors_state_controller.g.dart';

@riverpod
class ProcessAuthorizationSaleRequestErrorsStateController
    extends _$ProcessAuthorizationSaleRequestErrorsStateController {
  @override
  FutureOr<BSFSaleRequestErrorEntity> build({
    required int processCode,
    required SaleRequestErrorType errorType,
  }) async {
    ref.cache();

    final repository = ref.read(ecProcessAuthorizationRepositoryProvider);
    final ecParams = await ref.watch(ecRequestParamsProvider().future);

    ref.invalidate(judgmentDetailsStateControllerProvider(processCode));
    final details = await ref.read(
      judgmentDetailsStateControllerProvider(processCode).future,
    );
    final saleRequest = details.defendants
        ?.cast<BSFSaleRequestDefendantEntity?>()
        .firstOrNull
        ?.saleRequest;

    if (saleRequest == null) {
      throw AppException(
        'Não foi possível carregar os dados do pedido de vendas'.hardcoded,
      );
    }

    return repository.getSaleRequestErrors(
      ecParams,
      enterpriseCode: saleRequest.enterprise!.code!,
      saleRequestCode: saleRequest.code!,
      customerCode: saleRequest.customer!.code!,
      errorType: errorType,
    );
  }
}
