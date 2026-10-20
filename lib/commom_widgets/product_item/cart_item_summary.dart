import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class CartItemSummary extends StatelessWidget {
  final double cartQuantity;
  final double? cartValue;
  final ProductEntity product;
  final double? totalDiscount;
  final int priceDecimalHouses;
  const CartItemSummary({
    super.key,
    required this.cartQuantity,
    required this.cartValue,
    required this.product,
    this.totalDiscount,
    this.priceDecimalHouses = 2,
  });

  bool get changedPrice {
    if (cartQuantity >= (product.MinimumWholeQuantity ?? 0) &&
        (product.WholePracticedPrice ?? 0) > 0) {
      return cartValue != null && cartValue != product.WholePracticedPrice;
    }
    return cartValue != null && cartValue != product.getPrice;
  }

  double get itemPrice {
    if (changedPrice) {
      return cartValue!;
    }

    return product.getPrice;
  }

  double get totalPrice {
    if (totalDiscount != null) {
      return (itemPrice * cartQuantity) - totalDiscount!;
    } else {
      return itemPrice * cartQuantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? titleStyle = context.theme.textTheme.bodyMedium?.copyWith(
      color: context.theme.colorScheme.secondary,
    );
    TextStyle? subtitleStyle = context.theme.textTheme.titleMedium?.copyWith(
      color: context.theme.colorScheme.secondary,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndSubTitle(
          title: context.l10n.quantityInCart,
          subTitle: cartQuantity.toString().toBrazilianNumber(3, true),
          titleStyle: titleStyle,
          subTitleStyle: subtitleStyle,
        ),
        if (changedPrice)
          TitleAndSubTitle(
            title: context.l10n.enteredPrice,
            subTitle: itemPrice.toString().toBrazilianNumber(
              priceDecimalHouses,
            ),
            subTitleIsPrice: true,
            titleStyle: titleStyle,
            subTitleStyle: subtitleStyle,
          ),
        if ((totalDiscount ?? 0) > 0)
          TitleAndSubTitle(
            title: context.l10n.discount,
            subTitle: totalDiscount.toString().toBrazilianNumber(),
            subTitleIsPrice: true,
            titleStyle: titleStyle,
            subTitleStyle: subtitleStyle,
          ),
        TitleAndSubTitle(
          title: context.l10n.total,
          subTitle: totalPrice.toString().toBrazilianNumber(),
          subTitleIsPrice: true,
          titleStyle: titleStyle,
          subTitleStyle: subtitleStyle,
        ),
      ],
    );
  }
}
