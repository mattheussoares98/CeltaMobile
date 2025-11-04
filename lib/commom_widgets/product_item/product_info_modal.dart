import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../core/domain/entities/entities.dart';
import 'product_item.dart';

class ProductInfoModal extends StatefulWidget {
  final ProductEntity product;
  final int enterpriseCode;
  final BsRoutine routine;
  const ProductInfoModal({
    super.key,
    required this.product,
    required this.enterpriseCode,
    required this.routine,
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
      //TODO check in all modules, if load the data from each page. Because if is necessary, needs to hide depending on the module
      Prices(widget: widget, enterpriseCode: widget.enterpriseCode),
      Stocks(widget: widget),
      Addresses(widget: widget),
      Shopping(widget: widget),
      Costs(widget: widget),
      if (widget.routine == BsRoutine.adjustSalePrice) Margins(widget: widget),
    ];

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
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
          BottomNavigationBarItem(
            icon: Icon(
              isIOS ? CupertinoIcons.money_dollar : Icons.attach_money,
            ),
            label: 'Preços'.hardcoded,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              isIOS ? CupertinoIcons.archivebox : Icons.inventory_2_outlined,
            ),
            label: 'Estoques'.hardcoded,
          ),
          BottomNavigationBarItem(
            icon: Icon(isIOS ? CupertinoIcons.location : Icons.location_pin),
            label: 'Endereços'.hardcoded,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              isIOS
                  ? CupertinoIcons.shopping_cart
                  : Icons.shopping_cart_outlined,
            ),
            label: 'Compras'.hardcoded,
          ),
          BottomNavigationBarItem(
            icon: Icon(isIOS ? CupertinoIcons.creditcard : Icons.credit_card),
            label: 'Custos'.hardcoded,
          ),
          if (widget.routine == BsRoutine.adjustSalePrice)
            BottomNavigationBarItem(
              icon: Icon(
                isIOS ? CupertinoIcons.chart_bar : Icons.bar_chart_rounded,
              ),
              label: 'Margens'.hardcoded,
            ),
        ],
      ),
    );
  }
}
