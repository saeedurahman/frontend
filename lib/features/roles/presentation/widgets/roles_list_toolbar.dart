import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/roles/presentation/utils/roles_navigation.dart';

class RolesListToolbar extends StatelessWidget {
  const RolesListToolbar({super.key, required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Settings',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        const SizedBox(width: 4),
        Text('Roles & Permissions', style: AppTextStyles.headlineMedium),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '($total roles)',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
          ),
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () => openRoleForm(context, RouteNames.settingsRoleNew),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Create Role'),
        ),
      ],
    );
  }
}
