import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_orders_list_cubit.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_orders_list_state.dart';
import 'package:frantend/features/purchases/presentation/widgets/purchase_status_chip.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_data_table_pagination.dart';
import 'package:frantend/shared/widgets/tables/app_table_cells.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

const _purchaseOrderTableColumns = [
  AppDataTableColumn(label: 'PO Number', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Supplier', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Ordered', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Expected', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Status', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Total', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Items', flex: 1, sortable: true),
];
Future<void> openPurchaseOrderForm(BuildContext context) async {
  final created = await context.push<bool>(RouteNames.purchaseOrderNew);
  if (created == true && context.mounted) {
    await context.read<PurchaseOrdersListCubit>().refresh();
  }
}

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
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100,
                    child: const AppDataTableShimmer(),
                  ),                PurchaseOrdersListLoaded(:final filteredOrders)
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
          onPressed: () => openPurchaseOrderForm(context),
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

class _OrdersTable extends StatefulWidget {
  const _OrdersTable({required this.orders});

  final List<PurchaseOrderModel> orders;

  @override
  State<_OrdersTable> createState() => _OrdersTableState();
}

class _OrdersTableState extends State<_OrdersTable> {
  int? _sortColumn;
  bool _sortAscending = true;

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return '—';
    return value.split('T').first;
  }

  List<PurchaseOrderModel> get _sortedOrders {
    final orders = [...widget.orders];
    final column = _sortColumn;
    if (column == null) return orders;

    int compare<T extends Comparable<T>>(T a, T b) =>
        _sortAscending ? a.compareTo(b) : b.compareTo(a);

    orders.sort((a, b) {
      return switch (column) {
        0 => compare(a.poNumber.toLowerCase(), b.poNumber.toLowerCase()),
        1 => compare(
            (a.supplier?.name ?? a.supplierId).toLowerCase(),
            (b.supplier?.name ?? b.supplierId).toLowerCase(),
          ),
        2 => compare(
            (a.orderedAt ?? '').toLowerCase(),
            (b.orderedAt ?? '').toLowerCase(),
          ),
        3 => compare(
            (a.expectedAt ?? '').toLowerCase(),
            (b.expectedAt ?? '').toLowerCase(),
          ),
        4 => compare(a.status.toLowerCase(), b.status.toLowerCase()),
        5 => compare(a.grandTotal, b.grandTotal),
        6 => compare(a.lines.length, b.lines.length),
        _ => 0,
      };
    });
    return orders;
  }

  void _openOrder(BuildContext context, PurchaseOrderModel order) {
    context.push('${RouteNames.purchases}/${order.id}');
  }

  @override
  Widget build(BuildContext context) {
    final orders = _sortedOrders;
    final total = orders.length;

    return AppDataTable<PurchaseOrderModel>(
      columns: _purchaseOrderTableColumns,
      items: orders,
      itemId: (order) => order.id,
      onColumnSort: (index) {
        setState(() {
          if (_sortColumn == index) {
            _sortAscending = !_sortAscending;
          } else {
            _sortColumn = index;
            _sortAscending = true;
          }
        });
      },
      onRowTap: (order) => _openOrder(context, order),
      pagination: AppDataTablePaginationData(
        from: total == 0 ? 0 : 1,
        to: total,
        total: total,
        itemLabel: 'orders',
      ),
      rowBuilder: (context, order, {required selected, required onSelected}) {
        return AppDataTableRowLayout(
          columns: _purchaseOrderTableColumns,
          selected: selected,
          onSelected: onSelected,
          cells: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.poNumber,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (order.notes != null && order.notes!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    order.notes!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
            Text(
              order.supplier?.name ?? order.supplierId,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              _formatDate(order.orderedAt),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              _formatDate(order.expectedAt),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            PurchaseStatusChip(status: order.status),
            Text(
              formatPKR(order.grandTotal),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '${order.lines.length}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
          actions: AppTableActionButton(
            icon: Icons.chevron_right,
            tooltip: 'View',
            onPressed: () => _openOrder(context, order),
          ),
        );
      },
    );
  }
}