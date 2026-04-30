import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../../localization/string_hardcoded.dart';
import '../../../../../../utils/utils.dart';
import '../../../../domain/entities/entities.dart';
import '../components.dart';

class BSFProductItemSummary extends ConsumerWidget {
  final BSFProductItemEntity? item;
  final ProductEntity product;
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;

  const BSFProductItemSummary({
    super.key,
    required this.item,
    required this.product,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(Sizes.p4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(12),
        borderRadius: BorderRadius.circular(Sizes.p8),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (MediaQuery.sizeOf(context).width > 200)
                Row(
                  children: [
                    PlatformIcon(
                      cupertinoIcon: Icons.shopping_cart_outlined,
                      materialIcon: Icons.shopping_cart_outlined,
                      size: 14,
                      color: theme.primaryColor,
                    ),
                    gapW4,
                    FittedBox(
                      child: Text(
                        'Qtd'.hardcoded,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              gapW4,
              Flexible(
                child: Row(
                  children: [
                    Flexible(
                      child: QuantityControlButton(
                        item: item,
                        product: product,
                        enterpriseCode: enterpriseCode,
                        customerCode: customerCode,
                        saleRequestId: saleRequestId,
                        isAdding: false,
                      ),
                    ),
                    gapW4,
                    FittedBox(
                      child: Text(
                        (item?.quantity ?? 0).toString().toBrazilianNumber(
                          3,
                          true,
                        ),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    gapW4,
                    Flexible(
                      child: QuantityControlButton(
                        item: item,
                        product: product,
                        enterpriseCode: enterpriseCode,
                        customerCode: customerCode,
                        saleRequestId: saleRequestId,
                        isAdding: true,
                      ),
                    ),
                  ],
                ),
              ),
              if (item != null)
                DeleteSummaryButton(
                  item: item!,
                  enterpriseCode: enterpriseCode,
                  customerCode: customerCode,
                  saleRequestId: saleRequestId,
                ),
            ],
          ),
          if (item != null)
            SummaryTable(
              items: [
                SummaryTableItem(
                  title: 'Preço'.hardcoded,
                  value: item!.value,
                  decimalHouses: 2,
                  isPrice: true,
                ),
                if (item!.totalDeliveryTax > 0)
                  SummaryTableItem(
                    title: 'Frete'.hardcoded,
                    value: item!.totalDeliveryTax,
                    isPrice: true,
                    color: theme.colorScheme.secondary,
                  ),
                if (item!.totalDiscountValue > 0)
                  SummaryTableItem(
                    title: 'Desconto'.hardcoded,
                    value: item!.totalDiscountValue,
                    isPrice: true,
                    color: Colors.red,
                  ),
                if (item!.totalIncrement > 0)
                  SummaryTableItem(
                    title: 'Acréscimo'.hardcoded,
                    value: item!.totalIncrement,
                    isPrice: true,
                    color: Colors.orange,
                  ),
                SummaryTableItem(
                  title: 'Total'.hardcoded,
                  value: item!.totalLiquid,
                  isPrice: true,
                  color: theme.primaryColor,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
