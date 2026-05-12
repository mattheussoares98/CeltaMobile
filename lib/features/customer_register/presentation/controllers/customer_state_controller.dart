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
  FutureOr<SoapCustomerEntity?> build() => null;

  Future<void> loadCustomer(String cpfCnpj) async {
    final emptyCustomer = SoapCustomerEntity.empty();
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
            workingUrl: validatedUserSession.enterprise!.workingUrl!,
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

  void updatePersonalData({
    String? Name,
    String? ReducedName,
    String? CpfCnpjNumber,
    String? Password,
    DateTime? DateOfBirth,
    CustomerSexType? SexType,
    CustomerPersonType? PersonType,
    String? RegistrationNumber,
  }) {
    state = AsyncValue.data(
      (state.value ?? SoapCustomerEntity.empty()).copyWith(
        Name: Name,
        ReducedName: ReducedName,
        CpfCnpjNumber: CpfCnpjNumber,
        Password: Password,
        DateOfBirth: DateOfBirth,
        SexType: SexType,
        PersonType: PersonType,
        RegistrationNumber: RegistrationNumber,
      ),
    );
  }

  void updateEmails(List<String> value) {
    state = AsyncData(
      (state.value ?? SoapCustomerEntity.empty()).copyWith(Emails: value),
    );
  }

  void updateTelephones(List<CustomerTelephoneEntity> value) {
    state = AsyncData(
      (state.value ?? SoapCustomerEntity.empty()).copyWith(Telephones: value),
    );
  }

  void updateCustomerCovenants(List<CustomerCovenantEntity> value) {
    state = AsyncData(
      (state.value ?? SoapCustomerEntity.empty()).copyWith(
        CustomerCovenants: value,
      ),
    );
  }

  void updateAddresses(List<AddressEntity> value) {
    state = AsyncData(
      (state.value ?? SoapCustomerEntity.empty()).copyWith(Addresses: value),
    );
  }
}
