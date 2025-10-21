import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/components.dart';
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
      bottomNavigationBar: BottomNavBar(
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}
