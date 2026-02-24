import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/app_usage/app_usage.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../providers.dart';
import 'controllers.dart';

part 'insert_buy_request_controller.g.dart';

@Riverpod(keepAlive: true)
class InsertBuyRequestController extends _$InsertBuyRequestController {
  @override
  FutureOr<void> build(int enterpriseCode) async {}

  Future<bool> insert(String observations) async {
    bool succeeds = false;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final userSession = await ref.watch(validatedUserSessionProvider.future);
      final pending = await ref.read(
        pendingBuyRequestStateControllerProvider(enterpriseCode).future,
      );

      ref
          .read(appUsageStateControllerProvider.notifier)
          .addUsage(UsageType.insertBuyRequest);

      final response = await ref
          .read(soapInsertBuyRequestRepositoryProvider)
          .insertBuyRequest(
            workingUrl: userSession!.enterprise!.workingUrl!,
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
          .read(
            pendingBuyRequestStateControllerProvider(enterpriseCode).notifier,
          )
          .clearState(response);
      succeeds = true;
    });

    return succeeds;
  }
}
