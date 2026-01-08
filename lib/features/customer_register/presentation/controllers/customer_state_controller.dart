import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../core/providers/customer/customer.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';

part 'customer_state_controller.g.dart';

@Riverpod(keepAlive: true)
class CustomerStateController extends _$CustomerStateController {
  @override
  FutureOr<CustomerEntity?> build() async {
    return null;
  }

  Future<void> loadCustomer(String cpfCnpj) async {
    final emptyCustomer = CustomerEntity.empty();
    try {
      state = const AsyncValue.loading();
      final validatedUserSession = await ref.watch(
        validatedUserSessionProvider.future,
      );
      final selectedEnterprise = ref.read(
        selectedEnterpriseStateControllerProvider,
      );

      final result = await ref
          .read(soapCustomerRepositoryProvider)
          .loadCustomer(
            searchType: SearchCustomerType.exactCnpjCpfNumber,
            searchValue: cpfCnpj,
            crossIdentity: validatedUserSession!.user.CrossIdentity_Usuario!,
            urlInUse: validatedUserSession.enterprise!.urlInUse!,
            enterpriseCode: selectedEnterprise!.Code!,
          );

      if (result.isEmpty) {
        state = AsyncValue.data(emptyCustomer);
        return;
      }

      state = AsyncValue.data(result.first);
    } catch (e) {
      state = AsyncValue.data(emptyCustomer);
    }
  }

  void updateCustomer(CustomerEntity? entity) {
    state = AsyncValue.data(entity);
  }
}
