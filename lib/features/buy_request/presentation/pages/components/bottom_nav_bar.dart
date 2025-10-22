import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../commom_widgets/commom_widgets.dart';
import '../../controllers/controllers.dart';

class BottomNavBar extends ConsumerWidget {
  final void Function(int)? onTap;
  final int currentIndex;
  const BottomNavBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingBuyRequestStateControllerProvider);
    final theme = Theme.of(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          label: 'Identificação'.hardcoded,
          icon: ValidatedBadge(
            isValid:
                pendingAsync.value?.selectedBuyer != null &&
                pendingAsync.value?.selectedRequestType != null &&
                pendingAsync.value?.selectedSupplier != null,
            materialIcon: Icons.info,
            cupertinoIcon: CupertinoIcons.info,
            iconColor: currentIndex == 0 ? theme.primaryColor : null,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Empresas'.hardcoded,
          icon: ValidatedBadge(
            isValid:
                pendingAsync.value?.selectedEnterprises?.isNotEmpty ==
                true, //TODO change
            materialIcon: Icons.business,
            cupertinoIcon: CupertinoIcons.building_2_fill,
            iconColor: currentIndex == 1 ? theme.primaryColor : null,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Produtos'.hardcoded,
          icon: ValidatedBadge(
            isValid: true, //TODO change
            materialIcon: Icons.shopping_cart,
            cupertinoIcon: CupertinoIcons.shopping_cart,
            iconColor: currentIndex == 2 ? theme.primaryColor : null,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Confirmação'.hardcoded,
          icon: ValidatedBadge(
            isValid: true, //TODO change
            materialIcon: Icons.check_box_outlined,
            cupertinoIcon: CupertinoIcons.checkmark_square,
            iconColor: currentIndex == 3 ? theme.primaryColor : null,
          ),
        ),
      ],
    );
  }
}
