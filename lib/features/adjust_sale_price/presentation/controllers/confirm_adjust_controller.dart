import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/user_session/user_session.dart';
import '../../../auth/presentation/controllers/controllers.dart';
import '../../domain/entities/entities.dart';
import '../../providers.dart';

part 'confirm_adjust_controller.g.dart';

@riverpod
class ConfirmAdjustController extends _$ConfirmAdjustController {
  @override
  FutureOr<void> build() {}

  Future<void> confirm({
    required int enterpriseCode,
    required int productCode,
    required int productPackingCode,
    required SaleType saleType,
    required List<ReplicationTypes> replications,
    required OfferParams? offerParams,
    required RetailParams? retailParams,
    required DateTime now,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userSession = await ref.watch(userSessionProvider.future);
      final userEntity = await ref.watch(authStateControllerProvider.future);

      await ref
          .read(soapAdjustSalePriceRepositoryProvider)
          .confirm(
            baseUrl: userSession!.baseUrl!,
            crossIdentity: userEntity!.CrossIdentity_Usuario!,
            enterpriseCode: enterpriseCode,
            productCode: productCode,
            productPackingCode: productPackingCode,
            saleType: saleType,
            replications: replications,
            offerParams: offerParams,
            retailParams: retailParams,
            now: now,
          );
    });
  }
}
