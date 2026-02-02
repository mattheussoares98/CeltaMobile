import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/entities.dart';
import '../user_session/user_session.dart';
import '../../../providers/request_type/request_type.dart';

part 'request_type_state_controller.g.dart';

@Riverpod(keepAlive: true)
class RequestTypeStateController extends _$RequestTypeStateController {
  @override
  FutureOr<List<RequestTypeEntity>?> build(
    Modules module,
    int enterpriseCode,
  ) async {
    final userSession = await ref.watch(validatedUserSessionProvider.future);

    return await ref
        .read(soapLoadRequestTypeRepositoryProvider)
        .load(
          workingUrl: userSession!.enterprise!.workingUrl!,
          crossIdentity: userSession.user.CrossIdentity_Usuario!,
          inclusiveBuy: module == Modules.buyRequest,
          inclusiveTransfer: module == Modules.transferRequest,
          inclusiveSale: module == Modules.saleRequest,
          enterpriseCode: enterpriseCode,
        );
  }
}
