import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/entities/entities.dart';
import 'pages.dart';

class TransferBetweenStocksPage extends StatefulWidget {
  final int enterpriseCode;
  final EnterpriseEntity? selectedEnterprise;

  const TransferBetweenStocksPage({
    super.key,
    required this.enterpriseCode,
    required this.selectedEnterprise,
  });

  @override
  State<TransferBetweenStocksPage> createState() =>
      _TransferBetweenStocksPageState();
}

class _TransferBetweenStocksPageState extends State<TransferBetweenStocksPage> {
  int currentIndex = 0;
  final pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIos = theme.platform == TargetPlatform.iOS;

    final pages = [
      ProductsPage(
        enterpriseCode: widget.enterpriseCode,
        selectedEnterprise: widget.selectedEnterprise,
      ),
      LotPage(),
    ];

    return Scaffold(
      body: PageView(
        controller: pageController,
        children: pages,
        onPageChanged: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 200),
            curve: Curves.linear,
          );
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(isIos ? CupertinoIcons.list_bullet : Icons.list),
            label: 'Produtos'.hardcoded,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              isIos ? CupertinoIcons.shopping_cart : Icons.shopping_cart,
            ),
            label: 'Lote'.hardcoded,
          ),
        ],
      ),
    );
  }
}
