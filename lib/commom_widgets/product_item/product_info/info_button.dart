import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/domain/entities/entities.dart';
import '../../commom_widgets.dart';

class InfoButton extends StatelessWidget {
  final ProductItemWidget widget;
  const InfoButton(this.widget, {super.key});

  bool get showPrices => [
    BsRoutine.generic,
    BsRoutine.saleRequest,
    BsRoutine.buyRequest,
    BsRoutine.transferRequest,
    BsRoutine.priceConference,
    BsRoutine.adjustStock,
    BsRoutine.adjustSalePrice,
    BsRoutine.buyQuotation,
  ].any((x) => x == widget.routine);

  bool get showStocks =>
      widget.product.Stocks?.any((x) => x.StockQuantity >= 0) ?? false;

  bool get showMargins => [
    widget.product.PriceCost?.RetailMargin,
    widget.product.PriceCost?.RetailMinimumMargin,
    widget.product.PriceCost?.RetailOfferMargin,
    widget.product.PriceCost?.WholeMargin,
    widget.product.PriceCost?.WholeMinimumMargin,
    widget.product.PriceCost?.WholeOfferMargin,
    widget.product.PriceCost?.ECommerceMargin,
    widget.product.PriceCost?.ECommerceMinimumMargin,
    widget.product.PriceCost?.ECommerceOfferMargin,
  ].any((x) => x != null && x > 0);

  bool get showCosts => [
    widget.product.LiquidCost,
    widget.product.LiquidCostMidle,
    widget.product.FiscalCost,
    widget.product.FiscalLiquidCost,
    widget.product.OperationalCost,
    widget.product.RealCost,
    widget.product.RealLiquidCost,
    widget.product.ReplacementCost,
    widget.product.ReplacementCostMidle,
  ].where((e) => e != null && e != -1).isNotEmpty;

  bool get showShoppings =>
      widget.product.LastBuyEntrances?.isNotEmpty ?? false;

  bool get showAddresses =>
      widget.product.StorageAreaAddress != null ||
      (widget.product.StockByEnterpriseAssociateds?.length ?? 0) > 0;

  int get showQuantity => [
    showPrices,
    showStocks,
    showAddresses,
    showShoppings,
    showCosts,
    showMargins,
  ].where((e) => e == true).length;

  @override
  Widget build(BuildContext context) {
    if (widget.showInfoButton == false) {
      return const SizedBox.shrink();
    } else if (widget.routine == BsRoutine.researchOfPrice) {
      return const SizedBox.shrink();
    } else if (showQuantity < 2) {
      //should be bigger than 2 to avoid error in the bottomNavigationBar
      return const SizedBox.shrink();
    } else if (widget.routine == BsRoutine.goodsReceiving) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return PrimaryTextButton(
      text: 'Info'.hardcoded,
      icon: Icon(
        isIOS ? CupertinoIcons.info_circle_fill : Icons.info,
        color: theme.primaryColor,
        size: 18,
      ),
      onPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showModalPage(
          ProductInfoModal(
            product: widget.product,
            routine: widget.routine,
            showPrices: showPrices,
            showStocks: showStocks,
            showAddresses: showAddresses,
            showShoppings: showShoppings,
            showCosts: showCosts,
            showMargins: showMargins,
          ),
          context,
        );
      },
    );
  }
}
