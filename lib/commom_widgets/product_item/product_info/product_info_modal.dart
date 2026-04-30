import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../../core/domain/entities/entities.dart';
import '../../commom_widgets.dart';

class ProductInfoModal extends StatefulWidget {
  final ProductEntity product;
  final BsRoutine routine;
  final bool showPrices;
  final bool showStocks;
  final bool showAddresses;
  final bool showShoppings;
  final bool showCosts;
  final bool showMargins;
  const ProductInfoModal({
    super.key,
    required this.product,
    required this.routine,
    required this.showPrices,
    required this.showStocks,
    required this.showAddresses,
    required this.showShoppings,
    required this.showCosts,
    required this.showMargins,
  });

  @override
  State<ProductInfoModal> createState() => _ProductInfoModalState();
}

class _ProductInfoModalState extends State<ProductInfoModal> {
  final scrollController = PageController();
  int currentIndex = 0;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      if (widget.showPrices) Prices(widget: widget),
      if (widget.showStocks) Stocks(widget: widget),
      if (widget.showAddresses) Addresses(widget: widget),
      if (widget.showShoppings) Shopping(widget: widget),
      if (widget.showCosts) Costs(widget: widget),
      if (widget.showMargins) Margins(widget: widget),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: PageView(
          controller: scrollController,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          children: pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          scrollController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          );
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          if (widget.showPrices)
            BottomNavigationBarItem(
              icon: const PlatformIcon(
                cupertinoIcon: CupertinoIcons.money_dollar,
                materialIcon: Icons.attach_money,
              ),
              label: 'Preços'.hardcoded,
            ),
          if (widget.showStocks)
            BottomNavigationBarItem(
              icon: const PlatformIcon(
                cupertinoIcon: CupertinoIcons.archivebox,
                materialIcon: Icons.inventory_2_outlined,
              ),
              label: 'Estoques'.hardcoded,
            ),
          if (widget.showAddresses)
            BottomNavigationBarItem(
              icon: const PlatformIcon(
                cupertinoIcon: CupertinoIcons.location,
                materialIcon: Icons.location_pin,
              ),
              label: 'Endereços'.hardcoded,
            ),
          if (widget.showShoppings)
            BottomNavigationBarItem(
              icon: const PlatformIcon(
                cupertinoIcon: CupertinoIcons.shopping_cart,
                materialIcon: Icons.shopping_cart_outlined,
              ),
              label: 'Compras'.hardcoded,
            ),
          if (widget.showCosts)
            BottomNavigationBarItem(
              icon: const PlatformIcon(
                cupertinoIcon: CupertinoIcons.creditcard,
                materialIcon: Icons.credit_card,
              ),
              label: 'Custos'.hardcoded,
            ),
          if (widget.showMargins)
            BottomNavigationBarItem(
              icon: const PlatformIcon(
                cupertinoIcon: CupertinoIcons.chart_bar,
                materialIcon: Icons.bar_chart_rounded,
              ),
              label: 'Margens'.hardcoded,
            ),
        ],
      ),
    );
  }
}
