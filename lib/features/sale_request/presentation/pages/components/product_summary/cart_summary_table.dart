import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
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
          decimalHouses: 2,
          isPrice: true,
          trailing: SummaryTooltip(
            message: 'Preço ${practicedPrice.name.toLowerCase()}'.hardcoded,
            text: practicedPrice.name.substring(0, 1),
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
              message: _buildDiscountTooltipMessage(item),
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

  String? _buildDiscountTooltipMessage(BSFProductItemEntity item) {
    final activeDiscounts = item.discounts?.where(
      (d) => (d.discount?.value ?? 0) > 0,
    );
    if (activeDiscounts?.isEmpty ?? true) {
      return null;
    }

    final buffer = StringBuffer();
    for (final d in activeDiscounts!) {
      if (buffer.isNotEmpty) {
        buffer.write('\n');
      }

      final value = d.discount!.value!.toString().toBrazilianNumber(2);
      final isPercentage = d.discount!.type == PercentageOrValue.percentage;
      final valueLabel = isPercentage ? '$value%' : 'R\$ $value';

      final origin = d.discountOrigin?.description ?? '';
      final justification = d.justification ?? '';

      final details = [
        if (origin.isNotEmpty) origin,
        if (justification.isNotEmpty) justification,
      ];

      buffer.write(valueLabel);
      if (details.isNotEmpty) {
        buffer.write(' (${details.join(' - ')})');
      }
    }

    return buffer.toString();
  }
}
