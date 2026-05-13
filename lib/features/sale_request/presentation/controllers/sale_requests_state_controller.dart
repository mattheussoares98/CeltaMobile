import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/app_usage/app_usage.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';
import 'controllers.dart';

part 'sale_requests_state_controller.g.dart';

@riverpod
class SaleRequestsStateController extends _$SaleRequestsStateController {
  @override
  FutureOr<EcPaginationResults<SaleRequestEntity>?> build() async {
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

  Future<void> load({
    required DateTime startDateHourOfCreation,
    DateTime? endDateHourOfCreation,
    List<String>? personalizedCodes,
    int? actualPage,
    int? recordsByPage,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );
      final args = ref.watch(saleRequestArgsProvider);

      ref
          .read(appUsageStateControllerProvider.notifier)
          .addUsage(UsageType.shallowSearchSaleRequest);

      ref.invalidate(saleRequestDetailsStateControllerProvider);

      return await ref
          .read(ecSaleRequestsRepositoryProvider)
          .get(
            params: EcRequestParams(
              workingUrl: validatedUser!.enterprise!.workingUrl!,
              user: validatedUser.user.name!,
              accessKey: validatedUser.user.AccessKey!,
              actualPage: actualPage,
              recordsByPage: recordsByPage,
            ),
            enterpriseIds: [args.enterpriseCode],
            endDateHourOfCreation: endDateHourOfCreation,
            startDateHourOfCreation: startDateHourOfCreation,
            personalizedCodes: personalizedCodes,
            mountCustomer: true,
            mountSeller: true,
            mountRequestType: true,
          );
    });
  }
}
