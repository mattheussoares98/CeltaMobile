import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/components/product_summary/discount_presentation_extensions.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/components/product_summary/summary_tooltip.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class CartSummaryTable extends StatelessWidget {
  final BSFProductItemEntity item;
  const CartSummaryTable({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final practicedPrice = item.practicedPriceType;

    return SummaryTable(
      items: [
        SummaryTableItem(
          title: 'Preço'.hardcoded,
          value: item.value,
          isPrice: true,
          trailing: SummaryTooltip(
            message:
                'Preço ${practicedPrice.description.toLowerCase()}'.hardcoded,
            text: practicedPrice.abbreviation,
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
            trailing: SummaryTooltip(
              message: item.discounts.formattedDescription,
              color: Colors.red,
            ),
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
