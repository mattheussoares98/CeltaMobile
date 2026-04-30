import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../localization/string_hardcoded.dart';
import '../../../../controllers/controllers.dart';

class ProductSummary extends ConsumerWidget {
  const ProductSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(currentProductItemProvider);
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleAndSubTitle(
            title: 'Quantidade'.hardcoded,
            subTitle: item.quantity,
            titleStyle: labelStyle,
            subTitleStyle: valueStyle,
          ),
          gapH8,
          TitleAndSubTitle(
            title: 'Preço Bruto'.hardcoded,
            subTitle: (item.quantity ?? 0) * (item.value ?? 0),
            subTitleIsPrice: true,
            titleStyle: labelStyle,
            subTitleStyle: valueStyle,
          ),
          if (item.totalDeliveryTax > 0) ...[
            gapH8,
            TitleAndSubTitle(
              title: 'Frete'.hardcoded,
              subTitle: item.totalDeliveryTax,
              subTitleIsPrice: true,
              titleStyle: labelStyle,
              subTitleStyle: valueStyle?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
          ],
          if (item.totalDiscountValue > 0) ...[
            gapH8,
            TitleAndSubTitle(
              title: 'Total Descontos'.hardcoded,
              subTitle: item.totalDiscountValue,
              subTitleIsPrice: true,
              titleStyle: labelStyle,
              subTitleStyle: valueStyle?.copyWith(color: theme.colorScheme.error),
            ),
          ],
          if (item.totalIncrement > 0) ...[
            gapH8,
            TitleAndSubTitle(
              title: 'Acréscimo'.hardcoded,
              subTitle: item.totalIncrement,
              subTitleIsPrice: true,
              titleStyle: labelStyle,
              subTitleStyle:
                  valueStyle?.copyWith(color: theme.colorScheme.primary),
            ),
          ],
          const Divider(height: Sizes.p24),
          TitleAndSubTitle(
            title: 'Total Líquido'.hardcoded,
            subTitle: item.totalLiquid,
            subTitleIsPrice: true,
            titleStyle: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            subTitleStyle: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
