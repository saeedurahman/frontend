import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/users/data/models/staff_user_model.dart';
import 'package:frantend/features/users/presentation/utils/users_list_actions.dart';
import 'package:frantend/features/users/presentation/utils/users_navigation.dart';
import 'package:frantend/shared/widgets/badges/status_badge.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_paginated_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_table_cells.dart';

const _userTableColumns = [
  AppDataTableColumn(label: 'Name', flex: 3, sortable: true),
  AppDataTableColumn(label: 'Phone', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Branch', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Role(s)', flex: 3, sortable: true),
  AppDataTableColumn(label: 'Status', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Last Login', flex: 3, sortable: true),
];

class UsersDataTable extends StatelessWidget {
  const UsersDataTable({super.key, required this.users});

  final List<StaffUserModel> users;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sl<AuthLocalDataSource>().getCachedUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final canUpdate = UserRoleUtils.canUpdateUsers(
          role: user?.role,
          permissionKeys: user?.permissionKeys ?? const [],
        );
        final canDelete = UserRoleUtils.canDeleteUsers(
          role: user?.role,
          permissionKeys: user?.permissionKeys ?? const [],
        );

        return AppPaginatedDataTable<StaffUserModel>(
          columns: _userTableColumns,
          items: users,
          itemId: (u) => u.id,
          itemLabel: 'staff',
          actionsWidth: canUpdate || canDelete ? 100 : 0,
          sortCompare: _sortCompare,
          onRowTap: canUpdate
              ? (u) => openUserForm(
                    context,
                    RouteNames.staffEditPath(u.id),
                  )
              : null,
          rowBuilder: (context, staff, {required selected, required onSelected}) {
            return AppDataTableRowLayout(
              columns: _userTableColumns,
              selected: selected,
              onSelected: onSelected,
              actionsWidth: canUpdate || canDelete ? 100 : 0,
              cells: [
                Text(
                  staff.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  staff.phone ?? '—',
                  style: const TextStyle(fontSize: 13),
                ),
                Text(
                  branchDisplayName(staff),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
                Text(
                  formatStaffRoles(staff.roles),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
                StatusBadge(
                  label: staff.isActive ? 'Active' : 'Inactive',
                  color: staff.isActive ? AppColors.success : AppColors.textSecondary,
                ),
                Text(
                  formatLastLogin(staff.lastLoginAt),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              actions: Row(
                children: [
                  if (canUpdate)
                    AppTableActionButton(
                      icon: Icons.edit_outlined,
                      tooltip: 'Edit',
                      onPressed: () => openUserForm(
                        context,
                        RouteNames.staffEditPath(staff.id),
                      ),
                    ),
                  if (canDelete) ...[
                    const SizedBox(width: 6),
                    AppTableActionButton(
                      icon: Icons.delete_outline,
                      iconColor: AppColors.error,
                      tooltip: 'Delete',
                      onPressed: () => confirmDeleteUser(context, staff),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  static int _sortCompare(StaffUserModel a, StaffUserModel b, int column) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);

    return switch (column) {
      0 => compare(a.fullName.toLowerCase(), b.fullName.toLowerCase()),
      1 => compare(
          (a.phone ?? '').toLowerCase(),
          (b.phone ?? '').toLowerCase(),
        ),
      2 => compare(
          branchDisplayName(a).toLowerCase(),
          branchDisplayName(b).toLowerCase(),
        ),
      3 => compare(
          formatStaffRoles(a.roles).toLowerCase(),
          formatStaffRoles(b.roles).toLowerCase(),
        ),
      4 => compare(a.isActive ? 0 : 1, b.isActive ? 0 : 1),
      5 => compare(
          a.lastLoginAt ?? '',
          b.lastLoginAt ?? '',
        ),
      _ => 0,
    };
  }
}
