import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ManualPriceDialog extends StatefulWidget {
  const ManualPriceDialog({
    super.key,
    required this.productName,
    this.variationName,
  });

  final String productName;
  final String? variationName;

  static Future<Decimal?> show(
    BuildContext context, {
    required String productName,
    String? variationName,
  }) {
    return showDialog<Decimal>(
      context: context,
      builder: (_) => ManualPriceDialog(
        productName: productName,
        variationName: variationName,
      ),
    );
  }

  @override
  State<ManualPriceDialog> createState() => _ManualPriceDialogState();
}

class _ManualPriceDialogState extends State<ManualPriceDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final price = Decimal.tryParse(_controller.text.trim());
    if (price == null || price <= Decimal.zero) {
      setState(() => _error = 'Enter a valid price greater than 0');
      return;
    }
    Navigator.pop(context, price);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.variationName != null
        ? '${widget.productName} (${widget.variationName})'
        : widget.productName;

    return AlertDialog(
      title: Text('Set Price for $title', style: Theme.of(context).textTheme.titleMedium),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'No price configured for this product',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              autofocus: true,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: InputDecoration(
                labelText: 'Price (Rs.) *',
                border: const OutlineInputBorder(),
                errorText: _error,
              ),
              onSubmitted: (_) => _submit(),
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
          onPressed: _submit,
          child: const Text('Add to Cart'),
        ),
      ],
    );
  }
}
