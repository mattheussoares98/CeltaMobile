import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/app_usage/app_usage.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../providers.dart';

part 'sale_request_details_state_controller.g.dart';

@riverpod
class SaleRequestDetailsStateController
    extends _$SaleRequestDetailsStateController {
  @override
  FutureOr<dynamic> build({
    required int customerCode,
    required int enterpriseCode,
    required int saleRequestCode,
  }) async {
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
        .read(ecGetSaleRequestsRepositoryProvider)
        .getComplete(
          params: EcRequestParams(
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            user: validatedUser.user.name!,
            accessKey: validatedUser.user.AccessKey!,
          ),
          customerCode: customerCode,
          enterpriseCode: enterpriseCode,
          saleRequestCode: saleRequestCode,
        );
  }
}
