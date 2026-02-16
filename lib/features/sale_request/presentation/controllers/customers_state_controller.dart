import 'dart:async';

import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../core/providers/customer/customer.dart';
import '../../../../core/validators/validators.dart';
import 'controllers.dart';

part 'customers_state_controller.g.dart';

@riverpod
class CustomersStateController extends _$CustomersStateController {
  @override
  FutureOr<List<CustomerEntity>> build(int enterpriseCode) async {
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

      final pendingSelectedCustomer = ref.read(
        pendingSaleRequestStateControllerProvider(
          enterpriseCode,
        ).select((s) => s.value?.customer),
      );

      if (pendingSelectedCustomer == null) {
        return customers;
      }

      final List<CustomerEntity> result = [pendingSelectedCustomer];
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
