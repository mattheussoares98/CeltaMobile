import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
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

  bool get showingLittleInformations {
    int value = [
      showPracticedPrices,
      showWholePrices,
      showLiquidCosts,
      showCurrentAndSaleStocks,
      showEans,
    ].fold(0, (p, e) => e ? ++p : p);
    if (showCurrentAndSaleStocks) {
      //show 2 informations
      value++;
    }

    return value <= 1;
  }

  double get bottomPadding {
    if (routine == BsRoutine.goodsReceiving) {
      return Sizes.p8;
    } else if (routine == BsRoutine.priceConference) {
      return 0;
    } else if (routine == BsRoutine.adjustSalePrice) {
      return 0;
    } else if (cartItemSummary != null) {
      return Sizes.p8;
    } else if (showEans && showingLittleInformations) {
      return Sizes.p32;
    } else if (showEans) {
      return Sizes.p16;
    }

    return Sizes.p8;
  }

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

    return RepaintBoundary(
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(bottom: Sizes.p8),
        child: Column(
          children: [
            InkWell(
              onTap: onTap == null || isIOS
                  ? null
                  : () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      onTap!();
                    },
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                Sizes.p8,
                                Sizes.p8,
                                Sizes.p8,
                                bottomPadding,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          TitleAndSubTitle(
                                            title: "PLU ",
                                            subTitle: product.PLU,
                                          ),
                                          if (showPracticedPrices)
                                            PracticedPriceProperty(this),
                                          if (showWholePrices)
                                            WholePriceAndMinQuantity(this),
                                          if (showLiquidCosts)
                                            LiquidCostProperty(this),
                                          if (showCurrentAndSaleStocks)
                                            CurrentAndSaleStocks(this),
                                          if (showEans) EansProperty(this),
                                          ?cartItemSummary,
                                          ?clickableBottom,
                                        ],
                                      ),
                                      if (!showingLittleInformations)
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: InfoButton(this),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          right: isIOS ? Sizes.p4 : 0,
                          bottom: isIOS
                              ? routine == BsRoutine.buyQuotation
                                    ? -Sizes.p4
                                    : Sizes.p4
                              : 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  if (showingLittleInformations)
                                    InfoButton(this),
                                  if (onDelete != null)
                                    DeleteItemButton(onDelete: onDelete),
                                  if (showDropIcon == true)
                                    SelectedIconIndicator(
                                      selected: isSelected ?? false,
                                      onTap: onTap,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ?rightWidget,
                ],
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
      ),
    );
  }
}
