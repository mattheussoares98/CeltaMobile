import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/core/providers/request_type/request_type.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'request_type_state_controller.g.dart';

@Riverpod(keepAlive: true)
class RequestTypeStateController extends _$RequestTypeStateController {
  @override
  FutureOr<List<BSFRequestTypeEntity>?> build(
    Modules module,
    int enterpriseCode,
  ) async {
    ref.cache(60);
    final ecParams = await ref.watch(ecRequestParamsProvider().future);
    final enterpriseCode = ref.read(
      selectedEnterpriseStateControllerProvider.select((s) => s?.Code),
    );

    return await ref
        .read(ecGetRequestTypesRepositoryProvider)
        .search(
          parameters: EcRequestTypeParametersEntity(
            enterpriseCode: enterpriseCode!,
            inclusiveSale: module == Modules.saleRequest,
            inclusiveBuy: module == Modules.buyRequest,
            inclusiveTransfer: module == Modules.transferRequest,
          ),
          params: ecParams,
        );
  }
}
