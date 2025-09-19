import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/providers.dart';
import '../../../../features/enterprises/presentation/controllers/selected_enterprise_state_controller.dart';
import '../../../auth/presentation/controllers/controllers.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'price_schedules_state_controller.g.dart';

@riverpod
class PriceSchedulesStateController extends _$PriceSchedulesStateController {
  @override
  FutureOr<List<PriceScheduleEntity>?> build(
    int enterpriseCode,
    String productPlu,
  ) {
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

  Future<void> getPriceSchedules({
    required int enterpriseCode,
    required int productCode,
    required int productPackingCode,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userSession = await ref.watch(userSessionProvider.future);
      final userEntity = await ref.watch(authStateControllerProvider.future);
      final selectedEnterprise = ref.watch(
        selectedEnterpriseStateControllerProvider,
      );

      return await ref
          .read(soapGetPriceSchedulesRepositoryProvider)
          .getPriceSchedules(
            baseUrl: userSession!.baseUrl!,
            crossIdentity: userEntity!.CrossIdentity_Usuario!,
            enterpriseCode: selectedEnterprise!.Code!,
            productCode: productCode,
            productPackingCode: productPackingCode,
          );
    });
  }
}
