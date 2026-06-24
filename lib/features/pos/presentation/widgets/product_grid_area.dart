import 'package:cached_network_image/cached_network_image.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_cubit.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_state.dart';
import 'package:frantend/features/pos/presentation/utils/pos_product_actions.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:shimmer/shimmer.dart';

class ProductGridArea extends StatelessWidget {
  const ProductGridArea({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosCubit, PosState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CategoryTabs(state: state),
            Container(
              height: 2,
              color: AppColors.brandingPanel,
            ),
            const SizedBox(height: 15),
            Expanded(
              child: state.isLoadingProducts
                  ? const _ProductShimmerGrid()
                  : state.filteredProducts.isEmpty
                      ? const Center(child: Text('No products found'))
                      : _ProductGrid(products: state.filteredProducts),
            ),
          ],
        );
      },
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({required this.state});
  final PosState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PosCubit>();
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          _CategoryChip(
            label: 'All',
            selected: state.selectedCategoryId == null,
            onTap: () => cubit.selectCategory(null),
          ),
          ...state.categories.map(
            (c) => _CategoryChip(
              label: c.name,
              selected: state.selectedCategoryId == c.id,
              onTap: () => cubit.selectCategory(c.id),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products});
  final List<ProductListItemModel> products;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount =
            (constraints.maxWidth / 180).floor().clamp(2, 5);
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.68,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) =>
              _ProductCard(product: products[index]),
        );
      },
    );
  }
}

class _ProductCard extends StatefulWidget {
  const _ProductCard({required this.product});
  final ProductListItemModel product;

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _flash = false;

  Future<void> _openPriceDialog() async {
    final cubit = context.read<PosCubit>();
    final added = await setProductPriceFromGrid(
      context,
      cubit,
      widget.product,
    );
    if (added && mounted) _flashAdded();
  }

  void _flashAdded() {
    setState(() => _flash = true);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _flash = false);
    });
  }

  bool _isInStock(String? stock) {
    if (stock == null) return false;
    final qty = Decimal.tryParse(stock);
    return qty != null && qty > Decimal.zero;
  }

  String _formatStock(String? stock) {
    if (stock == null) return '—';
    final qty = Decimal.tryParse(stock);
    if (qty == null) return stock;
    if (qty == qty.truncate()) return qty.toStringAsFixed(0);
    return qty.toString();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PosCubit>();
    final price = cubit.getDisplayPrice(widget.product.id);
    final stock = cubit.getDisplayStock(widget.product.id);
    final hasPrice = price != null && price > Decimal.zero;
    final inStock = _isInStock(stock);
    final imageUrl = widget.product.imageUrl?.trim();
    final hasNetworkImage =
        imageUrl != null && imageUrl.isNotEmpty && imageUrl.startsWith('http');

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _openPriceDialog,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: _flash
                  ? AppColors.primary.withValues(alpha: 0.06)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _flash ? AppColors.primary : AppColors.border,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(11),
                    ),
                    child: hasNetworkImage
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => _PlaceholderImage(
                              name: widget.product.name,
                              loading: true,
                            ),
                            errorWidget: (_, __, ___) =>
                                _PlaceholderImage(name: widget.product.name),
                          )
                        : _PlaceholderImage(name: widget.product.name),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _StockBadge(inStock: inStock),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (widget.product.categoryName != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.product.categoryName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    _InfoRow(
                      icon: Icons.inventory_2_outlined,
                      label: 'Stock',
                      value: _formatStock(stock),
                      valueColor: AppColors.textPrimary,
                      valueBold: true,
                    ),
                    const SizedBox(height: 4),
                    _InfoRow(
                      icon: Icons.sell_outlined,
                      label: 'Price',
                      value: hasPrice
                          ? formatPKR(price.toDouble())
                          : 'Tap to set',
                      valueColor:
                          hasPrice ? AppColors.textPrimary : AppColors.warning,
                      valueBold: hasPrice,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                            child: InkWell(
                              onTap: _openPriceDialog,
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        hasPrice
                                            ? formatPKR(price.toDouble())
                                            : 'Tap to set price',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: hasPrice
                                              ? AppColors.textPrimary
                                              : AppColors.warning,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.edit_outlined,
                                      size: 14,
                                      color: hasPrice
                                          ? AppColors.textSecondary
                                          : AppColors.warning,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        SizedBox(
                          height: 36,
                          width: 36,
                          child: Material(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                            child: PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.more_vert,
                                size: 18,
                                color: AppColors.textSecondary,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onSelected: (value) {
                                if (value == 'add') _openPriceDialog();
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'add',
                                  child: Text('Add to cart'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
          ),
        ),
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.inStock});

  final bool inStock;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: inStock ? AppColors.success : AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            inStock ? 'In Stock' : 'Out of Stock',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
    this.valueBold = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final bool valueBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: valueColor,
            fontWeight: valueBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage({
    required this.name,
    this.loading = false,
  });

  final String name;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      color: AppColors.primary.withValues(alpha: loading ? 0.06 : 0.12),
      alignment: Alignment.center,
      child: loading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(
              letter,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
    );
  }
}

class _ProductShimmerGrid extends StatelessWidget {
  const _ProductShimmerGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemCount: 8,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: AppColors.border,
        highlightColor: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
