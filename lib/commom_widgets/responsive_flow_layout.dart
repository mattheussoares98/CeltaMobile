import 'package:flutter/material.dart';

import '../constants/constants.dart';

//TODO delete this file and use ResponsiveListFlow
class ResponsiveFlowLayout extends StatelessWidget {
  final List<Widget> items;
  final double spacing;
  final double runSpacing;
  final double? maxItemWidth;
  const ResponsiveFlowLayout({
    super.key,
    required this.items,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.maxItemWidth = Breakpoint.tablet,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (items.isEmpty) {
          return SizedBox.shrink();
        }

        return Center(
          child: Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            children: items.map((item) {
              return SizedBox(width: maxItemWidth, child: item);
            }).toList(),
          ),
        );
      },
    );
  }
}
