import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/returns/data/models/sale_return_response_model.dart';
import 'package:frantend/features/returns/presentation/utils/return_display_utils.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_paginated_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_table_cells.dart';
import 'package:go_router/go_router.dart';

const _returnsTableColumns = [
  AppDataTableColumn(label: 'Return #', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Date', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Customer', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Refund', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Method', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Reason', flex: 3, sortable: true),
];

class ReturnsDataTable extends StatelessWidget {
  const ReturnsDataTable({super.key, required this.items});

  final List<SaleReturnResponseModel> items;

  @override
  Widget build(BuildContext context) {
    return AppPaginatedDataTable<SaleReturnResponseModel>(
      columns: _returnsTableColumns,
      items: items,
      itemId: (item) => item.id,
      itemLabel: 'returns',
      sortCompare: _sortCompare,
      onRowTap: (item) => context.push(RouteNames.returnDetailPath(item.id)),
      rowBuilder: (context, item, {required selected, required onSelected}) {
        return AppDataTableRowLayout(
          columns: _returnsTableColumns,
          selected: selected,
          onSelected: onSelected,
          cells: [
            Text(
              item.returnNumber,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.primary,
              ),
            ),
            Text(
              formatReturnDate(item.returnedAt ?? item.createdAt),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              item.customerId ?? 'Walk-in',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
            Text(
              formatRefundTotal(item),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              refundMethodsLabel(item),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
            Text(
              item.reason?.trim().isNotEmpty == true ? item.reason!.trim() : '—',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          actions: AppTableActionButton(
            icon: Icons.chevron_right,
            tooltip: 'View',
            onPressed: () =>
                context.push(RouteNames.returnDetailPath(item.id)),
          ),
        );
      },
    );
  }

  static int _sortCompare(
    SaleReturnResponseModel a,
    SaleReturnResponseModel b,
    int column,
  ) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);

    return switch (column) {
      0 => compare(
          a.returnNumber.toLowerCase(),
          b.returnNumber.toLowerCase(),
        ),
      1 => compare(
          (a.returnedAt ?? a.createdAt ?? '').toLowerCase(),
          (b.returnedAt ?? b.createdAt ?? '').toLowerCase(),
        ),
      2 => compare(
          (a.customerId ?? '').toLowerCase(),
          (b.customerId ?? '').toLowerCase(),
        ),
      3 => compare(
          refundTotal(a).toDouble(),
          refundTotal(b).toDouble(),
        ),
      4 => compare(
          refundMethodsLabel(a).toLowerCase(),
          refundMethodsLabel(b).toLowerCase(),
        ),
      5 => compare(
          (a.reason ?? '').toLowerCase(),
          (b.reason ?? '').toLowerCase(),
        ),
      _ => 0,
    };
  }
}
