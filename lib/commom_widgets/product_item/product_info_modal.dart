import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/domain/entities/entities.dart';
import 'product_item.dart';

class ProductInfoModal extends StatefulWidget {
  final ProductEntity product;
  final int enterpriseCode;
  const ProductInfoModal({
    super.key,
    required this.product,
    required this.enterpriseCode,
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
      Costs(widget: widget),
      Margins(widget: widget),
    ];

    final theme = Theme.of(context);
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
              theme.platform == TargetPlatform.iOS
                  ? CupertinoIcons.money_dollar
                  : Icons.attach_money,
            ),
            label: 'Preços'.hardcoded,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              theme.platform == TargetPlatform.iOS
                  ? CupertinoIcons.creditcard
                  : Icons.credit_card,
            ),
            label: 'Custos'.hardcoded,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              theme.platform == TargetPlatform.iOS
                  ? CupertinoIcons.chart_bar
                  : Icons.bar_chart_rounded,
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
