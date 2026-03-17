import 'dart:async';

import 'package:celta_inventario/exceptions/app_exception.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entities.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repository/repository.dart';
import '../../providers.dart';

part 'pending_sale_request_state_controller.g.dart';

@riverpod
class SaleRequestStateController extends _$SaleRequestStateController {
  @override
  Future<SaleRequestEntity> build(int enterpriseCode) async {
    final repository = ref.watch(localSaleRequestRepositoryProvider);
    final localData = await repository.load(enterpriseCode);

    return (localData ?? SaleRequestEntity.empty()).copyWith(
      needProcessCart: true,
    );
  }

  ILocalSaleRequestRepository get _repository =>
      ref.read(localSaleRequestRepositoryProvider);

  Future<void> _updateAndSave(
    SaleRequestEntity newState, {
    bool? needProcessCart,
  }) async {
    state = const AsyncValue.loading();
    newState = newState.copyWith(needProcessCart: needProcessCart);
    state = await AsyncValue.guard(() async {
      await _repository.save(newState, enterpriseCode);
      return newState;
    });
  }

  Future<bool> addProduct(SaleRequestCartProductEntity item) async {
    if (state.value == null) return false;

    bool updated = false;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (item.getValueLiquid <= 0) {
        throw AppException(
          'O preço do produto precisa ser maior que zero'.hardcoded,
        );
      } else if (item.getPriceIsManual && (item.DiscountValue ?? 0) > 0) {
        throw AppException(
          'Não é permitido inserir preço manual e desconto manual. Insira somente um'
              .hardcoded,
        );
      }
      final newCart = Map.of(state.value!.cart);

      newCart[item.ProductPackingCode] = item;

      await _updateAndSave(
        state.value!.copyWith(cart: newCart),
        needProcessCart: true,
      );
      updated = true;
      return state.value!;
    });
    return updated;
  }

  Future<void> removeProduct(SaleRequestCartProductEntity product) async {
    if (state.value == null) return;

    final newCart = Map.of(state.value!.cart);
    newCart.remove(product.ProductPackingCode);

    await _updateAndSave(
      state.value!.copyWith(cart: newCart),
      needProcessCart: true,
    );
  }

  Future<void> changeCustomer(CustomerEntity newCustomer) async {
    if (state.value == null) return;

    if (newCustomer.Code == state.value!.customer?.Code) {
      await _updateAndSave(
        state.value!.annulValues(customer: true, covenant: true),
        needProcessCart: true,
      );
    } else {
      await _updateAndSave(
        state.value!
            .annulValues(covenant: true)
            .copyWith(customer: newCustomer),
        needProcessCart: true,
      );
    }
  }

  Future<void> changeCovenant(CustomerCovenantEntity newCovenant) async {
    if (state.value?.customer == null) return;

    if (newCovenant.covenant?.Code == state.value!.covenant?.covenant?.Code) {
      await _updateAndSave(
        state.value!.annulValues(covenant: true),
        needProcessCart: true,
      );
    } else {
      await _updateAndSave(
        state.value!.copyWith(covenant: newCovenant),
        needProcessCart: true,
      );
    }
  }

  Future<void> changeObservations(String observations) async {
    if (state.value == null) return;

    await _updateAndSave(state.value!.copyWith(observations: observations));
  }

  Future<void> changeInstructions(String instructions) async {
    if (state.value == null) return;

    await _updateAndSave(state.value!.copyWith(instructions: instructions));
  }

  Future<void> updateProductsFromProcessedCart(
    ProcessedCartEntity processedCart,
  ) async {
    if (state.value == null) return;

    await _updateAndSave(
      state.value!.copyWith(
        cart: {
          for (final product
              in processedCart.Products ?? <SaleRequestCartProductEntity>[])
            product.ProductPackingCode: product.copyWith(
              product: state.value!.cart[product.ProductPackingCode]!.product,
            ),
        },
      ),
      needProcessCart: false,
    );
  }
}
