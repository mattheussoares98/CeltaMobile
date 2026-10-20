import 'package:flutter/material.dart';

import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';

class DrawerItem extends StatelessWidget {
  final String message;
  final PlatformIcon platformIcon;
  final VoidCallback? onTap;
  const DrawerItem({
    super.key,
    required this.message,
    required this.platformIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Row(
          children: [
            Expanded(child: Text(message)),
            platformIcon,
          ],
        ),
      ),
    );
  }
}
