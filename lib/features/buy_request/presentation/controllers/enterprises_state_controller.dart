import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../providers.dart';
import 'controllers.dart';

part 'enterprises_state_controller.g.dart';

@Riverpod(keepAlive: true)
class EnterprisesStateController extends _$EnterprisesStateController {
  @override
  FutureOr<List<EnterpriseEntity>> build() async {
    final repository = ref.read(soapLoadEnterpriseByFiltersRepositoryProvider);
    final pending = await ref.read(
      pendingBuyRequestStateControllerProvider.future,
    );
    final userSession = await ref.watch(validatedUserSessionProvider.future);

    final enterprises = await repository.load(
      workingUrl: userSession!.enterprise!.workingUrl!,
      crossIdentity: userSession.user.CrossIdentity_Usuario!,
      supplierCode: pending.selectedSupplier!.Code,
      requestTypeCode: pending.selectedRequestType!.Code,
    );

    return enterprises;
  }
}
