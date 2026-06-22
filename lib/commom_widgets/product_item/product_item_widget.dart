import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/commom_widgets/product_item/properties/properties.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/controllers/controllers.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductItemWidget extends ConsumerWidget {
  final ProductEntity product;
  final BsRoutine routine;
  final Widget? notClickableBottom;
  final Widget? clickableBottom;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool showEditIcon;
  final PlatformIcon? editIcon;
  final bool? isSelected;
  final bool? showInfoButton;
  final Widget? cartItemSummary;
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
    this.editIcon,
    this.onDelete,
    this.notClickableBottom,
    this.clickableBottom,
    this.showEditIcon = false,
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

  bool get showPracticedPrices {
    if (hidePrice == true) {
      return false;
    } else if ([
      BsRoutine.adjustStock,
      BsRoutine.buyRequest,
      BsRoutine.buyQuotation,
      BsRoutine.goodsReceiving,
      BsRoutine.adjustStock,
      BsRoutine.researchOfPrice,
    ].contains(routine)) {
      return false;
    }
    return true;
  }

  bool get showWholePrices {
    if (hideWholeInformations == true) {
      return false;
    } else if ([
      BsRoutine.adjustSalePrice,
      BsRoutine.adjustStock,
      BsRoutine.buyQuotation,
      BsRoutine.researchOfPrice,
      BsRoutine.priceConference,
    ].contains(routine)) {
      return false;
    } else if ((product.WholePracticedPrice ?? 0) == 0) {
      return false;
    }
    return true;
  }

  bool get showLiquidCosts {
    if (hideCost == true) {
      return false;
    } else if ([
      BsRoutine.adjustStock,
      BsRoutine.buyQuotation,
      BsRoutine.goodsReceiving,
      BsRoutine.researchOfPrice,
      BsRoutine.transferRequest,
    ].contains(routine)) {
      return false;
    }
    return true;
  }

  bool get showCurrentAndSaleStocks {
    if (hideCurrentAndSaleStocks == true) {
      return false;
    } else if ([
      BsRoutine
          .adjustSalePrice, //! is not returning this property on this routine
      BsRoutine.buyQuotation,
      BsRoutine.goodsReceiving,
      BsRoutine.researchOfPrice,
    ].contains(routine)) {
      return false;
    }
    return true;
  }

  bool get showEans {
    return product.EANs?.any((s) => s.isNotEmpty) ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      finishOfferControllerProvider(
        product.ProductPackingCode!,
        product.EnterpriseCode,
      ),
      (p, n) {
        n.showAlertDialogOnError(context);
        n.showAlertDialogOnSuccess(
          context,
          previous: p,
          title: 'Oferta encerrada'.hardcoded,
          message:
              'Oferta encerrada com sucesso. Consulte o produto novamente para atualizar as informações'
                  .hardcoded,
        );
      },
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: context.theme.cardTheme.margin?.add(
        const EdgeInsets.only(bottom: Sizes.p4),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap == null || PlatformUtil.isCupertino
                ? null
                : () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    onTap!();
                  },
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ?itemBeforeProductName,
                            NameAndPacking(product: product),
                            Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TitleAndSubTitle(
                                      copyableSubtitle: true,
                                      title: "PLU ",
                                      subTitle: product.PLU,
                                    ),
                                    if (showPracticedPrices)
                                      PracticedPriceProperty(this),
                                    if (showWholePrices)
                                      WholePriceAndMinQuantity(this),
                                    if (showLiquidCosts)
                                      ReplacementCostProperty(this),
                                    if (showCurrentAndSaleStocks)
                                      CurrentAndSaleStocks(this),
                                    if (showEans) EansProperty(this),
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InfoButton(this),
                                ),
                              ],
                            ),
                            ?clickableBottom,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (onDelete != null) ...[
                                  Flexible(
                                    child: DeleteItemButton(onDelete: onDelete),
                                  ),
                                ],
                                if (showEditIcon)
                                  Flexible(
                                    child: SelectedIconIndicator(
                                      selected: isSelected ?? false,
                                      onTap: onTap,
                                      editIcon: editIcon,
                                    ),
                                  ),
                              ],
                            ),
                            ?cartItemSummary,
                          ],
                        ),
                      ),
                      ?rightWidget,
                    ],
                  ),
                ],
              ),
            ),
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
