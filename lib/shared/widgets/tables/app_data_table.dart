import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/shared/widgets/tables/app_data_table_pagination.dart';

class AppDataTableColumn {
  const AppDataTableColumn({
    required this.label,
    this.flex = 1,
    this.width,
    this.sortable = false,
  });

  final String label;
  final int flex;
  final double? width;
  final bool sortable;
}

typedef AppDataTableRowBuilder<T> = Widget Function(
  BuildContext context,
  T item, {
  required bool selected,
  required ValueChanged<bool> onSelected,
});

class AppDataTable<T> extends StatefulWidget {
  const AppDataTable({
    super.key,
    required this.columns,
    required this.items,
    required this.itemId,
    required this.rowBuilder,
    this.pagination,
    this.onColumnSort,
    this.showSelection = true,
    this.actionsHeader = 'Actions',
    this.actionsWidth = 88,
    this.onRowTap,
  });

  final List<AppDataTableColumn> columns;
  final List<T> items;
  final String Function(T item) itemId;
  final AppDataTableRowBuilder<T> rowBuilder;
  final AppDataTablePaginationData? pagination;
  final void Function(int columnIndex)? onColumnSort;
  final bool showSelection;
  final String actionsHeader;
  final double actionsWidth;
  final void Function(T item)? onRowTap;

  @override
  State<AppDataTable<T>> createState() => _AppDataTableState<T>();
}

class _AppDataTableState<T> extends State<AppDataTable<T>> {
  final _selectedIds = <String>{};

  void _toggleSelectAll(bool? value) {
    setState(() {
      if (value == true) {
        _selectedIds.addAll(widget.items.map(widget.itemId));
      } else {
        _selectedIds.clear();
      }
    });
  }

  void _toggleRow(String id, bool selected) {
    setState(() {
      if (selected) {
        _selectedIds.add(id);
      } else {
        _selectedIds.remove(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    final allSelected =
        items.isNotEmpty && _selectedIds.length == items.length;
    final someSelected =
        _selectedIds.isNotEmpty && _selectedIds.length < items.length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: AppColors.brandingPanel,
            child: Row(
              children: [
                if (widget.showSelection)
                  SizedBox(
                    width: 40,
                    child: Checkbox(
                      value: allSelected
                          ? true
                          : (someSelected ? null : false),
                      tristate: true,
                      onChanged: _toggleSelectAll,
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.white;
                        }
                        return Colors.transparent;
                      }),
                      checkColor: AppColors.brandingPanel,
                      side: const BorderSide(color: Colors.white70, width: 1.5),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ...List.generate(widget.columns.length, (index) {
                  final column = widget.columns[index];
                  final header = AppDataTableHeaderLabel(
                    label: column.label,
                    sortable: column.sortable,
                    onSort: column.sortable && widget.onColumnSort != null
                        ? () => widget.onColumnSort!(index)
                        : null,
                  );
                  if (column.width != null) {
                    return SizedBox(width: column.width, child: header);
                  }
                  return Expanded(flex: column.flex, child: header);
                }),
                SizedBox(
                  width: widget.actionsWidth,
                  child: Text(
                    widget.actionsHeader,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: AppColors.border),
              itemBuilder: (context, index) {
                final item = items[index];
                final id = widget.itemId(item);
                final selected = _selectedIds.contains(id);
                final row = widget.rowBuilder(
                  context,
                  item,
                  selected: selected,
                  onSelected: (value) => _toggleRow(id, value),
                );
                if (widget.onRowTap == null) return row;
                return Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () => widget.onRowTap!(item),
                    child: row,
                  ),
                );
              },
            ),
          ),
          if (widget.pagination != null)
            AppDataTablePaginationFooter(data: widget.pagination!),
        ],
      ),
    );
  }
}

class AppDataTableHeaderLabel extends StatelessWidget {
  const AppDataTableHeaderLabel({
    required this.label,
    this.sortable = false,
    this.onSort,
  });

  final String label;
  final bool sortable;
  final VoidCallback? onSort;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        if (sortable) ...[
          const SizedBox(width: 4),
          const Icon(Icons.unfold_more, size: 14, color: Colors.white70),
        ],
      ],
    );

    if (onSort == null) return content;
    return InkWell(onTap: onSort, child: content);
  }
}

class AppDataTableShimmer extends StatelessWidget {
  const AppDataTableShimmer({super.key, this.rowCount = 5});

  final int rowCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(height: 48, color: AppColors.brandingPanel),
          ...List.generate(
            rowCount,
            (_) => Container(
              height: 72,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lays out row cells aligned with [AppDataTable] header columns.
class AppDataTableRowLayout extends StatelessWidget {
  const AppDataTableRowLayout({
    super.key,
    required this.columns,
    required this.cells,
    required this.actions,
    this.showSelection = true,
    this.selected = false,
    this.onSelected,
    this.actionsWidth = 88,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  });

  final List<AppDataTableColumn> columns;
  final List<Widget> cells;
  final Widget actions;
  final bool showSelection;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final double actionsWidth;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    assert(columns.length == cells.length);

    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showSelection)
            SizedBox(
              width: 40,
              child: Checkbox(
                value: selected,
                onChanged: onSelected == null
                    ? null
                    : (value) => onSelected!(value ?? false),
                activeColor: AppColors.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ...List.generate(columns.length, (index) {
            final column = columns[index];
            final cell = cells[index];
            if (column.width != null) {
              return SizedBox(width: column.width, child: cell);
            }
            return Expanded(flex: column.flex, child: cell);
          }),
          SizedBox(width: actionsWidth, child: actions),
        ],
      ),
    );
  }
}
