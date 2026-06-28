import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/core/utils/date_formatter.dart';
import 'package:frantend/features/sales/data/models/sale_list_item_model.dart';
import 'package:frantend/features/sales/presentation/cubit/sales_list_cubit.dart';
import 'package:frantend/features/sales/presentation/cubit/sales_list_state.dart';
import 'package:frantend/features/sales/presentation/utils/sale_calculations.dart';
import 'package:frantend/features/sales/presentation/utils/sale_line_display.dart';
import 'package:frantend/features/sales/presentation/widgets/sale_list_cells.dart';
import 'package:frantend/features/sales/presentation/widgets/sale_list_products_cell.dart';
import 'package:frantend/features/sales/presentation/widgets/sale_status_chip.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_paginated_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_table_cells.dart';
import 'package:frantend/shared/widgets/tables/app_table_pagination_helpers.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

const _salesTableColumns = [
  AppDataTableColumn(label: 'Invoice #', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Date/Time', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Customer', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Cashier', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Products', flex: 3, sortable: true),
  AppDataTableColumn(label: 'Payment', flex: 2, sortable: false),
  AppDataTableColumn(label: 'Total', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Status', flex: 1, sortable: true),
];

class SalesListPage extends StatelessWidget {
  const SalesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SalesListCubit>()..init(),
      child: const _SalesListView(),
    );
  }
}

class _SalesListView extends StatefulWidget {
  const _SalesListView();

  @override
  State<_SalesListView> createState() => _SalesListViewState();
}

class _SalesListViewState extends State<_SalesListView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SalesListCubit, SalesListState>(
      listener: (context, state) {
        if (state is SalesListError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        final total = switch (state) {
          SalesListLoaded(:final total) => total,
          _ => 0,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Toolbar(total: total),
            const SizedBox(height: AppDimensions.spacingMd),
            if (state is SalesListLoaded) _FilterBar(state: state),
            const SizedBox(height: AppDimensions.spacingMd),
            Expanded(
              child: switch (state) {
                SalesListInitial() || SalesListLoading() =>
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100,
                    child: const AppDataTableShimmer(),
                  ),
                SalesListLoaded(:final items) when items.isEmpty =>
                  _EmptyState(
                    hasFilters: state.hasActiveFilters,
                    onClear: () =>
                        context.read<SalesListCubit>().clearFilters(),
                  ),
                SalesListLoaded loaded => _SalesTable(state: loaded),
                SalesListError(:final message) => Center(
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
        Text('Sales', style: AppTextStyles.headlineMedium),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '($total sales)',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
          ),
        ),
        const Spacer(),
        OutlinedButton.icon(
          onPressed: () => AppAlerts.showInfoMessage(
            context,
            'Export coming soon',
          ),
          icon: const Icon(Icons.download_outlined, size: 18),
          label: const Text('Export'),
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.state});

  final SalesListLoaded state;

  static const _statusTabs = [
    (null, 'All'),
    (SaleStatus.completed, 'Completed'),
    (SaleStatus.partiallyPaid, 'Partially Paid'),
    (SaleStatus.draft, 'Draft'),
    (SaleStatus.cancelled, 'Cancelled'),
    (SaleStatus.voided, 'Voided'),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SalesListCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _datePresets(context, cubit, state),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _statusTabs.map((tab) {
              final selected = state.statusFilter == tab.$1;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(tab.$2),
                  selected: selected,
                  onSelected: (_) => cubit.applyStatusFilter(tab.$1),
                  selectedColor: AppColors.primary.withValues(alpha: 0.15),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            hintText: 'Search invoice number…',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: cubit.search,
        ),
      ],
    );
  }

  List<Widget> _datePresets(
    BuildContext context,
    SalesListCubit cubit,
    SalesListLoaded state,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final presets = [
      ('Today', today, today),
      ('Yesterday', today.subtract(const Duration(days: 1)),
          today.subtract(const Duration(days: 1))),
      ('Last 7 Days', today.subtract(const Duration(days: 6)), today),
      ('Last 30 Days', today.subtract(const Duration(days: 29)), today),
      ('This Month', DateTime(now.year, now.month, 1), today),
    ];

    return presets.map((preset) {
      final from = state.dateFrom;
      final to = state.dateTo;
      final matches = from != null &&
          to != null &&
          _sameDay(from, preset.$2) &&
          _sameDay(to, preset.$3);
      return ActionChip(
        label: Text(preset.$1),
        backgroundColor:
            matches ? AppColors.primary.withValues(alpha: 0.12) : null,
        onPressed: () => cubit.applyDateRange(preset.$2, preset.$3),
      );
    }).toList();
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _SalesTable extends StatelessWidget {
  const _SalesTable({required this.state});

  final SalesListLoaded state;

  static String _formatDate(String soldAt) {
    try {
      return DateFormatter.formatDateTime(DateTime.parse(soldAt));
    } catch (_) {
      return soldAt;
    }
  }

  static String _formatAmount(String? amount) {
    if (amount == null || amount.isEmpty) return '—';
    return formatPKR(double.tryParse(amount) ?? 0);
  }

  static int _sortCompare(SaleListItemModel a, SaleListItemModel b, int column) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);

    return switch (column) {
      0 => compare(
          a.saleNumber.toLowerCase(),
          b.saleNumber.toLowerCase(),
        ),
      1 => compare(a.soldAt.toLowerCase(), b.soldAt.toLowerCase()),
      2 => compare(
          (a.customerName ?? '').toLowerCase(),
          (b.customerName ?? '').toLowerCase(),
        ),
      3 => compare(
          (a.cashierName ?? '').toLowerCase(),
          (b.cashierName ?? '').toLowerCase(),
        ),
      4 => compare(
          SaleLineDisplay.summaryFromNames(a.productNames).toLowerCase(),
          SaleLineDisplay.summaryFromNames(b.productNames).toLowerCase(),
        ),
      6 => compare(
          double.tryParse(a.totalAmount ?? '0') ?? 0,
          double.tryParse(b.totalAmount ?? '0') ?? 0,
        ),
      7 => compare(a.status.toLowerCase(), b.status.toLowerCase()),
      _ => 0,
    };
  }

  void _openSale(BuildContext context, SaleListItemModel item) {
    context.push(RouteNames.saleDetailPath(item.id));
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SalesListCubit>();

    return AppPaginatedDataTable<SaleListItemModel>(
      columns: _salesTableColumns,
      items: state.items,
      itemId: (item) => item.id,
      itemLabel: 'sales',
      paginationMode: AppTablePaginationMode.server,
      sortCompare: _sortCompare,
      skip: state.skip,
      total: state.total,
      limit: [10, 25, 50].contains(state.limit) ? state.limit : cubit.pageSize,
      currentPage: cubit.currentPage(state),
      totalPages: cubit.totalPages(state),
      onPageSizeChanged: cubit.setPageSize,
      onGoToPage: cubit.goToPage,
      onRowTap: (item) => _openSale(context, item),
      rowBuilder: (context, item, {required selected, required onSelected}) {
        final customerLabel = item.customerName ?? 'Walk-in Customer';

        return AppDataTableRowLayout(
          columns: _salesTableColumns,
          selected: selected,
          onSelected: onSelected,
          cells: [
            Text(
              item.saleNumber,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.primary,
              ),
            ),
            Text(
              _formatDate(item.soldAt),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              customerLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              item.cashierName ?? '—',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            SaleListProductsCell(
              productNames: item.productNames,
              itemCount: item.itemCount,
            ),
            SaleListPaymentMethodsCell(methods: item.paymentMethods),
            SaleListTotalCell(
              totalAmount: item.totalAmount,
              balanceDue: item.balanceDue,
              formatAmount: _formatAmount,
            ),
            SaleStatusChip(status: item.status),
          ],
          actions: AppTableActionButton(
            icon: Icons.chevron_right,
            tooltip: 'View',
            onPressed: () => _openSale(context, item),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasFilters, required this.onClear});

  final bool hasFilters;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: AppColors.primary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            hasFilters ? 'No sales match your filters' : 'No sales found',
            style: AppTextStyles.titleMedium,
          ),
          if (hasFilters) ...[
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onClear, child: const Text('Clear Filters')),
          ],
        ],
      ),
    );
  }
}
