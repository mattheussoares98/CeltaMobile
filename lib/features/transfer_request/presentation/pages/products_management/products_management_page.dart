import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import 'products_management.dart';

class ProductsManagementPage extends ConsumerStatefulWidget {
  final int enterpriseOriginCode;
  final int enterpriseDestinyCode;
  final int requestTypeCode;
  const ProductsManagementPage({
    super.key,
    required this.enterpriseOriginCode,
    required this.enterpriseDestinyCode,
    required this.requestTypeCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductsManagementPageState();
}

class _ProductsManagementPageState
    extends ConsumerState<ProductsManagementPage> {
  int currentIndex = 0;
  final searchValueController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final searchValueFocusNode = FocusNode();
  final priceFocusNode = FocusNode();
  final quantityFocusNode = FocusNode();

  @override
  void dispose() {
    searchValueController.dispose();
    quantityController.dispose();
    priceController.dispose();
    searchValueFocusNode.dispose();
    priceFocusNode.dispose();
    quantityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      InsertProductsPage(
        enterpriseOriginCode: widget.enterpriseOriginCode,
        enterpriseDestinyCode: widget.enterpriseDestinyCode,
        requestTypeCode: widget.requestTypeCode,
        searchValueController: searchValueController,
        searchValueFocusNode: searchValueFocusNode,
        quantityController: quantityController,
        quantityFocusNode: quantityFocusNode,
        priceFocusNode: priceFocusNode,
        priceController: priceController,
      ),
      CartPage(),
    ];
    final appBarTitles = ['Inserir produtos'.hardcoded, 'Carrinho'.hardcoded];

    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Scaffold(
      appBar: AppBar(title: Text(appBarTitles[currentIndex])),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(
            label: 'Inserir'.hardcoded,
            icon: Icon(
              isIOS
                  ? CupertinoIcons.cart_badge_plus
                  : Icons.add_shopping_cart_outlined,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Carrinho'.hardcoded,
            icon: QuantityBadge(
              quantity: 0,
              materialIcon: Icons.shopping_cart,
              cupertinoIcon: CupertinoIcons.shopping_cart,
              isSelected: currentIndex == 1,
            ),
          ),
        ],
      ),
    );
  }
}
