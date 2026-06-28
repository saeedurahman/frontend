import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/products/data/models/brand_model.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/presentation/cubit/brands_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/brands_state.dart';
import 'package:frantend/features/products/presentation/cubit/categories_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/categories_state.dart';
import 'package:frantend/features/products/presentation/cubit/products_list_cubit.dart';
import 'package:frantend/features/products/presentation/cubit/products_list_state.dart';
import 'package:frantend/features/products/presentation/utils/category_utils.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:frantend/shared/widgets/tables/app_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_paginated_data_table.dart';
import 'package:frantend/shared/widgets/tables/app_table_cells.dart';
import 'package:frantend/shared/widgets/tables/app_table_pagination_helpers.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

Future<void> openProductForm(BuildContext context, String path) async {
  final saved = await context.push<bool>(path);
  if (saved == true && context.mounted) {
    await context.read<ProductsListCubit>().refresh();
  }
}

class ProductsListPage extends StatelessWidget {
  const ProductsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ProductsListCubit>()..loadProducts(),
        ),
        BlocProvider(create: (_) => sl<CategoriesCubit>()..load()),
        BlocProvider(create: (_) => sl<BrandsCubit>()..load()),
      ],
      child: const _ProductsListView(),
    );
  }
}

class _ProductsListView extends StatefulWidget {
  const _ProductsListView();

  @override
  State<_ProductsListView> createState() => _ProductsListViewState();
}

class _ProductsListViewState extends State<_ProductsListView> {
  final _searchController = TextEditingController();
  DateTime? _lastKeyTime;
  int _rapidKeyCount = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    final now = DateTime.now();
    if (_lastKeyTime != null &&
        now.difference(_lastKeyTime!).inMilliseconds < 100) {
      _rapidKeyCount++;
    } else {
      _rapidKeyCount = 0;
    }
    _lastKeyTime = now;
    context.read<ProductsListCubit>().search(value);
  }

  Future<void> _onSearchSubmitted(String value) async {
    if (_rapidKeyCount >= 3 && value.isNotEmpty) {
      final productId =
          await context.read<ProductsListCubit>().lookupBarcode(value);
      if (!mounted) return;
      if (productId != null) {
        openProductForm(context, '${RouteNames.products}/$productId/edit');
        return;
      }
      AppAlerts.showErrorMessage(context, 'No product found for barcode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsListCubit, ProductsListState>(
      listener: (context, state) {
        if (state is ProductsListError) {
          AppAlerts.showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Toolbar(total: switch (state) {
              ProductsListLoaded(:final total) => total,
              _ => 0,
            }),
            const SizedBox(height: AppDimensions.spacingMd),
            _FilterBar(
              searchController: _searchController,
              onSearchChanged: _onSearchChanged,
              onSearchSubmitted: _onSearchSubmitted,
            ),
            const SizedBox(height: AppDimensions.spacingXxl),
            Expanded(
              child: switch (state) {
                ProductsListInitial() || ProductsListLoading() =>
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100,
                    child: const AppDataTableShimmer(),
                  ),
                ProductsListLoaded(:final items) when items.isEmpty =>
                  _EmptyState(
                    hasFilters:
                        context.read<ProductsListCubit>().hasActiveFilters,
                  ),
                ProductsListLoaded loaded => BlocBuilder<CategoriesCubit, CategoriesState>(
                    builder: (context, _) {
                      return BlocBuilder<BrandsCubit, BrandsState>(
                        builder: (context, _) {
                          return _ProductsTable(state: loaded);
                        },
                      );
                    },
                  ),
                ProductsListError(:final message) => Center(
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
        const Text('Products', style: AppTextStyles.headlineMedium),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '( $total products )',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.background),
            
          ),
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () => openProductForm(context, RouteNames.productNew),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Product'),
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSearchSubmitted;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsListCubit>();

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 320,
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            onSubmitted: onSearchSubmitted,
            decoration: InputDecoration(
              hintText: 'Search by name or SKU',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
       const SizedBox(width: 18,),
        BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, catState) {
            final categories = switch (catState) {
              CategoriesLoaded(:final categories) => categories,
              _ => <CategoryModel>[],
            };
            final flat = flattenCategories(categories);
            return _FilterDropdown<String?>(
              label: 'Category',
              value: switch (context.watch<ProductsListCubit>().state) {
                ProductsListLoaded(:final currentCategoryId) =>
                  currentCategoryId,
                _ => null,
              },
              items: [
                const DropdownMenuItem(value: null, child: Text('All Categories')),
                ...flat.map(
                  (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                ),
              ],
              onChanged: cubit.filterByCategory,
            );
          },
        ),
         const SizedBox(width: 18,),
        BlocBuilder<BrandsCubit, BrandsState>(
          builder: (context, brandState) {
            final brands = switch (brandState) {
              BrandsLoaded(:final brands) => brands,
              _ => <BrandModel>[],
            };
            return _FilterDropdown<String?>(
              label: 'Brand',
              value: switch (context.watch<ProductsListCubit>().state) {
                ProductsListLoaded(:final currentBrandId) => currentBrandId,
                _ => null,
              },
              items: [
                const DropdownMenuItem(value: null, child: Text('All Brands')),
                ...brands.map(
                  (b) => DropdownMenuItem(value: b.id, child: Text(b.name)),
                ),
              ],
              onChanged: cubit.filterByBrand,
            );
          },
        ),
         const SizedBox(width: 18,),
        _StatusFilter(cubit: cubit),
        if (cubit.hasActiveFilters)
          TextButton(
            onPressed: () {
              searchController.clear();
              cubit.clearFilters();
            },
            child: const Text('Reset filters'),
          ),
      ],
    );
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}

class _StatusFilter extends StatelessWidget {
  const _StatusFilter({required this.cubit});

  final ProductsListCubit cubit;

  @override
  Widget build(BuildContext context) {
    final active = switch (context.watch<ProductsListCubit>().state) {
      ProductsListLoaded(:final currentIsActive) => currentIsActive,
      _ => null,
    };

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SegmentButton(
            label: 'All',
            selected: active == null,
            onTap: () => cubit.filterByActiveStatus(null),
          ),
          _SegmentButton(
            label: 'Active',
            selected: active == true,
            onTap: () => cubit.filterByActiveStatus(true),
          ),
          _SegmentButton(
            label: 'Inactive',
            selected: active == false,
            onTap: () => cubit.filterByActiveStatus(false),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 16
          ),
        ),
      ),
    );
  }
}

const _productTableColumns = [
  AppDataTableColumn(label: 'Product', flex: 4, sortable: true),
  AppDataTableColumn(label: 'Category', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Brand', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Type', flex: 2, sortable: true),
  AppDataTableColumn(label: 'Status', flex: 2, sortable: true),
];

class _ProductsTable extends StatelessWidget {
  const _ProductsTable({required this.state});

  final ProductsListLoaded state;

  static int _sortCompare(
    ProductListItemModel a,
    ProductListItemModel b,
    int column,
  ) {
    int compare<T extends Comparable<T>>(T x, T y) => x.compareTo(y);

    return switch (column) {
      0 => compare(a.name.toLowerCase(), b.name.toLowerCase()),
      1 => compare(
          (a.categoryName ?? '').toLowerCase(),
          (b.categoryName ?? '').toLowerCase(),
        ),
      2 => compare(
          (a.brandName ?? '').toLowerCase(),
          (b.brandName ?? '').toLowerCase(),
        ),
      3 => compare(
          a.productType.toLowerCase(),
          b.productType.toLowerCase(),
        ),
      4 => compare(a.isActive ? 1 : 0, b.isActive ? 1 : 0),
      _ => 0,
    };
  }

  String? _categoryName(BuildContext context, String? id) {
    if (id == null) return null;
    final catState = context.read<CategoriesCubit>().state;
    if (catState is CategoriesLoaded) {
      for (final c in flattenCategories(catState.categories)) {
        if (c.id == id) return c.name;
      }
    }
    return null;
  }

  String? _brandName(BuildContext context, String? id) {
    if (id == null) return null;
    final brandState = context.read<BrandsCubit>().state;
    if (brandState is BrandsLoaded) {
      for (final b in brandState.brands) {
        if (b.id == id) return b.name;
      }
    }
    return null;
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ProductListItemModel product,
  ) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Delete ${product.name}?',
      message:
          'This will also remove its variations and barcodes. This cannot be undone.',
    );
    if (ok == true && context.mounted) {
      final success =
          await context.read<ProductsListCubit>().deleteProduct(product.id);
      if (success && context.mounted) {
        AppAlerts.showSuccessMessage(context, 'Product deleted');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsListCubit>();

    return AppPaginatedDataTable<ProductListItemModel>(
      columns: _productTableColumns,
      items: state.items,
      itemId: (product) => product.id,
      itemLabel: 'products',
      paginationMode: AppTablePaginationMode.server,
      sortCompare: _sortCompare,
      skip: state.skip,
      total: state.total,
      limit: [10, 25, 50].contains(state.limit) ? state.limit : cubit.pageSize,
      currentPage: cubit.currentPage(state),
      totalPages: cubit.totalPages(state),
      onPageSizeChanged: cubit.setPageSize,
      onGoToPage: cubit.goToPage,
      onRowTap: (product) => openProductForm(
        context,
        '${RouteNames.products}/${product.id}/edit',
      ),
      rowBuilder: (context, product, {required selected, required onSelected}) {
        final categoryName =
            _categoryName(context, product.categoryId) ?? product.categoryName;
        final brandName =
            _brandName(context, product.brandId) ?? product.brandName;
        final variantLabel =
            product.productType == 'variant' ? 'Variant' : 'Default';

        return AppDataTableRowLayout(
          columns: _productTableColumns,
          selected: selected,
          onSelected: onSelected,
          cells: [
            AppTableProductCell(
              name: product.name,
              code: appTableProductCode(sku: product.sku, id: product.id),
              variantLabel: variantLabel,
              imageUrl: product.imageUrl,
            ),
            categoryName != null
                ? AppTableCategoryBadge(name: categoryName)
                : const AppTableDashText(),
            Text(
              brandName ?? '—',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
            AppTableTypeBadge(type: product.productType),
            Row(
              children: [
                Switch(
                  value: product.isActive,
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.4),
                  activeThumbColor: AppColors.primary,
                  onChanged: (v) => cubit.toggleActive(product.id, v),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(width: 4),
                Text(
                  product.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: product.isActive
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
          actions: Row(
            children: [
              AppTableActionButton(
                icon: Icons.edit_outlined,
                tooltip: 'Edit',
                onPressed: () => openProductForm(
                  context,
                  '${RouteNames.products}/${product.id}/edit',
                ),
              ),
              const SizedBox(width: 6),
              AppTableActionButton(
                icon: Icons.delete_outline,
                iconColor: AppColors.error,
                tooltip: 'Delete',
                onPressed: () => _confirmDelete(context, product),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasFilters});

  final bool hasFilters;

  @override
  Widget build(BuildContext context) {
    if (hasFilters) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text('No products match your filters', style: AppTextStyles.titleMedium),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: context.read<ProductsListCubit>().clearFilters,
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      );
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.primary.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text('No products yet', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Add your first product to get started',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => openProductForm(context, RouteNames.productNew),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
          ),
        ],
      ),
    );
  }
}
