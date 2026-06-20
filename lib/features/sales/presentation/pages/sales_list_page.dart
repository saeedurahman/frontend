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
import 'package:frantend/features/sales/presentation/widgets/sale_list_cells.dart';
import 'package:frantend/features/sales/presentation/widgets/sale_status_chip.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

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
                  const _ShimmerTable(),
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

  String _formatDate(String soldAt) {
    try {
      return DateFormatter.formatDateTime(DateTime.parse(soldAt));
    } catch (_) {
      return soldAt;
    }
  }

  String _formatAmount(String? amount) {
    if (amount == null || amount.isEmpty) return '—';
    return formatPKR(double.tryParse(amount) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SalesListCubit>();

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
                Expanded(flex: 2, child: Text('Invoice #', style: AppTextStyles.labelLarge)),
                Expanded(flex: 2, child: Text('Date/Time', style: AppTextStyles.labelLarge)),
                Expanded(flex: 2, child: Text('Customer', style: AppTextStyles.labelLarge)),
                Expanded(flex: 1, child: Text('Cashier', style: AppTextStyles.labelLarge)),
                Expanded(flex: 1, child: Text('Items', style: AppTextStyles.labelLarge)),
                Expanded(flex: 1, child: Text('Payment', style: AppTextStyles.labelLarge)),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Total',
                    style: AppTextStyles.labelLarge,
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(flex: 1, child: Text('Status', style: AppTextStyles.labelLarge)),
              ],
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification &&
                    notification.metrics.extentAfter < 200 &&
                    !state.isLoadingMore &&
                    state.items.length < state.total) {
                  cubit.loadMore();
                }
                return false;
              },
              child: ListView.builder(
                itemCount:
                    state.items.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.items.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final item = state.items[index];
                  return _SaleRow(
                    item: item,
                    formatDate: _formatDate,
                    formatAmount: _formatAmount,
                    onTap: () => context.push(RouteNames.saleDetailPath(item.id)),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SaleRow extends StatelessWidget {
  const _SaleRow({
    required this.item,
    required this.formatDate,
    required this.formatAmount,
    required this.onTap,
  });

  final SaleListItemModel item;
  final String Function(String) formatDate;
  final String Function(String?) formatAmount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final customerLabel = item.customerName ?? 'Walk-in Customer';
    final itemCountLabel =
        item.itemCount != null ? '${item.itemCount} items' : '—';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  item.saleNumber,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(formatDate(item.soldAt), style: AppTextStyles.bodySmall),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  customerLabel,
                  style: AppTextStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  item.cashierName ?? '—',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(itemCountLabel, style: AppTextStyles.bodySmall),
              ),
              Expanded(
                flex: 1,
                child: SaleListPaymentMethodsCell(methods: item.paymentMethods),
              ),
              Expanded(
                flex: 2,
                child: SaleListTotalCell(
                  totalAmount: item.totalAmount,
                  balanceDue: item.balanceDue,
                  formatAmount: formatAmount,
                ),
              ),
              Expanded(
                flex: 1,
                child: SaleStatusChip(status: item.status),
              ),
            ],
          ),
        ),
      ),
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
              height: 56,
              margin: const EdgeInsets.all(12),
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
