import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/customer/customer.dart';

part 'consumer_customer_state_controller.g.dart';

@Riverpod(keepAlive: true)
class ConsumerCustomerStasteController
    extends _$ConsumerCustomerStasteController {
  @override
  Future<SoapCustomerEntity?> build(int enterpriseCode) async {
    final validatedUserSession = await ref.watch(
      validatedUserSessionProvider.future,
    );
    final response = await ref
        .read(soapCustomerRepositoryProvider)
        .loadCustomer(
          searchType: SearchCustomerType.exactCode,
          searchValue: '-1',
          crossIdentity: validatedUserSession!.user.CrossIdentity_Usuario!,
          workingUrl: validatedUserSession.enterprise!.workingUrl!,
          enterpriseCode: enterpriseCode,
        );

    return response.first;
  }
}
