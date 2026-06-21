import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_cubit.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_state.dart';
import 'package:frantend/features/pos/presentation/pages/payment_modal.dart';
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
        return Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                child: Row(
                  children: [
                    const Text(
                      'Current Sale',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
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
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: state.cartItems.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) => _CartItemRow(
                          index: index,
                          state: state,
                        ),
                      ),
              ),
              _CartSummary(state: state),
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  height: 56,
                  child: FilledButton(
                    onPressed: state.cartItems.isEmpty
                        ? null
                        : (onPayPressed ??
                            () => PaymentModal.show(context)),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.border,
                    ),
                    child: Text(
                      'PAY NOW — ${formatPKR(state.grandTotal.toDouble())}',
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

class _CartItemRow extends StatelessWidget {
  const _CartItemRow({required this.index, required this.state});

  final int index;
  final PosState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PosCubit>();
    final item = state.cartItems[index];
    final hasDiscount = item.lineDiscount > Decimal.zero;
    final hasTax = item.taxRateId != null;
    final taxLabel = hasTax ? item.taxRateName! : 'No tax';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    if (item.variationName != null)
                      Container(
                        margin: const EdgeInsets.only(right: 6, top: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.variationName!,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    if (item.sku != null)
                      Text(
                        item.sku!,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
                if (hasDiscount)
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
                      ),
                    ),
                  ),
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
                  child: Container(
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: hasTax
                          ? AppColors.primary.withValues(alpha: 0.08)
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: hasTax
                            ? AppColors.primary.withValues(alpha: 0.25)
                            : AppColors.border,
                      ),
                    ),
                    child: Text(
                      taxLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: hasTax
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          _QtyStepper(index: index, qty: item.qty),
          const SizedBox(width: 8),
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
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          IconButton(
            iconSize: 16,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => cubit.removeFromCart(index),
            icon: const Icon(Icons.close, size: 16),
          ),
        ],
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
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 16),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            onPressed: () => cubit.decrementQty(widget.index),
          ),
          SizedBox(
            width: 36,
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              style: const TextStyle(fontSize: 13),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (v) {
                final qty = Decimal.tryParse(v) ?? Decimal.one;
                cubit.updateCartItemQty(widget.index, qty);
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 16),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            onPressed: () => cubit.incrementQty(widget.index),
          ),
        ],
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
          _SummaryRow('Subtotal', formatPKR(state.subtotal.toDouble())),
          Row(
            children: [
              const Expanded(child: Text('Discount')),
              Text(formatPKR(state.totalDiscount.toDouble())),
              IconButton(
                iconSize: 14,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () async {
                  final result = await CartDiscountDialog.show(
                    context,
                    currentType: state.cartDiscountType,
                    currentValue: state.cartDiscountDecimal,
                    previewSubtotal: state.subtotal,
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
          _SummaryRow('Tax', formatPKR(state.totalTax.toDouble())),
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
                formatPKR(state.grandTotal.toDouble()),
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
