import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_orders_list_cubit.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_orders_list_state.dart';
import 'package:frantend/features/purchases/presentation/widgets/purchase_status_chip.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class PurchaseOrdersListPage extends StatelessWidget {
  const PurchaseOrdersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PurchaseOrdersListCubit>()..load(),
      child: const _PurchaseOrdersListView(),
    );
  }
}

class _PurchaseOrdersListView extends StatelessWidget {
  const _PurchaseOrdersListView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PurchaseOrdersListCubit, PurchaseOrdersListState>(
      listener: (context, state) {
        if (state is PurchaseOrdersListError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        final count = switch (state) {
          PurchaseOrdersListLoaded(:final filteredOrders) => filteredOrders.length,
          _ => 0,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Toolbar(total: count),
            const SizedBox(height: AppDimensions.spacingMd),
            if (state is PurchaseOrdersListLoaded) _FilterBar(state: state),
            const SizedBox(height: AppDimensions.spacingMd),
            Expanded(
              child: switch (state) {
                PurchaseOrdersListInitial() || PurchaseOrdersListLoading() =>
                  const _ShimmerTable(),
                PurchaseOrdersListLoaded(:final filteredOrders)
                    when filteredOrders.isEmpty =>
                  const Center(
                    child: Text('No purchase orders found'),
                  ),
                PurchaseOrdersListLoaded loaded => _OrdersTable(
                    orders: loaded.filteredOrders,
                  ),
                PurchaseOrdersListError(:final message) => Center(
                    child: Text(message, style: AppTextStyles.bodyMedium),
                  ),
              },
            ),
          ],
        );
      },
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Purchase Orders', style: AppTextStyles.headlineMedium),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '($total orders)',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
          ),
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () => context.push(RouteNames.purchaseOrderNew),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('New Purchase Order'),
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.state});

  final PurchaseOrdersListLoaded state;

  static const _statusTabs = [
    (null, 'All'),
    (PurchaseOrderStatus.draft, 'Draft'),
    (PurchaseOrderStatus.ordered, 'Submitted'),
    (PurchaseOrderStatus.partial, 'Partial'),
    (PurchaseOrderStatus.received, 'Completed'),
    (PurchaseOrderStatus.cancelled, 'Cancelled'),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PurchaseOrdersListCubit>();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: _statusTabs.map((tab) {
              final selected = state.statusFilter == tab.$1;
              return InkWell(
                onTap: () => cubit.filterByStatus(tab.$1),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tab.$2,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: selected ? Colors.white : AppColors.textSecondary,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(
          width: 220,
          child: DropdownButtonFormField<String?>(
            initialValue: state.supplierFilter,
            decoration: const InputDecoration(
              labelText: 'Supplier',
              filled: true,
              fillColor: Colors.white,
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('All Suppliers')),
              ...state.suppliers.map(
                (s) => DropdownMenuItem(value: s.id, child: Text(s.name)),
              ),
            ],
            onChanged: cubit.filterBySupplier,
          ),
        ),
      ],
    );
  }
}

class _OrdersTable extends StatelessWidget {
  const _OrdersTable({required this.orders});

  final List<PurchaseOrderModel> orders;

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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(child: Text('PO Number', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Supplier', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Ordered', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Expected', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Status', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Total', style: AppTextStyles.labelLarge)),
                SizedBox(width: 60, child: Text('Items', style: AppTextStyles.labelLarge)),
                const SizedBox(width: 40),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _OrderRow(order: order);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.order});

  final PurchaseOrderModel order;

  String _formatDate(String? value) {
    if (value == null) return '—';
    return value.split('T').first;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('${RouteNames.purchases}/${order.id}'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(order.poNumber, style: AppTextStyles.titleMedium),
              ),
              Expanded(
                child: Text(
                  order.supplier?.name ?? order.supplierId,
                  style: AppTextStyles.bodySmall,
                ),
              ),
              Expanded(
                child: Text(_formatDate(order.orderedAt), style: AppTextStyles.bodySmall),
              ),
              Expanded(
                child: Text(_formatDate(order.expectedAt), style: AppTextStyles.bodySmall),
              ),
              Expanded(child: PurchaseStatusChip(status: order.status)),
              Expanded(
                child: Text(
                  order.grandTotal.toStringAsFixed(2),
                  style: AppTextStyles.bodySmall,
                ),
              ),
              SizedBox(
                width: 60,
                child: Text('${order.lines.length}', style: AppTextStyles.bodySmall),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => context.push('${RouteNames.purchases}/${order.id}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerTable extends StatelessWidget {
  const _ShimmerTable();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: List.generate(
            5,
            (_) => Container(
              height: 64,
              margin: const EdgeInsets.all(12),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
