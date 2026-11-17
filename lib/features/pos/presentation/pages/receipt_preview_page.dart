import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/presentation/services/receipt_service.dart';
import 'package:frantend/features/receipts/presentation/widgets/receipt_view.dart';
import 'package:frantend/features/sales/presentation/services/receipt_share_service.dart';
import 'package:frantend/features/sales/presentation/services/sale_receipt_service.dart';
import 'package:go_router/go_router.dart';

class ReceiptPreviewPage extends StatefulWidget {
  const ReceiptPreviewPage({super.key, required this.sale});

  final SaleResponseModel sale;

  @override
  State<ReceiptPreviewPage> createState() => _ReceiptPreviewPageState();
}

class _ReceiptPreviewPageState extends State<ReceiptPreviewPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _animController.forward();
    _checkAutoPrint();
  }

  Future<void> _checkAutoPrint() async {
    final config = await sl<PrinterService>().loadConfig();
    if (config.autoPrintAfterSale && mounted) {
      await SaleReceiptService.printReceipt(widget.sale, context: context);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter): () => _newSale(context),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Sale Completed!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.sale.clientReceiptNo ??
                        widget.sale.saleNumber ??
                        widget.sale.id.substring(0, 8),
                    key: const Key('receipt-number'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _ReceiptCard(sale: widget.sale),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      FilledButton.icon(
                        onPressed: () =>
                            ReceiptShareService.sendOnWhatsApp(context, widget.sale),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.share),
                        label: const Text('Send on WhatsApp'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () =>
                            ReceiptShareService.copyReceiptLink(context, widget.sale),
                        icon: const Icon(Icons.link),
                        label: const Text('Copy link'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () =>
                            SaleReceiptService.printReceipt(widget.sale, context: context),
                        icon: const Icon(Icons.print),
                        label: const Text('Print Receipt'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () =>
                            ReceiptShareService.savePdf(context, widget.sale),
                        icon: const Icon(Icons.picture_as_pdf_outlined),
                        label: const Text('Save PDF'),
                      ),
                      FilledButton.icon(
                        onPressed: () => _newSale(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        icon: const Icon(Icons.add),
                        label: const Text('New Sale'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _newSale(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    context.go('/pos');
  }
}

/// The receipt as it will print: the business's print layout, drawn by the
/// same pipeline as the PDF (no sync badges, one receipt number).
class _ReceiptCard extends StatefulWidget {
  const _ReceiptCard({required this.sale});

  final SaleResponseModel sale;

  @override
  State<_ReceiptCard> createState() => _ReceiptCardState();
}

class _ReceiptCardState extends State<_ReceiptCard> {
  late final Future<PreparedReceipt> _prepared = _load();

  Future<PreparedReceipt> _load() async {
    if (sl.isRegistered<ReceiptService>()) {
      return sl<ReceiptService>().prepare(widget.sale, ReceiptChannel.print);
    }
    return SaleReceiptService.prepare(widget.sale);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PreparedReceipt>(
      future: _prepared,
      builder: (context, snap) {
        if (snap.hasError) {
          return const Text('The receipt could not be drawn.');
        }
        final prepared = snap.data;
        if (prepared == null) {
          return const SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }
        return ReceiptView(
          key: const Key('receipt-view'),
          model: prepared.model,
          maxWidth: 420,
        );
      },
    );
  }
}
