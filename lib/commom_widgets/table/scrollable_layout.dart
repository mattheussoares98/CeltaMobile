part of 'scrollable_table.dart';

class _ScrollableLayout<T> extends StatelessWidget {
  final List<ScrollableTableColumnSpec<T>> columns;
  final List<T> sortedItems;
  final double totalMinWidth;
  final double extraPerColumn;
  final double headerHeight;
  final double rowHeight;
  final double footerHeight;
  final Color? headerBackgroundColor;
  final Color? rowBackgroundColor;
  final Color? footerBackgroundColor;
  final int? sortColumnIndex;
  final bool sortAscending;
  final void Function(int) onHeaderTap;
  final bool hasFooter;

  const _ScrollableLayout({
    required this.columns,
    required this.sortedItems,
    required this.totalMinWidth,
    required this.extraPerColumn,
    required this.headerHeight,
    required this.rowHeight,
    required this.footerHeight,
    required this.headerBackgroundColor,
    required this.rowBackgroundColor,
    required this.footerBackgroundColor,
    required this.sortColumnIndex,
    required this.sortAscending,
    required this.onHeaderTap,
    required this.hasFooter,
  });

  @override
  Widget build(BuildContext context) {
    final double totalWidth = totalMinWidth + (extraPerColumn * columns.length);
    final Color headerBg = headerBackgroundColor ?? context.theme.cardColor;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: totalWidth,
        child: Column(
          children: [
            SizedBox(
              height: headerHeight,
              child: Row(
                children: [
                  for (int i = 0; i < columns.length; i++)
                    _ScrollableHeaderCellWrapper<T>(
                      col: columns[i],
                      colIndex: i,
                      colWidth: columns[i].minWidth + extraPerColumn,
                      headerHeight: headerHeight,
                      headerBg: headerBg,
                      isSorted: sortColumnIndex == i,
                      sortAscending: sortAscending,
                      onTap: () => onHeaderTap(i),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sortedItems.length,
                itemExtent: rowHeight,
                itemBuilder: (_, index) => _ScrollableRow<T>(
                  item: sortedItems[index],
                  columns: columns,
                  rowHeight: rowHeight,
                  rowBackgroundColor: rowBackgroundColor,
                  extraPerColumn: extraPerColumn,
                ),
              ),
            ),
            if (hasFooter)
              SizedBox(
                height: footerHeight,
                child: Row(
                  children: [
                    for (int i = 0; i < columns.length; i++)
                      _ScrollableTableCell(
                        showTopBorder: true,
                        width: columns[i].minWidth + extraPerColumn,
                        height: footerHeight,
                        spec: columns[i],
                        backgroundColor: footerBackgroundColor ?? headerBg,
                        child:
                            columns[i].footerCellBuilder?.call(sortedItems) ??
                            const SizedBox.shrink(),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
