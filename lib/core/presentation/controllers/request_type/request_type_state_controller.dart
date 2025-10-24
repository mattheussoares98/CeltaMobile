import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/entities.dart';
import '../user_session/user_session.dart';
import '../../../providers/request_type/request_type.dart';
import '../../../../features/enterprise_manager/domain/entities/entities.dart';

part 'request_type_state_controller.g.dart';

@Riverpod(keepAlive: true)
class RequestTypeStateController extends _$RequestTypeStateController {
  @override
  FutureOr<List<RequestTypeEntity>?> build(Modules module) async {
    final userSession = await ref.watch(validatedUserSessionProvider.future);

    return await ref
        .read(soapLoadRequestTypeRepositoryProvider)
        .load(
          baseUrl: userSession!.enterprise!.baseUrl!,
          crossIdentity: userSession.user.CrossIdentity_Usuario!,
          inclusiveBuy: true,
          inclusiveTransfer: false,
          inclusiveSale: false,
        );
  }
}
