import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../providers.dart';
import 'controllers.dart';

part 'insert_buy_request_controller.g.dart';

@Riverpod(keepAlive: true)
class InsertBuyRequestController extends _$InsertBuyRequestController {
  @override
  FutureOr<void> build(String observations) async {
    final userSession = await ref.watch(validatedUserSessionProvider.future);
    final pending = await ref.read(
      pendingBuyRequestStateControllerProvider.future,
      //TODO add property of last saved number and allow always go to confirm page
    );

    await ref
        .read(soapInsertBuyRequestRepositoryProvider)
        .insertBuyRequest(
          baseUrl: userSession!.enterprise!.baseUrl!,
          crossIdentity: userSession.user.CrossIdentity_Usuario!,
          buyerCode: pending.selectedBuyer!.Code,
          requestTypeCode: pending.selectedRequestType!.Code,
          supplierCode: pending.selectedSupplier!.Code,
          enterpriseCodes: pending.selectedEnterprises!
              .map((e) => e.Code!)
              .toList(),
          observations: observations,
          products: pending.products!.values.map((e) => e).toList(),
        );
  }
}
