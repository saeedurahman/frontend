import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customers_list_state.dart';
import 'package:frantend/features/customers/presentation/utils/customer_balance_utils.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

Future<void> openCustomerForm(BuildContext context, String path) async {
  final saved = await context.push<bool>(path);
  if (saved == true && context.mounted) {
    await context.read<CustomersListCubit>().refresh();
  }
}

class CustomersListPage extends StatelessWidget {
  const CustomersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CustomersListCubit>()..load(),
      child: const _CustomersListView(),
    );
  }
}

class _CustomersListView extends StatefulWidget {
  const _CustomersListView();

  @override
  State<_CustomersListView> createState() => _CustomersListViewState();
}

class _CustomersListViewState extends State<_CustomersListView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomersListCubit, CustomersListState>(
      listener: (context, state) {
        if (state is CustomersListError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        final count = switch (state) {
          CustomersListLoaded(:final filteredItems) => filteredItems.length,
          _ => 0,
        };

        final activeFilter = switch (state) {
          CustomersListLoaded(:final activeFilter) => activeFilter,
          _ => CustomerActiveFilter.all,
        };

        final hasOutstandingOnly = switch (state) {
          CustomersListLoaded(:final hasOutstandingOnly) => hasOutstandingOnly,
          _ => false,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Toolbar(total: count),
            const SizedBox(height: AppDimensions.spacingMd),
            Row(
              children: [
                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: _searchController,
                    onChanged: context.read<CustomersListCubit>().search,
                    decoration: InputDecoration(
                      hintText: 'Search customers',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingMd),
                _FilterChip(
                  label: 'All',
                  selected: activeFilter == CustomerActiveFilter.all,
                  onSelected: () => context
                      .read<CustomersListCubit>()
                      .setActiveFilter(CustomerActiveFilter.all),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Active',
                  selected: activeFilter == CustomerActiveFilter.active,
                  onSelected: () => context
                      .read<CustomersListCubit>()
                      .setActiveFilter(CustomerActiveFilter.active),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Inactive',
                  selected: activeFilter == CustomerActiveFilter.inactive,
                  onSelected: () => context
                      .read<CustomersListCubit>()
                      .setActiveFilter(CustomerActiveFilter.inactive),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Outstanding'),
                  selected: hasOutstandingOnly,
                  onSelected: (v) =>
                      context.read<CustomersListCubit>().setHasOutstandingFilter(v),
                  selectedColor: AppColors.primary.withValues(alpha: 0.15),
                  checkmarkColor: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Expanded(
              child: switch (state) {
                CustomersListInitial() || CustomersListLoading() =>
                  const _ShimmerTable(),
                CustomersListLoaded(:final filteredItems)
                    when filteredItems.isEmpty =>
                  _EmptyState(
                    hasSearch: _searchController.text.isNotEmpty,
                    onClear: () {
                      _searchController.clear();
                      context.read<CustomersListCubit>().search('');
                    },
                  ),
                CustomersListLoaded loaded => _CustomersTable(
                    items: loaded.filteredItems,
                  ),
                CustomersListError(:final message) => Center(
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      checkmarkColor: AppColors.primary,
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
        Text('Customers', style: AppTextStyles.headlineMedium),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '($total customers)',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
          ),
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () => openCustomerForm(context, RouteNames.customerNew),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Customer'),
        ),
      ],
    );
  }
}

class _CustomersTable extends StatelessWidget {
  const _CustomersTable({required this.items});

  final List<CustomerListRow> items;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomersListCubit>();

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
                Expanded(
                  flex: 3,
                  child: Text('Name / Phone', style: AppTextStyles.labelLarge),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Email', style: AppTextStyles.labelLarge),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Credit Limit', style: AppTextStyles.labelLarge),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Outstanding Balance',
                    style: AppTextStyles.labelLarge,
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text('Status', style: AppTextStyles.labelLarge),
                ),
                const SizedBox(width: 120),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final row = items[index];
                return _CustomerRow(
                  row: row,
                  onEdit: () => openCustomerForm(
                    context,
                    '${RouteNames.customers}/${row.customer.id}/edit',
                  ),
                  onViewLedger: () => context.push(
                    RouteNames.customerDetail(row.customer.id),
                  ),
                  onToggleActive: (v) =>
                      cubit.toggleActive(row.customer.id, v),
                  onDeactivate: () => _confirmDeactivate(context, row),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeactivate(
    BuildContext context,
    CustomerListRow row,
  ) async {
    final owed = CustomerBalanceUtils.amountOwed(row.balance);
    final message = owed > Decimal.zero
        ? 'This customer owes ${DecimalUtils.format(owed)}. Deactivating will not clear the balance.\n\nThe customer will be marked inactive.'
        : 'The customer will be marked inactive.';

    final ok = await ConfirmDialog.show(
      context,
      title: 'Deactivate ${row.customer.name}?',
      message: message,
    );
    if (ok == true && context.mounted) {
      final success = await context
          .read<CustomersListCubit>()
          .deactivateCustomer(row.customer.id);
      if (success && context.mounted) {
        AppAlerts.showSuccessMessage(context, 'Customer deactivated');
      }
    }
  }
}

class _CustomerRow extends StatelessWidget {
  const _CustomerRow({
    required this.row,
    required this.onEdit,
    required this.onViewLedger,
    required this.onToggleActive,
    required this.onDeactivate,
  });

  final CustomerListRow row;
  final VoidCallback onEdit;
  final VoidCallback onViewLedger;
  final ValueChanged<bool> onToggleActive;
  final VoidCallback onDeactivate;

  @override
  Widget build(BuildContext context) {
    final customer = row.customer;
    final balanceDisplay = CustomerBalanceUtils.formatBalanceDisplay(row.balance);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onViewLedger,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    Text(customer.name, style: AppTextStyles.titleMedium),
                    Text(
                      customer.phone ?? '—',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  customer.email ?? '—',
                  style: AppTextStyles.bodySmall,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  CustomerBalanceUtils.formatCreditLimit(customer.creditLimit),
                  style: AppTextStyles.bodySmall,
                ),
              ),
              Expanded(
                flex: 2,
                child: row.balanceLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        balanceDisplay.text,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: balanceDisplay.isOwed
                              ? AppColors.error
                              : AppColors.textPrimary,
                        ),
                      ),
              ),
              SizedBox(
                width: 80,
                child: Switch(
                  value: customer.isActive,
                  activeThumbColor: AppColors.primary,
                  onChanged: onToggleActive,
                ),
              ),
              SizedBox(
                width: 120,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.receipt_long_outlined, size: 20),
                      onPressed: onViewLedger,
                      tooltip: 'View Ledger',
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: onEdit,
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.person_off_outlined,
                        size: 20,
                        color: AppColors.error,
                      ),
                      onPressed: customer.isActive ? onDeactivate : null,
                      tooltip: 'Deactivate',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasSearch, required this.onClear});

  final bool hasSearch;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (hasSearch) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No customers match your search',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onClear,
              child: const Text('Clear Search'),
            ),
          ],
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text('No customers yet', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => openCustomerForm(context, RouteNames.customerNew),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Customer'),
          ),
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
