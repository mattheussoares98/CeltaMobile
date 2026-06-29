import 'dart:async';

import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'print_sale_request_controller.g.dart';

@riverpod
class PrintSaleRequestController extends _$PrintSaleRequestController {
  @override
  FutureOr<void> build() {}

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
          SaleRequestArgs(
            enterpriseCode: enterpriseCode,
            customerCode: customerCode,
            saleRequestId: saleRequestCode,
          ),
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
