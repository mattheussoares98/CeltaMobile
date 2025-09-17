import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';

abstract class SelectableItem {
  String get name;
}

class DefaultCupertinoCheckBox<T extends SelectableItem>
    extends StatelessWidget {
  final List<T> items;
  final T? selectedSaleType;
  final void Function(T) onTap;
  const DefaultCupertinoCheckBox({
    super.key,
    required this.items,
    required this.selectedSaleType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CupertinoListSection(
      dividerMargin: 0,
      margin: EdgeInsets.zero,
      topMargin: Sizes.p8,
      backgroundColor: Colors.transparent,
      additionalDividerMargin: 0,
      separatorColor: Colors.transparent,
      header: null,
      children: items.map((item) {
        final isSelected = selectedSaleType == item;

        return CupertinoListTile(
          title: Text(item.name, style: theme.textTheme.bodyMedium),
          onTap: () => onTap(item),
          backgroundColor: isSelected
              ? theme.primaryColorLight.withAlpha(100)
              : null,
          trailing: isSelected
              ? const Icon(
                  CupertinoIcons.check_mark,
                  color: CupertinoColors.activeGreen,
                )
              : null,
        );
      }).toList(),
    );
  }
}
