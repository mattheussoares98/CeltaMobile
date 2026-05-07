import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../features/enterprises/presentation/controllers/controllers.dart';
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
          params: EcRequestParams(
            workingUrl: userSession!.enterprise!.workingUrl!,
            user: userSession.user.name!,
            accessKey: userSession.user.AccessKey!,
          ),
        );
  }
}
