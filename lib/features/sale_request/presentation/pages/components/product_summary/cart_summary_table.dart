import 'package:flutter/material.dart';

import '../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../core/domain/entities/entities.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../domain/entities/entities.dart';

class CartSummaryTable extends StatelessWidget {
  final BSFProductItemEntity item;
  final ProductEntity product;
  const CartSummaryTable({
    super.key,
    required this.item,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final practicedPrice = product.getPracticedPriceType(
      quantity: item.quantity ?? 0,
      manualPrice: item.value,
    );
    final size = MediaQuery.sizeOf(context);

    return SummaryTable(
      items: [
        SummaryTableItem(
          title: 'Preço'.hardcoded,
          value: item.value,
          decimalHouses: 2,
          isPrice: true,
          trailing: size.width <= 200
              ? null
              : Tooltip(
                  message:
                      'Preço ${practicedPrice.name.toLowerCase()}'.hardcoded,
                  triggerMode: TooltipTriggerMode.tap,
                  child: Container(
                    padding: const EdgeInsets.all(Sizes.p4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(30),
                      borderRadius: BorderRadius.circular(Sizes.p4),
                    ),
                    child: Text(
                      practicedPrice.name.substring(0, 1),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
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
        SummaryTableItem(
          title: 'Total'.hardcoded,
          value: item.totalLiquid,
          isPrice: true,
          color: theme.primaryColor,
        ),
      ],
    );
  }
}
