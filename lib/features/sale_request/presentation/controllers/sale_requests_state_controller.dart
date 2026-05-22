import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sale_requests_state_controller.g.dart';

@riverpod
class SaleRequestsStateController extends _$SaleRequestsStateController {
  @override
  FutureOr<EcPaginationResults<SaleRequestEntity>?> build(
    int enterpriseCode,
  ) async {
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
      final validatedUser = await ref.read(validatedUserSessionProvider.future);

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
            enterpriseIds: [enterpriseCode],
            endDateHourOfCreation: endDateHourOfCreation,
            startDateHourOfCreation: startDateHourOfCreation,
            personalizedCodes: personalizedCodes,
            mountCustomer: true,
            mountSeller: true,
            mountRequestType: true,
          );
    });
  }

  void updateSingleRequestInList(SaleRequestEntity updatedRequest) {
    if (state is! AsyncData) return;

    final currentData = state.value;
    if (currentData == null) return;

    final updatedCollection = currentData.collection.toList();

    updatedCollection.removeWhere((item) => item.Id == updatedRequest.Id);
    updatedCollection.insert(0, updatedRequest);

    state = AsyncData(
      EcPaginationResults<SaleRequestEntity>(
        collection: updatedCollection,
        totalRecords: currentData.totalRecords,
        totalPages: currentData.totalPages,
        recordsOnThisPage: currentData.recordsOnThisPage,
        recordsByPage: currentData.recordsByPage,
        actualPage: currentData.actualPage,
      ),
    );
  }
}
