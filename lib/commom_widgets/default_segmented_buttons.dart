import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    final selectedItem = items.cast<T>().firstWhere(
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

          thumbColor: selectedItem.color ?? context.theme.primaryColor,

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
                  child: DefaultText(
                    item.name,
                    overflow: TextOverflow.ellipsis,
                    color: selectedValue == item.value
                        ? Colors.white
                        : CupertinoColors.black,
                  ),
                ),
              ),
          },
        );
      },
    );
  }
}
