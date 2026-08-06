import 'package:celta_inventario/core/domain/entities/customer/customer.dart';
import 'package:celta_inventario/core/providers/customer/customer.dart';
import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/insert_update/insert_update.dart';
import 'package:celta_inventario/features/sale_request/presentation/models/models.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'searched_customers_state_controller.g.dart';

@Riverpod(dependencies: [saleRequestArgs, InsertUpdateStateController])
class SearchedCustomersStateController
    extends _$SearchedCustomersStateController {
  @override
  FutureOr<SearchedCustomersState> build() async {
    final insertUpdateState = await ref.read(
      insertUpdateStateControllerProvider.future,
    );
    final customer = insertUpdateState.customer;

    return SearchedCustomersState(customers: [?customer]);
  }

  void toggleSearchByPersonalizedCode() {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        searchByPersonalizedCode: !current.searchByPersonalizedCode,
      ),
    );
  }

  Future<bool> loadCustomer(String value) async {
    final current = state.value;
    final searchByPersonalizedCode = current?.searchByPersonalizedCode ?? false;

    state = const AsyncValue.loading();
    String? errorMessage;

    state = await AsyncValue.guard(() async {
      final insertUpdateState = await ref.read(
        insertUpdateStateControllerProvider.future,
      );

      final selectedCustomer = insertUpdateState.customer;

      try {
        final args = ref.read(saleRequestArgsProvider);

        final params = await ref.read(ecRequestParamsProvider().future);

        final customers = await ref
            .read(ecCustomersRepositoryProvider)
            .searchForMobileApp(
              EcGetCustomersParams(
                params: params,
                searchValue: value,
                enterpriseCode: args.enterpriseCode,
                searchByPersonalizedCode: searchByPersonalizedCode,
                sellerCode: insertUpdateState.seller?.code,
              ),
            );

        if (customers.isEmpty) {
          errorMessage = "Nenhum cliente foi encontrado".hardcoded;
        }

        final matchingCustomer = selectedCustomer != null
            ? customers.firstWhereOrNull((c) => c.code == selectedCustomer.code)
            : null;

        if (matchingCustomer != null) {
          ref
              .read(insertUpdateStateControllerProvider.notifier)
              .updateCustomerData(matchingCustomer);
        }

        final updatedSelectedCustomer = matchingCustomer ?? selectedCustomer;

        return SearchedCustomersState(
          customers: [
            ?updatedSelectedCustomer,
            ...customers.where((c) => c.code != updatedSelectedCustomer?.code),
          ],
          errorMessage: errorMessage,
          searchByPersonalizedCode: searchByPersonalizedCode,
        );
      } catch (e) {
        errorMessage = e.toString();

        return SearchedCustomersState(
          customers: [?selectedCustomer],
          errorMessage: errorMessage,
          searchByPersonalizedCode: searchByPersonalizedCode,
        );
      }
    });

    return errorMessage == null;
  }
}
