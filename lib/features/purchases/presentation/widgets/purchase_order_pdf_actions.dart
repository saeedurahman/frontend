import 'package:flutter/material.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/utils/logger.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';
import 'package:frantend/features/purchases/presentation/services/purchase_order_pdf_service.dart';
import 'package:frantend/utils/app_alerts.dart';

/// Save, print and share of a purchase order, with the message each one ends in.
abstract final class PurchaseOrderPdfActions {
  static const failed = 'Could not make the PDF. Please try again.';
  static const noWhatsApp = 'Could not open WhatsApp';

  static Future<void> save(BuildContext context, PurchaseOrderModel order) =>
      _guard(context, () async {
        final service = sl<PurchaseOrderPdfService>();
        final path = await service.save(order);
        if (path == null || !context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved ${order.poNumber}'),
            action: SnackBarAction(
              label: 'Open folder',
              onPressed: () => service.openFolder(path),
            ),
          ),
        );
      });

  static Future<void> print(BuildContext context, PurchaseOrderModel order) =>
      _guard(context, () => sl<PurchaseOrderPdfService>().print(order));

  static Future<void> share(BuildContext context, PurchaseOrderModel order) =>
      _guard(context, () async {
        final opened =
            await sl<PurchaseOrderPdfService>().shareOnWhatsApp(order);
        if (!opened && context.mounted) {
          AppAlerts.showErrorMessage(context, noWhatsApp);
        }
      });

  static Future<void> _guard(
    BuildContext context,
    Future<void> Function() action,
  ) async {
    try {
      await action();
    } catch (e, st) {
      AppLogger.error('Purchase order PDF failed', error: e, stackTrace: st);
      if (context.mounted) AppAlerts.showErrorMessage(context, failed);
    }
  }
}

/// "Download": save the PDF, print it, or share the order.
class PurchaseOrderDownloadButton extends StatelessWidget {
  const PurchaseOrderDownloadButton({super.key, required this.order});

  final PurchaseOrderModel order;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          key: const ValueKey('po-save'),
          leadingIcon: const Icon(Icons.save_alt, size: 18),
          onPressed: () => PurchaseOrderPdfActions.save(context, order),
          child: const Text('Save PDF'),
        ),
        MenuItemButton(
          key: const ValueKey('po-print'),
          leadingIcon: const Icon(Icons.print_outlined, size: 18),
          onPressed: () => PurchaseOrderPdfActions.print(context, order),
          child: const Text('Print'),
        ),
        MenuItemButton(
          key: const ValueKey('po-share'),
          leadingIcon: const Icon(Icons.share_outlined, size: 18),
          onPressed: () => PurchaseOrderPdfActions.share(context, order),
          child: const Text('Share on WhatsApp'),
        ),
      ],
      builder: (context, menu, _) => OutlinedButton.icon(
        onPressed: () => menu.isOpen ? menu.close() : menu.open(),
        icon: const Icon(Icons.download_outlined, size: 18),
        label: const Text('Download'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
