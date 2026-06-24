import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
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
  final bool showStock;
  final bool showInfoButton;

  const BSFProductItemSummary({
    super.key,
    required this.product,
    required this.item,
    this.useCard = true,
    required this.heroPrefix,
    required this.showStock,
    required this.showInfoButton,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final breakLine =
        item.totalDiscountValue > 0 ||
        item.totalIncrement > 0 ||
        item.totalDeliveryTax > 0;

    final summaryContent = SingleChildScrollView(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (size.width > 200)
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(child: DeleteSummaryButton(item: item)),
                  Expanded(
                    child: Visibility(
                      visible: !breakLine,
                      child: CartSummaryTable(item: item),
                    ),
                  ),
                  QuantityControlButton(item: item, isAdding: false),
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
                  QuantityControlButton(item: item, isAdding: true),
                ],
              ),
            if (breakLine) CartSummaryTable(item: item),
          ],
        ),
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
            hideCost: true,
            showInfoButton: showInfoButton,
            hideCurrentAndSaleStocks: !showStock,
            showEditIcon: PlatformUtil.isCupertino,
            editIcon: const PlatformIcon(
              cupertinoIcon: CupertinoIcons.arrow_up_right,
              materialIcon: Icons.arrow_outward_rounded,
            ),
            hideWholeInformations:
                (product.WholePracticedPrice ??
                        product.PriceCost?.WholePracticedPrice ??
                        0) ==
                    0 ||
                (product.MinimumWholeQuantity ??
                        product.PriceCost?.MinimumWholeQuantity ??
                        0) ==
                    0,
            product: product,
            routine: BsRoutine.saleRequest,
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
            clickableBottom: summaryContent,
          ),
        ),
      ),
    );
  }
}
