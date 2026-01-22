import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../domain/entities/entities.dart';
import '../../../controllers/controllers.dart';
import 'components.dart';

class TotalPriceAndInsertButton extends ConsumerWidget {
  final VoidCallback insertProduct;
  final QuantityPriceDiscountFieldsAndInsertButton widget;
  const TotalPriceAndInsertButton({
    super.key,
    required this.insertProduct,
    required this.widget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final discountType = ref.watch(
      selectedItemUIControllerProvider(
        isCartPage: widget.isCartPage,
      ).select((state) => state.discountType),
    );

    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.priceController,
        widget.quantityController,
        widget.discountController,
      ]),
      builder: (_, _) {
        final newItem = CartProductEntity.create(
          quantity: widget.quantityController.text.toDouble() ?? 0,
          price:
              widget.priceController.text.toDouble() ??
              widget.product.getPracticedPrice(
                quantity: widget.quantityController.text.toDouble() ?? 0,
                manualPrice: widget.priceController.text.toDouble(),
              ),
          discountByItem: widget.discountController.text.toDouble(),
          discountType: discountType,
          product: widget.product,
        );
        return Column(
          children: [
            TitleAndSubTitle(
              title: 'Total'.hardcoded,
              titleStyle: theme.textTheme.titleMedium,
              subTitleStyle: theme.textTheme.titleLarge,
              subTitle: newItem.getTotalLiquid,
              subTitleIsPrice: true,
            ),
            gapH4,
            Consumer(
              builder: (_, ref, _) {
                final correspondentProduct = ref.watch(
                  pendingSaleRequestStateControllerProvider.select(
                    (state) =>
                        state.value?.cart[widget.product.ProductPackingCode],
                  ),
                );
                return PrimaryButton(
                  text: widget.isCartPage || correspondentProduct != null
                      ? 'Atualizar'.hardcoded
                      : 'Adicionar'.hardcoded,
                  onPressed: insertProduct,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
