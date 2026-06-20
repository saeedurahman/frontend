import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/shared/widgets/buttons/primary_button.dart';

class CartDiscountDialog extends StatefulWidget {
  const CartDiscountDialog({
    super.key,
    required this.currentType,
    required this.currentValue,
    required this.previewSubtotal,
  });

  final String? currentType;
  final Decimal currentValue;
  final Decimal previewSubtotal;

  static Future<(String type, Decimal value)?> show(
    BuildContext context, {
    String? currentType,
    Decimal? currentValue,
    required Decimal previewSubtotal,
  }) {
    return showDialog<(String, Decimal)?>(
      context: context,
      builder: (_) => CartDiscountDialog(
        currentType: currentType,
        currentValue: currentValue ?? Decimal.zero,
        previewSubtotal: previewSubtotal,
      ),
    );
  }

  @override
  State<CartDiscountDialog> createState() => _CartDiscountDialogState();
}

class _CartDiscountDialogState extends State<CartDiscountDialog> {
  late bool _isPercentage;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _isPercentage = widget.currentType != 'fixed';
    _controller = TextEditingController(
      text: widget.currentValue > Decimal.zero
          ? widget.currentValue.toString()
          : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Decimal get _previewReduction {
    final value = Decimal.tryParse(_controller.text) ?? Decimal.zero;
    if (value <= Decimal.zero) return Decimal.zero;
    if (_isPercentage) {
      return (widget.previewSubtotal * value / Decimal.fromInt(100))
          .toDecimal(scaleOnInfinitePrecision: 10);
    }
    return value > widget.previewSubtotal ? widget.previewSubtotal : value;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cart Discount'),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Percentage')),
                ButtonSegment(value: false, label: Text('Fixed Amount')),
              ],
              selected: {_isPercentage},
              onSelectionChanged: (s) =>
                  setState(() => _isPercentage = s.first),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: InputDecoration(
                labelText: _isPercentage ? 'Percentage (%)' : 'Amount (Rs.)',
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Text(
              'This will reduce total by ${formatPKR(_previewReduction.toDouble())}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final value = Decimal.tryParse(_controller.text) ?? Decimal.zero;
            if (value <= Decimal.zero) return;
            Navigator.pop(context, (
              _isPercentage ? 'percentage' : 'fixed',
              value,
            ));
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

class ItemDiscountDialog extends StatefulWidget {
  const ItemDiscountDialog({
    super.key,
    required this.lineSubtotal,
    required this.currentPct,
    required this.currentAmount,
  });

  final Decimal lineSubtotal;
  final Decimal currentPct;
  final Decimal currentAmount;

  static Future<(Decimal pct, Decimal amount)?> show(
    BuildContext context, {
    required Decimal lineSubtotal,
    Decimal? currentPct,
    Decimal? currentAmount,
  }) {
    return showDialog<(Decimal, Decimal)?>(
      context: context,
      builder: (_) => ItemDiscountDialog(
        lineSubtotal: lineSubtotal,
        currentPct: currentPct ?? Decimal.zero,
        currentAmount: currentAmount ?? Decimal.zero,
      ),
    );
  }

  @override
  State<ItemDiscountDialog> createState() => _ItemDiscountDialogState();
}

class _ItemDiscountDialogState extends State<ItemDiscountDialog> {
  late bool _isPercentage;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _isPercentage = widget.currentAmount <= Decimal.zero;
    _controller = TextEditingController(
      text: _isPercentage
          ? (widget.currentPct > Decimal.zero
              ? widget.currentPct.toString()
              : '')
          : (widget.currentAmount > Decimal.zero
              ? widget.currentAmount.toString()
              : ''),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Item Discount'),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Percentage')),
                ButtonSegment(value: false, label: Text('Fixed Amount')),
              ],
              selected: {_isPercentage},
              onSelectionChanged: (s) =>
                  setState(() => _isPercentage = s.first),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: InputDecoration(
                labelText: _isPercentage ? 'Percentage (%)' : 'Amount (Rs.)',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final value = Decimal.tryParse(_controller.text) ?? Decimal.zero;
            if (_isPercentage) {
              Navigator.pop(context, (value, Decimal.zero));
            } else {
              Navigator.pop(context, (Decimal.zero, value));
            }
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

class LineNoteDialog extends StatefulWidget {
  const LineNoteDialog({super.key, this.initialNote});

  final String? initialNote;

  static Future<String?> show(BuildContext context, {String? initialNote}) {
    return showDialog<String>(
      context: context,
      builder: (_) => LineNoteDialog(initialNote: initialNote),
    );
  }

  @override
  State<LineNoteDialog> createState() => _LineNoteDialogState();
}

class _LineNoteDialogState extends State<LineNoteDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Line Note'),
      content: TextField(
        controller: _controller,
        maxLines: 3,
        maxLength: 200,
        decoration: const InputDecoration(
          hintText: 'Extra cheese, no onions...',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
