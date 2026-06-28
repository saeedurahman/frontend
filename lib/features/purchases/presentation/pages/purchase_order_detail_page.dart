import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/core/utils/date_formatter.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_order_detail_cubit.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_order_detail_state.dart';
import 'package:frantend/features/purchases/presentation/widgets/purchase_status_chip.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/shared/widgets/tables/app_table_cells.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';

class PurchaseOrderDetailPage extends StatelessWidget {
  const PurchaseOrderDetailPage({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PurchaseOrderDetailCubit>()..load(orderId),
      child: _PurchaseOrderDetailView(orderId: orderId),
    );
  }
}

class _PurchaseOrderDetailView extends StatelessWidget {
  const _PurchaseOrderDetailView({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PurchaseOrderDetailCubit, PurchaseOrderDetailState>(
      listener: (context, state) {
        if (state is PurchaseOrderDetailError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        return switch (state) {
          PurchaseOrderDetailInitial() || PurchaseOrderDetailLoading() =>
            const Center(child: CircularProgressIndicator()),
          PurchaseOrderDetailError(:final message) =>
            Center(child: Text(message)),
          PurchaseOrderDetailLoaded loaded => _DetailContent(
              state: loaded,
              orderId: orderId,
            ),
        };
      },
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.state, required this.orderId});

  final PurchaseOrderDetailLoaded state;
  final String orderId;

  @override
  Widget build(BuildContext context) {
    final order = state.order;
    final cubit = context.read<PurchaseOrderDetailCubit>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TopBar(
            order: order,
            isUpdating: state.isUpdating,
            onSubmit: () => _updateStatus(
              context,
              cubit,
              PurchaseOrderStatus.ordered,
              'Order submitted',
            ),
            onCancel: () async {
              final ok = await ConfirmDialog.show(
                context,
                title: 'Cancel order?',
                message: 'This purchase order will be cancelled.',
              );
              if (ok == true && context.mounted) {
                await _updateStatus(
                  context,
                  cubit,
                  PurchaseOrderStatus.cancelled,
                  'Order cancelled',
                );
              }
            },
            onReceive: () =>
                context.push('${RouteNames.purchases}/$orderId/receive'),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          _HeaderSummaryCard(order: order),
          const SizedBox(height: AppDimensions.spacingMd),
          _StatusTimelineCard(order: order),
          const SizedBox(height: AppDimensions.spacingMd),
          _ItemsTableCard(order: order),
          const SizedBox(height: AppDimensions.spacingMd),
          _SummaryGrid(order: order),
        ],
      ),
    );
  }

  Future<void> _updateStatus(
    BuildContext context,
    PurchaseOrderDetailCubit cubit,
    String status,
    String successMessage,
  ) async {
    final err = await cubit.updateStatus(status);
    if (!context.mounted) return;
    if (err != null) {
      AppAlerts.showErrorMessage(context, err);
    } else {
      AppAlerts.showSuccessMessage(context, successMessage);
    }
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.order,
    required this.isUpdating,
    required this.onSubmit,
    required this.onCancel,
    required this.onReceive,
  });

  final PurchaseOrderModel order;
  final bool isUpdating;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;
  final VoidCallback onReceive;

  @override
  Widget build(BuildContext context) {
    final canSubmit = order.status == PurchaseOrderStatus.draft;
    final canCancel = order.status == PurchaseOrderStatus.draft;
    final canReceive = order.status == PurchaseOrderStatus.ordered ||
        order.status == PurchaseOrderStatus.partial;
    final hasMoreActions = canSubmit || canCancel || canReceive;

    return Row(
      children: [
        TextButton.icon(
          onPressed: () => context.pop(),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
          icon: const Icon(Icons.arrow_back, size: 18),
          label: const Text(
            'Back to Purchase Orders',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
        const Spacer(),
        _OutlinedToolbarButton(
          icon: Icons.print_outlined,
          label: 'Print',
          onPressed: () => AppAlerts.showInfoMessage(
            context,
            'Print coming soon',
          ),
        ),
        const SizedBox(width: 8),
        if (hasMoreActions)
          PopupMenuButton<String>(
            enabled: !isUpdating,
            onSelected: (value) {
              switch (value) {
                case 'submit':
                  onSubmit();
                case 'cancel':
                  onCancel();
                case 'receive':
                  onReceive();
              }
            },
            itemBuilder: (context) => [
              if (canSubmit)
                const PopupMenuItem(
                  value: 'submit',
                  child: Text('Submit Order'),
                ),
              if (canReceive)
                const PopupMenuItem(
                  value: 'receive',
                  child: Text('Receive Goods'),
                ),
              if (canCancel)
                const PopupMenuItem(
                  value: 'cancel',
                  child: Text('Cancel Order'),
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

class _HeaderSummaryCard extends StatelessWidget {
  const _HeaderSummaryCard({required this.order});

  final PurchaseOrderModel order;

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
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        order.poNumber,
                        style: AppTextStyles.headlineMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    PurchaseStatusChip(status: order.status),
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
              final isNarrow = constraints.maxWidth < 720;
              if (isNarrow) {
                return Wrap(
                  spacing: 24,
                  runSpacing: 16,
                  children: _infoItems(order),
                );
              }
              return IntrinsicHeight(
                child: Row(
                  children: [
                    for (var i = 0; i < _infoItems(order).length; i++) ...[
                      if (i > 0)
                        const VerticalDivider(
                          color: AppColors.border,
                          width: 32,
                          thickness: 1,
                        ),
                      Expanded(child: _infoItems(order)[i]),
                    ],
                  ],
                ),
              );
            },
          ),
          if (order.notes != null && order.notes!.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 12),
            Text('Notes', style: AppTextStyles.labelLarge),
            const SizedBox(height: 4),
            Text(order.notes!, style: AppTextStyles.bodySmall),
          ],
        ],
      ),
    );
  }

  List<Widget> _infoItems(PurchaseOrderModel order) => [
        _HeaderInfoItem(
          icon: Icons.people_outline,
          label: 'Supplier',
          value: order.supplier?.name ?? order.supplierId,
        ),
        _HeaderInfoItem(
          icon: Icons.calendar_today_outlined,
          label: 'Order Date',
          value: _formatDisplayDate(order.orderedAt),
        ),
        _HeaderInfoItem(
          icon: Icons.event_outlined,
          label: 'Expected Date',
          value: _formatDisplayDate(order.expectedAt),
        ),
        _HeaderInfoItem(
          icon: Icons.payments_outlined,
          label: 'Total Amount',
          value: formatPKR(order.grandTotal),
        ),
      ];
}

class _HeaderInfoItem extends StatelessWidget {
  const _HeaderInfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 10),
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
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusTimelineCard extends StatelessWidget {
  const _StatusTimelineCard({required this.order});

  final PurchaseOrderModel order;

  @override
  Widget build(BuildContext context) {
    final statusInfo = _statusInfo(order.status);
    final createdDate = _formatDisplayDate(order.createdAt ?? order.orderedAt);
    final progressDate = _formatDisplayDate(order.orderedAt ?? order.updatedAt);
    final completedDate = _formatDisplayDate(order.updatedAt ?? order.orderedAt);

    final createdDone = true;
    final inProgressDone = order.status == PurchaseOrderStatus.ordered ||
        order.status == PurchaseOrderStatus.partial ||
        order.status == PurchaseOrderStatus.received;
    final completedDone = order.status == PurchaseOrderStatus.received;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      decoration: _cardDecoration(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 900;
          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StatusMessage(
                  icon: statusInfo.$1,
                  title: statusInfo.$2,
                  subtitle: statusInfo.$3,
                  color: statusInfo.$4,
                ),
                const SizedBox(height: 24),
                _TimelineRow(
                  createdDate: createdDate,
                  progressDate: progressDate,
                  completedDate: completedDate,
                  createdDone: createdDone,
                  inProgressDone: inProgressDone,
                  completedDone: completedDone,
                ),
              ],
            );
          }
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: _StatusMessage(
                  icon: statusInfo.$1,
                  title: statusInfo.$2,
                  subtitle: statusInfo.$3,
                  color: statusInfo.$4,
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                flex: 3,
                child: _TimelineRow(
                  createdDate: createdDate,
                  progressDate: progressDate,
                  completedDate: completedDate,
                  createdDone: createdDone,
                  inProgressDone: inProgressDone,
                  completedDone: completedDone,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  (IconData, String, String, Color) _statusInfo(String status) =>
      switch (status) {
        PurchaseOrderStatus.draft => (
            Icons.edit_outlined,
            'Draft',
            'This purchase order is still a draft.',
            AppColors.textSecondary,
          ),
        PurchaseOrderStatus.ordered => (
            Icons.autorenew,
            'In Progress',
            'Goods are expected from the supplier.',
            AppColors.info,
          ),
        PurchaseOrderStatus.partial => (
            Icons.inventory_2_outlined,
            'Partially Received',
            'Some items have been received.',
            AppColors.warning,
          ),
        PurchaseOrderStatus.received => (
            Icons.check_circle_outline,
            'Completed',
            'This purchase order has been completed.',
            AppColors.success,
          ),
        PurchaseOrderStatus.cancelled => (
            Icons.cancel_outlined,
            'Cancelled',
            'This purchase order was cancelled.',
            AppColors.error,
          ),
        _ => (
            Icons.info_outline,
            PurchaseStatusChip.labelFor(status),
            'Purchase order status update.',
            AppColors.textSecondary,
          ),
      };
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.createdDate,
    required this.progressDate,
    required this.completedDate,
    required this.createdDone,
    required this.inProgressDone,
    required this.completedDone,
  });

  final String createdDate;
  final String progressDate;
  final String completedDate;
  final bool createdDone;
  final bool inProgressDone;
  final bool completedDone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TimelineStep(
            icon: Icons.event_outlined,
            label: 'Created',
            date: createdDate,
            isDone: createdDone,
            showLineAfter: true,
            lineDone: inProgressDone || completedDone,
          ),
        ),
        Expanded(
          child: _TimelineStep(
            icon: Icons.history,
            label: 'In Progress',
            date: progressDate,
            isDone: inProgressDone,
            showLineAfter: true,
            lineDone: completedDone,
          ),
        ),
        Expanded(
          child: _TimelineStep(
            icon: Icons.check_circle_outline,
            label: 'Completed',
            date: completedDate,
            isDone: completedDone,
            showLineAfter: false,
            lineDone: false,
          ),
        ),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.icon,
    required this.label,
    required this.date,
    required this.isDone,
    required this.showLineAfter,
    required this.lineDone,
  });

  final IconData icon;
  final String label;
  final String date;
  final bool isDone;
  final bool showLineAfter;
  final bool lineDone;

  @override
  Widget build(BuildContext context) {
    final color = isDone ? AppColors.primary : AppColors.textSecondary;

    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: color),
            if (showLineAfter)
              Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  color: lineDone
                      ? AppColors.primary
                      : AppColors.border,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            date,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ItemsTableCard extends StatelessWidget {
  const _ItemsTableCard({required this.order});

  final PurchaseOrderModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Text(
                  'Items (${order.lines.length})',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () => AppAlerts.showInfoMessage(
                    context,
                    'Download coming soon',
                  ),
                  icon: const Icon(Icons.download_outlined, size: 18),
                  label: const Text('Download'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: AppColors.brandingPanel,
            child: const Row(
              children: [
                SizedBox(width: 36, child: Text('#', style: _tableHeaderStyle)),
                Expanded(flex: 4, child: Text('Product', style: _tableHeaderStyle)),
                Expanded(flex: 2, child: Text('Ordered', style: _tableHeaderStyle)),
                Expanded(flex: 2, child: Text('Received', style: _tableHeaderStyle)),
                Expanded(flex: 2, child: Text('Progress', style: _tableHeaderStyle)),
                Expanded(flex: 2, child: Text('Cost', style: _tableHeaderStyle, textAlign: TextAlign.right)),
              ],
            ),
          ),
          if (order.lines.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No items in this order')),
            )
          else
            ...order.lines.asMap().entries.map(
                  (entry) => _LineRow(index: entry.key + 1, line: entry.value),
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

class _LineRow extends StatelessWidget {
  const _LineRow({required this.index, required this.line});

  final int index;
  final PurchaseLineModel line;

  @override
  Widget build(BuildContext context) {
    final ordered = double.tryParse(line.orderedQty) ?? 0;
    final received = double.tryParse(line.receivedQty) ?? 0;
    final progress = ordered > 0 ? (received / ordered).clamp(0.0, 1.0) : 0.0;
    final variantLabel = (line.variationName != null &&
            line.variationName!.isNotEmpty)
        ? line.variationName!
        : 'Default';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 36,
            child: Text(
              '$index',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: AppTableProductCell(
              name: line.productName ?? line.productId,
              code: line.sku ?? line.productId,
              variantLabel: variantLabel,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${line.orderedQty} Units',
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${line.receivedQty} Units',
              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: AppColors.background,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatPKR(line.lineSubtotal),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.order});

  final PurchaseOrderModel order;

  @override
  Widget build(BuildContext context) {
    var totalOrdered = 0.0;
    var totalReceived = 0.0;
    for (final line in order.lines) {
      totalOrdered += double.tryParse(line.orderedQty) ?? 0;
      totalReceived += double.tryParse(line.receivedQty) ?? 0;
    }

    final cards = [
      _SummaryCard(
        icon: Icons.shopping_basket_outlined,
        label: 'Total Items',
        value: '${order.lines.length}',
      ),
      _SummaryCard(
        icon: Icons.inventory_2_outlined,
        label: 'Total Ordered',
        value: '${_formatQty(totalOrdered)} Units',
      ),
      _SummaryCard(
        icon: Icons.fact_check_outlined,
        label: 'Total Received',
        value: '${_formatQty(totalReceived)} Units',
      ),
      _SummaryCard(
        icon: Icons.payments_outlined,
        label: 'Total Cost',
        value: formatPKR(order.grandTotal),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 900;
        if (isNarrow) {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: cards
                .map(
                  (card) => SizedBox(
                    width: (constraints.maxWidth - 12) / 2,
                    child: card,
                  ),
                )
                .toList(),
          );
        }
        return Row(
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(child: cards[i]),
            ],
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
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
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() => BoxDecoration(
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

String _formatDisplayDate(String? value) {
  if (value == null || value.isEmpty) return '—';
  try {
    return DateFormatter.formatDate(DateTime.parse(value));
  } catch (_) {
    return value.split('T').first;
  }
}

String _formatQty(double qty) {
  if (qty == qty.roundToDouble()) {
    return qty.toStringAsFixed(0);
  }
  return qty.toStringAsFixed(4).replaceAll(RegExp(r'\.?0+$'), '');
}
