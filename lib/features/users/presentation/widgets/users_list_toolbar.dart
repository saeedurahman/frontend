import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/users/presentation/utils/users_navigation.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';

class UsersListToolbar extends StatelessWidget {
  const UsersListToolbar({super.key, required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sl<AuthLocalDataSource>().getCachedUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final canCreate = UserRoleUtils.canCreateUsers(
          role: user?.role,
          permissionKeys: user?.permissionKeys ?? const [],
        );

        return Row(
          children: [
            Text(
              '$total staff member${total == 1 ? '' : 's'}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            if (canCreate)
              PrimaryButton(
                label: 'Add Staff',
                icon: Icons.person_add_outlined,
                fullWidth: false,
                onPressed: () => openUserForm(context, RouteNames.staffNew),
              ),
          ],
        );
      },
    );
  }
}
