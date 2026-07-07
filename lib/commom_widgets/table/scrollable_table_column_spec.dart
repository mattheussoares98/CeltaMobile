part of 'scrollable_table.dart';

class ScrollableTableColumnSpec<T> {
  final String headerTitle;
  final double minWidth;
  final Widget Function(T item) cellBuilder;
  final Comparable Function(T item)? sortValueMapper;

  const ScrollableTableColumnSpec({
    required this.headerTitle,
    required this.minWidth,
    required this.cellBuilder,
    this.sortValueMapper,
  });
}
