import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../../../core/providers/customer/customer.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../providers.dart';
import '../../../models/models.dart';
import '../insert_update.dart';

part 'searched_customers_state_controller.g.dart';

@Riverpod(dependencies: [saleRequestArgs, InsertUpdateStateController])
class SearchedCustomersStateController
    extends _$SearchedCustomersStateController {
  @override
  FutureOr<SearchedCustomersState> build() async {
    final customer = await ref.read(
      insertUpdateStateControllerProvider.selectAsync((s) => s.customer),
    );

    return SearchedCustomersState(customers: [?customer], errorMessage: null);
  }

  Future<bool> loadCustomer(String value, bool searchByPersonalizedCode) async {
    state = const AsyncValue.loading();
    String? errorMessage;

    state = await AsyncValue.guard(() async {
      final selectedCustomer = await ref.read(
        insertUpdateStateControllerProvider.selectAsync((s) => s.customer),
      );

      try {
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
          errorMessage = "Nenhum cliente foi encontrado".hardcoded;
        }

        return SearchedCustomersState(
          customers: [
            ?selectedCustomer,
            ...customers.where((c) => c.code != selectedCustomer?.code),
          ],
          errorMessage: errorMessage,
        );
      } catch (e) {
        errorMessage = e.toString();

        return SearchedCustomersState(
          customers: [?selectedCustomer],
          errorMessage: errorMessage,
        );
      }
    });

    return errorMessage == null;
  }
}
