import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/accounting/data/models/chart_of_account_model.dart';
import 'package:frantend/features/accounting/domain/utils/account_type_subtype_map.dart';
import 'package:frantend/features/accounting/domain/utils/coa_form_payload.dart';
import 'package:frantend/features/accounting/presentation/cubit/coa_form_cubit.dart';
import 'package:frantend/features/accounting/presentation/cubit/coa_form_state.dart';
import 'package:frantend/features/accounting/presentation/widgets/account_parent_picker.dart';
import 'package:frantend/features/accounting/presentation/widgets/coa_system_badge.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/buttons/secondary_button.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

class CoaFormPage extends StatelessWidget {
  const CoaFormPage({super.key, this.accountId});

  final String? accountId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<CoaFormCubit>();
        if (accountId == null) {
          cubit.loadForCreate();
        } else {
          cubit.loadForEdit(accountId!);
        }
        return cubit;
      },
      child: _CoaFormView(isEdit: accountId != null),
    );
  }
}

class _CoaFormView extends StatefulWidget {
  const _CoaFormView({required this.isEdit});

  final bool isEdit;

  @override
  State<_CoaFormView> createState() => _CoaFormViewState();
}

class _CoaFormViewState extends State<_CoaFormView> {
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  var _fieldsInitialized = false;

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _syncControllers(CoaFormState state) {
    if (state.isLoading) return;
    if (!_fieldsInitialized) {
      _codeController.text = state.accountCode;
      _nameController.text = state.accountName;
      _descriptionController.text = state.description;
      _fieldsInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoaFormCubit, CoaFormState>(
      listenWhen: (p, c) => c.errors.containsKey('_general'),
      listener: (context, state) {
        final err = state.errors['_general'];
        if (err != null) AppAlerts.showErrorMessage(context, err);
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        _syncControllers(state);
        final cubit = context.read<CoaFormCubit>();
        final readOnly = state.isReadOnly;

        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: state.canManage ? 88 : AppDimensions.spacingLg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.isEdit
                            ? (readOnly ? 'View Account' : 'Edit Account')
                            : 'New Account',
                        style: AppTextStyles.headlineMedium,
                      ),
                      if (state.isSystem) ...[
                        const SizedBox(width: 12),
                        const CoaSystemBadge(),
                      ],
                    ],
                  ),
                  if (readOnly) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Read-only — you do not have permission to modify accounts.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppDimensions.spacingLg),
                  _FormCard(
                    title: 'Account Details',
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _codeController,
                                enabled: !readOnly && !state.isSystem,
                                decoration: InputDecoration(
                                  labelText: 'Account code *',
                                  errorText: state.errors['account_code'],
                                  helperText: state.isSystem
                                      ? 'System account codes cannot be changed'
                                      : null,
                                ),
                                onChanged: cubit.updateAccountCode,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: _nameController,
                                enabled: !readOnly,
                                decoration: InputDecoration(
                                  labelText: 'Account name *',
                                  errorText: state.errors['account_name'],
                                ),
                                onChanged: cubit.updateAccountName,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: state.accountType,
                                decoration: InputDecoration(
                                  labelText: 'Account type *',
                                  errorText: state.errors['account_type'],
                                ),
                                items: AccountType.all
                                    .map(
                                      (type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(formatAccountType(type)),
                                      ),
                                    )
                                    .toList(),
                                onChanged: readOnly
                                    ? null
                                    : (value) {
                                        if (value != null) {
                                          cubit.updateAccountType(value);
                                        }
                                      },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<String?>(
                                value: subtypesForAccountType(state.accountType)
                                        .contains(state.accountSubtype)
                                    ? state.accountSubtype
                                    : null,
                                decoration: const InputDecoration(
                                  labelText: 'Account subtype',
                                ),
                                items: subtypesForAccountType(state.accountType)
                                    .map(
                                      (subtype) => DropdownMenuItem(
                                        value: subtype,
                                        child: Text(
                                          formatAccountSubtype(subtype),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: readOnly ? null : cubit.updateAccountSubtype,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        AccountParentPicker(
                          value: state.parentId,
                          options: cubit.parentPickerOptions(),
                          enabled: !readOnly,
                          onChanged: cubit.updateParentId,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _descriptionController,
                          enabled: !readOnly,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                          ),
                          maxLines: 2,
                          onChanged: cubit.updateDescription,
                        ),
                        const SizedBox(height: 8),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Active'),
                          value: state.isActive,
                          onChanged: readOnly ? null : cubit.updateIsActive,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (state.canManage)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _BottomBar(state: state, isEdit: widget.isEdit),
              ),
          ],
        );
      },
    );
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
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
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

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.state, required this.isEdit});

  final CoaFormState state;
  final bool isEdit;

  Future<void> _save(BuildContext context) async {
    final ok = await context.read<CoaFormCubit>().submit();
    if (!context.mounted) return;
    if (ok == true) {
      AppAlerts.showSuccessMessage(
        context,
        isEdit ? 'Account updated' : 'Account created',
      );
      context.pop(true);
    }
  }

  Future<void> _delete(BuildContext context) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Delete account?',
      message:
          'This cannot be undone. Accounts with child accounts or journal lines cannot be deleted.',
    );
    if (ok != true || !context.mounted) return;

    final deleted = await context.read<CoaFormCubit>().deleteAccount();
    if (!context.mounted) return;
    if (deleted == true) {
      AppAlerts.showSuccessMessage(context, 'Account deleted');
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingLg,
          vertical: AppDimensions.spacingMd,
        ),
        child: Row(
          children: [
            if (isEdit && !state.isSystem)
              SecondaryButton(
                label: 'Delete',
                onPressed: state.isSubmitting || state.isDeleting
                    ? null
                    : () => _delete(context),
              ),
            const Spacer(),
            SecondaryButton(
              label: 'Cancel',
              onPressed: state.isSubmitting || state.isDeleting
                  ? null
                  : () => context.pop(),
            ),
            const SizedBox(width: 12),
            PrimaryButton(
              label: isEdit ? 'Save' : 'Create Account',
              fullWidth: false,
              isLoading: state.isSubmitting,
              onPressed: state.isDeleting ? null : () => _save(context),
            ),
          ],
        ),
      ),
    );
  }
}
