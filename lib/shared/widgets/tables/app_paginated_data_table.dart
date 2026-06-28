import 'package:flutter/material.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_data_table_pagination.dart';
import 'package:frantend/shared/widgets/tables/app_table_pagination_helpers.dart';

/// Reusable data table with shared sort + pagination behaviour.
///
/// - [AppTablePaginationMode.client]: sort full list, slice pages in memory.
/// - [AppTablePaginationMode.server]: sort current page only; footer from cubit.
/// - [AppTablePaginationMode.summary]: show full sorted list; count-only footer.
class AppPaginatedDataTable<T> extends StatefulWidget {
  const AppPaginatedDataTable({
    super.key,
    required this.columns,
    required this.items,
    required this.itemId,
    required this.rowBuilder,
    this.sortCompare,
    this.paginationMode = AppTablePaginationMode.client,
    this.itemLabel = 'items',
    this.initialPageSize = 10,
    this.skip,
    this.total,
    this.limit,
    this.currentPage,
    this.totalPages,
    this.onPageSizeChanged,
    this.onGoToPage,
    this.onColumnSort,
    this.onRowTap,
    this.showSelection = true,
    this.showActions = true,
    this.actionsHeader = 'Actions',
    this.actionsWidth = 88,
    this.pagination,
    this.embedded = false,
  });

  final List<AppDataTableColumn> columns;
  final List<T> items;
  final String Function(T item) itemId;
  final AppDataTableRowBuilder<T> rowBuilder;
  final AppDataTableColumnSort<T>? sortCompare;
  final AppTablePaginationMode paginationMode;
  final String itemLabel;
  final int initialPageSize;

  /// Server pagination fields (required when [paginationMode] is [AppTablePaginationMode.server]).
  final int? skip;
  final int? total;
  final int? limit;
  final int? currentPage;
  final int? totalPages;
  final ValueChanged<int>? onPageSizeChanged;
  final ValueChanged<int>? onGoToPage;

  /// Optional override when pagination cannot be derived from mode/fields.
  final AppDataTablePaginationData? pagination;

  final void Function(int columnIndex)? onColumnSort;
  final void Function(T item)? onRowTap;
  final bool showSelection;
  final bool showActions;
  final String actionsHeader;
  final double actionsWidth;

  /// When true, sizes to visible rows instead of expanding (for scroll views).
  final bool embedded;

  static const double _embeddedHeaderHeight = 48;
  static const double _embeddedRowHeight = 52;
  static const double _embeddedFooterHeight = 56;

  @override
  State<AppPaginatedDataTable<T>> createState() =>
      _AppPaginatedDataTableState<T>();
}

class _AppPaginatedDataTableState<T> extends State<AppPaginatedDataTable<T>> {
  int? _sortColumn;
  bool _sortAscending = true;
  late int _currentPage;
  late int _pageSize;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentPage ?? 1;
    _pageSize = widget.limit ?? widget.initialPageSize;
  }

  @override
  void didUpdateWidget(covariant AppPaginatedDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentPage != null && widget.currentPage != _currentPage) {
      _currentPage = widget.currentPage!;
    }
    if (widget.limit != null && widget.limit != _pageSize) {
      _pageSize = widget.limit!;
    }
  }

  List<T> get _sortedItems {
    final items = [...widget.items];
    final column = _sortColumn;
    final compare = widget.sortCompare;
    if (column == null || compare == null) return items;

    items.sort((a, b) {
      final result = compare(a, b, column);
      return _sortAscending ? result : -result;
    });
    return items;
  }

  List<T> get _displayItems {
    final sorted = _sortedItems;
    if (widget.paginationMode == AppTablePaginationMode.client) {
      return AppTablePaginationHelpers.pageSlice(
        sorted,
        _effectivePage,
        _effectivePageSize,
      );
    }
    return sorted;
  }

  int get _effectivePage => widget.currentPage ?? _currentPage;

  int get _effectivePageSize => widget.limit ?? _pageSize;

  AppDataTablePaginationData? get _pagination {
    if (widget.pagination != null) return widget.pagination;

    return switch (widget.paginationMode) {
      AppTablePaginationMode.client => AppTablePaginationHelpers.client(
          totalItems: _sortedItems.length,
          currentPage: _effectivePage,
          pageSize: _effectivePageSize,
          itemLabel: widget.itemLabel,
          onPageSizeChanged: _onClientPageSizeChanged,
          onGoToPage: _onClientGoToPage,
        ),
      AppTablePaginationMode.server => AppTablePaginationHelpers.server(
          skip: widget.skip ?? 0,
          itemCount: widget.items.length,
          total: widget.total ?? widget.items.length,
          itemLabel: widget.itemLabel,
          currentPage: widget.currentPage ?? 1,
          totalPages: widget.totalPages ?? 1,
          pageSize: widget.limit ?? _pageSize,
          onPageSizeChanged: widget.onPageSizeChanged!,
          onGoToPage: widget.onGoToPage!,
        ),
      AppTablePaginationMode.summary => AppTablePaginationHelpers.summary(
          total: _sortedItems.length,
          itemLabel: widget.itemLabel,
        ),
    };
  }

  void _onClientPageSizeChanged(int size) {
    if (widget.onPageSizeChanged != null) {
      widget.onPageSizeChanged!(size);
    } else {
      setState(() {
        _pageSize = size;
        _currentPage = 1;
      });
    }
  }

  void _onClientGoToPage(int page) {
    if (widget.onGoToPage != null) {
      widget.onGoToPage!(page);
    } else {
      setState(() => _currentPage = page);
    }
  }

  void _handleColumnSort(int index) {
    if (widget.onColumnSort != null) {
      widget.onColumnSort!(index);
      return;
    }
    if (widget.sortCompare == null) return;

    setState(() {
      if (_sortColumn == index) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = index;
        _sortAscending = true;
      }
    });
  }

  double? get _embeddedHeight {
    if (!widget.embedded) return null;
    final rowCount = _displayItems.length;
    if (rowCount == 0) return null;
    var height = AppPaginatedDataTable._embeddedHeaderHeight +
        rowCount * AppPaginatedDataTable._embeddedRowHeight;
    if (_pagination != null) {
      height += AppPaginatedDataTable._embeddedFooterHeight;
    }
    return height;
  }

  @override
  Widget build(BuildContext context) {
    final table = AppDataTable<T>(
      columns: widget.columns,
      items: _displayItems,
      itemId: widget.itemId,
      rowBuilder: widget.rowBuilder,
      pagination: _pagination,
      onColumnSort: widget.sortCompare != null || widget.onColumnSort != null
          ? _handleColumnSort
          : null,
      onRowTap: widget.onRowTap,
      showSelection: widget.showSelection,
      showActions: widget.showActions,
      actionsHeader: widget.actionsHeader,
      actionsWidth: widget.actionsWidth,
    );

    final height = _embeddedHeight;
    if (height != null) {
      return SizedBox(height: height, child: table);
    }
    return SizedBox.expand(child: table);
  }
}
