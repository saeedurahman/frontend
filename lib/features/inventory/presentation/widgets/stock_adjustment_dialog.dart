import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_dimensions.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/inventory/data/models/stock_model.dart';
import 'package:frantend/features/inventory/domain/usecases/inventory_usecases.dart';
import 'package:frantend/features/inventory/presentation/cubit/inventory_stock_state.dart';
import 'package:frantend/utils/app_alerts.dart';

class StockAdjustmentDialog extends StatefulWidget {
  const StockAdjustmentDialog({
    super.key,
    required this.row,
    this.onSaved,
  });

  final StockDisplayRow row;
  final VoidCallback? onSaved;

  static Future<bool?> show(
    BuildContext context, {
    required StockDisplayRow row,
    VoidCallback? onSaved,
  }) =>
      showDialog<bool>(
        context: context,
        builder: (_) => StockAdjustmentDialog(row: row, onSaved: onSaved),
      );

  @override
  State<StockAdjustmentDialog> createState() => _StockAdjustmentDialogState();
}

class _StockAdjustmentDialogState extends State<StockAdjustmentDialog> {
  bool _isAdd = true;
  String _reason = AdjustmentReasons.countCorrection;
  final _qtyController = TextEditingController();
  final _costController = TextEditingController(text: '0');
  final _notesController = TextEditingController();
  bool _saving = false;

  static const _reasons = {
    AdjustmentReasons.countCorrection: 'Count Correction',
    AdjustmentReasons.damage: 'Damage',
    AdjustmentReasons.theft: 'Theft',
    AdjustmentReasons.expiry: 'Expiry',
    AdjustmentReasons.other: 'Other',
  };

  @override
  void dispose() {
    _qtyController.dispose();
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final qty = double.tryParse(_qtyController.text.trim());
    if (qty == null || qty <= 0) return;

    final user = await sl<AuthLocalDataSource>().getCachedUser();
    final branchId = user?.branchId;
    if (branchId == null) {
      if (mounted) AppAlerts.showErrorMessage(context, 'Branch not found');
      return;
    }

    setState(() => _saving = true);

    final delta = _isAdd ? qty : -qty;
    final params = CreateStockAdjustmentParams(
      branchId: branchId,
      reason: _reason,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      lines: [
        CreateStockAdjustmentLineParams(
          productId: widget.row.product.id,
          variationId: widget.row.balance.variationId,
          qtyDelta: DecimalUtils.parse(delta.toString()),
          costPerUnit: DecimalUtils.parse(_costController.text.trim().isEmpty
              ? '0'
              : _costController.text.trim()),
        ),
      ],
    );

    final result = await sl<CreateStockAdjustmentUseCase>()(params);
    if (!mounted) return;
    setState(() => _saving = false);

    result.fold(
      (failure) => AppAlerts.showErrorMessage(context, failure.message),
      (_) {
        AppAlerts.showSuccessMessage(context, 'Stock adjusted');
        widget.onSaved?.call();
        Navigator.pop(context, true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productLabel = widget.row.variationName != null
        ? '${widget.row.product.name} — ${widget.row.variationName}'
        : widget.row.product.name;

    return AlertDialog(
      title: const Text('Stock Adjustment'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(productLabel),
            Text(
              'Current: ${widget.row.balance.currentQty}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Add Stock')),
                ButtonSegment(value: false, label: Text('Remove Stock')),
              ],
              selected: {_isAdd},
              onSelectionChanged: (s) => setState(() => _isAdd = s.first),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            DropdownButtonFormField<String>(
              initialValue: _reason,
              decoration: const InputDecoration(labelText: 'Reason'),
              items: _reasons.entries
                  .map(
                    (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _reason = v);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _costController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Cost per Unit'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Apply', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
