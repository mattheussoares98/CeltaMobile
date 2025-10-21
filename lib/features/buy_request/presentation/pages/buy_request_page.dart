import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../commom_widgets/commom_widgets.dart';
import 'pages.dart';

class BuyRequestPage extends ConsumerStatefulWidget {
  const BuyRequestPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BuyRequestPageState();
}

class _BuyRequestPageState extends ConsumerState<BuyRequestPage> {
  final supplierController = TextEditingController();
  int currentIndex = 0;

  @override
  void dispose() {
    super.dispose();
    supplierController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      IdentificationPage(supplierController: supplierController),
      EnterprisesPage(),
      ProductsPage(),
      ConfirmationPage(),
    ];
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(
            label: 'Identificação'.hardcoded,
            icon: ValidatedBadge(
              isValid: true, //TODO change
              materialIcon: Icons.info,
              cupertinoIcon: CupertinoIcons.info,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Empresas'.hardcoded,
            icon: ValidatedBadge(
              isValid: true, //TODO change
              materialIcon: Icons.business,
              cupertinoIcon: CupertinoIcons.building_2_fill,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Produtos'.hardcoded,
            icon: ValidatedBadge(
              isValid: true, //TODO change
              materialIcon: Icons.shopping_cart,
              cupertinoIcon: CupertinoIcons.shopping_cart,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Confirmação'.hardcoded,
            icon: ValidatedBadge(
              isValid: true, //TODO change
              materialIcon: Icons.check_box_outlined,
              cupertinoIcon: CupertinoIcons.checkmark_square,
            ),
          ),
        ],
      ),
    );
  }
}
