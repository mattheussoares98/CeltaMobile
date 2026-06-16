import 'package:celta_inventario/commom_widgets/animations/animations.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class SummaryTableItem {
  final String title;
  final dynamic value;
  final bool isPrice;
  final bool isPercentage;
  final int decimalHouses;
  final Color? color;
  final Widget? trailing;

  SummaryTableItem({
    required this.title,
    required this.value,
    this.isPrice = false,
    this.isPercentage = false,
    this.decimalHouses = 2,
    this.color,
    this.trailing,
  });
}

class SummaryTable extends StatelessWidget {
  final List<SummaryTableItem> items;
  final MainAxisAlignment mainAxisAlignment;
  const SummaryTable({
    super.key,
    required this.items,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.theme.textTheme.labelSmall?.copyWith(
      color: context.theme.hintColor,
      fontWeight: FontWeight.bold,
    );
    final valueStyle = context.theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.bold,
    );

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: items.map((item) {
        String formattedValue = item.value.toString();
        String? priceText;

        if (item.value is num) {
          if (item.isPrice) {
            priceText = item.value.toString().toBrazilianNumber(
              item.decimalHouses,
            );
          } else if (item.isPercentage) {
            formattedValue =
                '${item.value.toString().toBrazilianNumber(item.decimalHouses)} %';
          } else {
            formattedValue = item.value.toString().toBrazilianNumber(
              item.decimalHouses,
              true,
            );
          }
        }

        final effectiveValueStyle = item.color != null
            ? valueStyle?.copyWith(color: item.color)
            : valueStyle;

        return Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      item.title,
                      style: labelStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (item.trailing != null) ...[gapW4, item.trailing!],
                ],
              ),
              if (priceText != null)
                AnimatedPriceValue(
                  key: ValueKey(item.title),
                  value: item.value as num,
                  style: effectiveValueStyle,
                  priceText: priceText,
                )
              else
                Text(
                  formattedValue,
                  style: effectiveValueStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
