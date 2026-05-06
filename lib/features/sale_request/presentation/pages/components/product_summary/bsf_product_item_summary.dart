import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../components.dart';

class BSFProductItemSummary extends ConsumerWidget {
  final ProductEntity product;
  final BSFProductItemEntity item;
  final int enterpriseCode;
  final int customerCode;
  final int saleRequestId;
  final bool useCard;
  final String heroPrefix;

  const BSFProductItemSummary({
    super.key,
    required this.product,
    required this.item,
    required this.enterpriseCode,
    required this.customerCode,
    required this.saleRequestId,
    this.useCard = true,
    required this.heroPrefix,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if ((item.value ?? 0) <= 0 && useCard) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final summaryContent = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (size.width > 200)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                QuantityControlButton(
                  item: item,
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
                      (item.quantity ?? 0).toString().toBrazilianNumber(
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
                  enterpriseCode: enterpriseCode,
                  customerCode: customerCode,
                  saleRequestId: saleRequestId,
                  isAdding: true,
                  size: 32,
                ),
                const Spacer(),
                DeleteSummaryButton(
                  item: item,
                  enterpriseCode: enterpriseCode,
                  customerCode: customerCode,
                  saleRequestId: saleRequestId,
                ),
              ],
            ),
          CartSummaryTable(item: item),
        ],
      ),
    );

    if (!useCard) {
      return summaryContent;
    }

    final heroTag = '$heroPrefix-product-${product.ProductPackingCode}';

    return Hero(
      tag: heroTag,
      child: Material(
        type: MaterialType.transparency,
        child: SingleChildScrollView(
          child: ProductItemWidget(
            product: product,
            routine: BsRoutine.saleRequest,
            hideCurrentAndSaleStocks: true,
            onTap: () {
              context.pushNamed(
                Routes.saleRequestInsertProduct.name,
                extra: {
                  'product': item,
                  'originalProduct': product,
                  'heroTag': heroTag,
                },
                pathParameters: {
                  'saleRequestId': saleRequestId.toString(),
                  'enterpriseCode': enterpriseCode.toString(),
                  'customerCode': customerCode.toString(),
                },
              );
            },
            cartItemSummary: summaryContent,
          ),
        ),
      ),
    );
  }
}
