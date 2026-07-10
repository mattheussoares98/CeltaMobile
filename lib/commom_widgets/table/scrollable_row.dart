part of 'scrollable_table.dart';

class _ScrollableRow<T> extends StatelessWidget {
  final T item;
  final List<ScrollableTableColumnSpec<T>> columns;
  final double rowHeight;
  final Color? backgroundColor;
  final double extraPerColumn;

  const _ScrollableRow({
    required this.item,
    required this.columns,
    required this.rowHeight,
    required this.backgroundColor,
    required this.extraPerColumn,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: rowHeight,
      child: Row(
        children: [
          for (final col in columns)
            _ScrollableTableCell(
              width: col.minWidth + extraPerColumn,
              height: rowHeight,
              spec: col,
              backgroundColor: backgroundColor,
              child: col.cellBuilder(item),
            ),
        ],
      ),
    );
  }
}
