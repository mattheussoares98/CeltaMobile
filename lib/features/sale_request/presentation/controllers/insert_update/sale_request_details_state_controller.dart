import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';

part 'sale_request_details_state_controller.g.dart';

@Riverpod(keepAlive: true)
class SaleRequestDetailsStateController
    extends _$SaleRequestDetailsStateController {
  @override
  FutureOr<BSFSaleRequestEntity> build(SaleRequestArgs args) async {
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

    final validatedUser = await ref.watch(validatedUserSessionProvider.future);
    ref
        .read(appUsageStateControllerProvider.notifier)
        .addUsage(UsageType.completeSearchSaleRequest);

    return await ref
        .read(ecSaleRequestsRepositoryProvider)
        .getComplete(
          params: EcRequestParams(
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            user: validatedUser.user.name!,
            accessKey: validatedUser.user.AccessKey!,
          ),
          customerCode: args.customerCode,
          enterpriseCode: args.enterpriseCode,
          saleRequestCode: args.saleRequestId,
        );
  }
}
