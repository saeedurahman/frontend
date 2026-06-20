import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_cubit.dart';
import 'package:frantend/features/suppliers/presentation/cubit/suppliers_list_state.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

Future<void> openSupplierForm(BuildContext context, String path) async {
  final saved = await context.push<bool>(path);
  if (saved == true && context.mounted) {
    await context.read<SuppliersListCubit>().refresh();
  }
}

class SuppliersListPage extends StatelessWidget {
  const SuppliersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SuppliersListCubit>()..load(),
      child: const _SuppliersListView(),
    );
  }
}

class _SuppliersListView extends StatefulWidget {
  const _SuppliersListView();

  @override
  State<_SuppliersListView> createState() => _SuppliersListViewState();
}

class _SuppliersListViewState extends State<_SuppliersListView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SuppliersListCubit, SuppliersListState>(
      listener: (context, state) {
        if (state is SuppliersListError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        final count = switch (state) {
          SuppliersListLoaded(:final filteredItems) => filteredItems.length,
          _ => 0,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Toolbar(total: count),
            const SizedBox(height: AppDimensions.spacingMd),
            SizedBox(
              width: 320,
              child: TextField(
                controller: _searchController,
                onChanged: context.read<SuppliersListCubit>().search,
                decoration: InputDecoration(
                  hintText: 'Search suppliers',
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
            const SizedBox(height: AppDimensions.spacingMd),
            Expanded(
              child: switch (state) {
                SuppliersListInitial() || SuppliersListLoading() =>
                  const _ShimmerTable(),
                SuppliersListLoaded(:final filteredItems)
                    when filteredItems.isEmpty =>
                  _EmptyState(
                    hasSearch: _searchController.text.isNotEmpty,
                    onClear: () {
                      _searchController.clear();
                      context.read<SuppliersListCubit>().search('');
                    },
                  ),
                SuppliersListLoaded loaded => _SuppliersTable(
                    items: loaded.filteredItems,
                  ),
                SuppliersListError(:final message) => Center(
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
        Text('Suppliers', style: AppTextStyles.headlineMedium),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '($total suppliers)',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
          ),
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () => openSupplierForm(context, RouteNames.supplierNew),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Supplier'),
        ),
      ],
    );
  }
}

class _SuppliersTable extends StatelessWidget {
  const _SuppliersTable({required this.items});

  final List<SupplierListRow> items;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SuppliersListCubit>();

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
                Expanded(flex: 3, child: Text('Name', style: AppTextStyles.labelLarge)),
                Expanded(flex: 2, child: Text('Phone', style: AppTextStyles.labelLarge)),
                Expanded(flex: 2, child: Text('Outstanding Balance', style: AppTextStyles.labelLarge)),
                SizedBox(width: 80, child: Text('Status', style: AppTextStyles.labelLarge)),
                const SizedBox(width: 80),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final row = items[index];
                return _SupplierRow(
                  row: row,
                  onTap: () => openSupplierForm(
                    context,
                    '${RouteNames.suppliers}/${row.supplier.id}/edit',
                  ),
                  onToggleActive: (v) =>
                      cubit.toggleActive(row.supplier.id, v),
                  onDelete: () => _confirmDelete(context, row),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, SupplierListRow row) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Delete ${row.supplier.name}?',
      message: 'This action cannot be undone.',
    );
    if (ok == true && context.mounted) {
      final success =
          await context.read<SuppliersListCubit>().deleteSupplier(row.supplier.id);
      if (success && context.mounted) {
        AppAlerts.showSuccessMessage(context, 'Supplier deleted');
      }
    }
  }
}

class _SupplierRow extends StatelessWidget {
  const _SupplierRow({
    required this.row,
    required this.onTap,
    required this.onToggleActive,
    required this.onDelete,
  });

  final SupplierListRow row;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggleActive;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final supplier = row.supplier;

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
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(supplier.name, style: AppTextStyles.titleMedium),
                    if (supplier.contactPerson != null)
                      Text(
                        supplier.contactPerson!,
                        style: AppTextStyles.bodySmall,
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  supplier.phone ?? '—',
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
                        row.balance ?? '—',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              SizedBox(
                width: 80,
                child: Switch(
                  value: supplier.isActive,
                  activeThumbColor: AppColors.primary,
                  onChanged: onToggleActive,
                ),
              ),
              SizedBox(
                width: 80,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: onTap,
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: AppColors.error,
                      ),
                      onPressed: onDelete,
                      tooltip: 'Delete',
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
            const Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text('No suppliers match your search', style: AppTextStyles.titleMedium),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onClear, child: const Text('Clear Search')),
          ],
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_shipping_outlined, size: 64, color: AppColors.primary.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text('No suppliers yet', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => openSupplierForm(context, RouteNames.supplierNew),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Supplier'),
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
