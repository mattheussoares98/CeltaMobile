import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../localization/string_hardcoded.dart';
import '../commom_widgets.dart';

class SelectedIconIndicator extends StatelessWidget {
  final bool selected;
  final VoidCallback? onTap;
  const SelectedIconIndicator({
    super.key,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;

    final notSelectedIcon = PlatformIcon(
      cupertinoIcon: CupertinoIcons.arrow_down,
      materialIcon: Icons.arrow_drop_down,
      color: theme.colorScheme.primary,
    );

    final selectedIcon = PlatformIcon(
      cupertinoIcon: CupertinoIcons.arrow_up,
      materialIcon: Icons.arrow_drop_up,
      color: theme.colorScheme.primary,
    );

    if (isIOS) {
      return PrimaryTextButton(
        text: 'Editar'.hardcoded,
        icon: selected ? selectedIcon : notSelectedIcon,
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          onTap?.call();
        },
      );
    } else {
      return selected ? selectedIcon : notSelectedIcon;
    }
  }
}
