import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../commom_widgets/commom_widgets.dart';

import '../../../../../../localization/string_hardcoded.dart';
import '../../../controllers/controllers.dart';

class InsertUpdateBottomNavigationBar extends ConsumerWidget {
  const InsertUpdateBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(pageIndexStateControllerProvider);

    return BottomNavigationBar(
      currentIndex: pageIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => ref
          .read(pageIndexStateControllerProvider.notifier)
          .updateIndex(index),
      items: [
        BottomNavigationBarItem(
          icon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.search,
            materialIcon: Icons.search,
          ),
          label: 'Produtos'.hardcoded,
        ),
        BottomNavigationBarItem(
          icon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.list_bullet,
            materialIcon: Icons.list,
          ),
          label: 'Itens'.hardcoded,
        ),
        BottomNavigationBarItem(
          icon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.creditcard,
            materialIcon: Icons.payment,
          ),
          label: 'Pagamento'.hardcoded,
        ),
        BottomNavigationBarItem(
          icon: const PlatformIcon(
            cupertinoIcon: CupertinoIcons.info,
            materialIcon: Icons.info,
          ),
          label: 'Resumo'.hardcoded,
        ),
      ],
    );
  }
}
