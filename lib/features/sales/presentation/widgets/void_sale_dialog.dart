import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';

class VoidSaleDialog extends StatefulWidget {
  const VoidSaleDialog({
    super.key,
    required this.saleNumber,
  });

  final String saleNumber;

  static Future<bool?> show(
    BuildContext context, {
    required String saleNumber,
  }) =>
      showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => VoidSaleDialog(saleNumber: saleNumber),
      );

  @override
  State<VoidSaleDialog> createState() => _VoidSaleDialogState();
}

class _VoidSaleDialogState extends State<VoidSaleDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _confirmed =>
      _controller.text.trim() == widget.saleNumber.trim();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Void sale ${widget.saleNumber}?'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: const Text(
                'This permanently voids the entire sale. It cannot be undone.',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This will:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const _Bullet('Restore all sold stock (FIFO)'),
            const _Bullet('Mark payments as refunded'),
            const _Bullet('Reverse register cash transactions'),
            const _Bullet('Reverse customer credit (if applicable)'),
            const SizedBox(height: 16),
            Text('Type ${widget.saleNumber} to confirm:'),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) {
                if (_confirmed) Navigator.pop(context, true);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _confirmed ? () => Navigator.pop(context, true) : null,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
          ),
          child: const Text('Void sale'),
        ),
      ],
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(height: 1.4)),
          Expanded(child: Text(text, style: const TextStyle(height: 1.4))),
        ],
      ),
    );
  }
}
