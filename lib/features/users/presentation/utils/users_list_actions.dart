import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/users/data/models/staff_role_model.dart';
import 'package:frantend/features/users/data/models/staff_user_model.dart';
import 'package:frantend/features/users/presentation/cubit/users_list_cubit.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:intl/intl.dart';

Future<void> confirmDeleteUser(BuildContext context, StaffUserModel user) async {
  final ok = await ConfirmDialog.show(
    context,
    title: 'Delete ${user.fullName}?',
    message:
        'This staff member will be removed from your business. This action cannot be undone.',
  );
  if (ok == true && context.mounted) {
    final success = await context.read<UsersListCubit>().deleteUser(user.id);
    if (success && context.mounted) {
      AppAlerts.showSuccessMessage(context, 'Staff member deleted');
    }
  }
}

String formatStaffRoles(List<StaffRoleModel> roles) {
  if (roles.isEmpty) return '—';
  return roles.map((r) => r.name).join(', ');
}

String formatLastLogin(String? lastLoginAt) {
  if (lastLoginAt == null || lastLoginAt.trim().isEmpty) return '—';
  final parsed = DateTime.tryParse(lastLoginAt);
  if (parsed == null) return lastLoginAt;
  return DateFormat('MMM d, yyyy · HH:mm').format(parsed.toLocal());
}

String branchDisplayName(StaffUserModel user) {
  if (user.branchName != null && user.branchName!.trim().isNotEmpty) {
    return user.branchName!.trim();
  }
  return user.branchId ?? '—';
}
