import 'dart:async';

import 'package:celta_intelligence/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../core/providers/customer/customer.dart';
import '../../../../core/validators/validators.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';

part 'customers_state_controller.g.dart';

@riverpod
class CustomersStateController extends _$CustomersStateController {
  @override
  FutureOr<List<CustomerEntity>> build() {
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

    return [];
  }

  Future<void> loadCustomer(String value, bool searchByPersonalizedCode) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final validatedUserSession = await ref.watch(
        validatedUserSessionProvider.future,
      );
      final selectedEnterprise = ref.read(
        selectedEnterpriseStateControllerProvider,
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

      return await ref
          .read(soapCustomerRepositoryProvider)
          .loadCustomer(
            searchType: searchType,
            searchValue: value,
            crossIdentity: validatedUserSession!.user.CrossIdentity_Usuario!,
            baseUrl: validatedUserSession.enterprise!.baseUrl!,
            enterpriseCode: selectedEnterprise!.Code!,
          );
    });
  }
}
