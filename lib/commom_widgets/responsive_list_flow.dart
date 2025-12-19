import 'package:flutter/material.dart';

import '../constants/constants.dart';

class ResponsiveListFlow extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double? maxItemWidth;
  final bool isSliver;
  const ResponsiveListFlow({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.maxItemWidth = Breakpoint.tablet,
    this.isSliver = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (isSliver) {
      return SliverList.builder(
        itemCount: itemCount,
        itemBuilder: (context, rowIndex) {
          return _RowsItems(
            itemCount: itemCount,
            itemBuilder: itemBuilder,
            itemsPerRow: (width / maxItemWidth!).floor(),
            rowIndex: rowIndex,
          );
        },
      );
    }

    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, rowIndex) {
        return _RowsItems(
          itemCount: itemCount,
          itemBuilder: itemBuilder,
          itemsPerRow: (width / maxItemWidth!).floor(),
          rowIndex: rowIndex,
        );
      },
    );
  }
}

class _RowsItems extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int itemsPerRow;
  final int rowIndex;
  const _RowsItems({
    required this.itemCount,
    required this.itemBuilder,
    required this.itemsPerRow,
    required this.rowIndex,
  });

  @override
  Widget build(BuildContext context) {
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
  }
}
