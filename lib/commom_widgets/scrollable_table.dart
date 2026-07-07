import 'package:celta_inventario/commom_widgets/commom_widgets.dart';
import 'package:celta_inventario/constants/constants.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
//TODO create separated files and add a parameter "onRefresh"
// --------------------------------------------------------------------------
// ScrollableTableCell
// --------------------------------------------------------------------------

class ScrollableTableCell extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final Color? backgroundColor;

  const ScrollableTableCell({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(color: context.theme.dividerColor, width: 0.5),
          right: BorderSide(color: context.theme.dividerColor, width: 0.07),
        ),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: child,
    );
  }
}

// --------------------------------------------------------------------------
// ScrollableTableHeaderCell
// --------------------------------------------------------------------------

/// Intentionally a private constant so it is never recreated.
const _kUnsortedIconColor = Color(0x78808080); // grey with alpha 120

class ScrollableTableHeaderCell<T> extends StatelessWidget {
  final ScrollableTableColumnSpec<T> spec;
  final bool isSorted;
  final bool sortAscending;
  final VoidCallback? onTap;

  const ScrollableTableHeaderCell({
    super.key,
    required this.spec,
    required this.isSorted,
    required this.sortAscending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final canSort = spec.sortValueMapper != null;

    return InkWell(
      onTap: canSort ? onTap : null,
      child: Stack(
        children: [
          Center(child: BaseText.title(spec.headerTitle)),
          if (canSort) ...[
            Positioned(
              bottom: Sizes.p4,
              right: 0,
              child: PlatformIcon(
                cupertinoIcon: isSorted
                    ? (sortAscending
                          ? CupertinoIcons.arrow_up
                          : CupertinoIcons.arrow_down)
                    : CupertinoIcons.arrow_up,
                materialIcon: isSorted
                    ? (sortAscending
                          ? Icons.arrow_upward
                          : Icons.arrow_downward)
                    : Icons.arrow_upward,
                color: isSorted
                    ? context.theme.primaryColor
                    : _kUnsortedIconColor,
                size: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// --------------------------------------------------------------------------
// ScrollableTable
// --------------------------------------------------------------------------

class ScrollableTable<T> extends StatefulWidget {
  final List<T> items;
  final List<ScrollableTableColumnSpec<T>> columns;
  final bool fixFirstColumn;
  final double headerHeight;
  final double rowHeight;
  final Color? headerBackgroundColor;
  final Color? rowBackgroundColor;

  const ScrollableTable({
    super.key,
    required this.items,
    required this.columns,
    this.fixFirstColumn = false,
    this.headerHeight = 48.0,
    this.rowHeight = 48.0,
    this.headerBackgroundColor,
    this.rowBackgroundColor,
  });

  @override
  State<ScrollableTable<T>> createState() => _ScrollableTableState<T>();
}

class _ScrollableTableState<T> extends State<ScrollableTable<T>> {
  // ---- Scroll controllers ----
  late final ScrollController _fixedVerticalController;
  late final ScrollController _scrollableVerticalController;

  /// Guard flag that prevents the two scroll listeners from bouncing each
  /// other in an infinite loop: A → jumps B → triggers B's listener → jumps A…
  bool _isSyncing = false;

  // ---- Sort state ----
  int? _sortColumnIndex;
  bool _sortAscending = true;

  // ---- Cached derived data (computed once, not on every build) ----
  late List<T> _sortedItems;

  /// Columns that scroll horizontally (all columns when fixFirstColumn = false,
  /// or columns[1..] when fixFirstColumn = true). Cached so we never recreate
  /// the sublist on every build call.
  late List<ScrollableTableColumnSpec<T>> _scrollableColumns;

  @override
  void initState() {
    super.initState();

    _fixedVerticalController = ScrollController();
    _scrollableVerticalController = ScrollController();

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
      // Re-apply the current sort with the new data without calling setState
      // because didUpdateWidget is already inside a scheduled rebuild.
      _rebuildCache();
    }
  }

  // ---- Cache management ----

  void _rebuildCache() {
    _scrollableColumns = widget.fixFirstColumn && widget.columns.isNotEmpty
        ? widget.columns.sublist(1)
        : widget.columns;

    _applySort();
  }

  /// Sorts [widget.items] in-place into [_sortedItems].
  /// Must NOT call setState — callers are responsible for triggering a rebuild.
  void _applySort() {
    final items = List<T>.of(widget.items); // single shallow copy

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

  // ---- Scroll sync ----

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

  // ---- Sorting ----

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

  // ---- Build ----

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

        if (widget.fixFirstColumn) {
          return _FixedLayout<T>(
            columns: widget.columns,
            scrollableColumns: _scrollableColumns,
            sortedItems: _sortedItems,
            extraPerColumn: extraPerColumn,
            headerHeight: widget.headerHeight,
            rowHeight: widget.rowHeight,
            headerBackgroundColor: widget.headerBackgroundColor,
            rowBackgroundColor: widget.rowBackgroundColor,
            fixedVerticalController: _fixedVerticalController,
            scrollableVerticalController: _scrollableVerticalController,
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            onHeaderTap: _handleHeaderTap,
          );
        }

        return _ScrollableLayout<T>(
          columns: widget.columns,
          sortedItems: _sortedItems,
          totalMinWidth: totalMinWidth,
          extraPerColumn: extraPerColumn,
          headerHeight: widget.headerHeight,
          rowHeight: widget.rowHeight,
          headerBackgroundColor: widget.headerBackgroundColor,
          rowBackgroundColor: widget.rowBackgroundColor,
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          onHeaderTap: _handleHeaderTap,
        );
      },
    );
  }
}

// --------------------------------------------------------------------------
// _FixedLayout — renders the pinned first column alongside the horizontally
// scrollable remaining columns. All state is passed in so Flutter can diff
// the widget cleanly without reading from a parent state object.
// --------------------------------------------------------------------------

class _FixedLayout<T> extends StatelessWidget {
  final List<ScrollableTableColumnSpec<T>> columns;
  final List<ScrollableTableColumnSpec<T>> scrollableColumns;
  final List<T> sortedItems;
  final double extraPerColumn;
  final double headerHeight;
  final double rowHeight;
  final Color? headerBackgroundColor;
  final Color? rowBackgroundColor;
  final ScrollController fixedVerticalController;
  final ScrollController scrollableVerticalController;
  final int? sortColumnIndex;
  final bool sortAscending;
  final void Function(int) onHeaderTap;

  const _FixedLayout({
    required this.columns,
    required this.scrollableColumns,
    required this.sortedItems,
    required this.extraPerColumn,
    required this.headerHeight,
    required this.rowHeight,
    required this.headerBackgroundColor,
    required this.rowBackgroundColor,
    required this.fixedVerticalController,
    required this.scrollableVerticalController,
    required this.sortColumnIndex,
    required this.sortAscending,
    required this.onHeaderTap,
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
              ScrollableTableCell(
                width: firstColWidth,
                height: headerHeight,
                backgroundColor: headerBg,
                child: ScrollableTableHeaderCell<T>(
                  spec: firstCol,
                  isSorted: sortColumnIndex == 0,
                  sortAscending: sortAscending,
                  onTap: () => onHeaderTap(0),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: fixedVerticalController,
                  itemCount: sortedItems.length,
                  itemExtent: rowHeight,
                  itemBuilder: (_, index) => ScrollableTableCell(
                    width: firstColWidth,
                    height: rowHeight,
                    backgroundColor: rowBackgroundColor,
                    child: firstCol.cellBuilder(sortedItems[index]),
                  ),
                ),
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
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// --------------------------------------------------------------------------
// _ScrollableLayout — renders all columns in a single horizontally scrollable
// view (no pinned first column).
// --------------------------------------------------------------------------

class _ScrollableLayout<T> extends StatelessWidget {
  final List<ScrollableTableColumnSpec<T>> columns;
  final List<T> sortedItems;
  final double totalMinWidth;
  final double extraPerColumn;
  final double headerHeight;
  final double rowHeight;
  final Color? headerBackgroundColor;
  final Color? rowBackgroundColor;
  final int? sortColumnIndex;
  final bool sortAscending;
  final void Function(int) onHeaderTap;

  const _ScrollableLayout({
    required this.columns,
    required this.sortedItems,
    required this.totalMinWidth,
    required this.extraPerColumn,
    required this.headerHeight,
    required this.rowHeight,
    required this.headerBackgroundColor,
    required this.rowBackgroundColor,
    required this.sortColumnIndex,
    required this.sortAscending,
    required this.onHeaderTap,
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
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------
// _ScrollableRow  — extracted widget so Flutter can diff it efficiently.
// --------------------------------------------------------------------------

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
            ScrollableTableCell(
              width: col.minWidth + extraPerColumn,
              height: rowHeight,
              backgroundColor: rowBackgroundColor,
              child: col.cellBuilder(item),
            ),
        ],
      ),
    );
  }
}

// --------------------------------------------------------------------------
// _ScrollableHeaderCellWrapper — extracted widget so Flutter can diff and
// retain the header cell element across rebuilds instead of recreating it
// every time the parent rebuilds (e.g. on sort state change).
// --------------------------------------------------------------------------

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
    return ScrollableTableCell(
      width: colWidth,
      height: headerHeight,
      backgroundColor: headerBg,
      child: ScrollableTableHeaderCell<T>(
        spec: col,
        isSorted: isSorted,
        sortAscending: sortAscending,
        onTap: onTap,
      ),
    );
  }
}
