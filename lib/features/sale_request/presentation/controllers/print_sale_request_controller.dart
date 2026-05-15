import 'dart:async';

import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../../enterprises/presentation/controllers/controllers.dart';
import '../../providers.dart';
import 'controllers.dart';

part 'print_sale_request_controller.g.dart';

@riverpod
class PrintSaleRequestController extends _$PrintSaleRequestController {
  @override
  FutureOr<void> build() {}

  Future<void> soapPrint(String ip) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validateduser = await ref.read(validatedUserSessionProvider.future);
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
          .read(printSaleRequestRepositoryProvider)
          .soapPrint(
            saleRequest: lastSavedSaleRequest,
            ip: ip,
            userName: validateduser!.user.name!,
          );
    });
  }

  Future<void> bsfPrint({
    required int saleRequestCode,
    required int customerCode,
    required int enterpriseCode,
    required String ip,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validateduser = await ref.read(validatedUserSessionProvider.future);

      final saleRequest = await ref.read(
        saleRequestDetailsStateControllerProvider(
          ref.read(saleRequestArgsProvider),
        ).future,
      );

      await ref
          .read(ipPrintSaleRequestControllerProvider.notifier)
          .updateIp(ip);

      await ref
          .read(printSaleRequestRepositoryProvider)
          .bsfPrint(
            saleRequest: saleRequest,
            ip: ip,
            userName: validateduser!.user.name!,
          );
    });
  }
}
