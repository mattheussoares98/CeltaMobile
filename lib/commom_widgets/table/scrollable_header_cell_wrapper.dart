part of 'scrollable_table.dart';

class _ScrollableHeaderCellWrapper<T> extends StatelessWidget {
  final ScrollableTableColumnSpec<T> col;
  final int colIndex;
  final double colWidth;
  final double headerHeight;
  final Color headerBg;
  final bool isSorted;
  final bool sortAscending;
  final VoidCallback onTap;

  const _ScrollableHeaderCellWrapper({
    required this.col,
    required this.colIndex,
    required this.colWidth,
    required this.headerHeight,
    required this.headerBg,
    required this.isSorted,
    required this.sortAscending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _ScrollableTableCell(
      width: colWidth,
      height: headerHeight,
      spec: col,
      backgroundColor: headerBg,
      showBottomBorder: true,
      child: _ScrollableTableHeaderCell<T>(
        spec: col,
        isSorted: isSorted,
        sortAscending: sortAscending,
        onTap: onTap,
      ),
    );
  }
}
