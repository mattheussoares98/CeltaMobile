import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:celta_inventario/utils/utils.dart';

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
          title: Text(item.name, style: context.theme.textTheme.bodyMedium),
          onTap: () => onTap(item),
          backgroundColor: isSelected
              ? context.theme.primaryColorLight.withAlpha(100)
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
