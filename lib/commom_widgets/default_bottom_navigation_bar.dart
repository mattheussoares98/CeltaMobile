import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'commom_widgets.dart';

class DefaultBottomNavigationBarItem {
  const DefaultBottomNavigationBarItem({
    required this.platformIcon,
    this.label,
    this.tooltip,
  });

  final PlatformIcon platformIcon;
  final String? label;
  final String? tooltip;
}

class DefaultBottomNavigationBar extends StatelessWidget {
  const DefaultBottomNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<DefaultBottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).bottomNavigationBarTheme;

    // Premium separation border

    if (context.isCupertino) {
      return CupertinoTabBar(
        currentIndex: currentIndex,
        onTap: onTap,
        activeColor: theme.selectedItemColor,
        inactiveColor: theme.unselectedItemColor ?? const Color(0xFF64748B),
        backgroundColor: theme.backgroundColor,
        // border: border,
        items: items.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(
              item.platformIcon.cupertinoIcon,
              size: item.platformIcon.size ?? 22,
            ),
            label: item.label,
            tooltip: item.tooltip,
          );
        }).toList(),
      );
    }

    return Container(
      decoration: BoxDecoration(color: theme.backgroundColor),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: items.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(
              item.platformIcon.materialIcon,
              size: item.platformIcon.size,
            ),
            label: item.label ?? '',
            tooltip: item.tooltip,
          );
        }).toList(),
      ),
    );
  }
}
