import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../domain/entities/entities.dart';
import '../../controllers/controllers.dart';

class BSFProductItemSummary extends ConsumerWidget {
  final BSFProductItemEntity item;
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    PlatformIcon(
                      cupertinoIcon: CupertinoIcons.cart,
                      materialIcon: Icons.shopping_cart_outlined,
                      size: 14,
                      color: theme.primaryColor,
                    ),
                    gapW4,
                    Flexible(
                      child: Text(
                        'No carrinho'.hardcoded,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => ref
                    .read(
                      insertUpdateStateControllerProvider(
                        enterpriseCode: enterpriseCode,
                        customerCode: customerCode,
                        saleRequestId: saleRequestId,
                      ).notifier,
                    )
                    .removeItem(item),
                icon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.delete,
                  materialIcon: Icons.delete_outline,
                  size: 24,
                  color: Colors.red,
                ),
                padding: const EdgeInsets.all(Sizes.p4),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
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
              SummaryTableItem(
                title: 'Total'.hardcoded,
                value: item.totalLiquid,
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
