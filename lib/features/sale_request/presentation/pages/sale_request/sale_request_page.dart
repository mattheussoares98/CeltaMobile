import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import 'sale_request.dart';

class SaleRequestPage extends ConsumerStatefulWidget {
  final int enterpriseCode;
  const SaleRequestPage({super.key, required this.enterpriseCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SaleRequestPageState();
}

class _SaleRequestPageState extends ConsumerState<SaleRequestPage> {
  final searchProductsController = TextEditingController();
  int currentIndex = 0;
  final appBarTitles = [
    'Inserir produtos'.hardcoded,
    'Cliente'.hardcoded,
    'Carrinho'.hardcoded,
  ];

  @override
  void dispose() {
    super.dispose();
    searchProductsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final pages = [
      CartPage(),
      CustomerPage(),
      InsertProductsPage(
        enterpriseCode: widget.enterpriseCode,
        searchProductsController: searchProductsController,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text(appBarTitles[currentIndex])),
        actions: [
          QuantityBadge(
            quantity: null, //TODO fix
            materialIcon: Icons.shopping_cart,
            cupertinoIcon: CupertinoIcons.shopping_cart,
            isSelected: false,
            offset: const Offset(3, -3),
            subtitle: Text('R\$ 0,00'.hardcoded), //TODO fix
          ),
        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(
            label: 'Inserir produtos'.hardcoded,
            icon: Icon(
              isIOS ? CupertinoIcons.cart_fill : Icons.add_shopping_cart,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Cliente'.hardcoded,
            icon: Icon(isIOS ? CupertinoIcons.person : Icons.person),
          ),
          BottomNavigationBarItem(
            label: 'Carrinho'.hardcoded,
            icon: QuantityBadge(
              quantity: null, //TODO fix
              materialIcon: Icons.shopping_cart,
              cupertinoIcon: CupertinoIcons.shopping_cart,
              isSelected: currentIndex == 2,
            ),
          ),
        ],
      ),
    );
  }
}
