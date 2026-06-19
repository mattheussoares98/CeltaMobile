import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectedIconIndicator extends StatelessWidget {
  final bool selected;
  final VoidCallback? onTap;
  final PlatformIcon? editIcon;
  const SelectedIconIndicator({
    super.key,
    required this.selected,
    required this.onTap,
    this.editIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isIOS = PlatformUtil.isCupertino;

    final notSelectedIcon =
        editIcon ??
        PlatformIcon(
          cupertinoIcon: CupertinoIcons.arrow_down,
          materialIcon: Icons.arrow_drop_down,
          color: context.theme.colorScheme.primary,
        );

    final selectedIcon =
        editIcon ??
        PlatformIcon(
          cupertinoIcon: CupertinoIcons.arrow_up,
          materialIcon: Icons.arrow_drop_up,
          color: context.theme.colorScheme.primary,
        );

    if (isIOS) {
      return FittedBox(
        child: PrimaryTextButton(
          text: 'Editar'.hardcoded,
          icon: selected ? selectedIcon : notSelectedIcon,
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            onTap?.call();
          },
        ),
      );
    } else {
      return selected ? selectedIcon : notSelectedIcon;
    }
  }
}
