import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/shared/utils/quantity_expression.dart';

/// Everything the quantity calculator shows. Plain values only, so the same
/// widget serves the desktop POS and a future mobile app.
class QuantityCalculatorConfig {
  const QuantityCalculatorConfig({
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.unitPrice,
    this.priceUpdates,
    this.unitLabel,
    this.allowDecimal = false,
    this.stock,
    this.lowStockLevel,
    this.blockBelowStock = false,
    this.initialQuantity,
    this.canEditPrice = false,
    this.lineTotal,
    this.formatMoney,
    this.quickQuantities = const [1, 2, 3, 5, 10],
  });

  final String title;
  final String? subtitle;
  final String? imageUrl;

  /// Price of one unit; null hides the price and the total.
  final Decimal? unitPrice;

  /// New list prices while the popup is open (a price changed elsewhere, or
  /// the customer did): the popup then shows and totals with the new price.
  final Stream<Decimal?>? priceUpdates;

  /// Short unit name shown next to quantities ("kg", "pcs").
  final String? unitLabel;

  /// Fractions (up to 3 places) for weight / volume units.
  final bool allowDecimal;

  /// Known stock; null = unknown (nothing is shown).
  final Decimal? stock;
  final Decimal? lowStockLevel;

  /// True only when the owner forbids selling below stock: then a quantity
  /// above [stock] cannot be confirmed. Otherwise it is only a warning.
  final bool blockBelowStock;

  /// Set to edit an existing line: the popup opens with this quantity and
  /// offers Update / Remove instead of Add.
  final Decimal? initialQuantity;

  /// Tap on the price to type another one (price-override permission).
  final bool canEditPrice;

  /// Line total for a quantity and unit price (tax / discount rules of the
  /// caller). Defaults to quantity x price.
  final Decimal Function(Decimal quantity, Decimal unitPrice)? lineTotal;
  final String Function(Decimal amount)? formatMoney;
  final List<int> quickQuantities;

  bool get isEdit => initialQuantity != null;
}

enum QuantityCalculatorAction { confirm, remove }

class QuantityCalculatorResult {
  const QuantityCalculatorResult.confirm(Decimal this.quantity, {this.unitPrice})
      : action = QuantityCalculatorAction.confirm;
  const QuantityCalculatorResult.remove()
      : action = QuantityCalculatorAction.remove,
        quantity = null,
        unitPrice = null;

  final QuantityCalculatorAction action;
  final Decimal? quantity;

  /// Only set when the user typed a different price.
  final Decimal? unitPrice;
}

/// Fast quantity entry: a keypad with `× + − ÷`, quick chips, a live total,
/// full physical-keyboard support (digits, operators, Backspace, Enter, Esc).
///
/// [show] picks the container: a centered dialog on wide windows, a modal
/// bottom sheet below 600 px.
class QuantityCalculatorSheet extends StatefulWidget {
  const QuantityCalculatorSheet({super.key, required this.config});

  final QuantityCalculatorConfig config;

  static const dialogWidth = 420.0;
  static const narrowBreakpoint = 600.0;

  static Future<QuantityCalculatorResult?> show(
    BuildContext context,
    QuantityCalculatorConfig config,
  ) {
    final narrow =
        MediaQuery.sizeOf(context).width < narrowBreakpoint;
    if (narrow) {
      return showModalBottomSheet<QuantityCalculatorResult>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => SafeArea(
          child: QuantityCalculatorSheet(config: config),
        ),
      );
    }
    return showDialog<QuantityCalculatorResult>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.surface,
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: dialogWidth),
          child: QuantityCalculatorSheet(config: config),
        ),
      ),
    );
  }

  @override
  State<QuantityCalculatorSheet> createState() => _QuantityCalculatorSheetState();
}

class _QuantityCalculatorSheetState extends State<QuantityCalculatorSheet> {
  static const _maxLength = 24;

  final _focus = FocusNode(debugLabel: 'quantity-calculator');

  /// What was typed for the quantity (canonical operator symbols).
  String _expr = '';

  /// Edit mode opens with the current quantity; the first digit replaces it.
  bool _fresh = false;

  /// True while the keypad types the price instead of the quantity.
  bool _priceMode = false;
  String _priceText = '';
  Decimal? _manualPrice;
  Decimal? _livePrice;
  StreamSubscription<Decimal?>? _priceSub;

  bool _attempted = false;
  bool _closed = false;

  QuantityCalculatorConfig get _config => widget.config;

  @override
  void initState() {
    super.initState();
    _priceSub = _config.priceUpdates?.listen((p) {
      if (p == null || p <= Decimal.zero || !mounted) return;
      setState(() => _livePrice = p);
    });
    final initial = _config.initialQuantity;
    if (initial != null) {
      _expr = initial.toString();
      _fresh = true;
    }
  }

  @override
  void dispose() {
    _priceSub?.cancel();
    _focus.dispose();
    super.dispose();
  }

  // ── values ───────────────────────────────────────────────────────────

  Decimal? get _price => _manualPrice ?? _livePrice ?? _config.unitPrice;

  QuantityCheck get _check {
    final check = QuantityRules.parse(_expr, allowDecimal: _config.allowDecimal);
    final qty = check.quantity;
    final stock = _config.stock;
    if (qty != null && _config.blockBelowStock && stock != null && qty > stock) {
      return QuantityCheck.failed(
        QuantityError.insufficientStock,
        stock > Decimal.zero
            ? 'Only ${_qtyText(stock)} in stock'
            : 'Out of stock',
      );
    }
    return check;
  }

  String _money(Decimal value) =>
      _config.formatMoney?.call(value) ?? formatPKR(value.toDouble());

  String _qtyText(Decimal value) {
    final unit = _config.unitLabel;
    return unit == null || unit.isEmpty ? '$value' : '$value $unit';
  }

  /// Errors that are only noise while a number is still being typed.
  bool _showsLive(QuantityCheck check) =>
      check.error == QuantityError.tooLarge ||
      check.error == QuantityError.notWhole ||
      check.error == QuantityError.insufficientStock;

  // ── input ────────────────────────────────────────────────────────────

  String get _currentNumber {
    var i = _expr.length;
    while (i > 0 && !QuantityExpression.isOperator(_expr[i - 1])) {
      i--;
    }
    return _expr.substring(i);
  }

  void _type(String char) {
    if (_closed) return;
    setState(() {
      _attempted = false;
      if (_priceMode) {
        _typePrice(char);
      } else {
        _typeQuantity(char);
      }
    });
  }

  void _typePrice(String char) {
    if (QuantityExpression.isOperator(char)) return;
    if (char == '.') {
      if (_priceText.contains('.')) return;
      _priceText = _priceText.isEmpty ? '0.' : '$_priceText.';
      return;
    }
    final dot = _priceText.indexOf('.');
    if (dot >= 0 && _priceText.length - dot > 2) return;
    if (_priceText.length >= 12) return;
    _priceText = _priceText == '0' ? char : '$_priceText$char';
  }

  void _typeQuantity(String char) {
    if (QuantityExpression.isOperator(char)) {
      _fresh = false;
      if (_expr.isEmpty) return;
      final last = _expr[_expr.length - 1];
      if (QuantityExpression.isOperator(last)) {
        _expr = _expr.substring(0, _expr.length - 1);
      }
      if (_expr.length < _maxLength) _expr = '$_expr$char';
      return;
    }
    if (_fresh) {
      _expr = '';
      _fresh = false;
    }
    if (_expr.length >= _maxLength) return;
    final number = _currentNumber;
    if (char == '.') {
      if (number.contains('.')) return;
      _expr = number.isEmpty ? '${_expr}0.' : '$_expr.';
      return;
    }
    final dot = number.indexOf('.');
    if (dot >= 0 && number.length - dot > QuantityRules.maxDecimals) return;
    // "0" then a digit: replace the lone zero instead of "05".
    if (number == '0') _expr = _expr.substring(0, _expr.length - 1);
    _expr = '$_expr$char';
  }

  void _backspace() {
    if (_closed) return;
    setState(() {
      _attempted = false;
      if (_priceMode) {
        if (_priceText.isNotEmpty) {
          _priceText = _priceText.substring(0, _priceText.length - 1);
        }
        return;
      }
      _fresh = false;
      if (_expr.isNotEmpty) _expr = _expr.substring(0, _expr.length - 1);
    });
  }

  void _clear() {
    if (_closed) return;
    setState(() {
      _attempted = false;
      if (_priceMode) {
        _priceText = '';
      } else {
        _expr = '';
        _fresh = false;
      }
    });
  }

  void _setQuick(int quantity) {
    if (_closed) return;
    setState(() {
      _commitPrice();
      _attempted = false;
      _fresh = false;
      _expr = '$quantity';
    });
  }

  // ── price editing ────────────────────────────────────────────────────

  void _startPriceEdit() {
    if (!_config.canEditPrice || _closed) return;
    setState(() {
      _priceMode = true;
      _priceText = '';
      _attempted = false;
    });
  }

  /// Leaves price mode, keeping a valid typed price. False = invalid price.
  bool _commitPrice() {
    if (!_priceMode) return true;
    if (_priceText.isNotEmpty) {
      final typed = Decimal.tryParse(
        _priceText.endsWith('.') ? '${_priceText}0' : _priceText,
      );
      if (typed == null || typed <= Decimal.zero) return false;
      _manualPrice = typed == (_livePrice ?? _config.unitPrice) ? null : typed;
    }
    _priceMode = false;
    _priceText = '';
    return true;
  }

  // ── actions ──────────────────────────────────────────────────────────

  void _submit() {
    if (_closed) return;
    if (_priceMode) {
      // Enter on the price confirms the price and returns to the quantity.
      setState(() => _attempted = !_commitPrice());
      return;
    }
    final check = _check;
    final qty = check.quantity;
    if (qty == null) {
      setState(() => _attempted = true);
      return;
    }
    _closed = true; // a second tap / Enter cannot add twice
    Navigator.of(context).pop(
      QuantityCalculatorResult.confirm(qty, unitPrice: _manualPrice),
    );
  }

  void _remove() {
    if (_closed) return;
    _closed = true;
    Navigator.of(context).pop(const QuantityCalculatorResult.remove());
  }

  void _cancel() {
    if (_closed) return;
    if (_priceMode) {
      setState(() {
        _priceMode = false;
        _priceText = '';
        _attempted = false;
      });
      return;
    }
    _closed = true;
    Navigator.of(context).pop();
  }

  // ── keyboard ─────────────────────────────────────────────────────────

  static final Map<LogicalKeyboardKey, String> _keyChars = {
    LogicalKeyboardKey.digit0: '0',
    LogicalKeyboardKey.digit1: '1',
    LogicalKeyboardKey.digit2: '2',
    LogicalKeyboardKey.digit3: '3',
    LogicalKeyboardKey.digit4: '4',
    LogicalKeyboardKey.digit5: '5',
    LogicalKeyboardKey.digit6: '6',
    LogicalKeyboardKey.digit7: '7',
    LogicalKeyboardKey.digit8: '8',
    LogicalKeyboardKey.digit9: '9',
    LogicalKeyboardKey.numpad0: '0',
    LogicalKeyboardKey.numpad1: '1',
    LogicalKeyboardKey.numpad2: '2',
    LogicalKeyboardKey.numpad3: '3',
    LogicalKeyboardKey.numpad4: '4',
    LogicalKeyboardKey.numpad5: '5',
    LogicalKeyboardKey.numpad6: '6',
    LogicalKeyboardKey.numpad7: '7',
    LogicalKeyboardKey.numpad8: '8',
    LogicalKeyboardKey.numpad9: '9',
    LogicalKeyboardKey.period: '.',
    LogicalKeyboardKey.numpadDecimal: '.',
    LogicalKeyboardKey.add: '+',
    LogicalKeyboardKey.numpadAdd: '+',
    LogicalKeyboardKey.minus: '-',
    LogicalKeyboardKey.numpadSubtract: '-',
    LogicalKeyboardKey.asterisk: '×',
    LogicalKeyboardKey.numpadMultiply: '×',
    LogicalKeyboardKey.keyX: '×',
    LogicalKeyboardKey.slash: '÷',
    LogicalKeyboardKey.numpadDivide: '÷',
  };

  static const _typedChars = {
    '0': '0', '1': '1', '2': '2', '3': '3', '4': '4', '5': '5', '6': '6',
    '7': '7', '8': '8', '9': '9', '.': '.', '+': '+', '-': '-', '*': '×',
    'x': '×', 'X': '×', '/': '÷',
  };

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
      if (event is KeyDownEvent) _submit();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape) {
      if (event is KeyDownEvent) _cancel();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.backspace) {
      _backspace();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.delete) {
      _clear();
      return KeyEventResult.handled;
    }
    // The typed character wins (Shift+8 is "*", Shift+= is "+").
    final char = _typedChars[event.character] ?? _keyChars[key];
    if (char == null) return KeyEventResult.ignored;
    _type(char);
    return KeyEventResult.handled;
  }

  // ── build ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final check = _check;
    final showError = check.error != null && (_attempted || _showsLive(check));
    final priceError = _priceMode && _attempted;

    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(
              config: _config,
              price: _price,
              priceEdited: _manualPrice != null,
              priceMode: _priceMode,
              money: _money,
              qtyText: _qtyText,
              onPriceTap: _startPriceEdit,
              onClose: _cancel,
            ),
            const SizedBox(height: 14),
            _AmountCard(
              label: _priceMode ? 'New price' : 'Quantity',
              expression: _priceMode
                  ? (_priceText.isEmpty ? '0' : _priceText)
                  : (_expr.isEmpty ? '1' : _expr),
              dimmed: !_priceMode && _expr.isEmpty,
              result: _resultLine(check),
              total: _totalText(check),
            ),
            SizedBox(
              height: 26,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _message(check, showError: showError, priceError: priceError),
              ),
            ),
            if (!_priceMode) ...[
              Row(
                children: [
                  for (final q in _config.quickQuantities) ...[
                    Expanded(
                      child: _QuickChip(
                        key: Key('qty-chip-$q'),
                        label: '$q',
                        onTap: () => _setQuick(q),
                      ),
                    ),
                    if (q != _config.quickQuantities.last) const SizedBox(width: 8),
                  ],
                ],
              ),
              const SizedBox(height: 10),
            ],
            _Keypad(onType: _type, onBackspace: _backspace, onClear: _clear),
            const SizedBox(height: 14),
            Row(
              children: [
                if (_config.isEdit && !_priceMode) ...[
                  Expanded(
                    child: ExcludeFocus(
                      child: SizedBox(
                      height: 56,
                      child: OutlinedButton.icon(
                        key: const Key('qty-remove'),
                        onPressed: _remove,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text(
                          'Remove',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  flex: 2,
                  child: _ConfirmButton(
                    label: _priceMode
                        ? 'Set price'
                        : (_config.isEdit ? 'Update' : 'Add'),
                    onTap: _submit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? _resultLine(QuantityCheck check) {
    if (_priceMode) return null;
    final qty = check.quantity;
    if (qty == null) return null;
    final hasOperator = _expr.split('').any(QuantityExpression.isOperator);
    final unit = _config.unitLabel;
    if (!hasOperator) return unit == null || unit.isEmpty ? null : unit;
    return '= ${_qtyText(qty)}';
  }

  String? _totalText(QuantityCheck check) {
    final price = _price;
    final qty = check.quantity;
    if (price == null || qty == null) return null;
    final total = _config.lineTotal?.call(qty, price) ?? qty * price;
    return _money(total);
  }

  Widget _message(
    QuantityCheck check, {
    required bool showError,
    required bool priceError,
  }) {
    if (priceError) {
      return const _Notice(
        key: Key('qty-error'),
        text: 'Enter a price greater than 0',
        color: AppColors.error,
      );
    }
    if (_priceMode) {
      return const _Notice(
        text: 'Type the new price, then Enter',
        color: AppColors.textSecondary,
      );
    }
    if (showError) {
      return _Notice(
        key: const Key('qty-error'),
        text: check.message ?? 'Enter a valid quantity',
        color: AppColors.error,
      );
    }
    final qty = check.quantity;
    final stock = _config.stock;
    if (qty != null && stock != null && qty > stock) {
      return _Notice(
        key: const Key('qty-stock-warning'),
        text: stock > Decimal.zero
            ? 'More than the ${_qtyText(stock)} in stock'
            : 'No stock on record - selling anyway',
        color: AppColors.warning,
      );
    }
    return const SizedBox.shrink();
  }
}

// ── pieces ─────────────────────────────────────────────────────────────────

const _gradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [AppColors.primary, AppColors.primaryLight, AppColors.success],
);

class _Header extends StatelessWidget {
  const _Header({
    required this.config,
    required this.price,
    required this.priceEdited,
    required this.priceMode,
    required this.money,
    required this.qtyText,
    required this.onPriceTap,
    required this.onClose,
  });

  final QuantityCalculatorConfig config;
  final Decimal? price;
  final bool priceEdited;
  final bool priceMode;
  final String Function(Decimal) money;
  final String Function(Decimal) qtyText;
  final VoidCallback onPriceTap;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final url = config.imageUrl?.trim();
    final hasImage = url != null && url.startsWith('http');
    final letter = config.title.isEmpty ? '?' : config.title[0].toUpperCase();
    final placeholder = ColoredBox(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );

    final priceWidget = price == null
        ? const SizedBox.shrink()
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                money(price!),
                key: const Key('qty-price'),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: priceEdited ? AppColors.warning : AppColors.primary,
                ),
              ),
              if (config.canEditPrice) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: priceMode ? AppColors.primary : AppColors.textSecondary,
                ),
              ],
            ],
          );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 64,
            height: 64,
            child: hasImage
                ? CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => placeholder,
                    errorWidget: (_, __, ___) => placeholder,
                  )
                : placeholder,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                config.subtitle == null || config.subtitle!.isEmpty
                    ? config.title
                    : '${config.title} (${config.subtitle})',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              if (config.canEditPrice && price != null)
                InkWell(
                  key: const Key('qty-price-edit'),
                  onTap: onPriceTap,
                  canRequestFocus: false,
                  borderRadius: BorderRadius.circular(8),
                  child: priceWidget,
                )
              else
                priceWidget,
              _StockLine(config: config, qtyText: qtyText),
            ],
          ),
        ),
        ExcludeFocus(
          child: IconButton(
            key: const Key('qty-close'),
            onPressed: onClose,
            tooltip: 'Cancel (Esc)',
            icon: const Icon(Icons.close, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _StockLine extends StatelessWidget {
  const _StockLine({required this.config, required this.qtyText});

  final QuantityCalculatorConfig config;
  final String Function(Decimal) qtyText;

  @override
  Widget build(BuildContext context) {
    final stock = config.stock;
    if (stock == null) return const SizedBox.shrink();
    final low = config.lowStockLevel;
    final String text;
    final Color color;
    if (stock < Decimal.zero) {
      text = 'Stock: ${qtyText(stock)} (negative)';
      color = AppColors.error;
    } else if (stock == Decimal.zero) {
      text = 'Out of stock';
      color = AppColors.error;
    } else if (low != null && stock <= low) {
      text = 'Low stock: ${qtyText(stock)} left';
      color = AppColors.warning;
    } else {
      text = 'In stock: ${qtyText(stock)}';
      color = AppColors.textSecondary;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        text,
        key: const Key('qty-stock'),
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.label,
    required this.expression,
    required this.dimmed,
    this.result,
    this.total,
  });

  final String label;
  final String expression;
  final bool dimmed;
  final String? result;
  final String? total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: _gradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.85),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    expression,
                    key: const Key('qty-display'),
                    maxLines: 1,
                    style: TextStyle(
                      color: AppColors.textOnPrimary
                          .withValues(alpha: dimmed ? 0.6 : 1),
                      fontSize: 38,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  result ?? ' ',
                  key: const Key('qty-result'),
                  style: const TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (total != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
                Text(
                  total!,
                  key: const Key('qty-total'),
                  style: const TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        canRequestFocus: false,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 44,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({
    required this.onType,
    required this.onBackspace,
    required this.onClear,
  });

  final ValueChanged<String> onType;
  final VoidCallback onBackspace;
  final VoidCallback onClear;

  static const _rows = [
    ['7', '8', '9', '÷'],
    ['4', '5', '6', '×'],
    ['1', '2', '3', '-'],
    ['.', '0', '<', '+'],
  ];

  static const _keyNames = {
    '÷': 'div',
    '×': 'x',
    '-': 'minus',
    '+': 'plus',
    '.': 'dot',
    '<': 'back',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final row in _rows)
          Padding(
            padding: EdgeInsets.only(bottom: row == _rows.last ? 0 : 8),
            child: Row(
              children: [
                for (final key in row) ...[
                  Expanded(
                    child: _Key(
                      key: Key('qty-key-${_keyNames[key] ?? key}'),
                      label: key,
                      onTap: key == '<' ? onBackspace : () => onType(key),
                      onLongPress: key == '<' ? onClear : null,
                    ),
                  ),
                  if (key != row.last) const SizedBox(width: 8),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({
    super.key,
    required this.label,
    required this.onTap,
    this.onLongPress,
  });

  final String label;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final isOperator = QuantityExpression.isOperator(label);
    final isBack = label == '<';
    return Material(
      color: isOperator ? AppColors.inputFill : AppColors.background,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        canRequestFocus: false,
        borderRadius: BorderRadius.circular(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Center(
            child: isBack
                ? const Icon(Icons.backspace_outlined, color: AppColors.textPrimary)
                : Text(
                    label == '-' ? '−' : label,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: isOperator ? AppColors.info : AppColors.textPrimary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      child: Ink(
        decoration: const BoxDecoration(gradient: _gradient),
        child: InkWell(
          key: const Key('qty-confirm'),
          onTap: onTap,
          canRequestFocus: false,
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check, color: AppColors.textOnPrimary),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
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
