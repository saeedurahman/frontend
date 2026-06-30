import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/users/presentation/cubit/user_form_cubit.dart';
import 'package:frantend/features/users/presentation/cubit/user_form_state.dart';
import 'package:frantend/features/users/presentation/widgets/reset_pin_dialog.dart';
import 'package:frantend/features/users/presentation/widgets/user_role_picker.dart';
import 'package:frantend/shared/widgets/badges/status_badge.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

class UserFormPage extends StatelessWidget {
  const UserFormPage({super.key, this.userId});

  final String? userId;

  bool get isEdit => userId != null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<UserFormCubit>();
        if (userId != null) {
          cubit.loadForEdit(userId!);
        } else {
          cubit.initCreate();
        }
        return cubit;
      },
      child: _UserFormView(isEdit: isEdit),
    );
  }
}

class _UserFormView extends StatelessWidget {
  const _UserFormView({required this.isEdit});

  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserFormCubit, UserFormState>(
      listenWhen: (previous, current) =>
          current.errors.containsKey('_general') ||
          current.errors.containsKey('_roles') ||
          current.errors.containsKey('_pin') ||
          (current.saveWarning != null &&
              current.saveWarning != previous.saveWarning),
      listener: (context, state) {
        final general = state.errors['_general'];
        if (general != null) AppAlerts.showErrorMessage(context, general);
        final roles = state.errors['_roles'];
        if (roles != null) AppAlerts.showErrorMessage(context, roles);
        final pin = state.errors['_pin'];
        if (pin != null) AppAlerts.showErrorMessage(context, pin);
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errors.containsKey('_general') &&
            state.errors['_general'] == 'Access denied') {
          return const Center(
            child: Text("You don't have permission to manage this staff member"),
          );
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 96),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 840),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: state.isSaving || state.isDeleting
                                ? null
                                : () => context.pop(),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              isEdit ? 'Edit Staff Member' : 'Add Staff Member',
                              style: AppTextStyles.headlineMedium,
                            ),
                          ),
                          if (isEdit)
                            StatusBadge(
                              label: state.isActive ? 'Active' : 'Inactive',
                              color: state.isActive
                                  ? AppColors.success
                                  : AppColors.textSecondary,
                            ),
                        ],
                      ),
                      if (state.saveWarning != null) ...[
                        const SizedBox(height: AppDimensions.spacingMd),
                        MaterialBanner(
                          backgroundColor:
                              AppColors.warning.withValues(alpha: 0.12),
                          content: Text(
                            state.saveWarning!,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          leading: const Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.warning,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => context
                                  .read<UserFormCubit>()
                                  .clearSaveWarning(),
                              child: const Text('Dismiss'),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: AppDimensions.spacingLg),
                      _FormCard(
                        title: 'Profile',
                        child: _ProfileFields(state: state, isEdit: isEdit),
                      ),
                      const SizedBox(height: AppDimensions.spacingMd),
                      _FormCard(
                        title: 'Roles',
                        child: UserRolePicker(
                          state: state,
                          enabled: !isEdit || state.canEditRoles,
                          readOnlyNote: isEdit && !state.canEditRoles
                              ? 'Only users with role-management permission can change roles.'
                              : null,
                        ),
                      ),
                      if (isEdit && state.canUpdateProfile) ...[
                        const SizedBox(height: AppDimensions.spacingMd),
                        _FormCard(
                          title: 'Account Actions',
                          child: _AccountActions(state: state),
                        ),
                      ],
                      if (isEdit && state.canDelete) ...[
                        const SizedBox(height: AppDimensions.spacingMd),
                        OutlinedButton.icon(
                          onPressed: state.isDeleting || state.isSaving
                              ? null
                              : () => _confirmDelete(context, state),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                          ),
                          icon: state.isDeleting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.delete_outline),
                          label: const Text('Delete Staff Member'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Material(
                elevation: 8,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spacingMd),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: state.isSaving || state.isDeleting
                            ? null
                            : () => context.pop(),
                        child: const Text('Cancel'),
                      ),
                      const Spacer(),
                      PrimaryButton(
                        label: isEdit ? 'Save Changes' : 'Create Staff Member',
                        fullWidth: false,
                        isLoading: state.isSaving,
                        onPressed: state.isSaving ||
                                state.isDeleting ||
                                (isEdit && !state.canSave)
                            ? null
                            : () async {
                                final ok = await context
                                    .read<UserFormCubit>()
                                    .submit();
                                if (ok && context.mounted) {
                                  AppAlerts.showSuccessMessage(
                                    context,
                                    isEdit
                                        ? 'Staff member updated'
                                        : 'Staff member created',
                                  );
                                  context.pop(true);
                                }
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, UserFormState state) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Delete ${state.fullName}?',
      message:
          'This staff member will be removed from your business. This cannot be undone.',
    );
    if (ok == true && context.mounted) {
      final success =
          await context.read<UserFormCubit>().deleteUser();
      if (success && context.mounted) {
        AppAlerts.showSuccessMessage(context, 'Staff member deleted');
        context.pop(true);
      }
    }
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: AppTextStyles.titleMedium),
            const SizedBox(height: AppDimensions.spacingMd),
            child,
          ],
        ),
      ),
    );
  }
}

class _ProfileFields extends StatefulWidget {
  const _ProfileFields({required this.state, required this.isEdit});

  final UserFormState state;
  final bool isEdit;

  @override
  State<_ProfileFields> createState() => _ProfileFieldsState();
}

class _ProfileFieldsState extends State<_ProfileFields> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.state.fullName);
    _phoneController = TextEditingController(text: widget.state.phone);
  }

  @override
  void didUpdateWidget(covariant _ProfileFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.fullName != widget.state.fullName &&
        _nameController.text != widget.state.fullName) {
      _nameController.text = widget.state.fullName;
    }
    if (oldWidget.state.phone != widget.state.phone &&
        _phoneController.text != widget.state.phone) {
      _phoneController.text = widget.state.phone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final isEdit = widget.isEdit;
    final cubit = context.read<UserFormCubit>();
    final canEditProfile = !isEdit || state.canUpdateProfile;

    return Column(
      children: [
        TextField(
          enabled: canEditProfile,
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Full name *',
            border: const OutlineInputBorder(),
            errorText: state.errors['fullName'],
          ),
          onChanged: cubit.updateFullName,
        ),
        const SizedBox(height: 12),
        TextField(
          enabled: !isEdit,
          readOnly: isEdit,
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: 'Phone *',
            border: const OutlineInputBorder(),
            errorText: state.errors['phone'],
            helperText: isEdit ? 'Phone cannot be changed after creation' : null,
          ),
          onChanged: cubit.updatePhone,
          keyboardType: TextInputType.phone,
        ),
        if (!isEdit) ...[
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              labelText: 'Password *',
              border: const OutlineInputBorder(),
              errorText: state.errors['password'],
            ),
            obscureText: true,
            onChanged: cubit.updatePassword,
          ),
        ],
        const SizedBox(height: 12),
        DropdownButtonFormField<String?>(
          value: state.branchId,
          decoration: const InputDecoration(
            labelText: 'Branch',
            border: OutlineInputBorder(),
          ),
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text('No default branch'),
            ),
            ...state.branches.map(
              (b) => DropdownMenuItem<String?>(
                value: b.id,
                child: Text(b.name),
              ),
            ),
          ],
          onChanged: canEditProfile ? cubit.updateBranchId : null,
        ),
        if (isEdit && state.canUpdateProfile) ...[
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Active'),
            subtitle: const Text(
              'Inactive staff cannot log in. Changes apply immediately.',
            ),
            value: state.isActive,
            onChanged: state.isTogglingActive
                ? null
                : (_) async {
                    final wasActive = state.isActive;
                    final ok = await cubit.toggleActive();
                    if (ok && context.mounted) {
                      AppAlerts.showSuccessMessage(
                        context,
                        wasActive
                            ? 'Staff member deactivated'
                            : 'Staff member reactivated',
                      );
                    }
                  },
          ),
          if (state.isTogglingActive)
            const LinearProgressIndicator(minHeight: 2),
        ],
      ],
    );
  }
}

class _AccountActions extends StatelessWidget {
  const _AccountActions({required this.state});

  final UserFormState state;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: state.isResettingPin || state.isSaving
          ? null
          : () async {
              final pin = await ResetPinDialog.show(context);
              if (pin == null || !context.mounted) return;
              final ok = await context.read<UserFormCubit>().resetPin(pin);
              if (ok && context.mounted) {
                AppAlerts.showSuccessMessage(context, 'PIN reset successfully');
              }
            },
      icon: state.isResettingPin
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.pin_outlined),
      label: const Text('Reset PIN'),
    );
  }
}
