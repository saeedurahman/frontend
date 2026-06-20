import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/expenses/presentation/cubit/expense_categories_cubit.dart';
import 'package:frantend/features/expenses/presentation/cubit/expense_form_cubit.dart';
import 'package:frantend/features/expenses/presentation/cubit/expense_form_state.dart';
import 'package:frantend/features/expenses/presentation/utils/expense_calculations.dart';
import 'package:frantend/features/expenses/presentation/widgets/expense_status_chip.dart';
import 'package:frantend/features/expenses/presentation/widgets/quick_add_expense_category_dialog.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/buttons/secondary_button.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

class ExpenseFormPage extends StatelessWidget {
  const ExpenseFormPage({super.key, this.expenseId});

  final String? expenseId;

  bool get isEdit => expenseId != null;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ExpenseFormCubit>()..init(expenseId: expenseId),
        ),
        BlocProvider(
          create: (_) => sl<ExpenseCategoriesCubit>()..load(),
        ),
      ],
      child: _ExpenseFormView(isEdit: isEdit),
    );
  }
}

class _ExpenseFormView extends StatefulWidget {
  const _ExpenseFormView({required this.isEdit});

  final bool isEdit;

  @override
  State<_ExpenseFormView> createState() => _ExpenseFormViewState();
}

class _ExpenseFormViewState extends State<_ExpenseFormView> {
  late final TextEditingController _amountController;
  late final TextEditingController _taxController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _paymentAmountController;
  late final TextEditingController _referenceController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _taxController = TextEditingController(text: '0');
    _descriptionController = TextEditingController();
    _paymentAmountController = TextEditingController();
    _referenceController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _taxController.dispose();
    _descriptionController.dispose();
    _paymentAmountController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  void _syncControllers(ExpenseFormState state) {
    if (_amountController.text != state.amount) {
      _amountController.text = state.amount;
    }
    if (_taxController.text != state.taxAmount) {
      _taxController.text = state.taxAmount;
    }
    if (_descriptionController.text != state.description) {
      _descriptionController.text = state.description;
    }
    if (_paymentAmountController.text != state.paymentAmount) {
      _paymentAmountController.text = state.paymentAmount;
    }
    if (_referenceController.text != (state.referenceNo ?? '')) {
      _referenceController.text = state.referenceNo ?? '';
    }
  }

  Future<void> _pickDate(BuildContext context, ExpenseFormCubit cubit) async {
    final current = cubit.state.expenseDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) cubit.setExpenseDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpenseFormCubit, ExpenseFormState>(
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
        final cubit = context.read<ExpenseFormCubit>();
        final flatCategories = flattenExpenseCategories(state.categories);
        final showPaymentSection =
            !widget.isEdit && state.recordPaymentNow;
        final showPaymentToggle = !widget.isEdit;

        if (showPaymentSection &&
            state.paymentMethod == PaymentMethods.cash &&
            !state.isCheckingPaymentShift) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) cubit.checkPaymentShift();
          });
        }

        return Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 88),
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.isEdit ? 'Edit Expense' : 'New Expense',
                    style: AppTextStyles.headlineMedium,
                  ),
                  const SizedBox(height: AppDimensions.spacingLg),
                  _FormCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String?>(
                                initialValue: state.categoryId,
                                decoration: InputDecoration(
                                  labelText: 'Category *',
                                  errorText: state.errors['category'],
                                ),
                                items: flatCategories
                                    .map(
                                      (c) => DropdownMenuItem(
                                        value: c.id,
                                        child: Text(c.name),
                                      ),
                                    )
                                    .toList(),
                                onChanged: cubit.setCategoryId,
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: () async {
                                final created =
                                    await QuickAddExpenseCategoryDialog.show(
                                  context,
                                );
                                if (created != null && context.mounted) {
                                  cubit.appendCategory(created);
                                }
                              },
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('New Category'),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        DropdownButtonFormField<String?>(
                          initialValue: state.supplierId,
                          decoration: const InputDecoration(
                            labelText: 'Supplier (optional)',
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('None'),
                            ),
                            ...state.suppliers.map(
                              (s) => DropdownMenuItem(
                                value: s.id,
                                child: Text(s.name),
                              ),
                            ),
                          ],
                          onChanged: cubit.setSupplierId,
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _amountController,
                                keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*'),
                                  ),
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Amount *',
                                  errorText: state.errors['amount'],
                                ),
                                onChanged: cubit.setAmount,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _taxController,
                                keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*'),
                                  ),
                                ],
                                decoration: const InputDecoration(
                                  labelText: 'Tax amount',
                                ),
                                onChanged: cubit.setTaxAmount,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        InkWell(
                          onTap: () => _pickDate(context, cubit),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Expense Date *',
                              errorText: state.errors['expenseDate'],
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              state.expenseDate != null
                                  ? '${state.expenseDate!.day.toString().padLeft(2, '0')}/'
                                      '${state.expenseDate!.month.toString().padLeft(2, '0')}/'
                                      '${state.expenseDate!.year}'
                                  : 'Select date',
                            ),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingMd),
                        TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description *',
                            errorText: state.errors['description'],
                          ),
                          onChanged: cubit.setDescription,
                        ),
                      ],
                    ),
                  ),
                  if (showPaymentToggle) ...[
                    const SizedBox(height: AppDimensions.spacingMd),
                    _FormCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Record Payment Now'),
                            subtitle: const Text(
                              'Leave off to record an unpaid expense '
                              '(payment cannot be added later via API)',
                            ),
                            value: state.recordPaymentNow,
                            activeThumbColor: AppColors.primary,
                            onChanged: (v) {
                              cubit.setRecordPaymentNow(v);
                              if (v &&
                                  state.paymentMethod == PaymentMethods.cash) {
                                cubit.checkPaymentShift();
                              }
                            },
                          ),
                          if (showPaymentSection) ...[
                            const Divider(),
                            DropdownButtonFormField<String>(
                              initialValue: state.paymentMethod,
                              decoration: const InputDecoration(
                                labelText: 'Payment Method',
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: PaymentMethods.cash,
                                  child: Text('Cash'),
                                ),
                                DropdownMenuItem(
                                  value: PaymentMethods.card,
                                  child: Text('Card'),
                                ),
                                DropdownMenuItem(
                                  value: PaymentMethods.bankTransfer,
                                  child: Text('Bank Transfer'),
                                ),
                                DropdownMenuItem(
                                  value: PaymentMethods.wallet,
                                  child: Text('Wallet'),
                                ),
                                DropdownMenuItem(
                                  value: PaymentMethods.cheque,
                                  child: Text('Cheque'),
                                ),
                                DropdownMenuItem(
                                  value: PaymentMethods.other,
                                  child: Text('Other'),
                                ),
                              ],
                              onChanged: (v) {
                                if (v == null) return;
                                cubit.setPaymentMethod(v);
                                if (v == PaymentMethods.cash) {
                                  cubit.checkPaymentShift();
                                }
                              },
                            ),
                            const SizedBox(height: AppDimensions.spacingMd),
                            if (state.paymentMethod == PaymentMethods.cash)
                              CashShiftWarningBanner(
                                isChecking: state.isCheckingPaymentShift,
                                hasActiveShift:
                                    state.activePaymentShiftId != null,
                              ),
                            TextField(
                              controller: _paymentAmountController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*'),
                                ),
                              ],
                              decoration: InputDecoration(
                                labelText: 'Payment amount',
                                hintText: 'Defaults to full amount',
                                errorText: state.errors['paymentAmount'],
                              ),
                              onChanged: cubit.setPaymentAmount,
                            ),
                            if (state.paymentMethod != PaymentMethods.cash) ...[
                              const SizedBox(height: AppDimensions.spacingMd),
                              TextField(
                                controller: _referenceController,
                                decoration: InputDecoration(
                                  labelText: 'Reference No *',
                                  errorText: state.errors['referenceNo'],
                                ),
                                onChanged: (v) => cubit.setReferenceNo(v),
                              ),
                            ],
                          ],
                        ],
                      ),
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
              child: _ExpenseFormBottomBar(isEdit: widget.isEdit),
            ),
          ],
        );
      },
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _ExpenseFormBottomBar extends StatelessWidget {
  const _ExpenseFormBottomBar({required this.isEdit});

  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ExpenseFormCubit>().state;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SecondaryButton(
            label: 'Cancel',
            onPressed: state.isSaving ? null : () => context.pop(),
          ),
          const SizedBox(width: 12),
          PrimaryButton(
            label: isEdit ? 'Update Expense' : 'Save Expense',
            isLoading: state.isSaving,
            onPressed: state.isSaving
                ? null
                : () async {
                    final cubit = context.read<ExpenseFormCubit>();
                    final expense = await cubit.save();
                    if (!context.mounted) return;
                    if (expense != null) {
                      AppAlerts.showSuccessMessage(
                        context,
                        isEdit ? 'Expense updated' : 'Expense created',
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
