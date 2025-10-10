import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      Prices(widget: widget, enterpriseCode: widget.enterpriseCode),
      Stocks(widget: widget),
      Addresses(widget: widget),
      Costs(widget: widget),
      if (widget.routine == BsRoutine.adjustSalePrice) Margins(widget: widget),
    ];

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          scrollController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
    );
  }
}
