import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/features/roles/presentation/cubit/role_form_cubit.dart';
import 'package:frantend/features/roles/presentation/cubit/role_form_state.dart';
import 'package:frantend/features/roles/presentation/utils/roles_list_actions.dart';

class RolePermissionsPanel extends StatelessWidget {
  const RolePermissionsPanel({super.key, required this.state});

  final RoleFormState state;

  @override
  Widget build(BuildContext context) {
    final catalog = state.catalog;
    if (catalog == null || catalog.modules.isEmpty) {
      return Text(
        'No permissions catalog available.',
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
      );
    }

    final cubit = context.read<RoleFormCubit>();
    final selectedCount = state.selectedPermissionKeys.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('Permissions', style: AppTextStyles.titleMedium),
            const Spacer(),
            Text(
              formatPermissionCount(selectedCount),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...catalog.modules.map((module) {
          final fullySelected = cubit.isModuleFullySelected(module);
          final partiallySelected = cubit.isModulePartiallySelected(module);

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: AppColors.border),
            ),
            child: ExpansionTile(
              initiallyExpanded: true,
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      _formatModuleName(module.module),
                      style: AppTextStyles.titleMedium.copyWith(fontSize: 15),
                    ),
                  ),
                  Checkbox(
                    tristate: true,
                    value: partiallySelected ? null : fullySelected,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      if (value == null) {
                        cubit.toggleModule(module.module, false);
                      } else {
                        cubit.toggleModule(module.module, value);
                      }
                    },
                  ),
                ],
              ),
              subtitle: Text(
                '${module.permissions.length} available',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              children: module.permissions
                  .map(
                    (permission) => CheckboxListTile(
                      value: state.selectedPermissionKeys
                          .contains(permission.permissionKey),
                      activeColor: AppColors.primary,
                      onChanged: (_) =>
                          cubit.togglePermission(permission.permissionKey),
                      title: Text(
                        permission.description,
                        style: const TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                        permission.permissionKey,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontFamily: 'monospace',
                        ),
                      ),
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  )
                  .toList(),
            ),
          );
        }),
      ],
    );
  }

  String _formatModuleName(String module) {
    if (module.isEmpty) return 'General';
    return module
        .split('_')
        .map(
          (part) => part.isEmpty
              ? part
              : '${part[0].toUpperCase()}${part.substring(1)}',
        )
        .join(' ');
  }
}
