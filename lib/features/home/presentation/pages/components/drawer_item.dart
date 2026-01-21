import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

import '../../../../../constants/constants.dart';

class DrawerItem extends StatelessWidget {
  final String message;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final VoidCallback? onTap;
  const DrawerItem({
    super.key,
    required this.message,
    required this.materialIcon,
    required this.cupertinoIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: Row(
          children: [
            Expanded(child: Text(message.hardcoded)),
            Icon(
              theme.platform == TargetPlatform.iOS
                  ? cupertinoIcon
                  : materialIcon,
            ),
          ],
        ),
      ),
    );
  }
}
