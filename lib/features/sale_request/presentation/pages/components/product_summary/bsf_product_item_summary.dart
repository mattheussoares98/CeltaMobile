import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final size = MediaQuery.sizeOf(context);

    if (product.getPrice <= 0) {
      return const SizedBox.shrink();
    }

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
          if (size.width > 200)
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      QuantityControlButton(
                        item: item,
                        product: product,
                        enterpriseCode: enterpriseCode,
                        customerCode: customerCode,
                        saleRequestId: saleRequestId,
                        isAdding: false,
                        size: 32,
                      ),
                      gapW12,
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            (item?.quantity ?? 0).toString().toBrazilianNumber(
                              3,
                              true,
                            ),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Qtd'.hardcoded,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      gapW12,
                      QuantityControlButton(
                        item: item,
                        product: product,
                        enterpriseCode: enterpriseCode,
                        customerCode: customerCode,
                        saleRequestId: saleRequestId,
                        isAdding: true,
                        size: 32,
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
          if (item != null) CartSummaryTable(item: item!, product: product),
        ],
      ),
    );
  }
}
