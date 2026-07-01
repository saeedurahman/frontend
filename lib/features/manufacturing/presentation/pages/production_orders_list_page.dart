import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/utils/date_formatter.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_state.dart';
import 'package:frantend/features/manufacturing/data/models/production_order_model.dart';
import 'package:frantend/features/manufacturing/presentation/cubit/production_orders_list_cubit.dart';
import 'package:frantend/features/manufacturing/presentation/cubit/production_orders_list_state.dart';
import 'package:frantend/features/manufacturing/presentation/utils/manufacturing_navigation.dart';
import 'package:frantend/features/manufacturing/presentation/widgets/production_status_chip.dart';
import 'package:frantend/shared/widgets/feedback/empty_state.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_paginated_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_table_cells.dart';
import 'package:frantend/shared/widgets/tables/app_table_pagination_helpers.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

const _productionTableColumns = [
  AppDataTableColumn(label: 'PRD #', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Status', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Product', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Recipe', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Qty', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Branch', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Started', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Completed', flex: 2, sortable: true),
];

class ProductionOrdersListPage extends StatelessWidget {
  const ProductionOrdersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductionOrdersListCubit>()..init(),
      child: BlocListener<BranchSelectorCubit, BranchSelectorState>(
        bloc: sl<BranchSelectorCubit>(),
        listenWhen: (previous, current) =>
            previous.selectedBranchId != current.selectedBranchId &&
            current.isInitialized,
        listener: (context, _) =>
            context.read<ProductionOrdersListCubit>().refresh(),
        child: const _ProductionOrdersListView(),
      ),
    );
  }
}

class _ProductionOrdersListView extends StatelessWidget {
  const _ProductionOrdersListView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductionOrdersListCubit, ProductionOrdersListState>(
      listener: (context, state) {
        if (state is ProductionOrdersListError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is ProductionOrdersListAccessDenied) {
          return const EmptyState(
            icon: Icons.lock_outline,
            message: "You don't have permission to view production orders",
          );
        }

        final count = switch (state) {
          ProductionOrdersListLoaded(:final filteredOrders) =>
            filteredOrders.length,
          _ => 0,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Toolbar(
              total: count,
              canCreate: state is ProductionOrdersListLoaded && state.canCreate,
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            if (state is ProductionOrdersListLoaded) _FilterBar(state: state),
            const SizedBox(height: AppDimensions.spacingMd),
            Expanded(
              child: switch (state) {
                ProductionOrdersListInitial() ||
                ProductionOrdersListLoading() =>
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100,
                    child: const AppDataTableShimmer(),
                  ),
                ProductionOrdersListLoaded(:final filteredOrders)
                    when filteredOrders.isEmpty =>
                  const EmptyState(
                    icon: Icons.precision_manufacturing_outlined,
                    message: 'No production orders found',
                  ),
                ProductionOrdersListLoaded loaded => _OrdersTable(
                    orders: loaded.filteredOrders,
                    branchNames: loaded.branchNames,
                  ),
                ProductionOrdersListError(:final message) =>
                  Center(child: Text(message)),
                ProductionOrdersListAccessDenied() => const SizedBox.shrink(),
              },
            ),
          ],
        );
      },
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.total, required this.canCreate});

  final int total;
  final bool canCreate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Production Orders', style: AppTextStyles.headlineMedium),
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
        OutlinedButton.icon(
          onPressed: () => openBomsList(context),
          icon: const Icon(Icons.menu_book_outlined, size: 18),
          label: const Text('Manage BOMs'),
        ),
        if (canCreate) ...[
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () async {
              final created = await context.push<bool>(
                RouteNames.manufacturingProductionNew,
              );
              if (created == true && context.mounted) {
                await context.read<ProductionOrdersListCubit>().refresh();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New Production Order'),
          ),
        ],
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.state});

  final ProductionOrdersListLoaded state;

  static const _statusTabs = [
    (null, 'All'),
    (ProductionOrderStatus.draft, 'Draft'),
    (ProductionOrderStatus.inProgress, 'In progress'),
    (ProductionOrderStatus.completed, 'Completed'),
    (ProductionOrderStatus.cancelled, 'Cancelled'),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductionOrdersListCubit>();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ..._statusTabs.map(
          (tab) => ChoiceChip(
            label: Text(tab.$2),
            selected: state.statusFilter == tab.$1,
            onSelected: (_) => cubit.filterByStatus(tab.$1),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: () async {
            final range = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (range != null) {
              cubit.setDateRange(from: range.start, to: range.end);
            }
          },
          icon: const Icon(Icons.date_range, size: 18),
          label: Text(
            state.dateFrom != null && state.dateTo != null
                ? '${DateFormatter.formatDate(state.dateFrom!)} – ${DateFormatter.formatDate(state.dateTo!)}'
                : 'Date range',
          ),
        ),
        if (state.dateFrom != null || state.dateTo != null)
          TextButton(
            onPressed: () => cubit.setDateRange(from: null, to: null),
            child: const Text('Clear dates'),
          ),
      ],
    );
  }
}

class _OrdersTable extends StatelessWidget {
  const _OrdersTable({
    required this.orders,
    required this.branchNames,
  });

  final List<ProductionOrderModel> orders;
  final Map<String, String> branchNames;

  String _formatDate(String? raw) {
    if (raw == null) return '—';
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return DateFormatter.formatDateTime(parsed.toLocal());
  }

  String _qtyLabel(ProductionOrderModel order) {
    if (order.status == ProductionOrderStatus.completed) {
      return '${order.qtyProduced} / ${order.qtyToProduce}';
    }
    return order.qtyToProduce;
  }

  int _sortCompare(ProductionOrderModel a, ProductionOrderModel b, int column) {
    return switch (column) {
      0 => a.productionNumber.compareTo(b.productionNumber),
      1 => a.status.compareTo(b.status),
      2 => a.bom.productName.compareTo(b.bom.productName),
      3 => a.bom.name.compareTo(b.bom.name),
      4 => a.qtyToProduce.compareTo(b.qtyToProduce),
      5 => a.branchId.compareTo(b.branchId),
      6 => (a.startedAt ?? '').compareTo(b.startedAt ?? ''),
      7 => (a.completedAt ?? '').compareTo(b.completedAt ?? ''),
      _ => 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    return AppPaginatedDataTable<ProductionOrderModel>(
      columns: _productionTableColumns,
      items: orders,
      itemId: (order) => order.id,
      itemLabel: 'orders',
      paginationMode: AppTablePaginationMode.summary,
      sortCompare: _sortCompare,
      onRowTap: (order) => context.push(
        RouteNames.manufacturingProductionDetailPath(order.id),
      ),
      rowBuilder: (context, order, {required selected, required onSelected}) {
        return AppDataTableRowLayout(
          columns: _productionTableColumns,
          selected: selected,
          onSelected: onSelected,
          cells: [
            Text(
              order.productionNumber,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            ProductionStatusChip(status: order.status),
            Text(order.bom.productName, maxLines: 2, overflow: TextOverflow.ellipsis),
            Text('${order.bom.name} v${order.bom.version}'),
            Text(_qtyLabel(order)),
            Text(branchNames[order.branchId] ?? order.branchId),
            Text(_formatDate(order.startedAt)),
            Text(_formatDate(order.completedAt)),
          ],
          actions: AppTableActionButton(
            icon: Icons.chevron_right,
            tooltip: 'View',
            onPressed: () => context.push(
              RouteNames.manufacturingProductionDetailPath(order.id),
            ),
          ),
        );
      },
    );
  }
}
