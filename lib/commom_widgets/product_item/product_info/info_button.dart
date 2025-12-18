import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../core/domain/entities/entities.dart';
import '../../commom_widgets.dart';

class InfoButton extends StatelessWidget {
  final ProductItemWidget widget;
  const InfoButton(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    final showPrices = [
      BsRoutine.generic,
      BsRoutine.saleRequest,
      BsRoutine.buyRequest,
      BsRoutine.transferRequest,
      BsRoutine.priceConference,
      BsRoutine.adjustStock,
      BsRoutine.adjustSalePrice,
      BsRoutine.buyQuotation,
    ].any((x) => x == widget.routine);

    final stocks = widget.product.Stocks;
    final showStocks =
        stocks != null &&
        stocks.isNotEmpty &&
        stocks.any((e) => e.StockQuantity >= 0);

    final showMargins = [
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

    final showCosts = [
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

    final showShoppings =
        widget.product.LastBuyEntrances != null &&
        widget.product.LastBuyEntrances!.isNotEmpty;

    final showAddresses =
        widget.product.StorageAreaAddress != null &&
        (widget.product.StockByEnterpriseAssociateds?.length ?? 0) > 0;

    final showQuantity = [
      showPrices,
      showStocks,
      showAddresses,
      showShoppings,
      showCosts,
      showMargins,
    ].where((e) => e == true).length;

    if (showQuantity < 2) {
      //should be bigger than 2 to avoid error in the bottomNavigationBar
      return const SizedBox.shrink();
    } else if (widget.routine == BsRoutine.goodsReceiving) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);

    return PrimaryTextButton(
      text: 'Info'.hardcoded,
      icon: Icon(
        theme.platform == TargetPlatform.iOS ? Icons.info : Icons.info,
        color: theme.primaryColor,
      ),
      onPressed: () {
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
