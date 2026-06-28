import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_state.dart';
import 'package:frantend/features/customers/presentation/utils/customer_balance_utils.dart';
import 'package:frantend/features/customers/presentation/utils/customer_list_actions.dart';
import 'package:frantend/features/customers/presentation/utils/customer_list_navigation.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_paginated_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_table_cells.dart';
import 'package:frantend/shared/widgets/tables/app_table_pagination_helpers.dart';
import 'package:go_router/go_router.dart';

const _customerTableColumns = [
  AppDataTableColumn(label: 'Name / Phone', flex: 3, sortable: true),
  AppDataTableColumn(label: 'Email', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Credit Limit', flex: 2, sortable: true),
  AppDataTableColumn(
    label: 'Outstanding Balance',
    flex: 2,
    sortable: true,
  ),
  AppDataTableColumn(label: 'Status', flex: 1, sortable: true),
];

class CustomersDataTable extends StatelessWidget {
  const CustomersDataTable({super.key, required this.items});

  final List<CustomerListRow> items;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomersListCubit>();

    return AppPaginatedDataTable<CustomerListRow>(
      columns: _customerTableColumns,
      items: items,
      itemId: (row) => row.customer.id,
      itemLabel: 'customers',
      paginationMode: AppTablePaginationMode.client,
      actionsWidth: 160,
      sortCompare: _sortCompare,
      onRowTap: (row) =>
          context.push(RouteNames.customerDetail(row.customer.id)),
      rowBuilder: (context, row, {required selected, required onSelected}) {
        final customer = row.customer;
        final balanceDisplay =
            CustomerBalanceUtils.formatBalanceDisplay(row.balance);

        return AppDataTableRowLayout(
          columns: _customerTableColumns,
          selected: selected,
          onSelected: onSelected,
          actionsWidth: 160,
          cells: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  customer.phone ?? '—',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            Text(
              customer.email ?? '—',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              CustomerBalanceUtils.formatCreditLimit(customer.creditLimit),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            row.balanceLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    balanceDisplay.text,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: balanceDisplay.isOwed
                          ? AppColors.error
                          : AppColors.textPrimary,
                    ),
                  ),
            Switch(
              value: customer.isActive,
              activeTrackColor: AppColors.primary.withValues(alpha: 0.4),
              activeThumbColor: AppColors.primary,
              onChanged: (v) => cubit.toggleActive(customer.id, v),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
          actions: Row(
            children: [
              AppTableActionButton(
                icon: Icons.receipt_long_outlined,
                tooltip: 'View Ledger',
                onPressed: () => context.push(
                  RouteNames.customerDetail(customer.id),
                ),
              ),
              const SizedBox(width: 6),
              AppTableActionButton(
                icon: Icons.edit_outlined,
                tooltip: 'Edit',
                onPressed: () => openCustomerForm(
                  context,
                  '${RouteNames.customers}/${customer.id}/edit',
                ),
              ),
              const SizedBox(width: 6),
              if (customer.isActive)
                AppTableActionButton(
                  icon: Icons.person_off_outlined,
                  iconColor: AppColors.error,
                  tooltip: 'Deactivate',
                  onPressed: () => confirmDeactivateCustomer(context, row),
                ),
            ],
          ),
        );
      },
    );
  }

  static int _sortCompare(CustomerListRow a, CustomerListRow b, int column) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);

    return switch (column) {
      0 => compare(
          a.customer.name.toLowerCase(),
          b.customer.name.toLowerCase(),
        ),
      1 => compare(
          (a.customer.email ?? '').toLowerCase(),
          (b.customer.email ?? '').toLowerCase(),
        ),
      2 => compare(
          double.tryParse(a.customer.creditLimit) ?? 0,
          double.tryParse(b.customer.creditLimit) ?? 0,
        ),
      3 => compare(
          CustomerBalanceUtils.amountOwed(a.balance),
          CustomerBalanceUtils.amountOwed(b.balance),
        ),
      4 => compare(
          a.customer.isActive ? 1 : 0,
          b.customer.isActive ? 1 : 0,
        ),
      _ => 0,
    };
  }
}
