part of 'scrollable_table.dart';

class _FixedLayout<T> extends StatelessWidget {
  final List<ScrollableTableColumnSpec<T>> columns;
  final List<ScrollableTableColumnSpec<T>> scrollableColumns;
  final List<T> sortedItems;
  final double extraPerColumn;
  final double headerHeight;
  final double rowHeight;
  final double footerHeight;
  final Color? headerBackgroundColor;
  final Color? rowBackgroundColor;
  final Color? footerBackgroundColor;
  final ScrollController fixedVerticalController;
  final ScrollController scrollableVerticalController;
  final int? sortColumnIndex;
  final bool sortAscending;
  final void Function(int) onHeaderTap;
  final bool hasFooter;
  final ScrollPhysics? physics;

  const _FixedLayout({
    required this.columns,
    required this.scrollableColumns,
    required this.sortedItems,
    required this.extraPerColumn,
    required this.headerHeight,
    required this.rowHeight,
    required this.footerHeight,
    required this.headerBackgroundColor,
    required this.rowBackgroundColor,
    required this.footerBackgroundColor,
    required this.fixedVerticalController,
    required this.scrollableVerticalController,
    required this.sortColumnIndex,
    required this.sortAscending,
    required this.onHeaderTap,
    required this.hasFooter,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final firstCol = columns.first;
    final double firstColWidth = firstCol.minWidth + extraPerColumn;
    final Color headerBg = headerBackgroundColor ?? context.theme.cardColor;
    final double scrollableWidth = scrollableColumns.fold(
      0.0,
      (sum, col) => sum + col.minWidth + extraPerColumn,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fixed column
        SizedBox(
          width: firstColWidth,
          child: Column(
            children: [
              _ScrollableTableCell(
                width: firstColWidth,
                height: headerHeight,
                spec: firstCol,
                backgroundColor: headerBg,
                child: _ScrollableTableHeaderCell<T>(
                  spec: firstCol,
                  isSorted: sortColumnIndex == 0,
                  sortAscending: sortAscending,
                  onTap: () => onHeaderTap(0),
                ),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: ListView.builder(
                    controller: fixedVerticalController,
                    physics: physics,
                    itemCount: sortedItems.length,
                    itemExtent: rowHeight,
                    itemBuilder: (_, index) => _ScrollableTableCell(
                      width: firstColWidth,
                      height: rowHeight,
                      spec: firstCol,
                      backgroundColor: rowBackgroundColor,
                      child: firstCol.cellBuilder(sortedItems[index]),
                    ),
                  ),
                ),
              ),
              if (hasFooter)
                _ScrollableTableCell(
                  showTopBorder: true,
                  width: firstColWidth,
                  height: footerHeight,
                  spec: firstCol,
                  backgroundColor: footerBackgroundColor ?? headerBg,
                  child:
                      firstCol.footerCellBuilder?.call(sortedItems) ??
                      const SizedBox.shrink(),
                ),
            ],
          ),
        ),
        // Scrollable columns
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: scrollableWidth,
              child: Column(
                children: [
                  SizedBox(
                    height: headerHeight,
                    child: Row(
                      children: [
                        for (int i = 0; i < scrollableColumns.length; i++)
                          _ScrollableHeaderCellWrapper<T>(
                            col: scrollableColumns[i],
                            colIndex: i + 1,
                            colWidth:
                                scrollableColumns[i].minWidth + extraPerColumn,
                            headerHeight: headerHeight,
                            headerBg: headerBg,
                            isSorted: sortColumnIndex == i + 1,
                            sortAscending: sortAscending,
                            onTap: () => onHeaderTap(i + 1),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollableVerticalController,
                      physics: physics,
                      itemCount: sortedItems.length,
                      itemExtent: rowHeight,
                      itemBuilder: (_, index) => _ScrollableRow<T>(
                        item: sortedItems[index],
                        columns: scrollableColumns,
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
                          for (int i = 0; i < scrollableColumns.length; i++)
                            _ScrollableTableCell(
                              width:
                                  scrollableColumns[i].minWidth +
                                  extraPerColumn,
                              height: footerHeight,
                              spec: scrollableColumns[i],
                              backgroundColor:
                                  footerBackgroundColor ?? headerBg,
                              showTopBorder: true,
                              child:
                                  scrollableColumns[i].footerCellBuilder?.call(
                                    sortedItems,
                                  ) ??
                                  const SizedBox.shrink(),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
