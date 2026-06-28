import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/cash_register/presentation/widgets/shift_summary_widgets.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_cubit.dart';
import 'package:frantend/features/pos/presentation/cubit/pos_state.dart';
import 'package:frantend/features/pos/presentation/pages/payment_modal.dart';
import 'package:frantend/features/pos/presentation/widgets/cart_panel.dart';
import 'package:frantend/features/pos/presentation/widgets/customer_picker_dialog.dart';
import 'package:frantend/features/pos/presentation/widgets/held_orders_dialog.dart';
import 'package:frantend/features/pos/presentation/utils/pos_product_actions.dart';
import 'package:frantend/features/pos/presentation/widgets/product_grid_area.dart';
import 'package:frantend/shared/widgets/dialogs/confirm_dialog.dart';
import 'package:go_router/go_router.dart';

class PosPage extends StatefulWidget {
  const PosPage({super.key});

  @override
  State<PosPage> createState() => _PosPageState();
}

class _PosPageState extends State<PosPage> {
  final _searchFocusNode = FocusNode();
  final _searchController = TextEditingController();
  bool _paymentModalOpen = false;

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleBarcodeOrSearch(PosCubit cubit) async {
    final text = _searchController.text.trim();
    debugPrint('[POS:Enter] barcode lookup for "$text"');
    if (text.isEmpty) {
      debugPrint('[POS:Enter] SKIP — empty search text');
      return;
    }

    final found = await addBarcodeWithPricePrompt(context, cubit, text);
    debugPrint('[POS:Enter] barcode result found=$found');
    _searchController.clear();
    cubit.setSearchQueryImmediate('');
    if (!found && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product not found')),
      );
    }
    _searchFocusNode.requestFocus();
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter) {
      debugPrint(
        '[POS:Key] Enter pressed searchText="${_searchController.text}"',
      );
      _handleBarcodeOrSearch(context.read<PosCubit>());
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.f2): () =>
            _searchFocusNode.requestFocus(),
        const SingleActivator(LogicalKeyboardKey.f4): () =>
            _openCustomerPicker(context),
        const SingleActivator(LogicalKeyboardKey.f8): () {
          final state = context.read<PosCubit>().state;
          if (state.cartItems.isNotEmpty) {
            PaymentModal.show(context);
          }
        },
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            _handleEscape(context),
      },
      child: Focus(
        autofocus: true,
        child: BlocBuilder<PosCubit, PosState>(
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    // shift , walkin customer , search part
                    _PosHeader(
                      state: state,
                      searchController: _searchController,
                      searchFocusNode: _searchFocusNode,
                      onSearchKey: _handleKey,
                      onSearchChanged: (v) {
                        context.read<PosCubit>().setSearchQueryImmediate(v);
                        context.read<PosCubit>().searchProducts(v);
                      },
                      onCustomerTap: () => _openCustomerPicker(context),
                      onShiftTap: () => _showShiftSummary(context, state),
                      onHeldOrdersTap: () => HeldOrdersDialog.show(context),
                    ),
                    Expanded(
                      child: state.isShiftReady
                          ? Row(
                              children: [
                                const Expanded(
                                  flex: 65,
                                  child: ProductGridArea(),
                                ),
                                Container(
                                  width: 1,
                                  color: AppColors.border,
                                ),
                                SizedBox(
                                  width: 460,
                                  child: CartPanel(
                                    onPayPressed: () =>
                                        PaymentModal.show(context),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      color: AppColors.background,
                      child: const Text(
                        'F2 Search • F4 Customer • F8 Payment • ESC Cancel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (state.isCheckingShift)
                  Container(
                    color: Colors.white.withValues(alpha: 0.8),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (!state.isCheckingShift && !state.isShiftReady)
                  _ShiftGateOverlay(state: state),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _openCustomerPicker(BuildContext context) async {
    final customer = await CustomerPickerDialog.show(context);
    if (context.mounted) {
      context.read<PosCubit>().selectCustomer(customer);
    }
  }

  Future<void> _handleEscape(BuildContext context) async {
    if (_paymentModalOpen) {
      final navigator = Navigator.of(context, rootNavigator: true);
      if (navigator.canPop()) {
        navigator.pop();
      }
      return;
    }
    final state = context.read<PosCubit>().state;
    if (state.cartItems.isEmpty) return;
    final ok = await ConfirmDialog.show(
      context,
      title: 'Clear cart?',
      message: 'Remove all items from the current sale?',
    );
    if (ok == true && context.mounted) {
      context.read<PosCubit>().clearCart();
    }
  }

  void _showShiftSummary(BuildContext context, PosState state) {
    final summary = state.shiftSummary;
    final shift = state.activeShift;
    final registerName = _registerNameForShift(state);

    void dismissPopover(BuildContext dialogContext) {
      if (Navigator.canPop(dialogContext)) {
        Navigator.pop(dialogContext);
      }
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Shift Summary'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (shift?.openingFloat != null)
              Text(
                'Opening float: ${formatPKR(double.tryParse(shift!.openingFloat) ?? 0)}',
              ),
            if (summary != null) ...[
              Text(
                'Cash sales: ${ShiftFormatUtils.formatMoney(summary.totalCashSales)}',
              ),
              Text(
                'Expected cash: ${ShiftFormatUtils.formatMoney(summary.expectedCash)}',
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => dismissPopover(dialogContext),
            child: const Text('Done'),
          ),
          OutlinedButton(
            onPressed: shift == null || summary == null
                ? null
                : () {
                    dismissPopover(dialogContext);
                    context
                        .push(
                          RouteNames.closeShift,
                          extra: {
                            'shiftId': shift.id,
                            'summary': summary,
                            'registerName': registerName,
                          },
                        )
                        .then((_) {
                      if (context.mounted) {
                        context.read<PosCubit>().checkActiveShift();
                      }
                    });
                  },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.warning,
              side: const BorderSide(color: AppColors.warning),
            ),
            child: const Text('Close Shift →'),
          ),
        ],
      ),
    );
  }

  String _registerNameForShift(PosState state) {
    final shift = state.activeShift;
    final embeddedName = shift?.register?.name;
    if (embeddedName != null && embeddedName.isNotEmpty) {
      return embeddedName;
    }

    final registerId = shift?.cashRegisterId ?? state.selectedRegisterId;
    if (registerId != null) {
      for (final register in state.registers) {
        if (register.id == registerId) return register.name;
      }
    }

    return state.registers.isNotEmpty ? state.registers.first.name : '';
  }
}

class _PosHeader extends StatelessWidget {
  const _PosHeader({
    required this.state,
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearchKey,
    required this.onSearchChanged,
    required this.onCustomerTap,
    required this.onShiftTap,
    required this.onHeldOrdersTap,
  });

  final PosState state;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final FocusOnKeyEventCallback onSearchKey;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onCustomerTap;
  final VoidCallback onShiftTap;
  final VoidCallback onHeldOrdersTap;

  @override
  Widget build(BuildContext context) {
    final hasCustomer = state.selectedCustomer != null;
    return Container(
      height: 66,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          Text(
            state.cashierName ?? 'Cashier',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const Text('  •  ', style: TextStyle(color: AppColors.textSecondary)),
          InkWell(
            onTap: onShiftTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                    state.isOffline ? 'Shift Open (Offline)' : 'Shift Open',
                    style: const TextStyle(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
            ),
          ),
          if (state.heldOrders.isNotEmpty) ...[
            const SizedBox(width: 8),
            InkWell(
              onTap: onHeldOrdersTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  '📋 Held Orders (${state.heldOrders.length})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.warning,
                  ),
                ),
              ),
            ),
          ],
          const Spacer(),
          InkWell(
            onTap: onCustomerTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: hasCustomer
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: hasCustomer ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Text(
                hasCustomer
                    ? '👤 ${state.selectedCustomer!.name}'
                    : '👤 Walk-in Customer',
                style: TextStyle(
                  fontSize: 16,
                  color: hasCustomer ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 26),
          SizedBox(
            width: 250,
            child: Focus(
              onKeyEvent: onSearchKey,
              child: TextField(
                controller: searchController,
                focusNode: searchFocusNode,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Scan barcode or search product...' ,
                  hintStyle: const TextStyle(fontSize: 16),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.search, size: 28),
                ),
                onChanged: onSearchChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShiftGateOverlay extends StatefulWidget {
  const _ShiftGateOverlay({required this.state});

  final PosState state;

  @override
  State<_ShiftGateOverlay> createState() => _ShiftGateOverlayState();
}

class _ShiftGateOverlayState extends State<_ShiftGateOverlay> {
  final _floatController = TextEditingController(text: '0');
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _floatController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PosCubit>();
    final registers = widget.state.registers;

    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: SizedBox(
            width: 420,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.point_of_sale,
                    size: 48,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No Active Shift',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You need to open a register shift before making sales',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  if (registers.length > 1)
                    DropdownButtonFormField<String>(
                      value: widget.state.selectedRegisterId,
                      decoration: const InputDecoration(
                        labelText: 'Cash Register',
                        border: OutlineInputBorder(),
                      ),
                      items: registers
                          .map(
                            (r) => DropdownMenuItem(
                              value: r.id,
                              child: Text(r.name),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) cubit.selectRegister(v);
                      },
                    )
                  else if (registers.isNotEmpty)
                    ListTile(
                      title: Text(registers.first.name),
                      subtitle: const Text('Cash Register'),
                      leading: const Icon(Icons.store),
                    )
                  else
                    Column(
                      children: [
                        const Text(
                          'Is branch ke liye koi cash register setup nahi hai.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.error),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Pehle register banao, phir shift open karein.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: widget.state.isCreatingRegister
                              ? null
                              : () async {
                                  final ok = await cubit.createDefaultRegister();
                                  if (!ok && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          widget.state.registersError ??
                                              'Register create nahi ho saka',
                                        ),
                                      ),
                                    );
                                  }
                                },
                          icon: widget.state.isCreatingRegister
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.add),
                          label: const Text('Create Main Counter Register'),
                        ),
                      ],
                    ),
                  if (widget.state.registersError != null &&
                      registers.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      widget.state.registersError!,
                      style: const TextStyle(color: AppColors.error, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextField(
                    controller: _floatController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Opening Float *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: widget.state.isOpeningShift ||
                              registers.isEmpty ||
                              widget.state.isCreatingRegister
                          ? null
                          : () async {
                              final float = Decimal.tryParse(
                                    _floatController.text,
                                  ) ??
                                  Decimal.zero;
                              final ok = await cubit.openShift(
                                float,
                                _notesController.text.trim(),
                              );
                              if (!ok && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to open shift'),
                                  ),
                                );
                              }
                            },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: widget.state.isOpeningShift
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Open Shift & Start Selling'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
