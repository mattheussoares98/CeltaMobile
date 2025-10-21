import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../commom_widgets/commom_widgets.dart';

class BottomNavBar extends StatelessWidget {
  final void Function(int)? onTap;
  const BottomNavBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: onTap,
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
    );
  }
}
