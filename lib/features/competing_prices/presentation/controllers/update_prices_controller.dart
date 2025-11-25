import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../../../core/presentation/controllers/products/products.dart';
import '../../../../core/presentation/controllers/user_session/user_session.dart';
import '../../providers/providers.dart';

part 'update_prices_controller.g.dart';

@riverpod
class UpdatePricesController extends _$UpdatePricesController {
  @override
  FutureOr<void> build() {}

  Future<void> insertUpdate({
    required int enterpriseCode,
    required int researchCode,
    required int concurrentCode,
    required double priceRetail,
    required double offerRetail,
    required double priceWhole,
    required double offerWhole,
    required double priceECommerce,
    required double offerECommerce,
    required ProductEntity product,
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
            productPackingCode: product.ProductPackingCode!,
            priceLookUp: product.PLU!,
            priceRetail: priceRetail,
            offerRetail: offerRetail,
            priceWhole: priceWhole,
            offerWhole: offerWhole,
            priceECommerce: priceECommerce,
            offerECommerce: offerECommerce,
          );

      ref
          .read(
            searchProductsStateControllerProvider(
              enterpriseCode,
              BsRoutine.researchOfPrice,
              Modules.competingPrices,
            ).notifier,
          )
          .updateProduct(
            product.copyWith(
              ConcurrentCode: concurrentCode,
              ProductPackingCode: product.ProductPackingCode,
              PLU: product.PLU,
              RetailPracticedPrice: priceRetail,
              RetailOfferPrice: offerRetail,
              WholePracticedPrice: priceWhole,
              WholeOfferPrice: offerWhole,
              ECommercePracticedPrice: priceECommerce,
              ECommerceOfferPrice: offerECommerce,
            ),
          );
    });
  }
}
