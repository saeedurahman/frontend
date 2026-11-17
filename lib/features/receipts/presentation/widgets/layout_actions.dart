import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/features/receipts/domain/receipt_context.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/presentation/render/receipt_pdf_renderer.dart';
import 'package:frantend/features/receipts/presentation/widgets/layout_preview.dart';
import 'package:frantend/features/sales/presentation/services/receipt_text_renderer.dart';
import 'package:frantend/features/sales/presentation/services/sale_receipt_service.dart';
import 'package:frantend/utils/app_alerts.dart';

/// "Test print" and "Save as PDF" for a layout: the sample sale drawn by the
/// real PDF renderer, so the paper matches the preview.
abstract final class LayoutActions {
  /// The shop's real name, address, phone and NTN for the preview, when the
  /// device knows them.
  static Future<ReceiptBusiness?> realBusiness() async {
    try {
      final b = await SaleReceiptService.resolveBusinessProfile();
      if (b == null) return null;
      return ReceiptBusiness(
        name: b.name,
        address: b.addressLine1,
        phone: b.phone,
        taxId: b.taxId,
      );
    } catch (_) {
      return null;
    }
  }

  static Future<Uint8List> _pdf(ReceiptLayout layout) async {
    final business = await realBusiness();
    final model = LayoutPreviewModel.build(layout, business: business);
    var style = UrduReceiptStyle.nastaliq;
    try {
      style = UrduReceiptStyle.fromString((await sl<PrinterService>().loadConfig()).urduStyle);
    } catch (_) {}
    final doc = await ReceiptPdfRenderer.build(model, urduStyle: style);
    return doc.save();
  }

  static Future<void> testPrint(BuildContext context, ReceiptLayout layout) async {
    try {
      final bytes = await _pdf(layout);
      final ok = await sl<PrinterService>().printPdf(
        bytes,
        jobName: 'Receipt layout test',
      );
      if (!context.mounted) return;
      if (ok) {
        AppAlerts.showSuccessMessage(context, 'Test receipt sent to the printer');
      } else {
        AppAlerts.showErrorMessage(
          context,
          'Could not print. Please check the printer in Settings > Receipt & Printing.',
        );
      }
    } catch (_) {
      if (context.mounted) {
        AppAlerts.showErrorMessage(context, 'The test receipt could not be made.');
      }
    }
  }

  static Future<void> savePdf(BuildContext context, ReceiptLayout layout) async {
    try {
      final bytes = await _pdf(layout);
      final name = 'receipt_layout_${layout.name.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')}.pdf';
      final path = await sl<FileSaverService>().saveFileWithDialog(
        name,
        bytes,
        extensions: ['pdf'],
      );
      if (path != null && context.mounted) {
        AppAlerts.showSuccessMessage(context, 'Saved $name');
      }
    } catch (_) {
      if (context.mounted) {
        AppAlerts.showErrorMessage(context, 'The PDF could not be saved.');
      }
    }
  }
}
