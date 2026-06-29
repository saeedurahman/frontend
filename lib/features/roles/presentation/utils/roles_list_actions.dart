import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/roles/data/models/role_model.dart';
import 'package:frantend/features/roles/presentation/cubit/roles_list_cubit.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/utils/app_alerts.dart';

Future<void> confirmDeleteRole(BuildContext context, RoleModel role) async {
  if (role.isSystem) return;

  final ok = await ConfirmDialog.show(
    context,
    title: 'Delete ${role.name}?',
    message:
        'Users assigned to this role will need to be reassigned. This cannot be undone.',
  );
  if (ok == true && context.mounted) {
    final success =
        await context.read<RolesListCubit>().deleteRole(role.id);
    if (success && context.mounted) {
      AppAlerts.showSuccessMessage(context, 'Role deleted');
    }
  }
}

String formatPermissionCount(int count) =>
    '$count permission${count == 1 ? '' : 's'}';
