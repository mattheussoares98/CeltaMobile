import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../core/domain/entities/entities.dart';
import 'commom_widgets.dart';

/// PERFORMANCE: This widget chooses between a Segmented Control and a Wrap
/// layout based on available width to prevent text overflow and unreadable labels.
class DefaultChoiceChip<T extends SelectableItem<T>> extends StatelessWidget {
  const DefaultChoiceChip({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.minItemWidth = 100.0,
  });

  final List<T> items;
  final T? selectedValue;
  final ValueChanged<T> onChanged;
  final double minItemWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        final double widthPerItem = availableWidth / items.length;

        // If the calculated width per item is smaller than our threshold,
        // we switch to a Wrap layout to maintain legibility.
        if (widthPerItem < minItemWidth) {
          return RepaintBoundary(
            child: Wrap(
              key: const ValueKey('wrap'),
              spacing: Sizes.p8,
              runSpacing: Sizes.p8,
              alignment: WrapAlignment.center,
              children: items.map((item) {
                final isSelected = item.value == selectedValue;
                return ChoiceChip(
                  label: Text(item.name),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) onChanged(item.value);
                  },
                  selectedColor: item.color ?? theme.primaryColor,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : theme.textTheme.bodyMedium?.color,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),
          );
        }

        return DefaultSegmentedButtons(
          items: items,
          selectedValue: selectedValue,
          onChanged: onChanged,
        );
      },
    );
  }
}
