import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectedIconIndicator extends StatelessWidget {
  final bool selected;
  const SelectedIconIndicator({super.key, required this.selected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final notSelectedIcon = Icon(
      theme.platform == TargetPlatform.iOS
          ? CupertinoIcons.drop
          : Icons.arrow_drop_down,
      color: theme.colorScheme.primary,
    );

    final selectedIcon = Icon(
      theme.platform == TargetPlatform.iOS
          ? CupertinoIcons.arrow_up
          : Icons.arrow_drop_up,
      color: theme.colorScheme.primary,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [selected ? selectedIcon : notSelectedIcon],
    );
  }
}
