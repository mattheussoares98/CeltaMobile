import 'package:flutter/material.dart';

import '../constants/constants.dart';

class ResponsiveFlowLayout extends StatelessWidget {
  final List<Widget> items;
  final double spacing;
  final double runSpacing;
  final double? minItemWidth;
  const ResponsiveFlowLayout({
    super.key,
    required this.items,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.minItemWidth = Breakpoint.tablet,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (items.isEmpty) {
          return SizedBox.shrink();
        }

        final double totalWidth = constraints.maxWidth;
        final int crossAxisCount =
            (totalWidth / 600).floor().clamp(1, items.length);
        final double totalSpacing = spacing * (crossAxisCount - 1);
        final double itemWidth = (totalWidth - totalSpacing) / crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: items.map((item) {
            return SizedBox(
              width: itemWidth,
              child: item,
            );
          }).toList(),
        );
      },
    );
  }
}
