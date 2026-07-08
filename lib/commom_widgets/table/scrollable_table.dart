import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'fixed_layout.dart';
part 'scrollable_header_cell_wrapper.dart';
part 'scrollable_layout.dart';
part 'scrollable_row.dart';
part 'scrollable_table_cell.dart';
part 'scrollable_table_column_spec.dart';
part 'scrollable_table_header.dart';

//TODO add a parameter "onRefresh" and understand better how this entire widget works

class ScrollableTable<T> extends StatefulWidget {
  final List<T> items;
  final List<ScrollableTableColumnSpec<T>> columns;
  final bool fixFirstColumn;
  final double headerHeight;
  final double rowHeight;
  final Color? headerBackgroundColor;
  final Color? rowBackgroundColor;
  final Color? footerBackgroundColor;

  const ScrollableTable({
    super.key,
    required this.items,
    required this.columns,
    this.fixFirstColumn = false,
    this.headerHeight = 48.0,
    this.rowHeight = 48.0,
    this.headerBackgroundColor,
    this.rowBackgroundColor,
    this.footerBackgroundColor,
  });

  @override
  State<ScrollableTable<T>> createState() => _ScrollableTableState<T>();
}

class _ScrollableTableState<T> extends State<ScrollableTable<T>> {
  final _fixedVerticalController = ScrollController();
  final _scrollableVerticalController = ScrollController();

  bool _isSyncing = false;

  int? _sortColumnIndex;
  bool _sortAscending = true;

  late List<T> _sortedItems;

  late List<ScrollableTableColumnSpec<T>> _scrollableColumns;

  bool get _hasFooter =>
      widget.columns.any((col) => col.footerCellBuilder != null);

  static const double footerH = 40;

  @override
  void initState() {
    super.initState();

    _fixedVerticalController.addListener(_syncFixedToScrollable);
    _scrollableVerticalController.addListener(_syncScrollableToFixed);

    _rebuildCache();
  }

  @override
  void didUpdateWidget(covariant ScrollableTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final itemsChanged = !identical(widget.items, oldWidget.items);
    final columnsChanged = !identical(widget.columns, oldWidget.columns);

    if (itemsChanged || columnsChanged) {
      _rebuildCache();
    }
  }

  void _rebuildCache() {
    _scrollableColumns = widget.fixFirstColumn && widget.columns.isNotEmpty
        ? widget.columns.sublist(1)
        : widget.columns;

    _applySort();
  }

  void _applySort() {
    final items = List<T>.of(widget.items);

    if (_sortColumnIndex != null) {
      final mapper = widget.columns[_sortColumnIndex!].sortValueMapper;
      if (mapper != null) {
        items.sort((a, b) {
          final cmp = Comparable.compare(mapper(a), mapper(b));
          return _sortAscending ? cmp : -cmp;
        });
      }
    }

    _sortedItems = items;
  }

  void _syncFixedToScrollable() {
    if (_isSyncing) return;
    if (!_scrollableVerticalController.hasClients) return;

    final offset = _fixedVerticalController.offset;
    if (_scrollableVerticalController.offset == offset) return;

    _isSyncing = true;
    _scrollableVerticalController.jumpTo(offset);
    _isSyncing = false;
  }

  void _syncScrollableToFixed() {
    if (_isSyncing) return;
    if (!_fixedVerticalController.hasClients) return;

    final offset = _scrollableVerticalController.offset;
    if (_fixedVerticalController.offset == offset) return;

    _isSyncing = true;
    _fixedVerticalController.jumpTo(offset);
    _isSyncing = false;
  }

  @override
  void dispose() {
    _fixedVerticalController.removeListener(_syncFixedToScrollable);
    _scrollableVerticalController.removeListener(_syncScrollableToFixed);
    _fixedVerticalController.dispose();
    _scrollableVerticalController.dispose();
    super.dispose();
  }

  void _handleHeaderTap(int columnIndex) {
    if (widget.columns[columnIndex].sortValueMapper == null) return;

    setState(() {
      if (_sortColumnIndex == columnIndex) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumnIndex = columnIndex;
        _sortAscending = true;
      }
      _applySort();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.columns.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalMinWidth = widget.columns.fold(
          0.0,
          (sum, col) => sum + col.minWidth,
        );
        final double available = constraints.maxWidth;
        final double extraPerColumn = available > totalMinWidth
            ? (available - totalMinWidth) / widget.columns.length
            : 0.0;

        final double firstColWidth = widget.columns.isNotEmpty
            ? widget.columns.first.minWidth + extraPerColumn
            : 0.0;

        final bool shouldFix =
            widget.fixFirstColumn && firstColWidth < available;

        if (shouldFix) {
          return _FixedLayout<T>(
            columns: widget.columns,
            scrollableColumns: _scrollableColumns,
            sortedItems: _sortedItems,
            extraPerColumn: extraPerColumn,
            headerHeight: widget.headerHeight,
            rowHeight: widget.rowHeight,
            footerHeight: footerH,
            headerBackgroundColor: widget.headerBackgroundColor,
            rowBackgroundColor: widget.rowBackgroundColor,
            footerBackgroundColor: widget.footerBackgroundColor,
            fixedVerticalController: _fixedVerticalController,
            scrollableVerticalController: _scrollableVerticalController,
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            onHeaderTap: _handleHeaderTap,
            hasFooter: _hasFooter,
          );
        }

        return _ScrollableLayout<T>(
          columns: widget.columns,
          sortedItems: _sortedItems,
          totalMinWidth: totalMinWidth,
          extraPerColumn: extraPerColumn,
          headerHeight: widget.headerHeight,
          rowHeight: widget.rowHeight,
          footerHeight: footerH,
          headerBackgroundColor: widget.headerBackgroundColor,
          rowBackgroundColor: widget.rowBackgroundColor,
          footerBackgroundColor: widget.footerBackgroundColor,
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          onHeaderTap: _handleHeaderTap,
          hasFooter: _hasFooter,
        );
      },
    );
  }
}
