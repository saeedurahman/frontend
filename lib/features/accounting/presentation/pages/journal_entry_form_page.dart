import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/core/utils/date_formatter.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/accounting/presentation/cubit/journal_entry_form_cubit.dart';
import 'package:frantend/features/accounting/presentation/cubit/journal_entry_form_state.dart';
import 'package:frantend/features/accounting/presentation/widgets/journal_balance_footer.dart';
import 'package:frantend/features/accounting/presentation/widgets/journal_line_row.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/buttons/secondary_button.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

class JournalEntryFormPage extends StatelessWidget {
  const JournalEntryFormPage({super.key, this.entryId});

  final String? entryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<JournalEntryFormCubit>();
        if (entryId == null) {
          cubit.loadForCreate();
        } else {
          cubit.loadForEdit(entryId!);
        }
        return cubit;
      },
      child: _JournalEntryFormView(isEdit: entryId != null),
    );
  }
}

class _JournalEntryFormView extends StatefulWidget {
  const _JournalEntryFormView({required this.isEdit});

  final bool isEdit;

  @override
  State<_JournalEntryFormView> createState() => _JournalEntryFormViewState();
}

class _JournalEntryFormViewState extends State<_JournalEntryFormView> {
  final _descriptionController = TextEditingController();
  var _fieldsInitialized = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, JournalEntryFormCubit cubit) async {
    final state = cubit.state;
    final initial = DateTime.tryParse(state.entryDate) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      cubit.updateEntryDate(
        '${picked.year.toString().padLeft(4, '0')}-'
        '${picked.month.toString().padLeft(2, '0')}-'
        '${picked.day.toString().padLeft(2, '0')}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JournalEntryFormCubit, JournalEntryFormState>(
      listenWhen: (p, c) => c.errors.containsKey('_general'),
      listener: (context, state) {
        final err = state.errors['_general'];
        if (err != null) AppAlerts.showErrorMessage(context, err);
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!_fieldsInitialized && !state.isLoading) {
          _descriptionController.text = state.description;
          _fieldsInitialized = true;
        }

        final cubit = context.read<JournalEntryFormCubit>();
        final parsedDate = DateTime.tryParse(state.entryDate);

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.isEdit ? 'Edit Journal Entry' : 'New Journal Entry',
                      style: AppTextStyles.headlineMedium,
                    ),
                    const SizedBox(height: AppDimensions.spacingLg),
                    _FormCard(
                      title: 'Entry Details',
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => _pickDate(context, cubit),
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText: 'Entry date *',
                                      errorText: state.errors['entry_date'],
                                    ),
                                    child: Text(
                                      parsedDate != null
                                          ? DateFormatter.formatDate(parsedDate)
                                          : 'Select date',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                            ),
                            maxLines: 2,
                            onChanged: cubit.updateDescription,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingMd),
                    _FormCard(
                      title: 'Lines',
                      trailing: TextButton.icon(
                        onPressed: cubit.addLine,
                        icon: const Icon(Icons.add),
                        label: const Text('Add line'),
                      ),
                      child: Column(
                        children: [
                          if (state.errors['lines'] != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                state.errors['lines']!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ...state.lines.asMap().entries.map(
                            (entry) => JournalLineRow(
                              index: entry.key,
                              line: entry.value,
                              accounts: state.accounts,
                              error: state.errors['line_${entry.key}'],
                              onAccountChanged: (id) =>
                                  cubit.updateLineAccount(entry.key, id),
                              onSideChanged: (side) =>
                                  cubit.updateLineSide(entry.key, side),
                              onAmountChanged: (amount) =>
                                  cubit.updateLineAmount(entry.key, amount),
                              onDescriptionChanged: (description) =>
                                  cubit.updateLineDescription(
                                    entry.key,
                                    description,
                                  ),
                              onRemove: () => cubit.removeLine(entry.key),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            JournalBalanceFooter(summary: state.balanceSummary),
            if (state.canEdit)
              Material(
                elevation: 4,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingLg,
                    vertical: AppDimensions.spacingMd,
                  ),
                  child: Row(
                    children: [
                      if (widget.isEdit) ...[
                        SecondaryButton(
                          label: 'Delete',
                          onPressed: state.isSubmitting || state.isDeleting
                              ? null
                              : () => _delete(context),
                        ),
                        const Spacer(),
                      ] else
                        const Spacer(),
                      SecondaryButton(
                        label: 'Cancel',
                        onPressed: state.isSubmitting || state.isDeleting
                            ? null
                            : () => context.pop(),
                      ),
                      const SizedBox(width: 12),
                      PrimaryButton(
                        label: widget.isEdit ? 'Save draft' : 'Create draft',
                        fullWidth: false,
                        isLoading: state.isSubmitting,
                        onPressed: state.isDeleting ? null : () => _save(context),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _save(BuildContext context) async {
    final cubit = context.read<JournalEntryFormCubit>();
    final balance = cubit.state.balanceSummary;

    if (!balance.isBalanced) {
      final debit = formatPKR(
        double.tryParse(DecimalUtils.format(balance.totalDebit)) ?? 0,
      );
      final credit = formatPKR(
        double.tryParse(DecimalUtils.format(balance.totalCredit)) ?? 0,
      );
      final proceed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Unbalanced entry'),
          content: Text(
            "Debits ($debit) and credits ($credit) don't match. "
            'You can save as draft, but this entry cannot be posted until '
            'balanced. Continue saving?',
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Save Anyway'),
            ),
          ],
        ),
      );
      if (proceed != true || !context.mounted) return;
    }

    final ok = await cubit.submit();
    if (!context.mounted) return;
    if (ok == true) {
      AppAlerts.showSuccessMessage(context, 'Journal entry saved');
      context.pop(true);
    }
  }

  Future<void> _delete(BuildContext context) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Delete draft entry?',
      message: 'This draft journal entry will be permanently deleted.',
    );
    if (ok != true || !context.mounted) return;

    final deleted = await context.read<JournalEntryFormCubit>().deleteEntry();
    if (!context.mounted) return;
    if (deleted == true) {
      AppAlerts.showSuccessMessage(context, 'Journal entry deleted');
      context.pop(true);
    }
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

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
          Row(
            children: [
              Text(title, style: AppTextStyles.titleMedium),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          child,
        ],
      ),
    );
  }
}
