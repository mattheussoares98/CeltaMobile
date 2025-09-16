import 'dart:math';

import 'package:flutter/material.dart';

import '../constants/constants.dart';

class ResponsiveListFlow extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double? maxItemWidth;
  const ResponsiveListFlow({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.maxItemWidth = Breakpoint.tablet,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemsPerRow = max(
          (constraints.maxWidth / maxItemWidth!).floor(),
          1,
        );

        return ListView.builder(
          itemCount: max(itemCount, (itemCount / itemsPerRow).floor()),
          itemBuilder: (context, rowIndex) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(itemsPerRow, (colIndex) {
                final itemIndex = (rowIndex * itemsPerRow) + colIndex;

                if (itemIndex < itemCount) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: colIndex == 0 ? 0 : Sizes.p4,
                        right: colIndex == itemsPerRow - 1 ? 0 : Sizes.p4,
                        bottom: Sizes.p4,
                      ),
                      child: itemBuilder(context, itemIndex),
                    ),
                  );
                } else {
                  return const Expanded(child: SizedBox());
                }
              }),
            );
          },
        );
      },
    );
  }
}
