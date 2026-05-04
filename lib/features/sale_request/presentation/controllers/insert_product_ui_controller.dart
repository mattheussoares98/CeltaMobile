import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/entities.dart';
import '../models/models.dart';

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

  void updateQuantity(double quantity) {
    final pc = product.priceCost;
    double newPrice = state.price;

    if (pc != null) {
      final minWhole = pc.mininumQuantityForWholeSale ?? 0;
      final wholePrice = pc.salePracticedInWholeSale ?? 0;
      final retailPrice = pc.salePracticedInSaleRetail ?? 0;

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

  void addDiscount(BSFDiscountEntity discount) {
    if (discount.discount?.type == PercentageOrValue.reais) {
      state = state.copyWith(discounts: [discount]);
    } else {
      final discounts = state.discounts.toList();
      discounts.add(discount);
      state = state.copyWith(discounts: discounts);
    }
  }

  void removeDiscount(int index) {
    final discounts = state.discounts.toList();
    discounts.removeAt(index);
    state = state.copyWith(discounts: discounts);
  }

  void updateDiscountType(PercentageOrValue type) {
    final firstDiscount = state.discounts.firstOrNull;
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
