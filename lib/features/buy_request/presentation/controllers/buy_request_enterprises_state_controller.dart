import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/buy_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/buy_request/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'buy_request_enterprises_state_controller.g.dart';

@Riverpod(keepAlive: true)
class BuyRequestEnterprisesStateController
    extends _$BuyRequestEnterprisesStateController {
  @override
  FutureOr<List<EnterpriseEntity>> build(int enterpriseCode) async {
    final repository = ref.read(soapLoadEnterpriseByFiltersRepositoryProvider);
    final pending = await ref.read(
      pendingBuyRequestStateControllerProvider(enterpriseCode).future,
    );
    final userSession = await ref.watch(validatedUserSessionProvider.future);

    final enterprises = await repository.load(
      workingUrl: userSession!.enterprise!.workingUrl!,
      crossIdentity: userSession.user.CrossIdentity_Usuario!,
      supplierCode: pending.selectedSupplier!.Code,
      requestTypeCode: pending.selectedRequestType!.code!,
    );

    return enterprises;
  }
}
