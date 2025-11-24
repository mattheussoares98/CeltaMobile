import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../localization/string_hardcoded.dart';
import '../../controllers/controllers.dart';
import 'associateds/associateds.dart';
import 'not_associateds/not_associateds.dart';

class ProductsPage extends ConsumerStatefulWidget {
  final int researchCode;
  final int concurrentCode;
  const ProductsPage({
    super.key,
    required this.researchCode,
    required this.concurrentCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [const AssociatedsPage(), const NotAssociatedsPage()];
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final selectedResearch = ref.watch(
      researchsStateControllerProvider.select(
        (s) => s.value?.firstWhere((e) => e.Code == widget.researchCode),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              child: Text(
                'Pesquisa ${widget.researchCode} - concorrente ${widget.concurrentCode}',
              ),
            ),
            Text(
              selectedResearch?.RestrictProducts == true
                  ? 'Produtos restringidos'
                  : 'Produtos não restringidos',
              style: theme.textTheme.bodySmall,
            ),
          ],
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
