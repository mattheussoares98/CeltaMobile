import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'insert_product_ui_controller.g.dart';

@riverpod
BSFProductItemEntity currentProductItem(Ref ref) => throw UnimplementedError(
  'You should override this provider passing the current product',
);

@riverpod
class InsertProductUIController extends _$InsertProductUIController {
  @override
  InsertProductUIState build(BSFProductItemEntity product) {
    return InsertProductUIState.fromProduct(product);
  }

  bool get hasNonManualDiscounts {
    return state.discounts.any((e) => e.discountOrigin != DiscountOrigin.manual);
  }

  void updateQuantity(double quantity) {
    final pc = product.priceCost;
    double newPrice = state.price;

    if (pc != null) {
      final minWhole = pc.mininumQuantityForWholeSale ?? 0;
      final wholePrice =
          pc.salePracticedInWholeSale ?? pc.wholeSalePricePractice ?? 0;
      final retailPrice =
          pc.salePracticedInSaleRetail ?? pc.saleRetailPricePractice ?? 0;

      if (minWhole > 0 && quantity >= minWhole && wholePrice > 0) {
        newPrice = wholePrice;
      } else if (retailPrice > 0) {
        newPrice = retailPrice;
      }
    }

    state = state.copyWith(quantity: quantity, price: newPrice);
  }

  void updatePrice(double price) {
    state = state.copyWith(price: price);
  }

  void updateDeliveryTaxValue(double value) {
    state = state.copyWith(deliveryTaxValue: value);
  }

  void updateDeliveryTaxType(PercentageOrValue type) {
    state = state.copyWith(deliveryTaxType: type);
  }

  void updateIncrementValue(double value) {
    state = state.copyWith(incrementValue: value);
  }

  void updateIncrementType(PercentageOrValue type) {
    state = state.copyWith(incrementType: type);
  }

  bool addDiscount({required double value, required PercentageOrValue type}) {
    if (value <= 0) {
      return false;
    }

    final discount = BSFDiscountEntity(
      order: state.discounts.isEmpty ? 0 : state.discounts.last.order! + 1,
      discountOrigin: DiscountOrigin.manual,
      user: null,
      justification: null,
      discount: BSFValueTypeEntity(value: value, type: type),
    );

    if (discount.discount?.type == PercentageOrValue.reais) {
      state = state.copyWith(discounts: [discount]);
      return true;
    } else {
      if (state.discounts.length >= 10) return false;

      final discounts = state.discounts
          .toList()
          .where((e) => e.discountOrigin == DiscountOrigin.manual)
          .toList();
      discounts.add(discount);
      state = state.copyWith(discounts: discounts);
      return true;
    }
  }

  void removeDiscount(int index) {
    final discounts = state.discounts.toList();
    discounts.removeAt(index);
    state = state.copyWith(discounts: discounts);
  }

  void updateDiscountType(PercentageOrValue type) {
    final manualDiscounts = state.discounts
        .where((e) => e.discountOrigin == DiscountOrigin.manual)
        .toList();
    //!If there is a non manual added discount and change the type,
    //!Automatically change the discount too. Because of this, it
    //!also automatically demove all discounts that are not manual
    final firstDiscount = manualDiscounts.firstOrNull;
    state = state.copyWith(
      discountType: type,
      discounts: [
        if (firstDiscount != null)
          firstDiscount.copyWith(
            discount: firstDiscount.discount?.copyWith(type: type),
          ),
      ],
    );
  }
}
