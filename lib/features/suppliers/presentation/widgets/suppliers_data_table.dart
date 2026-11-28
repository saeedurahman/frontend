import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/presentation/widgets/party_khata_actions.dart';
import 'package:frantend/features/khata/presentation/utils/supplier_balance_text.dart';
import 'package:frantend/features/khata/presentation/widgets/pay_supplier_dialog.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_cubit.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_state.dart';
import 'package:frantend/features/suppliers/presentation/utils/supplier_list_actions.dart';
import 'package:frantend/features/suppliers/presentation/utils/supplier_list_navigation.dart';
import 'package:frantend/shared/widgets/permission_gate.dart';
import 'package:frantend/shared/widgets/sync/not_synced_badge.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_paginated_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_table_cells.dart';

const _supplierTableColumns = [
  AppDataTableColumn(label: 'Name', flex: 3, sortable: true),
  AppDataTableColumn(label: 'Phone', flex: 2, sortable: true),
  AppDataTableColumn(
    label: 'Outstanding Balance',
    flex: 2,
    sortable: true,
  ),
  AppDataTableColumn(label: 'Status', flex: 1, sortable: true),
];

class SuppliersDataTable extends StatelessWidget {
  const SuppliersDataTable({super.key, required this.items});

  final List<SupplierListRow> items;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SuppliersListCubit>();

    return AppPaginatedDataTable<SupplierListRow>(
      columns: _supplierTableColumns,
      items: items,
      itemId: (row) => row.supplier.id,
      itemLabel: 'suppliers',
      resetToken: cubit.newestCreatedId,
      actionsWidth: 230,
      sortCompare: _sortCompare,
      onRowTap: hasPermission(context, Perm.suppliersLedgerView)
          ? (row) => openSupplierForm(
                context,
                '${RouteNames.suppliers}/${row.supplier.id}',
              )
          : (hasPermission(context, Perm.suppliersUpdate)
              ? (row) => openSupplierForm(
                    context,
                    '${RouteNames.suppliers}/${row.supplier.id}/edit',
                  )
              : null),
      rowBuilder: (context, row, {required selected, required onSelected}) {
        final supplier = row.supplier;

        return AppDataTableRowLayout(
          columns: _supplierTableColumns,
          selected: selected,
          onSelected: onSelected,
          actionsWidth: 230,
          cells: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        supplier.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    SupplierSyncBadge(supplierId: supplier.id),
                  ],
                ),
                if (supplier.contactPerson != null &&
                    supplier.contactPerson!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    supplier.contactPerson!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
            Text(
              supplier.phone ?? '—',
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
                : Builder(builder: (_) {
                    final view = SupplierBalanceText.of(row.balance);
                    return Text(
                      view.text,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: view.color,
                      ),
                    );
                  }),
            Switch(
              value: supplier.isActive,
              activeTrackColor: AppColors.primary.withValues(alpha: 0.4),
              activeThumbColor: AppColors.primary,
              onChanged: (v) => cubit.toggleActive(supplier.id, v),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
          actions: Row(
            children: [
              PermissionGate(
                permission: Perm.suppliersPaymentsCreate,
                mode: GateMode.disable,
                mutating: true,
                child: AppTableActionButton(
                  icon: Icons.payments_outlined,
                  iconColor: AppColors.primary,
                  tooltip: KhataText.paySupplierTitle,
                  onPressed: () async {
                    final paid = await PaySupplierDialog.show(
                      context,
                      supplierId: supplier.id,
                      supplierName: supplier.name,
                      supplierPhone: supplier.phone,
                    );
                    if (paid) cubit.refresh();
                  },
                ),
              ),
              const SizedBox(width: 6),
              PermissionGate(
                permission: Perm.suppliersLedgerView,
                child: AppTableActionButton(
                  icon: Icons.receipt_long_outlined,
                  tooltip: KhataText.ledgerTitle,
                  onPressed: () => openSupplierForm(
                    context,
                    '${RouteNames.suppliers}/${supplier.id}',
                  ),
                ),
              ),
              const SizedBox(width: 6),
              StatementRowButton(
                type: PartyType.supplier,
                partyId: supplier.id,
              ),
              PermissionGate(
                permission: Perm.suppliersUpdate,
                mutating: true,
                child: AppTableActionButton(
                  icon: Icons.edit_outlined,
                  tooltip: 'Edit',
                  onPressed: () => openSupplierForm(
                    context,
                    '${RouteNames.suppliers}/${supplier.id}/edit',
                  ),
                ),
              ),
              const SizedBox(width: 6),
              PermissionGate(
                permission: Perm.suppliersUpdate,
                mutating: true,
                child: AppTableActionButton(
                  icon: Icons.delete_outline,
                  iconColor: AppColors.error,
                  tooltip: 'Delete',
                  onPressed: () => confirmDeleteSupplier(context, row),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static int _sortCompare(SupplierListRow a, SupplierListRow b, int column) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);

    return switch (column) {
      0 => compare(
          a.supplier.name.toLowerCase(),
          b.supplier.name.toLowerCase(),
        ),
      1 => compare(
          (a.supplier.phone ?? '').toLowerCase(),
          (b.supplier.phone ?? '').toLowerCase(),
        ),
      2 => compare(
          double.tryParse(a.balance ?? '0') ?? 0,
          double.tryParse(b.balance ?? '0') ?? 0,
        ),
      3 => compare(
          a.supplier.isActive ? 1 : 0,
          b.supplier.isActive ? 1 : 0,
        ),
      _ => 0,
    };
  }
}
