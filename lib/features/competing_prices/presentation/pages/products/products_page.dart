import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../localization/string_hardcoded.dart';
import 'associateds/associateds.dart';
import 'not_associateds/not_associateds.dart';

class ProductsPage extends StatefulWidget {
  final int researchCode;
  final int concurrentCode;
  const ProductsPage({
    super.key,
    required this.researchCode,
    required this.concurrentCode,
  });

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [const AssociatedsPage(), const NotAssociatedsPage()];
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pesq ${widget.researchCode} - conc ${widget.concurrentCode}',
        ),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(
            label: 'Associados'.hardcoded,
            icon: Icon(isIOS ? CupertinoIcons.list_bullet : Icons.list),
          ),
          BottomNavigationBarItem(
            label: 'Não associados'.hardcoded,
            icon: Icon(isIOS ? CupertinoIcons.search : Icons.search),
          ),
        ],
      ),
    );
  }
}
