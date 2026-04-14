import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

class InsertUpdateBottomNavigationBar extends ConsumerWidget {
  const InsertUpdateBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(pageIndexStateControllerProvider);
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return BottomNavigationBar(
      currentIndex: pageIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => ref
          .read(pageIndexStateControllerProvider.notifier)
          .updateIndex(index),
      items: [
        BottomNavigationBarItem(
          icon: Icon(isIOS ? CupertinoIcons.search : Icons.search),
          label: 'Produtos'.hardcoded,
        ),
        BottomNavigationBarItem(
          icon: Icon(isIOS ? CupertinoIcons.list_bullet : Icons.list),
          label: 'Itens'.hardcoded,
        ),
        BottomNavigationBarItem(
          icon: Icon(isIOS ? CupertinoIcons.creditcard : Icons.payment),
          label: 'Pagamento'.hardcoded,
        ),
        BottomNavigationBarItem(
          icon: Icon(isIOS ? CupertinoIcons.info : Icons.info),
          label: 'Resumo'.hardcoded,
        ),
      ],
    );
  }
}
