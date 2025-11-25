import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../providers/providers.dart';

part 'update_prices_controller.g.dart';

@riverpod
class UpdatePricesController extends _$UpdatePricesController {
  @override
  FutureOr<void> build() {}

  Future<void> insertUpdate({
    required int researchCode,
    required int concurrentCode,
    required int productPackingCode,
    required String priceLookUp,
    required double? priceRetail,
    required double? offerRetail,
    required double? priceWhole,
    required double? offerWhole,
    required double? priceECommerce,
    required double? offerECommerce,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final validatedUser = await ref.watch(
        validatedUserSessionProvider.future,
      );

      await ref
          .read(soapInsertUpdatePricesDatasourceProvider)
          .insert(
            baseUrl: validatedUser!.enterprise!.baseUrl!,
            crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
            researchCode: researchCode,
            concurrentCode: concurrentCode,
            productPackingCode: productPackingCode,
            priceLookUp: priceLookUp,
            priceRetail: priceRetail,
            offerRetail: offerRetail,
            priceWhole: priceWhole,
            offerWhole: offerWhole,
            priceECommerce: priceECommerce,
            offerECommerce: offerECommerce,
          );
    });
  }
}
