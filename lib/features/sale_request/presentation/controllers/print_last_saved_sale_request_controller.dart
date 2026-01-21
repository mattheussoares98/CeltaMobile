import 'dart:async';

import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';
import '../../providers.dart';
import 'controllers.dart';

part 'print_last_saved_sale_request_controller.g.dart';

@riverpod
class PrintLastSavedSaleRequestController
    extends _$PrintLastSavedSaleRequestController {
  @override
  FutureOr<void> build() {}

  Future<bool> print(String ip) async {
    bool printed = false;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validateduser = await ref.watch(
        validatedUserSessionProvider.future,
      );
      final selectedEnterprise = ref.read(
        selectedEnterpriseStateControllerProvider,
      );
      final lastSavedSaleRequest = await ref.read(
        lastSavedSaleRequestStateControllerProvider(
          selectedEnterprise!.Code!,
        ).future,
      );

      if (lastSavedSaleRequest == null) {
        throw AppException(
          'Ainda não foram encontrados pedidos salvos para imprimir'.hardcoded,
        );
      }

      await ref
          .read(ipPrintSaleRequestControllerProvider.notifier)
          .updateIp(ip);

      await ref
          .read(printLastSavedSaleRequestRepositoryProvider)
          .print(
            saleRequest: lastSavedSaleRequest,
            ip: ip,
            userName: validateduser!.user.name!,
          );

      printed = true;
    });

    return printed;
  }
}
