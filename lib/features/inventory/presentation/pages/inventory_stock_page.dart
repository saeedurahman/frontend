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
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_paginated_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_table_cells.dart';
import 'package:frantend/shared/widgets/tables/app_table_pagination_helpers.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

const _inventoryTableColumns = [
  AppDataTableColumn(label: 'Product', flex: 4, sortable: true),
  AppDataTableColumn(label: 'Variation', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Category', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Current Stock', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Min Level', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Unit', flex: 1, sortable: true),
  AppDataTableColumn(label: 'Last Movement', flex: 2, sortable: true),
];
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
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100,
                    child: const AppDataTableShimmer(),
                  ),                InventoryStockLoaded(:final filteredRows)
                    when filteredRows.isEmpty =>
                  const Center(child: Text('No stock records found')),
                InventoryStockLoaded loaded => BlocBuilder<CategoriesCubit, CategoriesState>(
                    builder: (context, _) =>
                        _StockTable(rows: loaded.filteredRows),
                  ),
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

  static Color _stockColor(StockDisplayRow row) {
    if (row.isOutOfStock) return AppColors.error;
    if (row.isLowStock) return AppColors.warning;
    return AppColors.success;
  }

  static String _stockLabel(StockDisplayRow row) {
    if (row.isOutOfStock) return 'Out of Stock';
    if (row.isLowStock) return 'Low Stock';
    return 'In Stock';
  }

  static String _rowId(StockDisplayRow row) =>
      '${row.product.id}:${row.balance.variationId ?? 'default'}';

  static String? _categoryName(BuildContext context, String? categoryId) {
    if (categoryId == null) return null;
    final catState = context.read<CategoriesCubit>().state;
    if (catState is CategoriesLoaded) {
      for (final category in flattenCategories(catState.categories)) {
        if (category.id == categoryId) return category.name;
      }
    }
    return null;
  }

  static int _sortCompare(StockDisplayRow a, StockDisplayRow b, int column) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);

    return switch (column) {
      0 => compare(
          a.product.name.toLowerCase(),
          b.product.name.toLowerCase(),
        ),
      1 => compare(
          (a.variationName ?? '').toLowerCase(),
          (b.variationName ?? '').toLowerCase(),
        ),
      2 => compare(
          (a.product.categoryName ?? '').toLowerCase(),
          (b.product.categoryName ?? '').toLowerCase(),
        ),
      3 => compare(a.currentQty, b.currentQty),
      4 => compare(
          double.tryParse(a.minStockLevel ?? '') ?? 0,
          double.tryParse(b.minStockLevel ?? '') ?? 0,
        ),
      5 => compare(
          (a.unitName ?? '').toLowerCase(),
          (b.unitName ?? '').toLowerCase(),
        ),
      6 => compare(
          (a.balance.lastMovementAt ?? '').toLowerCase(),
          (b.balance.lastMovementAt ?? '').toLowerCase(),
        ),
      _ => 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<InventoryStockCubit>();

    return AppPaginatedDataTable<StockDisplayRow>(
      columns: _inventoryTableColumns,
      items: rows,
      itemId: _rowId,
      itemLabel: 'items',
      actionsWidth: 88,
      paginationMode: AppTablePaginationMode.summary,
      sortCompare: _sortCompare,
      rowBuilder: (context, row, {required selected, required onSelected}) {
        final categoryName = _categoryName(context, row.product.categoryId) ??
            row.product.categoryName;
        final stockColor = _stockColor(row);
        final variantLabel = row.variationName ?? 'Default';

        return AppDataTableRowLayout(
          columns: _inventoryTableColumns,
          selected: selected,
          onSelected: onSelected,
          cells: [
            AppTableProductCell(
              name: row.product.name,
              code: appTableProductCode(
                sku: row.product.sku,
                id: row.product.id,
              ),
              variantLabel: variantLabel,
              imageUrl: row.product.imageUrl,
              subtitle: row.unitName != null ? 'Unit: ${row.unitName}' : null,
            ),
            row.variationName != null
                ? AppTableVariantBadge(label: row.variationName!)
                : const AppTableDashText(),
            categoryName != null
                ? AppTableCategoryBadge(name: categoryName)
                : const AppTableDashText(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.balance.currentQty,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: stockColor,
                  ),
                ),
                const SizedBox(height: 4),
                AppTableStatusBadge(
                  label: _stockLabel(row),
                  color: stockColor,
                ),
              ],
            ),
            Text(
              row.minStockLevel ?? '—',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              row.unitName ?? '—',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              row.balance.lastMovementAt?.split('T').first ?? '—',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          actions: Row(
            children: [
              AppTableActionButton(
                icon: Icons.tune,
                tooltip: 'Adjust',
                onPressed: () async {
                  final saved = await StockAdjustmentDialog.show(
                    context,
                    row: row,
                  );
                  if (saved == true) await cubit.refresh();
                },
              ),
              const SizedBox(width: 6),
              AppTableActionButton(
                icon: Icons.history,
                tooltip: 'Movements',
                onPressed: () => context.push(
                  '${RouteNames.inventory}/movements/${row.product.id}',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}