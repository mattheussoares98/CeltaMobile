import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
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
      //TODO allow always go to confirm page to see the last saved request number
    );

    final response = await ref
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

    ref
        .read(pendingBuyRequestStateControllerProvider.notifier)
        .updatePending(
          PendingBuyRequestEntity.empty().copyWith(
            lastSavedRequestNumber: response,
          ),
        );
  }
}
