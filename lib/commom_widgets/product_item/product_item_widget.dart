import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/constants.dart';
import '../../core/domain/entities/entities.dart';
import '../../features/adjust_sale_price/presentation/controllers/controllers.dart';
import '../commom_widgets.dart';
import 'properties/properties.dart';

class ProductItemWidget extends ConsumerWidget {
  final ProductEntity product;
  final BsRoutine routine;
  final Widget? notClickableBottom;
  final Widget? clickableBottom;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool? showDropIcon;
  final bool? isSelected;
  final bool? showInfoButton;
  final CartItemSummary? cartItemSummary;
  final Widget? itemBeforeProductName;
  final Widget? rightWidget;
  final bool? hideWholeInformations;
  final bool? hideCost;
  final bool? hideCurrentAndSaleStocks;
  final bool? hidePrice;
  const ProductItemWidget({
    super.key,
    required this.product,
    required this.routine,
    this.onTap,
    this.onDelete,
    this.notClickableBottom,
    this.clickableBottom,
    this.showDropIcon,
    this.isSelected,
    this.showInfoButton = true,
    this.cartItemSummary,
    this.itemBeforeProductName,
    this.rightWidget,
    this.hideWholeInformations,
    this.hideCost,
    this.hideCurrentAndSaleStocks,
    this.hidePrice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(finishOfferControllerProvider, (p, n) {
      n.showAlertDialogOnError(context);
      n.showAlertDialogOnSuccess(
        context,
        previous: p,
        title: 'Oferta encerrada'.hardcoded,
        message:
            'Oferta encerrada com sucesso. Consulte o produto novamente para atualizar as informações'
                .hardcoded,
      );
    });

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: Sizes.p8),
      child: Column(
        children: [
          Stack(
            children: [
              InkWell(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ?itemBeforeProductName,
                            TitleAndSubTitle(
                              title: product.Name,
                              subTitle: product.PackingQuantity == null
                                  ? null
                                  : " (${product.PackingQuantity.toString().formattedPacking()})",
                              titleStyle: theme.textTheme.titleMedium,
                              subTitleStyle: theme.textTheme.bodyMedium,
                            ),
                            Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TitleAndSubTitle(
                                      title: "PLU ",
                                      subTitle: product.PLU,
                                    ),
                                    PracticedPriceProperty(this),
                                    WholePriceAndMinQuantity(this),
                                    LiquidCostProperty(this),
                                    CurrentAndSaleStocks(this),
                                    EansProperty(this),
                                    ?cartItemSummary,
                                    ?clickableBottom,
                                  ],
                                ),
                                if (routine != BsRoutine.researchOfPrice &&
                                    showInfoButton == true)
                                  Positioned(right: 0, child: InfoButton(this)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ?rightWidget,
                    ],
                  ),
                ),
              ),
              Positioned(
                right: isIOS ? Sizes.p4 : 0,
                bottom: isIOS ? Sizes.p4 : 0,
                child: Row(
                  children: [
                    if (onDelete != null) DeleteItemButton(onDelete: onDelete),
                    if (showDropIcon == true)
                      SelectedIconIndicator(selected: isSelected ?? false),
                  ],
                ),
              ),
            ],
          ),
          if (notClickableBottom != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Sizes.p8,
                0,
                Sizes.p8,
                Sizes.p8,
              ),
              child: notClickableBottom,
            ),
        ],
      ),
    );
  }
}
