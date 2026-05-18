import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../../../core/providers/customer/customer.dart';
import '../../../../../../exceptions/exceptions.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../providers.dart';
import '../insert_update.dart';

part 'searched_customers_state_controller.g.dart';

@Riverpod(dependencies: [saleRequestArgs, InsertUpdateStateController])
class SearchedCustomersStateController
    extends _$SearchedCustomersStateController {
  @override
  FutureOr<List<BSFCustomerEntity>> build() async {
    final customer = await ref.watch(
      insertUpdateStateControllerProvider.selectAsync((s) => s.customer),
    );

    return [?customer];
  }

  Future<bool> loadCustomer(String value, bool searchByPersonalizedCode) async {
    state = const AsyncValue.loading();
    bool succeeds = false;

    state = await AsyncValue.guard(() async {
      final args = ref.read(saleRequestArgsProvider);

      final validatedUserSession = await ref.read(
        validatedUserSessionProvider.future,
      );

      final customers = await ref
          .read(ecCustomersRepositoryProvider)
          .searchForMobileApp(
            params: EcRequestParams(
              workingUrl: validatedUserSession!.enterprise!.workingUrl!,
              user: validatedUserSession.user.name!,
              accessKey: validatedUserSession.user.AccessKey!,
            ),
            searchValue: value,
            enterpriseCode: args.enterpriseCode,
            searchByPersonalizedCode: searchByPersonalizedCode,
          );

      if (customers.isEmpty) {
        throw AppException('Nenhum cliente foi encontrado'.hardcoded);
      }

      final selectedCustomer = await ref.read(
        insertUpdateStateControllerProvider.selectAsync((s) => s.customer),
      );

      succeeds = true;

      //TODO create/fix tests. Now is always showing at first position if there is any selected customer
      return [
        ?selectedCustomer,
        ...customers.where((c) => c.code != selectedCustomer?.code),
      ];
    });
    return succeeds;
  }
}
