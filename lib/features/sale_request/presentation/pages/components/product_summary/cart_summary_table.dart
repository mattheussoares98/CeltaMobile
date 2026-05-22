import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class CartSummaryTable extends StatelessWidget {
  final BSFProductItemEntity item;
  const CartSummaryTable({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final practicedPrice = item.practicedPriceType;
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
                      color: context.theme.colorScheme.primary.withAlpha(30),
                      borderRadius: BorderRadius.circular(Sizes.p4),
                    ),
                    child: Text(
                      practicedPrice.name.substring(0, 1),
                      style: context.theme.textTheme.labelSmall?.copyWith(
                        color: context.theme.primaryColor,
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
            color: context.theme.colorScheme.secondary,
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
          color: context.theme.primaryColor,
        ),
      ],
    );
  }
}
