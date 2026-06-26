import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../commom_widgets.dart';

class DefaultBottomNavigationBarItem {
  const DefaultBottomNavigationBarItem({
    required this.platformIcon,
    this.label,
    this.tooltip,
    this.isValid,
    this.badgeLabel,
  });

  final PlatformIcon platformIcon;
  final String? label;
  final String? tooltip;
  final bool? isValid;
  final String? badgeLabel;
}

class DefaultBottomNavigationBar extends StatelessWidget {
  const DefaultBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.border = const Border(top: BorderSide(color: Colors.transparent)),
  });

  final List<DefaultBottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).bottomNavigationBarTheme;
    final isCupertino = context.isCupertino;

    List<BottomNavigationBarItem> localItems = items.map((e) {
      final isSelected = items.indexOf(e) == currentIndex;

      Widget icon = e.platformIcon.copyWith(size: isSelected ? 26.0 : 22.0);

      if (e.isValid != null) {
        icon = ValidatedBadge(
          isValid: e.isValid == true,
          platformIcon: icon as PlatformIcon,
          isSelected: isSelected,
        );
      }

      if (e.badgeLabel != null) {
        icon = Badge(
          label: DefaultText(e.badgeLabel!),
          offset: const Offset(8, -6),
          child: icon,
        );
      }

      if (isCupertino && e.label != null) {
        icon = Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTap(items.indexOf(e)),
            splashColor:
                theme.selectedItemColor?.withAlpha(30) ??
                Colors.green.withAlpha(30),
            highlightColor:
                theme.selectedItemColor?.withAlpha(15) ??
                Colors.green.withAlpha(15),
            borderRadius: BorderRadius.circular(Sizes.p8),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.p4,
                horizontal: Sizes.p8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: icon),
                  const SizedBox(height: Sizes.p4),
                  if (isSelected)
                    FittedBox(
                      child: DefaultText.title(
                        e.label!,
                        color: theme.selectedItemColor,
                      ),
                    )
                  else
                    DefaultText.bodySmall(
                      e.label!,
                      color:
                          theme.unselectedItemColor ?? const Color(0xFF64748B),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ),
        );
      }

      return BottomNavigationBarItem(
        icon: icon,
        label: isCupertino ? null : (e.label ?? ''),
        tooltip: e.tooltip,
      );
    }).toList();

    // Premium separation border

    if (isCupertino) {
      return CupertinoTabBar(
        currentIndex: currentIndex,
        onTap: onTap,
        activeColor: theme.selectedItemColor,
        inactiveColor: theme.unselectedItemColor ?? const Color(0xFF64748B),
        backgroundColor: theme.backgroundColor,
        border: border,
        items: localItems,
        height: 54.0,
      );
    }

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: Colors.transparent,
      elevation: 0,
      items: localItems,
    );
  }
}
