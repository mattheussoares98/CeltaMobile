import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/core/providers/customer/customer.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';

part 'consumer_customer_state_controller.g.dart';

@Riverpod(keepAlive: true)
class ConsumerCustomerStateController
    extends _$ConsumerCustomerStateController {
  @override
  FutureOr<BSFCustomerEntity?> build() async {
    try {
      final validatedUserSession = await ref.watch(
        validatedUserSessionProvider.future,
      );
      final enterpriseCode = ref.watch(
        selectedEnterpriseStateControllerProvider.select((s) => s!.Code!),
      );

      final customer = await ref
          .read(ecCustomersRepositoryProvider)
          .searchForMobileApp(
            params: EcRequestParams(
              workingUrl: validatedUserSession!.enterprise!.workingUrl!,
              user: validatedUserSession.user.name!,
              accessKey: validatedUserSession.user.AccessKey!,
            ),
            searchValue: "-1",
            enterpriseCode: enterpriseCode,
            searchByPersonalizedCode: false,
          );

      if (customer.isEmpty) {
        return null;
      }

      return customer.first;
    } catch (e) {
      if (e.toString().contains(
        "o número de documento informado não foi encontrado".hardcoded,
      )) {
        return null;
      }
      rethrow;
    }
  }
}
