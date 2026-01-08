import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../../core/providers/customer/customer.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';

part 'consumer_customer_state_controller.g.dart';

@Riverpod(keepAlive: true)
class ConsumerCustomerStasteController
    extends _$ConsumerCustomerStasteController {
  @override
  Future<CustomerEntity?> build() async {
    final validatedUserSession = await ref.watch(
      validatedUserSessionProvider.future,
    );
    final selectedEnterprise = ref.read(
      selectedEnterpriseStateControllerProvider,
    );
    final response = await ref
        .read(soapCustomerRepositoryProvider)
        .loadCustomer(
          searchType: SearchCustomerType.exactCode,
          searchValue: '-1',
          crossIdentity: validatedUserSession!.user.CrossIdentity_Usuario!,
          urlInUse: validatedUserSession.enterprise!.urlInUse!,
          enterpriseCode: selectedEnterprise!.Code!,
        );

    return response.first;
  }
}
