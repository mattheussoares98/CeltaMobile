import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/components/components.dart';
import 'package:celta_inventario/features/sale_request/providers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BSFProductItemSummary extends ConsumerWidget {
  final ProductEntity product;
  final BSFProductItemEntity item;
  final bool useCard;
  final String heroPrefix;

  const BSFProductItemSummary({
    super.key,
    required this.product,
    required this.item,
    this.useCard = true,
    required this.heroPrefix,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final summaryContent = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CartSummaryTable(item: item),

          if (size.width > 200)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DeleteSummaryButton(item: item),
                const Spacer(),
                QuantityControlButton(item: item, isAdding: false, size: 32),
                gapW12,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      (item.quantity ?? 0).toString().toBrazilianNumber(
                        3,
                        true,
                      ),
                      style: context.theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Qtd'.hardcoded,
                      style: context.theme.textTheme.labelSmall?.copyWith(
                        color: context.theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                QuantityControlButton(item: item, isAdding: true, size: 32),
              ],
            ),
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
            showEditIcon: PlatformUtil.isCupertino,
            editIcon: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.arrow_up_right,
              materialIcon: Icons.arrow_outward_rounded,
            ),
            product: product,
            routine: BsRoutine.saleRequest,
            hideCurrentAndSaleStocks: true,
            onTap: () {
              final args = ref.read(saleRequestArgsProvider);
              context.pushNamed(
                Routes.saleRequestInsertProduct.name,
                extra: {
                  'product': item,
                  'originalProduct': product,
                  'heroTag': heroTag,
                  'container': ProviderScope.containerOf(context),
                },
                pathParameters: args.toPathParametersJson(),
              );
            },
            cartItemSummary: summaryContent,
          ),
        ),
      ),
    );
  }
}
