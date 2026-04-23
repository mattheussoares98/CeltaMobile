import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/entities.dart';
import '../../../providers/request_type/request_type.dart';
import '../user_session/user_session.dart';

part 'request_type_state_controller.g.dart';

@Riverpod(keepAlive: true)
class RequestTypeStateController extends _$RequestTypeStateController {
  @override
  FutureOr<List<BSFRequestTypeEntity>?> build(
    Modules module,
    int enterpriseCode,
  ) async {
    final userSession = await ref.watch(validatedUserSessionProvider.future);
    return await ref
        .read(ecGetRequestTypesRepositoryProvider)
        .search(
          parameters: BSFSearchRequestTypeParametersEntity(
            makeRequestTypeForTransfer: module == Modules.transferRequest,
            makePaymentFinalizations: module == Modules.saleRequest,
            searchType: BSFSearchRequestType.approximateName,
            behaviorBasicFilters:
                BSFSearchRequestTypeBehaviorBasicFiltersEntity(
                  inclusiveBuy: module == Modules.buyRequest,
                  inclusiveTransfer: module == Modules.transferRequest,
                  inclusiveSale: module == Modules.saleRequest,
                  enterpriseCode: enterpriseCode,
                  userCode: userSession!.user.CodigoInterno_Usuario ?? 0,
                ),
          ),
          enterpriseCode: enterpriseCode,
          params: EcRequestParams(
            workingUrl: userSession.enterprise!.workingUrl!,
            user: userSession.user.name!,
            accessKey: userSession.user.AccessKey!,
          ),
        );
  }
}
