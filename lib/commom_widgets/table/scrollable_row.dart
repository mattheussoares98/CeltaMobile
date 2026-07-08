part of 'scrollable_table.dart';

class _ScrollableRow<T> extends StatelessWidget {
  final T item;
  final List<ScrollableTableColumnSpec<T>> columns;
  final double rowHeight;
  final Color? rowBackgroundColor;
  final double extraPerColumn;

  const _ScrollableRow({
    required this.item,
    required this.columns,
    required this.rowHeight,
    required this.rowBackgroundColor,
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
              backgroundColor: rowBackgroundColor,
              child: col.cellBuilder(item),
            ),
        ],
      ),
    );
  }
}
