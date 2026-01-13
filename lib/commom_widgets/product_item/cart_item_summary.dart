import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../core/domain/entities/entities.dart';

class CartItemSummary extends StatelessWidget {
  final double cartQuantity;
  final double? cartValue;
  final ProductEntity product;
  final double? totalDiscount;
  const CartItemSummary({
    super.key,
    required this.cartQuantity,
    required this.cartValue,
    required this.product,
    this.totalDiscount,
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
    final theme = Theme.of(context);

    TextStyle? titleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.secondary,
    );
    TextStyle? subtitleStyle = theme.textTheme.titleMedium?.copyWith(
      color: theme.colorScheme.secondary,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndSubTitle(
          title: 'Qtd no carrinho'.hardcoded,
          subTitle: cartQuantity.toString().toBrazilianNumber(3, true),
          titleStyle: titleStyle,
          subTitleStyle: subtitleStyle,
        ),
        if (changedPrice)
          TitleAndSubTitle(
            title: 'Preço digitado'.hardcoded,
            subTitle: itemPrice.toString().toBrazilianNumber(),
            subTitleIsPrice: true,
            titleStyle: titleStyle,
            subTitleStyle: subtitleStyle,
          ),
        if ((totalDiscount ?? 0) > 0)
          TitleAndSubTitle(
            title: 'Desconto'.hardcoded,
            subTitle: totalDiscount.toString().toBrazilianNumber(),
            subTitleIsPrice: true,
            titleStyle: titleStyle,
            subTitleStyle: subtitleStyle,
          ),
        TitleAndSubTitle(
          title: 'Total'.hardcoded,
          subTitle: totalPrice.toString().toBrazilianNumber(),
          subTitleIsPrice: true,
          titleStyle: titleStyle,
          subTitleStyle: subtitleStyle,
        ),
      ],
    );
  }
}
