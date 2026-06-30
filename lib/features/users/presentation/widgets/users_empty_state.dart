import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/users/presentation/utils/users_navigation.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';

class UsersEmptyState extends StatelessWidget {
  const UsersEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.people_outline,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          const Text(
            'No staff members yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first team member to get started',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          FutureBuilder(
            future: sl<AuthLocalDataSource>().getCachedUser(),
            builder: (context, snapshot) {
              final user = snapshot.data;
              if (!UserRoleUtils.canCreateUsers(
                role: user?.role,
                permissionKeys: user?.permissionKeys ?? const [],
              )) {
                return const SizedBox.shrink();
              }
              return PrimaryButton(
                label: 'Add Staff',
                icon: Icons.person_add_outlined,
                onPressed: () => openUserForm(context, RouteNames.staffNew),
              );
            },
          ),
        ],
      ),
    );
  }
}
