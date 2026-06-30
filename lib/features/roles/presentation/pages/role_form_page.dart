import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/roles/presentation/cubit/role_form_cubit.dart';
import 'package:frantend/features/roles/presentation/cubit/role_form_state.dart';
import 'package:frantend/shared/widgets/feedback/empty_state.dart';
import 'package:frantend/features/roles/presentation/widgets/role_permissions_panel.dart';
import 'package:frantend/shared/widgets/badges/status_badge.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/buttons/secondary_button.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

class RoleFormPage extends StatelessWidget {
  const RoleFormPage({super.key, this.roleId});

  final String? roleId;

  bool get isEdit => roleId != null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<RoleFormCubit>();
        if (roleId != null) {
          cubit.loadForEdit(roleId!);
        } else {
          cubit.initCreate();
        }
        return cubit;
      },
      child: _RoleFormView(isEdit: isEdit),
    );
  }
}

class _RoleFormView extends StatelessWidget {
  const _RoleFormView({required this.isEdit});

  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RoleFormCubit, RoleFormState>(
      listenWhen: (previous, current) =>
          current.errors.containsKey('_general'),
      listener: (context, state) {
        final err = state.errors['_general'];
        if (err != null) AppAlerts.showErrorMessage(context, err);
      },
      builder: (context, state) {
        if (state.accessDenied) {
          return const EmptyState(
            icon: Icons.lock_outline,
            message: "You don't have permission to manage roles",
          );
        }

        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
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
                            onPressed: state.isSubmitting || state.isDeleting
                                ? null
                                : () => context.pop(),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              isEdit ? 'Edit Role' : 'Create Role',
                              style: AppTextStyles.headlineMedium,
                            ),
                          ),
                          if (isEdit)
                            StatusBadge(
                              label: state.isSystem ? 'System' : 'Custom',
                              color: state.isSystem
                                  ? AppColors.info
                                  : AppColors.textSecondary,
                            ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spacingLg),
                      _FormCard(
                        title: 'Role Details',
                        child: _RoleDetailsFields(state: state, isEdit: isEdit),
                      ),
                      const SizedBox(height: AppDimensions.spacingMd),
                      _FormCard(
                        title: 'Access Permissions',
                        child: RolePermissionsPanel(state: state),
                      ),
                      if (isEdit && !state.isSystem) ...[
                        const SizedBox(height: AppDimensions.spacingMd),
                        OutlinedButton.icon(
                          onPressed: state.isDeleting || state.isSubmitting
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
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.delete_outline, size: 18),
                          label: const Text('Delete Role'),
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
              child: _BottomBar(state: state, isEdit: isEdit),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, RoleFormState state) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Delete ${state.name}?',
      message:
          'Users assigned to this role will need to be reassigned. This cannot be undone.',
    );
    if (ok != true || !context.mounted) return;

    final err = await context.read<RoleFormCubit>().deleteRole();
    if (!context.mounted) return;
    if (err != null) {
      AppAlerts.showErrorMessage(context, err);
    } else {
      AppAlerts.showSuccessMessage(context, 'Role deleted');
      context.pop(true);
    }
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: AppTextStyles.titleMedium),
          const SizedBox(height: AppDimensions.spacingMd),
          child,
        ],
      ),
    );
  }
}

class _RoleDetailsFields extends StatefulWidget {
  const _RoleDetailsFields({required this.state, required this.isEdit});

  final RoleFormState state;
  final bool isEdit;

  @override
  State<_RoleDetailsFields> createState() => _RoleDetailsFieldsState();
}

class _RoleDetailsFieldsState extends State<_RoleDetailsFields> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.state.name);
    _descriptionController =
        TextEditingController(text: widget.state.description);
  }

  @override
  void didUpdateWidget(covariant _RoleDetailsFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.name != widget.state.name &&
        _nameController.text != widget.state.name) {
      _nameController.text = widget.state.name;
    }
    if (oldWidget.state.description != widget.state.description &&
        _descriptionController.text != widget.state.description) {
      _descriptionController.text = widget.state.description;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RoleFormCubit>();
    final state = widget.state;
    final nameReadOnly = widget.isEdit && state.isSystem;

    return Column(
      children: [
        TextField(
          enabled: !nameReadOnly,
          decoration: InputDecoration(
            labelText: 'Role Name *',
            errorText: state.errors['name'],
            helperText: nameReadOnly
                ? 'System role names cannot be changed'
                : null,
          ),
          controller: _nameController,
          onChanged: nameReadOnly ? null : cubit.updateName,
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Description',
            helperText: 'Optional — helps staff understand this role',
          ),
          controller: _descriptionController,
          maxLines: 2,
          onChanged: cubit.updateDescription,
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.state, required this.isEdit});

  final RoleFormState state;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RoleFormCubit>();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SecondaryButton(
            label: 'Cancel',
            onPressed: state.isSubmitting || state.isDeleting
                ? null
                : () => context.pop(),
          ),
          const SizedBox(width: 12),
          PrimaryButton(
            label: isEdit ? 'Save Changes' : 'Create Role',
            isLoading: state.isSubmitting,
            fullWidth: false,
            onPressed: state.isSubmitting || state.isDeleting
                ? null
                : () async {
                    final err = await cubit.submit();
                    if (!context.mounted) return;
                    if (err != null) {
                      AppAlerts.showErrorMessage(context, err);
                    } else {
                      AppAlerts.showSuccessMessage(
                        context,
                        isEdit ? 'Role updated' : 'Role created',
                      );
                      context.pop(true);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
