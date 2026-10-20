import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/features/sale_request/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductSummary extends ConsumerWidget {
  const ProductSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(currentProductItemProvider);
    final uiState = ref.watch(insertProductUIControllerProvider(product));
    final item = uiState.applyTo(product);

    final labelStyle = context.theme.textTheme.labelMedium?.copyWith(
      color: context.theme.hintColor,
    );
    final valueStyle = context.theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.bold,
    );

    return Container(
      padding: const EdgeInsets.all(Sizes.p16),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surfaceContainerHighest.withAlpha(76),
        borderRadius: BorderRadius.circular(Sizes.p12),
        border: Border.all(color: context.theme.dividerColor.withAlpha(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleAndSubTitle(
            title: context.l10n.quantity,
            subTitle: item.quantity,
            titleStyle: labelStyle,
            subTitleStyle: valueStyle,
          ),
          gapH8,
          TitleAndSubTitle(
            title: context.l10n.grossPrice,
            subTitle: (item.quantity ?? 0) * (item.value ?? 0),
            subTitleIsPrice: true,
            titleStyle: labelStyle,
            subTitleStyle: valueStyle,
          ),
          if (item.totalDeliveryTax > 0) ...[
            gapH8,
            TitleAndSubTitle(
              title: context.l10n.freight,
              subTitle: item.totalDeliveryTax,
              subTitleIsPrice: true,
              titleStyle: labelStyle,
              subTitleStyle: valueStyle?.copyWith(
                color: context.theme.colorScheme.secondary,
              ),
            ),
          ],
          if (item.totalDiscountValue > 0) ...[
            gapH8,
            TitleAndSubTitle(
              title: context.l10n.totalDiscounts3,
              subTitle: item.totalDiscountValue,
              subTitleIsPrice: true,
              titleStyle: labelStyle,
              subTitleStyle: valueStyle?.copyWith(
                color: context.theme.colorScheme.error,
              ),
            ),
          ],
          if (item.totalIncrement > 0) ...[
            gapH8,
            TitleAndSubTitle(
              title: context.l10n.surcharge,
              subTitle: item.totalIncrement,
              subTitleIsPrice: true,
              titleStyle: labelStyle,
              subTitleStyle: valueStyle?.copyWith(color: Colors.orange),
            ),
          ],
          const Divider(height: Sizes.p24),
          TitleAndSubTitle(
            title: context.l10n.netTotal2,
            subTitle: item.totalLiquid,
            subTitleIsPrice: true,
            titleStyle: context.theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            subTitleStyle: context.theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
