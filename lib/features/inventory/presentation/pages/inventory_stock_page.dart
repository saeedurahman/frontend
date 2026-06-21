import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_state.dart';
import 'package:frantend/features/inventory/presentation/cubit/inventory_stock_cubit.dart';
import 'package:frantend/features/inventory/presentation/cubit/inventory_stock_state.dart';
import 'package:frantend/features/inventory/presentation/widgets/stock_adjustment_dialog.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/presentation/cubit/categories_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/categories_state.dart';
import 'package:frantend/features/products/presentation/utils/category_utils.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class InventoryStockPage extends StatelessWidget {
  const InventoryStockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<InventoryStockCubit>()..load()),
        BlocProvider(create: (_) => sl<CategoriesCubit>()..load()),
      ],
      child: BlocListener<BranchSelectorCubit, BranchSelectorState>(
        bloc: sl<BranchSelectorCubit>(),
        listenWhen: (previous, current) =>
            previous.selectedBranchId != current.selectedBranchId &&
            current.isInitialized,
        listener: (context, _) => context.read<InventoryStockCubit>().refresh(),
        child: const _InventoryStockView(),
      ),
    );
  }
}

class _InventoryStockView extends StatefulWidget {
  const _InventoryStockView();

  @override
  State<_InventoryStockView> createState() => _InventoryStockViewState();
}

class _InventoryStockViewState extends State<_InventoryStockView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InventoryStockCubit, InventoryStockState>(
      listener: (context, state) {
        if (state is InventoryStockError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        final count = switch (state) {
          InventoryStockLoaded(:final filteredRows) => filteredRows.length,
          _ => 0,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Toolbar(total: count),
            const SizedBox(height: AppDimensions.spacingMd),
            _FilterBar(searchController: _searchController),
            const SizedBox(height: AppDimensions.spacingMd),
            Expanded(
              child: switch (state) {
                InventoryStockInitial() || InventoryStockLoading() =>
                  const _ShimmerTable(),
                InventoryStockLoaded(:final filteredRows)
                    when filteredRows.isEmpty =>
                  const Center(child: Text('No stock records found')),
                InventoryStockLoaded loaded => _StockTable(rows: loaded.filteredRows),
                InventoryStockError(:final message) =>
                  Center(child: Text(message)),
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
        Text('Inventory', style: AppTextStyles.headlineMedium),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '($total items)',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.searchController});

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<InventoryStockCubit>();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 280,
          child: TextField(
            controller: searchController,
            onChanged: cubit.search,
            decoration: InputDecoration(
              hintText: 'Search products',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ),
        BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, catState) {
            final categories = switch (catState) {
              CategoriesLoaded(:final categories) => categories,
              _ => <CategoryModel>[],
            };
            final categoryFilter = switch (context.watch<InventoryStockCubit>().state) {
              InventoryStockLoaded(:final categoryFilter) => categoryFilter,
              _ => null,
            };
            return SizedBox(
              width: 180,
              child: DropdownButtonFormField<String?>(
                initialValue: categoryFilter,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All')),
                  ...flattenCategories(categories).map(
                    (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                  ),
                ],
                onChanged: cubit.filterByCategory,
              ),
            );
          },
        ),
        FilterChip(
          label: const Text('Low Stock'),
          selected: switch (context.watch<InventoryStockCubit>().state) {
            InventoryStockLoaded(:final lowStockOnly) => lowStockOnly,
            _ => false,
          },
          onSelected: cubit.toggleLowStock,
        ),
        FilterChip(
          label: const Text('Out of Stock'),
          selected: switch (context.watch<InventoryStockCubit>().state) {
            InventoryStockLoaded(:final outOfStockOnly) => outOfStockOnly,
            _ => false,
          },
          onSelected: cubit.toggleOutOfStock,
        ),
      ],
    );
  }
}

class _StockTable extends StatelessWidget {
  const _StockTable({required this.rows});

  final List<StockDisplayRow> rows;

  Color _stockColor(StockDisplayRow row) {
    if (row.isOutOfStock) return AppColors.error;
    if (row.isLowStock) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<InventoryStockCubit>();

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
                Expanded(flex: 3, child: Text('Product', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Variation', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Category', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Current Stock', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Min Level', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Unit', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Last Movement', style: AppTextStyles.labelLarge)),
                const SizedBox(width: 100),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: rows.length,
              itemBuilder: (context, index) {
                final row = rows[index];
                final color = _stockColor(row);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(row.product.name, style: AppTextStyles.titleMedium),
                      ),
                      Expanded(
                        child: Text(row.variationName ?? '—', style: AppTextStyles.bodySmall),
                      ),
                      Expanded(
                        child: Text(
                          row.product.categoryName ?? '—',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          row.balance.currentQty,
                          style: AppTextStyles.titleMedium.copyWith(color: color),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          row.minStockLevel ?? '—',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                      Expanded(
                        child: Text(row.unitName ?? '—', style: AppTextStyles.bodySmall),
                      ),
                      Expanded(
                        child: Text(
                          row.balance.lastMovementAt?.split('T').first ?? '—',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                              tooltip: 'Adjust',
                              icon: const Icon(Icons.tune, size: 20),
                              onPressed: () async {
                                final saved = await StockAdjustmentDialog.show(
                                  context,
                                  row: row,
                                );
                                if (saved == true) await cubit.refresh();
                              },
                            ),
                            IconButton(
                              tooltip: 'Movements',
                              icon: const Icon(Icons.history, size: 20),
                              onPressed: () => context.push(
                                '${RouteNames.inventory}/movements/${row.product.id}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
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
