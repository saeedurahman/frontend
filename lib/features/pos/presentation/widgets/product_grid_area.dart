import 'package:frantend/core/tax/tax_settings.dart';
import 'package:frantend/features/pos/domain/utils/tax_rate_resolver.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/gestures.dart';
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
            PosCategoryTabs(state: state),
            Container(
              height: 2,
              color: AppColors.brandingPanel,
            ),
            const SizedBox(height: 15),
            Expanded(
              child: state.isLoadingProducts
                  ? const _ProductShimmerGrid()
                  : state.filteredProducts.isEmpty
                      ? _EmptyOrError(error: state.productsError)
                      : _ProductGrid(
                          products: state.filteredProducts,
                          isLoadingMore: state.isLoadingMoreProducts,
                          total: state.productsTotal,
                        ),
            ),
          ],
        );
      },
    );
  }
}

/// The category chips above the grid. A horizontal list does not scroll with a
/// mouse by default on desktop (Flutter only drags with touch, and the wheel
/// only scrolls vertically), so this one accepts a mouse drag and turns the
/// wheel (and a trackpad swipe) into a horizontal scroll, and has arrow buttons
/// at the ends that appear only when there is more to see in that direction.
@visibleForTesting
class PosCategoryTabs extends StatefulWidget {
  const PosCategoryTabs({super.key, required this.state});
  final PosState state;

  @override
  State<PosCategoryTabs> createState() => _PosCategoryTabsState();
}

class _PosCategoryTabsState extends State<PosCategoryTabs> {
  final _controller = ScrollController();
  bool _canLeft = false;
  bool _canRight = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_syncArrows);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncArrows());
  }

  @override
  void didUpdateWidget(covariant PosCategoryTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncArrows());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncArrows() {
    if (!mounted || !_controller.hasClients) return;
    final p = _controller.position;
    final left = p.pixels > 1;
    final right = p.pixels < p.maxScrollExtent - 1;
    if (left != _canLeft || right != _canRight) {
      setState(() {
        _canLeft = left;
        _canRight = right;
      });
    }
  }

  void _scrollBy(double delta) {
    if (!_controller.hasClients) return;
    final p = _controller.position;
    _controller.jumpTo((p.pixels + delta).clamp(0.0, p.maxScrollExtent));
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent || !_controller.hasClients) return;
    if (_controller.position.maxScrollExtent <= 0) return;
    // The wheel scrolls vertically; a trackpad swipe may already be horizontal.
    final delta = event.scrollDelta.dx.abs() > event.scrollDelta.dy.abs()
        ? event.scrollDelta.dx
        : event.scrollDelta.dy;
    GestureBinding.instance.pointerSignalResolver.register(event, (_) {
      _scrollBy(delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final cubit = context.read<PosCubit>();
    return SizedBox(
      height: 52,
      child: Listener(
        onPointerSignal: _onPointerSignal,
        child: Stack(
          children: [
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.stylus,
                },
              ),
              child: ListView(
                controller: _controller,
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
            ),
            if (_canLeft)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: _TabsArrow(
                  key: const Key('category-tabs-left'),
                  icon: Icons.chevron_left,
                  onTap: () => _scrollBy(-240),
                ),
              ),
            if (_canRight)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: _TabsArrow(
                  key: const Key('category-tabs-right'),
                  icon: Icons.chevron_right,
                  onTap: () => _scrollBy(240),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TabsArrow extends StatelessWidget {
  const _TabsArrow({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 2,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(icon, size: 22, color: AppColors.primary),
          ),
        ),
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

class _EmptyOrError extends StatelessWidget {
  const _EmptyOrError({this.error});
  final String? error;

  @override
  Widget build(BuildContext context) {
    if (error == null) return const Center(child: Text('No products found'));
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Could not load products: $error',
            style: const TextStyle(color: AppColors.error),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: context.read<PosCubit>().retryProducts,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

/// Infinite-scrolling catalog: the next page is requested when the cashier
/// scrolls near the end of what is loaded.
class _ProductGrid extends StatefulWidget {
  const _ProductGrid({
    required this.products,
    required this.isLoadingMore,
    required this.total,
  });

  final List<ProductListItemModel> products;
  final bool isLoadingMore;
  final int total;

  @override
  State<_ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<_ProductGrid> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    if (position.pixels >= position.maxScrollExtent - 400) {
      context.read<PosCubit>().loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = _GridLayout.fit(
          constraints.maxWidth,
          MediaQuery.textScalerOf(context),
        );
        // Short first pages may not fill the viewport; keep pulling pages.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted &&
              _controller.hasClients &&
              _controller.position.maxScrollExtent <= 0) {
            context.read<PosCubit>().loadMoreProducts();
          }
        });
        return Column(
          children: [
            Expanded(
              child: GridView.builder(
                controller: _controller,
                padding: const EdgeInsets.all(_GridLayout._padding),
                gridDelegate: layout.delegate,
                itemCount: widget.products.length,
                itemBuilder: (context, index) => _ProductCard(
                  product: widget.products[index],
                  imageHeight: layout.imageHeight,
                ),
              ),
            ),
            if (widget.isLoadingMore)
              const Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ProductCard extends StatefulWidget {
  const _ProductCard({required this.product, required this.imageHeight});
  final ProductListItemModel product;

  /// Height of the picture; the rest of the (grid-fixed) tile is the text part.
  final double imageHeight;

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _flash = false;

  static const _cardRadius = 16.0;
  static const _borderWidth = 2.0;

  /// Card tap / "Add to cart": the quantity calculator, then the cart (or
  /// one unit straight away when "Ask quantity on product tap" is off). The
  /// price popup only appears when the product has no price.
  Future<void> _addToCart() async {
    final cubit = context.read<PosCubit>();
    final added = await openProductFromGrid(context, cubit, widget.product);
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
    // Each card listens to its own price and stock, so a sale, a pull or a
    // sync result updates it in place.
    final price = context.select<PosCubit, Decimal?>(
      (c) => c.getDisplayPrice(widget.product.id),
    );
    final stock = context.select<PosCubit, String?>(
      (c) => c.getDisplayStock(widget.product.id),
    );
    // "Wholesale" etc. when the customer's own list is in force.
    final listName = context.select<PosCubit, String?>(
      (c) => c.specialPriceListName,
    );
    // Rebuilds when tax settings or rates change (taxRevision bumps).
    final taxTag = context.select<PosCubit, String?>(
      (c) => TaxRateResolver.cardTag(
        tax: TaxSettingsHolder.current,
        taxExempt: widget.product.isTaxExempt,
        ownRateId: widget.product.taxRateId,
        rates: c.state.taxRates,
        defaultRate: c.state.defaultTaxRate,
      ),
    );
    final hasPrice = price != null && price > Decimal.zero;
    final inStock = _isInStock(stock);
    final imageUrl = widget.product.imageUrl?.trim();
    final hasNetworkImage =
        imageUrl != null && imageUrl.isNotEmpty && imageUrl.startsWith('http');
    // The hover effect is the InkWell's own (no state of ours is changed from a
    // mouse callback); only the "just added" flash lifts the card.
    final lifted = _flash;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _addToCart,
          borderRadius: BorderRadius.circular(_cardRadius),
          hoverColor: AppColors.accent.withValues(alpha: 0.10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            // The border: a thin gold-to-green frame around the white card.
            // The width never changes (a size change under the pointer would move
            // the card out from under the mouse); only colour and shadow do.
            padding: const EdgeInsets.all(_borderWidth),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_cardRadius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: lifted
                    ? const [
                        AppColors.accent,
                        AppColors.accentDark,
                        AppColors.primaryLight,
                      ]
                    : [
                        AppColors.accent.withValues(alpha: 0.85),
                        AppColors.accentDark.withValues(alpha: 0.55),
                        AppColors.primary.withValues(alpha: 0.55),
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: lifted
                      ? AppColors.accentDark.withValues(alpha: 0.35)
                      : Colors.black.withValues(alpha: 0.08),
                  blurRadius: lifted ? 18 : 10,
                  offset: Offset(0, lifted ? 8 : 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_cardRadius - _borderWidth),
              child: ColoredBox(
                color: _flash
                    ? Color.alphaBlend(
                        AppColors.primary.withValues(alpha: 0.06),
                        Colors.white,
                      )
                    : Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: widget.imageHeight,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          hasNetworkImage
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
                          // A soft shade at the bottom of the picture so that the
                          // tax tag reads on any photo.
                          const Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: 56,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Color(0x66000000)],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: _StockBadge(inStock: inStock),
                          ),
                          if (taxTag != null)
                            Positioned(
                              bottom: 8,
                              left: 10,
                              child: Container(
                                key: const Key('product-tax-tag'),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  taxTag,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // The gold hairline between the picture and the text.
                    Container(
                      height: 2,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.accentDark,
                            AppColors.accent,
                            AppColors.accentDark,
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
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
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            _InfoRow(
                              icon: Icons.inventory_2_outlined,
                              label: 'Stock',
                              value: _formatStock(stock),
                              valueColor: AppColors.textPrimary,
                              valueBold: true,
                            ),
                            const SizedBox(height: 6),
                            _InfoRow(
                              icon: Icons.sell_outlined,
                              label: listName ?? 'Price',
                              value: hasPrice ? formatPKR(price) : 'Tap to set',
                              valueColor: hasPrice
                                  ? AppColors.textPrimary
                                  : AppColors.warning,
                              valueBold: hasPrice,
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Expanded(
                                  child: _PriceButton(
                                    hasPrice: hasPrice,
                                    price: price,
                                    onTap: _addToCart,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Material(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(10),
                                    child: PopupMenuButton<String>(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.more_vert,
                                        size: 18,
                                        color: AppColors.textSecondary,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      onSelected: (value) {
                                        if (value == 'add') _addToCart();
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
        ),
      ),
    );
  }
}

/// The green price button at the foot of a card.
class _PriceButton extends StatelessWidget {
  const _PriceButton({
    required this.hasPrice,
    required this.price,
    required this.onTap,
  });

  final bool hasPrice;
  final Decimal? price;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: hasPrice
              ? const LinearGradient(
                  colors: [AppColors.primaryLight, AppColors.primary],
                )
              : null,
          color: hasPrice ? null : AppColors.warning.withValues(alpha: 0.12),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hasPrice ? formatPKR(price!) : 'Tap to set price',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: hasPrice ? Colors.white : AppColors.warning,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Icon(
                  hasPrice ? Icons.add_shopping_cart : Icons.edit_outlined,
                  size: 16,
                  color: hasPrice ? Colors.white : AppColors.warning,
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
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 14,
              color: valueColor,
              fontWeight: valueBold ? FontWeight.bold : FontWeight.w500,
            ),
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
    return LayoutBuilder(builder: (context, constraints) => GridView.builder(
      padding: const EdgeInsets.all(_GridLayout._padding),
      gridDelegate: _GridLayout.fit(
        constraints.maxWidth,
        MediaQuery.textScalerOf(context),
      ).delegate,
      itemCount: 8,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: AppColors.border,
        highlightColor: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    ));
  }
}

/// How the product grid is laid out for a given width and text size.
///
/// A tile is a picture on top of a text part whose content has a fixed height
/// (name, category, two rows, the price button) that grows with the system text
/// scale. A fixed aspect ratio made the tile's height depend on the width only,
/// so it was too short whenever the columns were wide enough to count but the
/// text did not shrink with them (overflow by a pixel or two, or worse with a
/// larger text size). Here the tile height is derived from both: the picture
/// follows the tile width, the text part follows the text scale, and the number
/// of columns follows the available width.
class _GridLayout {
  const _GridLayout(this.delegate, this.imageHeight);

  final SliverGridDelegate delegate;
  final double imageHeight;

  static const _padding = 14.0;
  static const _spacing = 16.0;

  // Everything under the picture: the padding, the gold hairline, the gaps and
  // the price button's own padding (fixed), plus the lines of text (name,
  // category, two rows, the button text) that grow with the system text size.
  static const _fixedInfo = 88.0;
  static const _scaledInfo = 112.0;

  /// Four cards to a line on a normal POS screen (a customer sees few, big,
  /// clear cards); fewer only when the window is too narrow for four.
  static int columnsFor(double available) {
    if (available >= 820) return 4;
    if (available >= 560) return 3;
    return 2;
  }

  static _GridLayout fit(double maxWidth, TextScaler textScaler) {
    final available = (maxWidth - _padding * 2).clamp(0.0, double.infinity);
    final columns = columnsFor(available);
    final cell = ((available - _spacing * (columns - 1)) / columns).clamp(120.0, double.infinity);
    // A large, clear picture: nearly as tall as the card is wide.
    final imageHeight = (cell * 0.82).clamp(110.0, 300.0);
    final scale = textScaler.scale(16) / 16;
    final info = _fixedInfo + _scaledInfo * scale;
    return _GridLayout(
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: _spacing,
        crossAxisSpacing: _spacing,
        mainAxisExtent: imageHeight + info,
      ),
      imageHeight,
    );
  }
}
