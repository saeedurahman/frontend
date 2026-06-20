import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/core/utils/date_formatter.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/returns/data/models/refund_line_model.dart';
import 'package:frantend/features/returns/presentation/cubit/process_return_cubit.dart';
import 'package:frantend/features/returns/presentation/cubit/process_return_state.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/buttons/secondary_button.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

const _returnReasons = [
  'Defective',
  'Wrong Item',
  'Customer Changed Mind',
  'Damaged',
  'Other',
];

class ProcessReturnPage extends StatelessWidget {
  const ProcessReturnPage({super.key, required this.saleId});

  final String saleId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProcessReturnCubit>()..load(saleId),
      child: _ProcessReturnView(saleId: saleId),
    );
  }
}

class _ProcessReturnView extends StatelessWidget {
  const _ProcessReturnView({required this.saleId});

  final String saleId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProcessReturnCubit, ProcessReturnState>(
      listener: (context, state) {
        if (state.error != null && state.originalSale == null) {
          AppAlerts.showErrorMessage(context, state.error!);
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null && state.originalSale == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.error!, style: AppTextStyles.bodyMedium),
                const SizedBox(height: 16),
                SecondaryButton(
                  label: 'Back to Sale',
                  onPressed: () => context.go('/sales/$saleId'),
                ),
              ],
            ),
          );
        }

        final sale = state.originalSale;
        if (sale == null) {
          return const Center(child: Text('Sale not found'));
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 96),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _HeaderSection(state: state),
                      const SizedBox(height: AppDimensions.spacingMd),
                      _ReturnItemsCard(state: state),
                      const SizedBox(height: AppDimensions.spacingMd),
                      _ReasonCard(state: state),
                      const SizedBox(height: AppDimensions.spacingMd),
                      _RefundSummaryCard(state: state),
                      const SizedBox(height: AppDimensions.spacingMd),
                      _RefundMethodCard(state: state),
                      if (state.submitError != null) ...[
                        const SizedBox(height: AppDimensions.spacingMd),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            state.submitError!,
                            style: const TextStyle(color: AppColors.error),
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
              child: _BottomBar(state: state, saleId: saleId),
            ),
          ],
        );
      },
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.state});

  final ProcessReturnState state;

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return '—';
    try {
      return DateFormatter.formatDateTime(DateTime.parse(value));
    } catch (_) {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sale = state.originalSale!;
    final customerName = state.customer?.name ??
        (sale.customerId == null ? 'Walk-in Customer' : 'Customer');
    final invoice = sale.saleNumber ?? sale.id.substring(0, 8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            Text(
              'Process Return — Invoice $invoice',
              style: AppTextStyles.headlineMedium,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 48),
          child: Text(
            '${_formatDate(sale.soldAt ?? sale.createdAt)} · $customerName',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReturnItemsCard extends StatelessWidget {
  const _ReturnItemsCard({required this.state});

  final ProcessReturnState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProcessReturnCubit>();

    return _Card(
      title: 'Return Items',
      child: Column(
        children: [
          for (var i = 0; i < state.returnLines.length; i++)
            _ReturnLineRow(
              line: state.returnLines[i],
              onQtyChanged: (qty) => cubit.updateReturnQty(i, qty),
              onReturnAll: () => cubit.returnAll(i),
            ),
        ],
      ),
    );
  }
}

class _ReturnLineRow extends StatelessWidget {
  const _ReturnLineRow({
    required this.line,
    required this.onQtyChanged,
    required this.onReturnAll,
  });

  final ReturnLineFormItem line;
  final ValueChanged<Decimal> onQtyChanged;
  final VoidCallback onReturnAll;

  @override
  Widget build(BuildContext context) {
    final isFullyReturned = line.maxReturnableQty <= Decimal.zero;
    final isActive = !isFullyReturned && line.returnQtyDecimal > Decimal.zero;
    final variation = line.variationName;
    final title = variation == null || variation.isEmpty
        ? line.productName
        : '${line.productName} — $variation';

    return Opacity(
      opacity: isFullyReturned ? 0.55 : 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isFullyReturned
              ? AppColors.border.withValues(alpha: 0.15)
              : isActive
                  ? AppColors.primary.withValues(alpha: 0.04)
                  : AppColors.border.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isFullyReturned
                ? AppColors.border
                : isActive
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                color: isFullyReturned ? AppColors.textSecondary : null,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Originally Sold: ${line.originalQty}',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
                if (line.alreadyReturnedQtyDecimal > Decimal.zero)
                  Text(
                    'Already returned: ${line.alreadyReturnedQty}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
            if (isFullyReturned) ...[
              const SizedBox(height: 8),
              Text(
                'Fully returned',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ] else ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Return Qty',
                        border: const OutlineInputBorder(),
                        isDense: true,
                        helperText:
                            'Max ${DecimalUtils.format(line.maxReturnableQty)}',
                        helperStyle: AppTextStyles.bodySmall,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      controller: TextEditingController(
                        text: line.returnQtyDecimal > Decimal.zero
                            ? line.returnQty
                            : '',
                      )..selection = TextSelection.collapsed(
                          offset: line.returnQtyDecimal > Decimal.zero
                              ? line.returnQty.length
                              : 0,
                        ),
                      onChanged: (value) {
                        final parsed =
                            Decimal.tryParse(value) ?? Decimal.zero;
                        onQtyChanged(parsed);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: onReturnAll,
                    child: Text(
                      'Return All (${DecimalUtils.format(line.maxReturnableQty)})',
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Unit Price: ${formatPKR(line.unitPriceDecimal.toDouble())}',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Line Refund: ${formatPKR(line.lineRefundAmount.toDouble())}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isActive
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReasonCard extends StatelessWidget {
  const _ReasonCard({required this.state});

  final ProcessReturnState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProcessReturnCubit>();

    return _Card(
      title: 'Reason',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            value: state.reason,
            decoration: const InputDecoration(
              labelText: 'Return Reason *',
              border: OutlineInputBorder(),
            ),
            items: _returnReasons
                .map(
                  (reason) => DropdownMenuItem(
                    value: reason,
                    child: Text(reason),
                  ),
                )
                .toList(),
            onChanged: cubit.setReason,
          ),
          if (state.reason == 'Other') ...[
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Notes *',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              controller: TextEditingController(text: state.notes ?? '')
                ..selection = TextSelection.collapsed(
                  offset: (state.notes ?? '').length,
                ),
              onChanged: cubit.setNotes,
            ),
          ] else ...[
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              controller: TextEditingController(text: state.notes ?? '')
                ..selection = TextSelection.collapsed(
                  offset: (state.notes ?? '').length,
                ),
              onChanged: cubit.setNotes,
            ),
          ],
        ],
      ),
    );
  }
}

class _RefundSummaryCard extends StatelessWidget {
  const _RefundSummaryCard({required this.state});

  final ProcessReturnState state;

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Refund Summary',
      child: Row(
        children: [
          const Text('Total Return Amount:', style: AppTextStyles.titleMedium),
          const Spacer(),
          Text(
            formatPKR(state.totalReturnAmount.toDouble()),
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RefundMethodCard extends StatelessWidget {
  const _RefundMethodCard({required this.state});

  final ProcessReturnState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProcessReturnCubit>();
    final showNoShiftWarning = state.hasCashRefund &&
        !state.isCheckingShift &&
        state.activeShiftId == null;

    return _Card(
      title: 'Refund Method',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _refundMethodOptions.map((option) {
              return SizedBox(
                width: 140,
                child: OutlinedButton(
                  onPressed: () => cubit.addRefundLine(
                    method: option.method,
                    label: option.label,
                    walletLabel: option.walletLabel,
                  ),
                  child: Column(
                    children: [
                      Text(option.icon, style: const TextStyle(fontSize: 20)),
                      Text(option.label, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          if (showNoShiftWarning) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '⚠ No active shift — this cash refund won\'t appear in drawer reconciliation',
                style: TextStyle(color: AppColors.warning),
              ),
            ),
          ],
          const SizedBox(height: 16),
          ...state.refundLines.asMap().entries.map((entry) {
            final index = entry.key;
            final line = entry.value;
            return _RefundLineEditor(
              line: line,
              onRemove: () => cubit.removeRefundLine(index),
              onAmountChanged: (amount) =>
                  cubit.updateRefundLineAmount(index, amount),
            );
          }),
          const Divider(),
          _SummaryRow(
            'Total Return',
            formatPKR(state.totalReturnAmount.toDouble()),
          ),
          _SummaryRow(
            'Refund Allocated',
            formatPKR(state.totalRefundEntered.toDouble()),
          ),
          _SummaryRow(
            state.remainingToRefund <= Decimal.zero ? 'Fully Allocated' : 'Remaining',
            formatPKR(state.remainingToRefund.abs().toDouble()),
            valueColor: state.remainingToRefund <= Decimal.zero
                ? AppColors.success
                : AppColors.error,
          ),
        ],
      ),
    );
  }
}

class _RefundLineEditor extends StatelessWidget {
  const _RefundLineEditor({
    required this.line,
    required this.onRemove,
    required this.onAmountChanged,
  });

  final RefundLineModel line;
  final VoidCallback onRemove;
  final ValueChanged<Decimal> onAmountChanged;

  @override
  Widget build(BuildContext context) {
    final label = line.walletLabel ?? line.label ?? line.paymentMethod;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: AppTextStyles.bodyMedium),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              controller: TextEditingController(
                text: line.amount > Decimal.zero
                    ? DecimalUtils.format(line.amount)
                    : '',
              )..selection = TextSelection.collapsed(
                  offset: line.amount > Decimal.zero
                      ? DecimalUtils.format(line.amount).length
                      : 0,
                ),
              onChanged: (value) {
                onAmountChanged(Decimal.tryParse(value) ?? Decimal.zero);
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.error),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.state, required this.saleId});

  final ProcessReturnState state;
  final String saleId;

  Future<void> _confirm(BuildContext context) async {
    final response = await context.read<ProcessReturnCubit>().submitReturn();
    if (!context.mounted) return;

    if (response != null) {
      AppAlerts.showSuccessMessage(
        context,
        'Return ${response.returnNumber} processed successfully',
      );
      context.go('/sales/$saleId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        color: Colors.white,
        child: Row(
          children: [
            SecondaryButton(
              label: 'Cancel',
              onPressed: state.isSubmitting ? null : () => context.pop(),
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Confirm Return',
              fullWidth: false,
              onPressed: state.canSubmit && !state.isSubmitting
                  ? () => _confirm(context)
                  : null,
              isLoading: state.isSubmitting,
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, {this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _RefundMethodOption {
  const _RefundMethodOption({
    required this.method,
    required this.label,
    required this.icon,
    this.walletLabel,
  });

  final String method;
  final String label;
  final String icon;
  final String? walletLabel;
}

const _refundMethodOptions = [
  _RefundMethodOption(method: PaymentMethods.cash, label: 'Cash', icon: '💵'),
  _RefundMethodOption(method: PaymentMethods.card, label: 'Card', icon: '💳'),
  _RefundMethodOption(
    method: PaymentMethods.wallet,
    label: 'Easypaisa',
    icon: '📱',
    walletLabel: 'Easypaisa',
  ),
  _RefundMethodOption(
    method: PaymentMethods.wallet,
    label: 'JazzCash',
    icon: '📱',
    walletLabel: 'JazzCash',
  ),
  _RefundMethodOption(
    method: PaymentMethods.bankTransfer,
    label: 'Bank Transfer',
    icon: '🏦',
  ),
  _RefundMethodOption(
    method: PaymentMethods.cheque,
    label: 'Cheque',
    icon: '📝',
  ),
  _RefundMethodOption(
    method: PaymentMethods.other,
    label: 'Other',
    icon: '⋯',
  ),
];
