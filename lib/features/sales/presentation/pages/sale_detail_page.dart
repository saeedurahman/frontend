import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/core/utils/date_formatter.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/presentation/cubit/sale_detail_cubit.dart';
import 'package:frantend/features/sales/presentation/cubit/sale_detail_state.dart';
import 'package:frantend/features/sales/presentation/services/sale_receipt_service.dart';
import 'package:frantend/features/sales/presentation/utils/sale_calculations.dart';
import 'package:frantend/features/sales/presentation/widgets/sale_status_chip.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:go_router/go_router.dart';

class SaleDetailPage extends StatelessWidget {
  const SaleDetailPage({super.key, required this.saleId});

  final String saleId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SaleDetailCubit>()..load(saleId),
      child: _SaleDetailView(saleId: saleId),
    );
  }
}

class _SaleDetailView extends StatelessWidget {
  const _SaleDetailView({required this.saleId});

  final String saleId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaleDetailCubit, SaleDetailState>(
      listener: (context, state) {
        if (state is SaleDetailError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        return switch (state) {
          SaleDetailInitial() || SaleDetailLoading() =>
            const Center(child: CircularProgressIndicator()),
          SaleDetailError(:final message) => Center(
              child: Text(message, style: AppTextStyles.bodyMedium),
            ),
          SaleDetailLoaded loaded => _LoadedView(state: loaded),
        };
      },
    );
  }
}

class _LoadedView extends StatelessWidget {
  const _LoadedView({required this.state});

  final SaleDetailLoaded state;

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return '—';
    try {
      return DateFormatter.formatDateTime(DateTime.parse(value));
    } catch (_) {
      return value;
    }
  }

  Future<void> _cancelSale(BuildContext context) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Cancel this sale?',
      message:
          'Stock will be restored. This cannot be undone for completed sales.',
    );
    if (ok != true || !context.mounted) return;

    final success = await context.read<SaleDetailCubit>().cancelSale();
    if (success && context.mounted) {
      AppAlerts.showSuccessMessage(context, 'Sale cancelled');
    }
  }

  @override
  Widget build(BuildContext context) {
    final sale = state.sale;
    final customerName =
        state.customer?.name ?? (sale.customerId == null ? 'Walk-in Customer' : 'Customer');
    final balanceDue = SaleCalculations.balanceDue(sale);

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => context.pop(),
                        ),
                        Text(
                          'Invoice ${sale.saleNumber ?? sale.id.substring(0, 8)}',
                          style: AppTextStyles.headlineMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingMd),
                    _HeaderCard(
                      sale: sale,
                      customerName: customerName,
                      customerPhone: state.customer?.phone,
                      formatDate: _formatDate,
                    ),
                    const SizedBox(height: AppDimensions.spacingMd),
                    _LinesCard(sale: sale),
                    const SizedBox(height: AppDimensions.spacingMd),
                    _SummaryCard(sale: sale, balanceDue: balanceDue),
                    const SizedBox(height: AppDimensions.spacingMd),
                    _PaymentsCard(sale: sale, formatDate: _formatDate),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.spacingMd),
              Expanded(
                flex: 35,
                child: _ActionsCard(
                  sale: sale,
                  isCancelling: state.isCancelling,
                  onPrint: () => SaleReceiptService.printReceipt(sale),
                  onDownload: () async {
                    final file =
                        await SaleReceiptService.downloadPdf(context, sale);
                    if (context.mounted && file != null) {
                      AppAlerts.showSuccessMessage(
                        context,
                        'Saved to ${file.path}',
                      );
                    }
                  },
                  onReturn: () =>
                      context.push(RouteNames.saleReturnPath(sale.id)),
                  onCancel: SaleStatus.canCancel(sale.saleStatus)
                      ? () => _cancelSale(context)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.sale,
    required this.customerName,
    required this.customerPhone,
    required this.formatDate,
  });

  final SaleResponseModel sale;
  final String customerName;
  final String? customerPhone;
  final String Function(String?) formatDate;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                sale.saleNumber ?? sale.id.substring(0, 8),
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              SaleStatusChip(status: sale.saleStatus),
            ],
          ),
          const SizedBox(height: 12),
          Text('Date: ${formatDate(sale.soldAt)}', style: AppTextStyles.bodySmall),
          Text('Type: ${sale.saleType}', style: AppTextStyles.bodySmall),
          const SizedBox(height: 8),
          Text(customerName, style: AppTextStyles.titleMedium),
          if (customerPhone != null)
            Text(customerPhone!, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class _LinesCard extends StatelessWidget {
  const _LinesCard({required this.sale});

  final SaleResponseModel sale;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Line Items', style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          if (sale.lines.isEmpty)
            Text('No line items', style: AppTextStyles.bodySmall)
          else
            ...sale.lines.map((line) {
              final total = SaleCalculations.lineTotal(line);
              final name = line.productName ?? 'Product ${line.productId.substring(0, 8)}';
              final variation = line.variationName;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: AppTextStyles.bodyMedium),
                          if (variation != null)
                            Text(variation, style: AppTextStyles.bodySmall),
                          Text(
                            '${line.qty} × ${formatPKR(double.tryParse(line.unitPrice) ?? 0)}',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      formatPKR(total.toDouble()),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.sale, required this.balanceDue});

  final SaleResponseModel sale;
  final Decimal balanceDue;

  @override
  Widget build(BuildContext context) {
    final subtotal = sale.subtotal ??
        DecimalUtils.format(SaleCalculations.sumLines(sale.lines));

    return _Card(
      child: Column(
        children: [
          _SummaryRow('Subtotal', subtotal),
          if (sale.totalDiscount != null && sale.totalDiscount != '0')
            _SummaryRow('Discount', sale.totalDiscount!),
          if (sale.totalTax != null && sale.totalTax != '0')
            _SummaryRow('Tax', sale.totalTax!),
          const Divider(),
          _SummaryRow(
            'TOTAL',
            sale.totalAmount,
            bold: true,
            valueColor: AppColors.primary,
          ),
          if (balanceDue > Decimal.zero) ...[
            const SizedBox(height: 8),
            _SummaryRow(
              'Balance Due',
              DecimalUtils.format(balanceDue),
              valueColor: AppColors.warning,
              bold: true,
            ),
          ],
        ],
      ),
    );
  }
}

class _PaymentsCard extends StatelessWidget {
  const _PaymentsCard({required this.sale, required this.formatDate});

  final SaleResponseModel sale;
  final String Function(String?) formatDate;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Payments', style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          if (sale.payments.isEmpty)
            Text('No payments recorded', style: AppTextStyles.bodySmall)
          else
            ...sale.payments.map(
              (p) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.paymentMethod.toUpperCase(),
                            style: AppTextStyles.bodyMedium,
                          ),
                          if (p.referenceNo != null)
                            Text(p.referenceNo!, style: AppTextStyles.bodySmall),
                          Text(formatDate(p.paidAt), style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    Text(
                      formatPKR(double.tryParse(p.amount) ?? 0),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActionsCard extends StatelessWidget {
  const _ActionsCard({
    required this.sale,
    required this.isCancelling,
    required this.onPrint,
    required this.onDownload,
    required this.onReturn,
    this.onCancel,
  });

  final SaleResponseModel sale;
  final bool isCancelling;
  final VoidCallback onPrint;
  final VoidCallback onDownload;
  final VoidCallback onReturn;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Actions', style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onPrint,
            icon: const Icon(Icons.print_outlined),
            label: const Text('Print Receipt'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onDownload,
            icon: const Icon(Icons.download_outlined),
            label: const Text('Download PDF'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: SaleStatus.canReturn(sale.saleStatus) ? onReturn : null,
            icon: const Icon(Icons.undo_outlined),
            label: const Text('Process Return'),
          ),
          if (onCancel != null) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: isCancelling ? null : onCancel,
              icon: isCancelling
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cancel_outlined, color: AppColors.error),
              label: Text(
                'Cancel Sale',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
          if (sale.registerShiftId != null) ...[
            const SizedBox(height: 16),
            Text(
              'Shift: ${sale.registerShiftId!.substring(0, 8)}…',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

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
      child: child,
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(
    this.label,
    this.value, {
    this.bold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: bold ? FontWeight.bold : null,
              ),
            ),
          ),
          Text(
            formatPKR(double.tryParse(value) ?? 0),
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
