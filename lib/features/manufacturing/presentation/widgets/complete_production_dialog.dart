import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/manufacturing/domain/utils/production_availability.dart';
import 'package:frantend/features/manufacturing/presentation/widgets/ingredient_availability_table.dart';

class CompleteProductionDialog extends StatefulWidget {
  const CompleteProductionDialog({
    super.key,
    required this.productionNumber,
    required this.defaultQtyProduced,
    required this.maxQtyProduced,
    required this.availability,
    required this.isLoadingPreview,
    required this.onQtyChanged,
  });

  final String productionNumber;
  final String defaultQtyProduced;
  final String maxQtyProduced;
  final List<IngredientAvailabilityRow> availability;
  final bool isLoadingPreview;
  final ValueChanged<String> onQtyChanged;

  static Future<String?> show(
    BuildContext context, {
    required String productionNumber,
    required String defaultQtyProduced,
    required String maxQtyProduced,
    required List<IngredientAvailabilityRow> availability,
    required bool isLoadingPreview,
    required ValueChanged<String> onQtyChanged,
  }) =>
      showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (_) => CompleteProductionDialog(
          productionNumber: productionNumber,
          defaultQtyProduced: defaultQtyProduced,
          maxQtyProduced: maxQtyProduced,
          availability: availability,
          isLoadingPreview: isLoadingPreview,
          onQtyChanged: onQtyChanged,
        ),
      );

  @override
  State<CompleteProductionDialog> createState() =>
      _CompleteProductionDialogState();
}

class _CompleteProductionDialogState extends State<CompleteProductionDialog> {
  late final TextEditingController _qtyController;
  var _confirmed = false;

  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController(text: widget.defaultQtyProduced);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onQtyChanged(widget.defaultQtyProduced);
    });
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  bool get _validQty {
    final qty = double.tryParse(_qtyController.text.trim());
    final max = double.tryParse(widget.maxQtyProduced);
    if (qty == null || qty <= 0) return false;
    if (max != null && qty > max) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Complete ${widget.productionNumber}?'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.35),
                  ),
                ),
                child: const Text(
                  'This permanently consumes ingredient stock (FIFO) and '
                  'creates a finished-goods inventory layer. This cannot be undone.',
                  style: TextStyle(height: 1.4, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _qtyController,
                decoration: InputDecoration(
                  labelText: 'Qty produced',
                  helperText:
                      'Max ${DecimalUtils.format(DecimalUtils.parse(widget.maxQtyProduced), fractionDigits: 4)}',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {});
                  widget.onQtyChanged(value);
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Ingredients to consume',
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: 8),
              IngredientAvailabilityTable(
                rows: widget.availability,
                isLoading: widget.isLoadingPreview,
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _confirmed,
                onChanged: (value) => setState(() => _confirmed = value ?? false),
                title: const Text(
                  'I understand this will permanently adjust inventory',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _confirmed && _validQty
              ? () => Navigator.pop(context, _qtyController.text.trim())
              : null,
          child: const Text('Complete production'),
        ),
      ],
    );
  }
}
