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
  final _scrollController = ScrollController();
  DateTime? _lastKeyTime;
  int _rapidKeyCount = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;
    if (max > 0 && offset / max >= 0.8) {
      context.read<ProductsListCubit>().loadMore();
    }
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
            const SizedBox(height: AppDimensions.spacingMd),
            Expanded(
              child: switch (state) {
                ProductsListInitial() || ProductsListLoading() =>
                  const _ShimmerTable(),
                ProductsListLoaded(:final items) when items.isEmpty =>
                  _EmptyState(
                    hasFilters:
                        context.read<ProductsListCubit>().hasActiveFilters,
                  ),
                ProductsListLoaded loaded => _ProductsTable(
                    state: loaded,
                    scrollController: _scrollController,
                  ),
                ProductsListError(:final message) => Center(
                    child: Text(message, style: AppTextStyles.bodyMedium),
                  ),
              },
            ),
            if (state is ProductsListLoaded && state.items.isNotEmpty)
              _PaginationFooter(state: state),
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
        Text('Products', style: AppTextStyles.headlineMedium),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '($total products)',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
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
      spacing: 12,
      runSpacing: 12,
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
        BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, catState) {
            final categories = switch (catState) {
              CategoriesLoaded(:final categories) => categories,
              _ => <CategoryModel>[],
            };
            return _FilterDropdown<String?>(
              label: 'Category',
              value: switch (context.watch<ProductsListCubit>().state) {
                ProductsListLoaded(:final currentCategoryId) =>
                  currentCategoryId,
                _ => null,
              },
              items: [
                const DropdownMenuItem(value: null, child: Text('All Categories')),
                ...flattenCategories(categories).map(
                  (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                ),
              ],
              onChanged: cubit.filterByCategory,
            );
          },
        ),
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
          ),
        ),
      ),
    );
  }
}

class _ProductsTable extends StatelessWidget {
  const _ProductsTable({
    required this.state,
    required this.scrollController,
  });

  final ProductsListLoaded state;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsListCubit>();

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
                const SizedBox(width: 48),
                Expanded(flex: 3, child: Text('Product', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Category', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Brand', style: AppTextStyles.labelLarge)),
                Expanded(child: Text('Type', style: AppTextStyles.labelLarge)),
                SizedBox(width: 80, child: Text('Status', style: AppTextStyles.labelLarge)),
                const SizedBox(width: 80),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.items.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return _ProductRow(
                  product: state.items[index],
                  categoryName: _categoryName(context, state.items[index].categoryId),
                  brandName: _brandName(context, state.items[index].brandId),
                  onTap: () => openProductForm(
                    context,
                    '${RouteNames.products}/${state.items[index].id}/edit',
                  ),
                  onToggleActive: (v) =>
                      cubit.toggleActive(state.items[index].id, v),
                  onDelete: () => _confirmDelete(context, state.items[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
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
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({
    required this.product,
    this.categoryName,
    this.brandName,
    required this.onTap,
    required this.onToggleActive,
    required this.onDelete,
  });

  final ProductListItemModel product;
  final String? categoryName;
  final String? brandName;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggleActive;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
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
              _ProductThumb(imageUrl: product.imageUrl),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: AppTextStyles.titleMedium),
                    if (product.sku != null)
                      Text(product.sku!, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              Expanded(
                child: categoryName != null
                    ? _Chip(label: categoryName!)
                    : const Text('—', style: AppTextStyles.bodySmall),
              ),
              Expanded(
                child: Text(
                  brandName ?? '—',
                  style: AppTextStyles.bodySmall,
                ),
              ),
              Expanded(child: _TypeChip(type: product.productType)),
              SizedBox(
                width: 80,
                child: Switch(
                  value: product.isActive,
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
                      icon: Icon(Icons.delete_outline, size: 20, color: AppColors.error),
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

class _ProductThumb extends StatelessWidget {
  const _ProductThumb({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(imageUrl!, fit: BoxFit.cover),
            )
          : const Icon(Icons.inventory_2_outlined, size: 20, color: AppColors.textSecondary),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: AppTextStyles.bodySmall),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.type});

  final String type;

  Color get _color => switch (type) {
        'standard' => AppColors.info,
        'variant' => AppColors.primary,
        'composite' => AppColors.accentDark,
        'manufactured' => AppColors.warning,
        'service' => AppColors.textSecondary,
        _ => AppColors.textSecondary,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        type,
        style: AppTextStyles.bodySmall.copyWith(color: _color),
      ),
    );
  }
}

class _PaginationFooter extends StatelessWidget {
  const _PaginationFooter({required this.state});

  final ProductsListLoaded state;

  @override
  Widget build(BuildContext context) {
    final from = state.skip + 1;
    final to = (state.skip + state.items.length).clamp(0, state.total);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing $from-$to of ${state.total}',
            style: AppTextStyles.bodySmall,
          ),
          if (state.isLoadingMore)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
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
