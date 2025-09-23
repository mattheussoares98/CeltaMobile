import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../core/domain/entities/entities.dart';

class DefaultSegmentedButtons<T extends SelectableItem<T>>
    extends StatelessWidget {
  const DefaultSegmentedButtons({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  final List<T> items;
  final T? selectedValue;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final selectedItem = items.firstWhere(
      (item) => item.value == selectedValue,

      orElse: () => items.first,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return CupertinoSlidingSegmentedControl<T>(
          groupValue: selectedValue,
          onValueChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },

          thumbColor: selectedItem.color ?? theme.primaryColor,

          children: {
            for (var item in items)
              item.value: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      (constraints.maxWidth / items.length / item.name.length) >
                          20
                      ? Sizes.p20
                      : Sizes.p4,
                  vertical: Sizes.p8,
                ),
                child: FittedBox(
                  child: Text(
                    item.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selectedValue == item.value
                          ? Colors.white
                          : CupertinoColors.black,
                    ),
                  ),
                ),
              ),
          },
        );
      },
    );
  }
}
