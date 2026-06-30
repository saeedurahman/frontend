import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/roles/data/models/role_model.dart';
import 'package:frantend/features/users/presentation/cubit/user_form_cubit.dart';
import 'package:frantend/features/users/presentation/cubit/user_form_state.dart';

class UserRolePicker extends StatelessWidget {
  const UserRolePicker({
    super.key,
    required this.state,
    required this.enabled,
    this.readOnlyNote,
  });

  final UserFormState state;
  final bool enabled;
  final String? readOnlyNote;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserFormCubit>();
    final roles = state.availableRoles;
    final roleError = state.errors['roles'];

    if (!enabled) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (readOnlyNote != null) ...[
            Text(
              readOnlyNote!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final role in _assignedRoles(roles))
                Chip(
                  label: Text(role.name),
                  backgroundColor: AppColors.background,
                ),
              if (_assignedRoles(roles).isEmpty)
                const Text(
                  '—',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
            ],
          ),
        ],
      );
    }

    if (roles.isEmpty) {
      return const Text(
        'No roles available. Create roles in Settings first.',
        style: TextStyle(color: AppColors.textSecondary),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...roles.map(
          (role) => CheckboxListTile(
            value: state.selectedRoleIds.contains(role.id),
            onChanged: enabled
                ? (checked) => cubit.toggleRole(role.id, checked ?? false)
                : null,
            title: Text(role.name),
            subtitle: role.description != null && role.description!.isNotEmpty
                ? Text(
                    role.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        if (roleError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              roleError,
              style: const TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ),
      ],
    );
  }

  List<RoleModel> _assignedRoles(List<RoleModel> all) {
    final selected = state.selectedRoleIds.toSet();
    return all.where((r) => selected.contains(r.id)).toList();
  }
}
