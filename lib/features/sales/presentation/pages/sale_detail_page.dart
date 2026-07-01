import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/core/utils/date_formatter.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/presentation/cubit/sale_detail_cubit.dart';
import 'package:frantend/features/sales/presentation/cubit/sale_detail_state.dart';
import 'package:frantend/features/sales/presentation/services/sale_receipt_service.dart';
import 'package:frantend/features/sales/presentation/utils/sale_calculations.dart';
import 'package:frantend/features/sales/presentation/utils/sale_line_display.dart';
import 'package:frantend/features/sales/presentation/widgets/sale_list_cells.dart';
import 'package:frantend/features/sales/presentation/widgets/sale_status_chip.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/features/sales/presentation/widgets/void_sale_dialog.dart';
import 'package:frantend/shared/widgets/tables/app_table_cells.dart';
import 'package:frantend/utils/app_alerts.dart';
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
      listenWhen: (previous, current) =>
          current is SaleDetailError ||
          (current is SaleDetailLoaded && current.voidError != null),
      listener: (context, state) {
        if (state is SaleDetailError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
        if (state is SaleDetailLoaded && state.voidError != null) {
          AppAlerts.showErrorMessage(context, state.voidError!);
          context.read<SaleDetailCubit>().clearVoidError();
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

  Future<void> _voidSale(BuildContext context) async {
    final sale = state.sale;
    final confirmNumber = sale.saleNumber ?? sale.id;
    final ok = await VoidSaleDialog.show(
      context,
      saleNumber: confirmNumber,
    );
    if (ok != true || !context.mounted) return;

    final success = await context.read<SaleDetailCubit>().voidSale();
    if (success && context.mounted) {
      AppAlerts.showSuccessMessage(context, 'Sale voided');
    }
  }

  @override
  Widget build(BuildContext context) {
    final sale = state.sale;
    final customerName = state.customer?.name ??
        (sale.customerId == null ? 'Walk-in Customer' : 'Customer');
    final balanceDue = SaleCalculations.balanceDue(sale);
    final invoiceLabel = sale.saleNumber ?? sale.id.substring(0, 8);
    final canCancel = SaleStatus.canCancel(sale.saleStatus) && state.canCancelSales;
    final canVoid = state.canVoid;
    final canProcessReturn =
        SaleStatus.canReturn(sale.saleStatus) && state.canCreateReturn;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SaleDetailTopBar(
            invoiceLabel: invoiceLabel,
            canCancel: canCancel,
            canVoid: canVoid,
            isCancelling: state.isCancelling,
            isVoiding: state.isVoiding,
            onCancel: canCancel ? () => _cancelSale(context) : null,
            onVoid: canVoid ? () => _voidSale(context) : null,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 960;
              final mainColumn = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SaleInvoiceHeaderCard(
                    sale: sale,
                    invoiceLabel: invoiceLabel,
                    customerName: customerName,
                    balanceDue: balanceDue,
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),
                  _SaleLineItemsCard(sale: sale),
                  const SizedBox(height: AppDimensions.spacingMd),
                  _SalePaymentsCard(
                    sale: sale,
                    balanceDue: balanceDue,
                  ),
                ],
              );
              final sideColumn = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SaleActionsCard(
                    sale: sale,
                    isCancelling: state.isCancelling,
                    isVoiding: state.isVoiding,
                    canVoid: canVoid,
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
                    onReturn: canProcessReturn
                        ? () =>
                            context.push(RouteNames.saleReturnPath(sale.id))
                        : null,
                    onVoid: canVoid ? () => _voidSale(context) : null,
                    onCancel: canCancel ? () => _cancelSale(context) : null,
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),
                  _SaleInvoiceSummaryCard(
                    sale: sale,
                    balanceDue: balanceDue,
                  ),
                ],
              );

              if (stacked) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    mainColumn,
                    const SizedBox(height: AppDimensions.spacingMd),
                    sideColumn,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 65, child: mainColumn),
                  const SizedBox(width: AppDimensions.spacingMd),
                  Expanded(flex: 35, child: sideColumn),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SaleDetailTopBar extends StatelessWidget {
  const _SaleDetailTopBar({
    required this.invoiceLabel,
    required this.canCancel,
    required this.canVoid,
    required this.isCancelling,
    required this.isVoiding,
    this.onCancel,
    this.onVoid,
  });

  final String invoiceLabel;
  final bool canCancel;
  final bool canVoid;
  final bool isCancelling;
  final bool isVoiding;
  final VoidCallback? onCancel;
  final VoidCallback? onVoid;

  @override
  Widget build(BuildContext context) {
    final hasMenuActions = canCancel || canVoid;
    final menuEnabled = !isCancelling && !isVoiding;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => context.pop(),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                ),
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text(
                  'Back to Sales',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Invoice $invoiceLabel',
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (hasMenuActions)
          PopupMenuButton<String>(
            enabled: menuEnabled,
            onSelected: (value) {
              if (value == 'cancel') onCancel?.call();
              if (value == 'void') onVoid?.call();
            },
            itemBuilder: (context) => [
              if (canVoid)
                const PopupMenuItem(
                  value: 'void',
                  child: Text(
                    'Void Sale',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              if (canCancel)
                const PopupMenuItem(
                  value: 'cancel',
                  child: Text('Cancel Sale'),
                ),
            ],
            child: _OutlinedToolbarButton(
              icon: Icons.more_horiz,
              label: 'More',
            ),
          )
        else
          _OutlinedToolbarButton(
            icon: Icons.more_horiz,
            label: 'More',
            onPressed: () => AppAlerts.showInfoMessage(
              context,
              'No additional actions',
            ),
          ),
      ],
    );
  }
}

class _OutlinedToolbarButton extends StatelessWidget {
  const _OutlinedToolbarButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

class _SaleInvoiceHeaderCard extends StatelessWidget {
  const _SaleInvoiceHeaderCard({
    required this.sale,
    required this.invoiceLabel,
    required this.customerName,
    required this.balanceDue,
  });

  final SaleResponseModel sale;
  final String invoiceLabel;
  final String customerName;
  final Decimal balanceDue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.brandingPanel,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      invoiceLabel,
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SaleStatusChip(status: sale.saleStatus),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final items = [
                _HeaderInfoItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Date',
                  value: _formatDate(sale.soldAt),
                ),
                _HeaderInfoItem(
                  icon: Icons.point_of_sale_outlined,
                  label: 'Type',
                  value: _saleTypeLabel(sale.saleType),
                ),
                _HeaderInfoItem(
                  icon: Icons.person_outline,
                  label: 'Customer',
                  value: customerName,
                ),
                _HeaderInfoItem(
                  icon: Icons.badge_outlined,
                  label: 'Sales Person',
                  value: '—',
                ),
                _HeaderInfoItem(
                  icon: Icons.payments_outlined,
                  label: 'Payment Status',
                  valueWidget: _PaymentStatusChip(balanceDue: balanceDue),
                ),
              ];

              if (constraints.maxWidth < 720) {
                return Wrap(
                  spacing: 24,
                  runSpacing: 16,
                  children: items,
                );
              }

              return IntrinsicHeight(
                child: Row(
                  children: [
                    for (var i = 0; i < items.length; i++) ...[
                      if (i > 0)
                        const VerticalDivider(
                          color: AppColors.border,
                          width: 32,
                          thickness: 1,
                        ),
                      Expanded(child: items[i]),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SaleLineItemsCard extends StatelessWidget {
  const _SaleLineItemsCard({required this.sale});

  final SaleResponseModel sale;

  @override
  Widget build(BuildContext context) {
    final subtotal = sale.subtotal ??
        DecimalUtils.format(SaleCalculations.sumLines(sale.lines));

    return Container(
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              'Line Items',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: AppColors.brandingPanel,
            child: const Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text('Product', style: _tableHeaderStyle),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Quantity', style: _tableHeaderStyle),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Unit Price', style: _tableHeaderStyle),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Total',
                    style: _tableHeaderStyle,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          if (sale.lines.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No line items')),
            )
          else
            ...sale.lines.map(_SaleLineRow.new),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Subtotal: ${formatPKR(double.tryParse(subtotal) ?? 0)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'TOTAL: ${formatPKR(double.tryParse(sale.totalAmount) ?? 0)}',
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.brandingPanel,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SaleLineRow extends StatelessWidget {
  const _SaleLineRow(this.line);

  final SaleLineModel line;

  @override
  Widget build(BuildContext context) {
    final total = SaleCalculations.lineTotal(line);
    final name = SaleLineDisplay.label(line);
    final unitPrice = double.tryParse(line.unitPrice) ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                const AppTableProductThumb(size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${line.qty} × ${formatPKR(unitPrice)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (line.variationName != null &&
                          line.variationName!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: AppTableVariantBadge(
                            label: line.variationName!,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  line.qty,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatPKR(unitPrice),
              style: AppTextStyles.bodySmall,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatPKR(total.toDouble()),
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SalePaymentsCard extends StatelessWidget {
  const _SalePaymentsCard({
    required this.sale,
    required this.balanceDue,
  });

  final SaleResponseModel sale;
  final Decimal balanceDue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Payments',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (sale.payments.isEmpty)
            Text('No payments recorded', style: AppTextStyles.bodySmall)
          else
            ...sale.payments.map(
              (payment) => _PaymentRow(
                payment: payment,
                isPaid: balanceDue <= Decimal.zero,
              ),
            ),
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.payment, required this.isPaid});

  final SalePaymentModel payment;
  final bool isPaid;

  @override
  Widget build(BuildContext context) {
    final method = SalePaymentMethodLabels.labelFor(payment.paymentMethod);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.brandingPanel,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _paymentIcon(payment.paymentMethod),
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method.toUpperCase(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _formatDate(payment.paidAt),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (payment.referenceNo != null &&
                    payment.referenceNo!.isNotEmpty)
                  Text(
                    payment.referenceNo!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatPKR(double.tryParse(payment.amount) ?? 0),
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.brandingPanel,
                ),
              ),
              if (isPaid) ...[
                const SizedBox(height: 4),
                const _PaidBadge(),
              ],
            ],
          ),
        ],
      ),
    );
  }

  static IconData _paymentIcon(String method) => switch (method) {
        PaymentMethods.cash => Icons.payments_outlined,
        PaymentMethods.card => Icons.credit_card_outlined,
        PaymentMethods.wallet || PaymentMethods.upi => Icons.account_balance_wallet_outlined,
        PaymentMethods.bankTransfer => Icons.account_balance_outlined,
        _ => Icons.payment_outlined,
      };
}

class _SaleActionsCard extends StatelessWidget {
  const _SaleActionsCard({
    required this.sale,
    required this.isCancelling,
    required this.isVoiding,
    required this.canVoid,
    required this.onPrint,
    required this.onDownload,
    required this.onReturn,
    this.onVoid,
    this.onCancel,
  });

  final SaleResponseModel sale;
  final bool isCancelling;
  final bool isVoiding;
  final bool canVoid;
  final VoidCallback onPrint;
  final VoidCallback onDownload;
  final VoidCallback? onReturn;
  final VoidCallback? onVoid;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final showDangerZone = canVoid || onCancel != null;
    final actionsLocked = isCancelling || isVoiding;

    return Container(
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: AppColors.brandingPanel,
            child: const Row(
              children: [
                Icon(Icons.bolt, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Actions',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _ActionListTile(
                  icon: Icons.print_outlined,
                  label: 'Print Receipt',
                  onTap: actionsLocked ? null : onPrint,
                ),
                const SizedBox(height: 8),
                _ActionListTile(
                  icon: Icons.download_outlined,
                  label: 'Download PDF',
                  onTap: actionsLocked ? null : onDownload,
                ),
                const SizedBox(height: 8),
                _ActionListTile(
                  icon: Icons.undo_outlined,
                  label: 'Process Return',
                  subtitle: 'Refund specific items',
                  onTap: actionsLocked ||
                          onReturn == null ||
                          !SaleStatus.canReturn(sale.saleStatus)
                      ? null
                      : onReturn,
                ),
                if (showDangerZone) ...[
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Danger zone',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (canVoid) ...[
                  _ActionListTile(
                    icon: Icons.block,
                    label: isVoiding ? 'Voiding…' : 'Void Sale',
                    subtitle: 'Full reversal — irreversible',
                    onTap: actionsLocked ? null : onVoid,
                    destructive: true,
                  ),
                ],
                if (onCancel != null) ...[
                  if (canVoid) const SizedBox(height: 8),
                  _ActionListTile(
                    icon: Icons.cancel_outlined,
                    label: isCancelling ? 'Cancelling…' : 'Cancel Sale',
                    onTap: actionsLocked ? null : onCancel,
                    destructive: true,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SaleInvoiceSummaryCard extends StatelessWidget {
  const _SaleInvoiceSummaryCard({
    required this.sale,
    required this.balanceDue,
  });

  final SaleResponseModel sale;
  final Decimal balanceDue;

  @override
  Widget build(BuildContext context) {
    final subtotal = sale.subtotal ??
        DecimalUtils.format(SaleCalculations.sumLines(sale.lines));
    final paid = SaleCalculations.totalPaid(sale);
    final discount = sale.totalDiscount ?? '0';
    final tax = sale.totalTax ?? '0';

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.bar_chart_rounded,
                size: 20,
                color: AppColors.brandingPanel,
              ),
              const SizedBox(width: 8),
              Text(
                'Invoice Summary',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SummaryLine(label: 'Items', value: '${sale.lines.length}'),
          _SummaryLine(
            label: 'Subtotal',
            value: formatPKR(double.tryParse(subtotal) ?? 0),
          ),
          _SummaryLine(
            label: 'Discount',
            value: formatPKR(double.tryParse(discount) ?? 0),
          ),
          _SummaryLine(
            label: 'Tax',
            value: formatPKR(double.tryParse(tax) ?? 0),
          ),
          const Divider(height: 24),
          _SummaryLine(
            label: 'Total',
            value: formatPKR(double.tryParse(sale.totalAmount) ?? 0),
            emphasized: true,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _SummaryLine(
              label: 'Paid',
              value: formatPKR(paid.toDouble()),
              valueColor: AppColors.brandingPanel,
            ),
          ),
          const SizedBox(height: 8),
          _SummaryLine(
            label: 'Due',
            value: formatPKR(balanceDue.toDouble()),
            valueColor:
                balanceDue > Decimal.zero ? AppColors.warning : AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}

class _HeaderInfoItem extends StatelessWidget {
  const _HeaderInfoItem({
    required this.icon,
    required this.label,
    this.value,
    this.valueWidget,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              valueWidget ??
                  Text(
                    value ?? '—',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentStatusChip extends StatelessWidget {
  const _PaymentStatusChip({required this.balanceDue});

  final Decimal balanceDue;

  @override
  Widget build(BuildContext context) {
    final isPaid = balanceDue <= Decimal.zero;
    final color = isPaid ? AppColors.success : AppColors.warning;
    final label = isPaid ? 'Paid' : 'Due';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPaid ? Icons.check_circle_outline : Icons.schedule_outlined,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaidBadge extends StatelessWidget {
  const _PaidBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, size: 14, color: AppColors.success),
        const SizedBox(width: 4),
        Text(
          'Paid',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.success,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ActionListTile extends StatelessWidget {
  const _ActionListTile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? AppColors.error : AppColors.textPrimary;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: destructive && onTap != null
                  ? AppColors.error.withValues(alpha: 0.35)
                  : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: onTap == null ? AppColors.textSecondary : color,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: onTap == null
                              ? AppColors.textSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.emphasized = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool emphasized;
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
                fontWeight: emphasized ? FontWeight.bold : null,
              ),
            ),
          ),
          Text(
            value,
            style: (emphasized
                    ? AppTextStyles.headlineMedium
                    : AppTextStyles.bodyMedium)
                .copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor ??
                  (emphasized ? AppColors.brandingPanel : AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

const _tableHeaderStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontSize: 13,
);

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppColors.border),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

String _formatDate(String? value) {
  if (value == null || value.isEmpty) return '—';
  try {
    return DateFormatter.formatDateTime(DateTime.parse(value));
  } catch (_) {
    return value;
  }
}

String _saleTypeLabel(String type) {
  return switch (type.toLowerCase()) {
    'pos' => 'POS Sale',
    _ => type
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' '),
  };
}
