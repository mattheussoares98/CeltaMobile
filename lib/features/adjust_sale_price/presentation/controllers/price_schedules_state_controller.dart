import 'dart:async';

import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/providers.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/selected_enterprise_state_controller.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'price_schedules_state_controller.g.dart';

@riverpod
class PriceSchedulesStateController extends _$PriceSchedulesStateController {
  @override
  FutureOr<List<PriceScheduleEntity>?> build(
    int enterpriseCode,
    String productPlu,
  ) {
    ref.cache();

    return null;
  }

  Future<void> getPriceSchedules({
    required int enterpriseCode,
    required int productCode,
    required int productPackingCode,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userSession = await ref.watch(validatedUserSessionProvider.future);
      final selectedEnterprise = ref.watch(
        selectedEnterpriseStateControllerProvider,
      );

      return await ref
          .read(soapGetPriceSchedulesRepositoryProvider)
          .getPriceSchedules(
            workingUrl: userSession!.enterprise!.workingUrl!,
            crossIdentity: userSession.user.CrossIdentity_Usuario!,
            enterpriseCode: selectedEnterprise!.Code!,
            productCode: productCode,
            productPackingCode: productPackingCode,
          );
    });
  }
}
