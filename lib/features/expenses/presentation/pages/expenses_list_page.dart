import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/expenses/data/models/expense_list_item_model.dart';
import 'package:frantend/features/expenses/presentation/cubit/expenses_list_cubit.dart';
import 'package:frantend/features/expenses/presentation/cubit/expenses_list_state.dart';
import 'package:frantend/features/expenses/presentation/utils/expense_calculations.dart';
import 'package:frantend/features/expenses/presentation/widgets/expense_status_chip.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class ExpensesListPage extends StatelessWidget {
  const ExpensesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExpensesListCubit>()..init(),
      child: const _ExpensesListView(),
    );
  }
}

class _ExpensesListView extends StatelessWidget {
  const _ExpensesListView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExpensesListCubit, ExpensesListState>(
      listener: (context, state) {
        if (state is ExpensesListError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        final total = switch (state) {
          ExpensesListLoaded(:final total) => total,
          _ => 0,
        };
        final pageTotal = switch (state) {
          ExpensesListLoaded loaded => context
              .read<ExpensesListCubit>()
              .pageTotalAmount(loaded),
          _ => '0',
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Toolbar(total: total, pageTotal: pageTotal),
            const SizedBox(height: AppDimensions.spacingMd),
            if (state is ExpensesListLoaded) _FilterBar(state: state),
            const SizedBox(height: AppDimensions.spacingMd),
            Expanded(
              child: switch (state) {
                ExpensesListInitial() || ExpensesListLoading() =>
                  const _ShimmerTable(),
                ExpensesListLoaded(:final items) when items.isEmpty =>
                  _EmptyState(
                    hasFilters: state.hasActiveFilters,
                    onClear: () =>
                        context.read<ExpensesListCubit>().clearFilters(),
                  ),
                ExpensesListLoaded loaded => _ExpensesTable(state: loaded),
                ExpensesListError(:final message) => Center(
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
  const _Toolbar({required this.total, required this.pageTotal});

  final int total;
  final String pageTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Expenses', style: AppTextStyles.headlineMedium),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$total expenses · ${formatPKR(double.tryParse(pageTotal) ?? 0)}',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
          ),
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () async {
            final saved = await context.push<bool>(RouteNames.expenseNew);
            if (saved == true && context.mounted) {
              await context.read<ExpensesListCubit>().loadExpenses();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Expense'),
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.state});

  final ExpensesListLoaded state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExpensesListCubit>();
    final flatCategories = flattenExpenseCategories(state.categories);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _datePresets(context, cubit, state),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            SizedBox(
              width: 220,
              child: DropdownButtonFormField<String?>(
                initialValue: state.categoryIdFilter,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All categories')),
                  ...flatCategories.map(
                    (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                  ),
                ],
                onChanged: cubit.setCategoryFilter,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 220,
              child: DropdownButtonFormField<String?>(
                initialValue: state.supplierIdFilter,
                decoration: const InputDecoration(
                  labelText: 'Supplier',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All suppliers')),
                  ...state.suppliers.map(
                    (s) => DropdownMenuItem(value: s.id, child: Text(s.name)),
                  ),
                ],
                onChanged: cubit.setSupplierFilter,
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _datePresets(
    BuildContext context,
    ExpensesListCubit cubit,
    ExpensesListLoaded state,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final presets = [
      ('Today', today, today),
      ('This Week', today.subtract(Duration(days: today.weekday - 1)), today),
      (
        'This Month',
        DateTime(now.year, now.month, 1),
        DateTime(now.year, now.month + 1, 0),
      ),
      (
        'Last Month',
        DateTime(now.year, now.month - 1, 1),
        DateTime(now.year, now.month, 0),
      ),
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
        onPressed: () => cubit.setDateRange(
          DateTime(preset.$2.year, preset.$2.month, preset.$2.day),
          DateTime(preset.$3.year, preset.$3.month, preset.$3.day, 23, 59, 59),
        ),
      );
    }).toList();
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _ExpensesTable extends StatelessWidget {
  const _ExpensesTable({required this.state});

  final ExpensesListLoaded state;

  String _formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return '${parsed.day.toString().padLeft(2, '0')}/'
          '${parsed.month.toString().padLeft(2, '0')}/'
          '${parsed.year}';
    } catch (_) {
      return date;
    }
  }

  String _supplierName(String? supplierId) {
    if (supplierId == null) return '—';
    for (final s in state.suppliers) {
      if (s.id == supplierId) return s.name;
    }
    return '—';
  }

  Future<void> _delete(
    BuildContext context,
    ExpenseListItemModel item,
  ) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Delete expense?',
      message: 'This will remove ${item.expenseNumber} from your records.',
    );
    if (ok != true || !context.mounted) return;
    final success =
        await context.read<ExpensesListCubit>().deleteExpense(item.id);
    if (success && context.mounted) {
      AppAlerts.showSuccessMessage(context, 'Expense deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExpensesListCubit>();
    final canLoadMore = state.items.length < state.total;

    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _TableHeader(),
                Expanded(
                  child: ListView.separated(
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: AppColors.border),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      final categoryName = categoryNameForId(
                            state.categories,
                            item.expenseCategoryId,
                          ) ??
                          '—';
                      return InkWell(
                        onTap: () => context.push(
                          RouteNames.expenseDetailPath(item.id),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  _formatDate(item.expenseDate),
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: ExpenseCategoryChip(label: categoryName),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  item.description?.isNotEmpty == true
                                      ? item.description!
                                      : item.expenseNumber,
                                  style: AppTextStyles.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  _supplierName(item.supplierId),
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  formatPKR(
                                    double.tryParse(item.amount) ?? 0,
                                  ),
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              SizedBox(
                                width: 120,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      tooltip: 'View',
                                      icon: const Icon(Icons.visibility_outlined,
                                          size: 20),
                                      onPressed: () => context.push(
                                        RouteNames.expenseDetailPath(item.id),
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Delete',
                                      icon: const Icon(Icons.delete_outline,
                                          size: 20,
                                          color: AppColors.error),
                                      onPressed: () => _delete(context, item),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        if (canLoadMore) ...[
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: state.isLoadingMore ? null : cubit.loadMore,
            child: state.isLoadingMore
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Load more'),
          ),
        ],
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text('Date', style: AppTextStyles.labelLarge),
          ),
          Expanded(
            flex: 2,
            child: Text('Category', style: AppTextStyles.labelLarge),
          ),
          Expanded(
            flex: 3,
            child: Text('Description', style: AppTextStyles.labelLarge),
          ),
          Expanded(
            flex: 2,
            child: Text('Supplier', style: AppTextStyles.labelLarge),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Amount',
              style: AppTextStyles.labelLarge,
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 120),
        ],
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
          Icon(Icons.receipt_long_outlined,
              size: 48, color: AppColors.textSecondary.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          Text(
            hasFilters ? 'No expenses match your filters' : 'No expenses yet',
            style: AppTextStyles.bodyLarge,
          ),
          if (hasFilters) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onClear, child: const Text('Clear filters')),
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
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
