import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/roles/data/models/role_model.dart';
import 'package:frantend/features/roles/presentation/utils/roles_list_actions.dart';
import 'package:frantend/features/roles/presentation/utils/roles_navigation.dart';
import 'package:frantend/shared/widgets/badges/status_badge.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_paginated_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_table_cells.dart';

const _roleTableColumns = [
  AppDataTableColumn(label: 'Role', flex: 3, sortable: true),
  AppDataTableColumn(label: 'Type', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Permissions', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Description', flex: 4, sortable: true),
];

class RolesDataTable extends StatelessWidget {
  const RolesDataTable({super.key, required this.roles});

  final List<RoleModel> roles;

  @override
  Widget build(BuildContext context) {
    return AppPaginatedDataTable<RoleModel>(
      columns: _roleTableColumns,
      items: roles,
      itemId: (role) => role.id,
      itemLabel: 'roles',
      actionsWidth: 100,
      sortCompare: _sortCompare,
      onRowTap: (role) => openRoleForm(
        context,
        RouteNames.settingsRoleEditPath(role.id),
      ),
      rowBuilder: (context, role, {required selected, required onSelected}) {
        return AppDataTableRowLayout(
          columns: _roleTableColumns,
          selected: selected,
          onSelected: onSelected,
          actionsWidth: 100,
          cells: [
            Text(
              role.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            StatusBadge(
              label: role.isSystem ? 'System' : 'Custom',
              color: role.isSystem ? AppColors.info : AppColors.textSecondary,
            ),
            Text(
              formatPermissionCount(role.permissionKeys.length),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              role.description?.trim().isNotEmpty == true
                  ? role.description!.trim()
                  : '—',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          actions: Row(
            children: [
              AppTableActionButton(
                icon: Icons.edit_outlined,
                tooltip: 'Edit',
                onPressed: () => openRoleForm(
                  context,
                  RouteNames.settingsRoleEditPath(role.id),
                ),
              ),
              if (!role.isSystem) ...[
                const SizedBox(width: 6),
                AppTableActionButton(
                  icon: Icons.delete_outline,
                  iconColor: AppColors.error,
                  tooltip: 'Delete',
                  onPressed: () => confirmDeleteRole(context, role),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  static int _sortCompare(RoleModel a, RoleModel b, int column) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);

    return switch (column) {
      0 => compare(a.name.toLowerCase(), b.name.toLowerCase()),
      1 => compare(a.isSystem ? 0 : 1, b.isSystem ? 0 : 1),
      2 => compare(a.permissionKeys.length, b.permissionKeys.length),
      3 => compare(
          (a.description ?? '').toLowerCase(),
          (b.description ?? '').toLowerCase(),
        ),
      _ => 0,
    };
  }
}
