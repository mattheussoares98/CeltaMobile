import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../../core/providers/customer/customer.dart';
import 'insert_update.dart';

part 'searched_customers_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SearchedCustomersStateController
    extends _$SearchedCustomersStateController {
  @override
  FutureOr<List<BSFCustomerEntity>> build({
    required int enterpriseCode,
    required int saleRequestId,
    required int customerCode,
  }) async {
    final currentCustomer = await ref.read(
      saleRequestDetailsStateControllerProvider(
        customerCode: customerCode,
        enterpriseCode: enterpriseCode,
        saleRequestCode: saleRequestId,
      ).selectAsync((s) => s.customer),
    ); //TODO invalidate when close the page

    return [?currentCustomer];
  }

  Future<bool> loadCustomer(String value, bool searchByPersonalizedCode) async {
    state = const AsyncValue.loading();
    bool succeeds = false;

    state = await AsyncValue.guard(() async {
      final validatedUserSession = await ref.read(
        validatedUserSessionProvider.future,
      );

      final customers = await ref
          .read(ecBSFCustomersRepositoryProvider)
          .searchForMobileApp(
            params: EcRequestParams(
              workingUrl: validatedUserSession!.enterprise!.workingUrl!,
              user: validatedUserSession.user.name!,
              accessKey: validatedUserSession.user.AccessKey!,
            ),
            searchValue: value,
            enterpriseCode: enterpriseCode,
            searchByPersonalizedCode: searchByPersonalizedCode,
          );

      final selectedCustomer = await ref.read(
        insertUpdateStateControllerProvider(
          customerCode: customerCode,
          enterpriseCode: enterpriseCode,
          saleRequestId: saleRequestId,
        ).selectAsync((s) => s.customer),
      );

      succeeds = true;

      final updatedSelectedCustomer =
          customers.firstWhereOrNull((c) => c.code == selectedCustomer?.code) ??
          selectedCustomer;

      return [
        ?updatedSelectedCustomer,
        ...customers.where((c) => c.code != selectedCustomer?.code),
      ];
    });
    return succeeds;
  }
}
