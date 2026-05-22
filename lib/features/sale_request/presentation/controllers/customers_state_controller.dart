import 'dart:async';

import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/customer/customer.dart';
import 'package:celta_inventario/core/validators/validators.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';

part 'customers_state_controller.g.dart';

@riverpod
class CustomersStateController extends _$CustomersStateController {
  @override
  FutureOr<List<SoapCustomerEntity>> build(int enterpriseCode) async {
    Timer? timer;
    final link = ref.keepAlive();
    ref.onCancel(() {
      timer = Timer(const Duration(seconds: 20), () {
        link.close();
      });
    });
    ref.onResume(() {
      timer?.cancel();
    });
    ref.onDispose(() {
      timer?.cancel();
    });

    final pendingSelectedCustomer = await ref.read(
      pendingSaleRequestStateControllerProvider(
        enterpriseCode,
      ).selectAsync((s) => s.customer),
    );

    return [?pendingSelectedCustomer];
  }

  Future<void> loadCustomer(String value, bool searchByPersonalizedCode) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final validatedUserSession = await ref.watch(
        validatedUserSessionProvider.future,
      );

      late SearchCustomerType searchType;

      if (searchByPersonalizedCode) {
        searchType = SearchCustomerType.personalizedCode;
      } else if (CpfCnpjValidator().isValid(value)) {
        searchType = SearchCustomerType.exactCnpjCpfNumber;
      } else if (value.toDouble() != null) {
        searchType = SearchCustomerType.exactCode;
      } else {
        searchType = SearchCustomerType.approximateName;
      }

      final customers = await ref
          .read(soapCustomerRepositoryProvider)
          .loadCustomer(
            searchType: searchType,
            searchValue: value,
            crossIdentity: validatedUserSession!.user.CrossIdentity_Usuario!,
            workingUrl: validatedUserSession.enterprise!.workingUrl!,
            enterpriseCode: enterpriseCode,
          );

      final pendingSelectedCustomer = await ref.read(
        pendingSaleRequestStateControllerProvider(
          enterpriseCode,
        ).selectAsync((s) => s.customer),
      );

      if (pendingSelectedCustomer == null) {
        return customers;
      }

      final List<SoapCustomerEntity> result = [pendingSelectedCustomer];
      // Using a for-in loop is O(n) and faster than .any() followed by .where()
      for (final customer in customers) {
        if (customer.Code != pendingSelectedCustomer.Code) {
          result.add(customer);
        }
      }

      return result;
    });
  }
}
