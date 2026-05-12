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

  Future<void> loadCustomer(String value, bool searchByPersonalizedCode) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final validatedUserSession = await ref.read(
        validatedUserSessionProvider.future,
      );

      return await ref
          .read(ecBSFCustomersRepositoryProvider)
          .searchForMobileApp(
            params: EcRequestParams(
              workingUrl: validatedUserSession!.enterprise!.workingUrl!,
              user: validatedUserSession.user.CrossIdentity_Usuario!,
              accessKey: validatedUserSession.user.AccessKey!,
            ),
            searchValue: value,
            enterpriseCode: enterpriseCode,
            searchByPersonalizedCode: searchByPersonalizedCode,
          );
    });
  }
}
