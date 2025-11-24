import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../localization/string_hardcoded.dart';
import '../../../domain/entities/entities.dart';
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
  ResearchEntity? selectedResearch;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        selectedResearch = await ref.read(
          researchsStateControllerProvider.select(
            (s) => s.value?.firstWhere((e) => e.Code == widget.researchCode),
          ),
        );
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const AssociatedsPage(),
      if (selectedResearch?.RestrictProducts == true)
        const NotAssociatedsPage(),
    ];
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

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
              style: theme.textTheme.bodySmall?.copyWith(
                color: selectedResearch?.RestrictProducts == true
                    ? theme.primaryColor
                    : Colors.red,
              ),
            ),
          ],
        ),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: selectedResearch?.RestrictProducts == true
          ? null
          : BottomNavigationBar(
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
