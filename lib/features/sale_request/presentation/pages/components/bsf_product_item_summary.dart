import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../commom_widgets/commom_widgets.dart';
import '../../../../../../../constants/constants.dart';
import '../../../../../../../core/domain/entities/entities.dart';
import '../../../../../localization/string_hardcoded.dart';
import '../../../../../utils/utils.dart';
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
    final currentQuantity = item.quantity ?? 0;

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
              PlatformIcon(
                cupertinoIcon: CupertinoIcons.cart,
                materialIcon: Icons.shopping_cart_outlined,
                size: 14,
                color: theme.primaryColor,
              ),
              gapW4,
              Text(
                'Qtd'.hardcoded,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              gapW4,
              IconButton(
                onPressed: () {
                  if (currentQuantity <= 1) {
                    return;
                  }

                  ref
                      .read(
                        insertUpdateStateControllerProvider(
                          enterpriseCode: enterpriseCode,
                          customerCode: customerCode,
                          saleRequestId: saleRequestId,
                        ).notifier,
                      )
                      .updateItemQuantity(item, (item.quantity ?? 0) - 1);
                },
                icon: PlatformIcon(
                  cupertinoIcon: CupertinoIcons.minus_circle,
                  materialIcon: Icons.remove_circle_outline,
                  size: 20,
                  color: (item.quantity ?? 0) > 1 ? null : theme.hintColor,
                ),
                padding: const EdgeInsets.all(Sizes.p4),
                constraints: const BoxConstraints(),
              ),
              gapW8,
              Text(
                (item.quantity ?? 0).toString().toBrazilianNumber(3, true),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              gapW8,
              IconButton(
                onPressed: () => ref
                    .read(
                      insertUpdateStateControllerProvider(
                        enterpriseCode: enterpriseCode,
                        customerCode: customerCode,
                        saleRequestId: saleRequestId,
                      ).notifier,
                    )
                    .updateItemQuantity(item, (item.quantity ?? 0) + 1),
                icon: const PlatformIcon(
                  cupertinoIcon: CupertinoIcons.plus_circle,
                  materialIcon: Icons.add_circle_outline,
                  size: 20,
                ),
                padding: const EdgeInsets.all(Sizes.p4),
                constraints: const BoxConstraints(),
              ),
              const Spacer(),
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
