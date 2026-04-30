import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../constants/constants.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../domain/entities/entities.dart';
import '../../../../controllers/controllers.dart';
import './summary_row.dart';

class ProductSummary extends ConsumerWidget {
  final BSFProductItemEntity product;
  const ProductSummary({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(insertProductUIControllerProvider(product));
    final item = uiState.applyTo(product);
    final theme = Theme.of(context);

    final labelStyle = theme.textTheme.labelMedium?.copyWith(
      color: theme.hintColor,
    );
    final valueStyle = theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.bold,
    );

    return Container(
      padding: const EdgeInsets.all(Sizes.p16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(76),
        borderRadius: BorderRadius.circular(Sizes.p12),
        border: Border.all(color: theme.dividerColor.withAlpha(25)),
      ),
      child: Column(
        children: [
          SummaryRow(
            label: 'Quantidade:'.hardcoded,
            value: item.quantity.toString().toBrazilianNumber(3, true),
            labelStyle: labelStyle,
            valueStyle: valueStyle,
          ),
          gapH8,
          SummaryRow(
            label: 'Preço Bruto:'.hardcoded,
            value: ((item.quantity ?? 0) * (item.value ?? 0))
                .toString()
                .toBrazilianNumber(2),
            labelStyle: labelStyle,
            valueStyle: valueStyle,
            isPrice: true,
          ),
          if (item.totalDeliveryTax > 0) ...[
            gapH8,
            SummaryRow(
              label: 'Frete:'.hardcoded,
              value: item.totalDeliveryTax.toString().toBrazilianNumber(2),
              labelStyle: labelStyle,
              valueStyle: valueStyle?.copyWith(
                color: theme.colorScheme.secondary,
              ),
              isPrice: true,
            ),
          ],
          if (item.totalDiscountValue > 0) ...[
            gapH8,
            SummaryRow(
              label: 'Total Descontos:'.hardcoded,
              value: item.totalDiscountValue.toString().toBrazilianNumber(2),
              labelStyle: labelStyle,
              valueStyle: valueStyle?.copyWith(color: theme.colorScheme.error),
              isPrice: true,
            ),
          ],
          if (item.totalIncrement > 0) ...[
            gapH8,
            SummaryRow(
              label: 'Acréscimo:'.hardcoded,
              value: item.totalIncrement.toString().toBrazilianNumber(2),
              labelStyle: labelStyle,
              valueStyle: valueStyle?.copyWith(color: theme.colorScheme.primary),
              isPrice: true,
            ),
          ],
          const Divider(height: Sizes.p24),
          SummaryRow(
            label: 'Total Líquido:'.hardcoded,
            value: item.totalLiquid.toString().toBrazilianNumber(2),
            labelStyle: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            valueStyle: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
            isPrice: true,
          ),
        ],
      ),
    );
  }
}
