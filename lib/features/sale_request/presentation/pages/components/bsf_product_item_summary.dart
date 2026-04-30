import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../constants/constants.dart';
import '../../../domain/entities/entities.dart';

class BSFProductItemSummary extends StatelessWidget {
  final BSFProductItemEntity item;
  final ProductEntity product;
  const BSFProductItemSummary({
    super.key,
    required this.item,
    required this.product,
  });

  bool get changedPrice {
    final cartQuantity = item.quantity ?? 0;
    final cartValue = item.value;
    if (cartQuantity >= (product.MinimumWholeQuantity ?? 0) &&
        (product.WholePracticedPrice ?? 0) > 0) {
      return cartValue != null && cartValue != product.WholePracticedPrice;
    }
    return cartValue != null && cartValue != product.getPrice;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SummaryTable(
          items: [
            SummaryTableItem(
              title: 'Qtd'.hardcoded,
              value: item.quantity ?? 0,
              decimalHouses: 3,
            ),
            SummaryTableItem(
              title: 'Preço'.hardcoded,
              value: item.value,
              decimalHouses: 2,
              isPrice: true,
            ),
            if (item.totalDeliveryTax > 0)
              SummaryTableItem(
                title: 'Frete'.hardcoded,
                value: item.totalDeliveryTax,
                isPrice: true,
                color: theme.colorScheme.secondary,
              ),
            if (item.totalDiscountValue > 0)
              SummaryTableItem(
                title: 'Desconto'.hardcoded,
                value: item.totalDiscountValue,
                isPrice: true,
                color: Colors.red,
              ),
            if (item.totalIncrement > 0)
              SummaryTableItem(
                title: 'Acréscimo'.hardcoded,
                value: item.totalIncrement,
                isPrice: true,
                color: Colors.orange,
              ),
          ],
        ),
        gapH8,
        TitleAndSubTitle(
          title: 'Total'.hardcoded,
          subTitle: item.totalLiquid,
          subTitleIsPrice: true,
        ),
      ],
    );
  }
}
