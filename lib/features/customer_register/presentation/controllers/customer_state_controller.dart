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

    return null;
  }

  Future<void> loadCustomer(String cpfCnpj) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUserSession = await ref.read(
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
            baseUrl: validatedUserSession.enterprise!.baseUrl!,
            enterpriseCode: selectedEnterprise!.Code!,
          );

      if (result.isEmpty) {
        return null;
      }

      return result.first;
    });
  }
}
