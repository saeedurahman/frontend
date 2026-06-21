import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_order_detail_cubit.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_order_detail_state.dart';
import 'package:frantend/features/purchases/presentation/widgets/purchase_status_chip.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
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
          PurchaseOrderDetailError(:final message) => Center(child: Text(message)),
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

  String _formatDate(String? value) =>
      value?.split('T').first ?? '—';

  @override
  Widget build(BuildContext context) {
    final order = state.order;
    final cubit = context.read<PurchaseOrderDetailCubit>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeaderCard(order: order),
          const SizedBox(height: AppDimensions.spacingMd),
          _ActionsBar(
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
            onReceive: () => context.push('${RouteNames.purchases}/$orderId/receive'),
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          _LinesTable(order: order),
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

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.order});

  final PurchaseOrderModel order;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(order.poNumber, style: AppTextStyles.headlineMedium),
              const SizedBox(width: 12),
              PurchaseStatusChip(status: order.status),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 24,
            runSpacing: 8,
            children: [
              _InfoItem(
                label: 'Supplier',
                value: order.supplier?.name ?? order.supplierId,
              ),
              _InfoItem(
                label: 'Ordered',
                value: order.orderedAt?.split('T').first ?? '—',
              ),
              _InfoItem(
                label: 'Expected',
                value: order.expectedAt?.split('T').first ?? '—',
              ),
              _InfoItem(
                label: 'Total',
                value: order.grandTotal.toStringAsFixed(2),
              ),
            ],
          ),
          if (order.notes != null && order.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('Notes', style: AppTextStyles.labelLarge),
            Text(order.notes!, style: AppTextStyles.bodySmall),
          ],
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        Text(value, style: AppTextStyles.titleMedium),
      ],
    );
  }
}

class _ActionsBar extends StatelessWidget {
  const _ActionsBar({
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
    final isCompleted = order.status == PurchaseOrderStatus.received;

    if (!canSubmit && !canCancel && !canReceive && !isCompleted) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        if (canSubmit)
          PrimaryButton(
            label: 'Submit Order',
            isLoading: isUpdating,
            fullWidth: false,
            onPressed: isUpdating ? null : onSubmit,
          ),
        if (canCancel) ...[
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: isUpdating ? null : onCancel,
            child: const Text('Cancel Order'),
          ),
        ],
        if (canReceive) ...[
          const SizedBox(width: 12),
          PrimaryButton(
            label: 'Receive Goods',
            isLoading: isUpdating,
            fullWidth: false,
            onPressed: isUpdating ? null : onReceive,
          ),
        ],
        if (isCompleted)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Completed',
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.success),
            ),
          ),
      ],
    );
  }
}

class _LinesTable extends StatelessWidget {
  const _LinesTable({required this.order});

  final PurchaseOrderModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text('Product', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Ordered', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Received', style: AppTextStyles.labelLarge)),
                Expanded(flex: 2, child: Text('Progress', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Cost', style: AppTextStyles.labelLarge)),
              ],
            ),
          ),
          ...order.lines.map((line) => _LineRow(line: line)),
        ],
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  const _LineRow({required this.line});

  final PurchaseLineModel line;

  @override
  Widget build(BuildContext context) {
    final ordered = double.tryParse(line.orderedQty) ?? 0;
    final received = double.tryParse(line.receivedQty) ?? 0;
    final progress = ordered > 0 ? (received / ordered).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.productName ?? line.productId,
                  style: AppTextStyles.titleMedium,
                ),
                if (line.variationName != null &&
                    line.variationName!.isNotEmpty)
                  Text(
                    line.variationName!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(child: Text(line.orderedQty, style: AppTextStyles.bodySmall)),
          Expanded(child: Text(line.receivedQty, style: AppTextStyles.bodySmall)),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.background,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 4),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(line.costPerUnit, style: AppTextStyles.bodySmall),
          ),
        ],
      ),
    );
  }
}
