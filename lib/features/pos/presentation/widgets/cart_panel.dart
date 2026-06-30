import 'package:cached_network_image/cached_network_image.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/pos/data/models/discount_scheme_model.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_cubit.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_state.dart';
import 'package:frantend/features/pos/presentation/pages/payment_modal.dart';
import 'package:frantend/features/pos/presentation/widgets/held_orders_dialog.dart';
import 'package:frantend/features/pos/presentation/widgets/pos_dialogs.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';

class CartPanel extends StatelessWidget {
  const CartPanel({super.key, this.onPayPressed});

  final VoidCallback? onPayPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosCubit, PosState>(
      builder: (context, state) {
        final cubit = context.read<PosCubit>();
        final isDineIn = state.isDineIn;
        final dineIn = state.dineIn;
        return Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (dineIn?.syncError != null)
                MaterialBanner(
                  content: Text(dineIn!.syncError!),
                  actions: [
                    TextButton(
                      onPressed: () {},
                      child: const SizedBox.shrink(),
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                child: Row(
                  children: [
                    Text(
                      isDineIn ? 'Table Order' : 'Current Sale',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (dineIn?.isSyncingLine == true) ...[
                      const SizedBox(width: 8),
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ],
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${state.cartItems.length} items',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    if (!isDineIn)
                      TextButton.icon(
                        onPressed: state.cartItems.isEmpty || state.isHoldingSale
                            ? null
                            : () async {
                                final defaultLabel =
                                    'Order #${state.heldOrders.length + 1}';
                                final label = await HoldSaleDialog.show(
                                  context,
                                  defaultLabel: defaultLabel,
                                );
                                if (label == null) return;
                                final ok = await cubit.holdCurrentSale(
                                  customLabel:
                                      label.isEmpty ? null : label,
                                );
                                if (ok && context.mounted) {
                                  final heldLabel =
                                      label.isEmpty ? defaultLabel : label;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Order held — $heldLabel'),
                                    ),
                                  );
                                }
                              },
                        icon: const Icon(Icons.pause, size: 18),
                        label: const Text('Hold'),
                      ),
                    TextButton.icon(
                      onPressed: state.cartItems.isEmpty
                          ? null
                          : () async {
                              final ok = await ConfirmDialog.show(
                                context,
                                title: 'Clear cart?',
                                message:
                                    'Remove all items from the current sale?',
                              );
                              if (ok == true) cubit.clearCart();
                            },
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Clear'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: state.cartItems.isEmpty
                    ? const _EmptyCart()
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                        itemCount: state.cartItems.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _CartItemCard(
                            index: index,
                            state: state,
                          ),
                        ),
                      ),
              ),
              if (state.discountSchemes.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: _DiscountSchemePicker(state: state),
                ),
              _CartSummary(state: state),
              if (isDineIn)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: state.cartItems.isEmpty ||
                                  state.isFiringTab ||
                                  dineIn?.isSyncingLine == true
                              ? null
                              : () => cubit.fireCurrentTab(),
                          icon: state.isFiringTab
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.local_fire_department),
                          label: const Text('Fire'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: state.cartItems.isEmpty ||
                                  state.isRequestingBill ||
                                  dineIn?.isSyncingLine == true
                              ? null
                              : () => cubit.requestBillForCurrentTab(),
                          icon: state.isRequestingBill
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.receipt_long),
                          label: const Text('Bill'),
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  height: 56,
                  child: FilledButton(
                    onPressed: state.canProceedToPayment &&
                            dineIn?.isSyncingLine != true
                        ? (onPayPressed ?? () => PaymentModal.show(context))
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.border,
                    ),
                    child: Text(
                      isDineIn
                          ? 'PAY TABLE — ${formatPKR(state.displayGrandTotal.toDouble())}'
                          : 'PAY NOW — ${formatPKR(state.displayGrandTotal.toDouble())}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 48, color: AppColors.textSecondary.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          const Text('Cart is empty',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            'Add products to start a sale',
            style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({required this.index, required this.state});

  final int index;
  final PosState state;

  String? _imageUrlFor(String productId) {
    for (final product in state.products) {
      if (product.id == productId) return product.imageUrl;
    }
    return state.productDetailsCache[productId]?.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PosCubit>();
    final item = state.cartItems[index];
    final hasDiscount = item.lineDiscount > Decimal.zero;
    final hasTax = item.taxRateId != null;
    final taxLabel = hasTax ? item.taxRateName! : 'No tax';
    final imageUrl = _imageUrlFor(item.productId)?.trim();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CartItemImage(
            imageUrl: imageUrl,
            name: item.productName,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              if (item.variationName != null)
                                _VariantBadge(label: item.variationName!),
                              for (final modifier in item.modifiers)
                                _VariantBadge(label: modifier.modifierName),
                              if (item.sku != null) ...[
                                Text(
                                  '•',
                                  style: TextStyle(
                                    color: AppColors.textSecondary
                                        .withValues(alpha: 0.6),
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  item.sku!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () async {
                              final result = await LineTaxRateDialog.show(
                                context,
                                taxRates: state.taxRates,
                                selectedTaxRateId: item.taxRateId,
                              );
                              if (result == null) return;
                              if (result is LineTaxRateNone) {
                                cubit.updateLineTaxRate(index, null);
                              } else if (result is TaxRateModel) {
                                cubit.updateLineTaxRate(index, result);
                              }
                            },
                            child: _TaxBadge(
                              label: taxLabel,
                              hasTax: hasTax,
                            ),
                          ),
                          if (hasDiscount) ...[
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () async {
                                final result = await ItemDiscountDialog.show(
                                  context,
                                  lineSubtotal: item.lineSubtotal,
                                  currentPct: item.effectiveDiscountPct,
                                  currentAmount: item.effectiveDiscountAmount,
                                );
                                if (result != null) {
                                  cubit.updateItemDiscount(
                                    index,
                                    pct: result.$1,
                                    amount: result.$2,
                                  );
                                }
                              },
                              child: Text(
                                'Discount: ${formatPKR(item.lineDiscount.toDouble())}',
                                style: const TextStyle(
                                  color: AppColors.warning,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: AppColors.primary,
                            ),
                            onPressed: () async {
                              final note = await LineNoteDialog.show(
                                context,
                                initialNote: item.lineNote,
                              );
                              if (note != null) cubit.updateLineNote(index, note);
                            },
                            child: Text(
                              item.lineNote?.isNotEmpty == true
                                  ? item.lineNote!
                                  : '+ Add note',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (hasDiscount)
                                  Text(
                                    formatPKR(item.lineSubtotal.toDouble()),
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                Text(
                                  formatPKR(item.lineTotal.toDouble()),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: () => cubit.removeFromCart(index),
                              borderRadius: BorderRadius.circular(4),
                              child: const Padding(
                                padding: EdgeInsets.all(2),
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _QtyStepper(index: index, qty: item.qty),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemImage extends StatelessWidget {
  const _CartItemImage({
    required this.imageUrl,
    required this.name,
  });

  final String? imageUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    final hasNetworkImage = imageUrl != null &&
        imageUrl!.isNotEmpty &&
        imageUrl!.startsWith('http');
    final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 56,
        height: 56,
        child: hasNetworkImage
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => ColoredBox(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  child: const Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => _placeholder(letter),
              )
            : _placeholder(letter),
      ),
    );
  }

  Widget _placeholder(String letter) {
    return ColoredBox(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _VariantBadge extends StatelessWidget {
  const _VariantBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _TaxBadge extends StatelessWidget {
  const _TaxBadge({required this.label, required this.hasTax});

  final String label;
  final bool hasTax;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: hasTax
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: hasTax
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: hasTax ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _QtyStepper extends StatefulWidget {
  const _QtyStepper({required this.index, required this.qty});

  final int index;
  final Decimal qty;

  @override
  State<_QtyStepper> createState() => _QtyStepperState();
}

class _QtyStepperState extends State<_QtyStepper> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.qty.toString());
  }

  @override
  void didUpdateWidget(_QtyStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.qty != widget.qty) {
      _controller.text = widget.qty.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PosCubit>();
    return Container(
      height: 34,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove,
            onPressed: () => cubit.decrementQty(widget.index),
          ),
          Container(width: 1, height: 34, color: AppColors.border),
          SizedBox(
            width: 36,
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              onSubmitted: (v) {
                final qty = Decimal.tryParse(v) ?? Decimal.one;
                cubit.updateCartItemQty(widget.index, qty);
              },
            ),
          ),
          Container(width: 1, height: 34, color: AppColors.border),
          _StepperButton(
            icon: Icons.add,
            color: AppColors.primary,
            onPressed: () => cubit.incrementQty(widget.index),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.onPressed,
    this.color = AppColors.textSecondary,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: 32,
        height: 34,
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({required this.state});
  final PosState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PosCubit>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (state.selectedDiscountScheme != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      state.selectedDiscountScheme!.summaryLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  if (state.isLoadingPricePreview) ...[
                    const SizedBox(width: 8),
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ],
                ],
              ),
            ),
          if (state.pricePreviewError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  state.pricePreviewError!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.error,
                  ),
                ),
              ),
            ),
          _SummaryRow('Subtotal', formatPKR(state.displaySubtotal.toDouble())),
          Row(
            children: [
              const Expanded(child: Text('Discount')),
              Text(formatPKR(state.displayTotalDiscount.toDouble())),
              IconButton(
                iconSize: 14,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () async {
                  final result = await CartDiscountDialog.show(
                    context,
                    currentType: state.cartDiscountType,
                    currentValue: state.cartDiscountDecimal,
                    previewSubtotal: state.displaySubtotal,
                  );
                  if (result != null) {
                    cubit.applyCartDiscount(result.$1, result.$2);
                  }
                },
                icon: const Icon(Icons.edit, size: 14),
              ),
            ],
          ),
          if (state.cartDiscountDecimal > Decimal.zero)
            Row(
              children: [
                Expanded(
                  child: Text(
                    state.cartDiscountType == 'percentage'
                        ? '${state.cartDiscountDecimal}% off applied'
                        : '${formatPKR(state.cartDiscountDecimal.toDouble())} off applied',
                    style: const TextStyle(fontSize: 11, color: AppColors.warning),
                  ),
                ),
                IconButton(
                  iconSize: 14,
                  onPressed: cubit.removeCartDiscount,
                  icon: const Icon(Icons.close, size: 14),
                ),
              ],
            ),
          _SummaryRow('Tax', formatPKR(state.displayTotalTax.toDouble())),
          const Divider(),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'TOTAL',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Text(
                formatPKR(state.displayGrandTotal.toDouble()),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DiscountSchemePicker extends StatelessWidget {
  const _DiscountSchemePicker({required this.state});

  final PosState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PosCubit>();
    return DropdownButtonFormField<String?>(
      value: state.selectedDiscountSchemeId,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Discount scheme',
        isDense: true,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: [
        const DropdownMenuItem<String?>(
          value: null,
          child: Text('No scheme'),
        ),
        ...state.discountSchemes.map(
          (scheme) => DropdownMenuItem<String?>(
            value: scheme.id,
            child: Text(scheme.summaryLabel),
          ),
        ),
      ],
      onChanged: cubit.selectDiscountScheme,
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value),
        ],
      ),
    );
  }
}
