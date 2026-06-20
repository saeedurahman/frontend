import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_order_form_cubit.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_order_form_state.dart';
import 'package:frantend/features/purchases/presentation/widgets/quick_add_supplier_dialog.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_cubit.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/buttons/secondary_button.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

class PurchaseOrderFormPage extends StatelessWidget {
  const PurchaseOrderFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<PurchaseOrderFormCubit>()..init(),
        ),
        BlocProvider(create: (_) => sl<SuppliersListCubit>()),
      ],
      child: const _PurchaseOrderFormView(),
    );
  }
}

class _PurchaseOrderFormView extends StatelessWidget {
  const _PurchaseOrderFormView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PurchaseOrderFormCubit, PurchaseOrderFormState>(
      listenWhen: (p, c) => c.errors.containsKey('_general'),
      listener: (context, state) {
        final err = state.errors['_general'];
        if (err != null) AppAlerts.showErrorMessage(context, err);
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 88),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('New Purchase Order', style: AppTextStyles.headlineMedium),
                  const SizedBox(height: AppDimensions.spacingLg),
                  _HeaderCard(state: state),
                  const SizedBox(height: AppDimensions.spacingMd),
                  _LinesCard(state: state),
                  const SizedBox(height: AppDimensions.spacingMd),
                  _TotalsCard(state: state),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BottomBar(state: state),
            ),
          ],
        );
      },
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.state});

  final PurchaseOrderFormState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PurchaseOrderFormCubit>();

    return _FormCard(
      title: 'Order Details',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String?>(
                  initialValue: state.supplierId,
                  decoration: InputDecoration(
                    labelText: 'Supplier *',
                    errorText: state.errors['supplier'],
                  ),
                  items: state.suppliers
                      .map(
                        (s) => DropdownMenuItem(value: s.id, child: Text(s.name)),
                      )
                      .toList(),
                  onChanged: cubit.updateSupplierId,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Quick add supplier',
                onPressed: () async {
                  final created = await QuickAddSupplierDialog.show(context);
                  if (created != null) cubit.updateSupplierId(created.id);
                },
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Expected Date'),
                  subtitle: Text(
                    state.expectedAt?.toString().split(' ').first ?? 'Not set',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        initialDate: state.expectedAt ?? DateTime.now(),
                      );
                      if (picked != null) cubit.updateExpectedAt(picked);
                    },
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Notes'),
                  controller: TextEditingController(text: state.notes)
                    ..selection = TextSelection.collapsed(offset: state.notes.length),
                  onChanged: cubit.updateNotes,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LinesCard extends StatelessWidget {
  const _LinesCard({required this.state});

  final PurchaseOrderFormState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PurchaseOrderFormCubit>();

    return _FormCard(
      title: 'Line Items',
      trailing: TextButton.icon(
        onPressed: cubit.addLine,
        icon: const Icon(Icons.add),
        label: const Text('Add Line'),
      ),
      child: Column(
        children: [
          if (state.errors['lines'] != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                state.errors['lines']!,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
              ),
            ),
          ...state.lines.asMap().entries.map(
            (entry) => _LineRow(
              index: entry.key,
              line: entry.value,
              products: state.products,
              error: state.errors['line_${entry.key}'],
            ),
          ),
        ],
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  const _LineRow({
    required this.index,
    required this.line,
    required this.products,
    this.error,
  });

  final int index;
  final PurchaseLineFormItem line;
  final List<ProductListItemModel> products;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PurchaseOrderFormCubit>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String?>(
                  initialValue: line.productId,
                  decoration: const InputDecoration(labelText: 'Product'),
                  items: products
                      .map(
                        (p) => DropdownMenuItem(
                          value: p.id,
                          child: Text(p.name),
                        ),
                      )
                      .toList(),
                  onChanged: (id) {
                    if (id != null) cubit.selectProduct(index, id);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String?>(
                  initialValue: line.variationId,
                  decoration: const InputDecoration(labelText: 'Variation'),
                  items: line.variations
                      .map(
                        (v) => DropdownMenuItem(value: v.id, child: Text(v.name)),
                      )
                      .toList(),
                  onChanged: (id) => cubit.selectVariation(index, id),
                ),
              ),
              IconButton(
                onPressed: () => cubit.removeLine(index),
                icon: Icon(Icons.delete_outline, color: AppColors.error),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Ordered Qty'),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: line.orderedQty)
                    ..selection =
                        TextSelection.collapsed(offset: line.orderedQty.length),
                  onChanged: (v) =>
                      cubit.updateLine(index, line.copyWith(orderedQty: v)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Cost/Unit'),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: line.costPerUnit)
                    ..selection =
                        TextSelection.collapsed(offset: line.costPerUnit.length),
                  onChanged: (v) =>
                      cubit.updateLine(index, line.copyWith(costPerUnit: v)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Tax %'),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: line.taxRate)
                    ..selection =
                        TextSelection.collapsed(offset: line.taxRate.length),
                  onChanged: (v) =>
                      cubit.updateLine(index, line.copyWith(taxRate: v)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Line Total: ${line.lineSubtotal.toStringAsFixed(2)}',
                  style: AppTextStyles.titleMedium,
                ),
              ),
            ],
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                error!,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
              ),
            ),
        ],
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({required this.state});

  final PurchaseOrderFormState state;

  @override
  Widget build(BuildContext context) {
    return _FormCard(
      title: 'Totals',
      child: Column(
        children: [
          _TotalRow(label: 'Subtotal', value: state.subtotal),
          _TotalRow(label: 'Tax', value: state.taxTotal),
          const Divider(),
          _TotalRow(label: 'Grand Total', value: state.grandTotal, bold: true),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  final String label;
  final double value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: bold ? AppTextStyles.titleMedium : AppTextStyles.bodyMedium,
          ),
          Text(
            value.toStringAsFixed(2),
            style: bold ? AppTextStyles.titleMedium : AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
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

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.state});

  final PurchaseOrderFormState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PurchaseOrderFormCubit>();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SecondaryButton(
            label: 'Cancel',
            onPressed: state.isSubmitting ? null : () => context.pop(),
          ),
          const SizedBox(width: 12),
          SecondaryButton(
            label: 'Save as Draft',
            onPressed: state.isSubmitting
                ? null
                : () async {
                    final err = await cubit.submitDraft();
                    if (!context.mounted) return;
                    if (err != null) {
                      AppAlerts.showErrorMessage(context, err);
                    } else {
                      AppAlerts.showSuccessMessage(context, 'Draft saved');
                      context.pop(true);
                    }
                  },
          ),
          const SizedBox(width: 12),
          PrimaryButton(
            label: 'Save & Submit',
            isLoading: state.isSubmitting,
            fullWidth: false,
            onPressed: state.isSubmitting
                ? null
                : () async {
                    final err = await cubit.submitAndOrder();
                    if (!context.mounted) return;
                    if (err != null) {
                      AppAlerts.showErrorMessage(context, err);
                    } else {
                      AppAlerts.showSuccessMessage(context, 'Order submitted');
                      context.pop(true);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
