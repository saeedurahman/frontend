
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/core/platform/url_launcher_service.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/domain/receipt_plain_text.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/presentation/services/sale_receipt_service.dart';
import 'package:frantend/utils/app_alerts.dart';

abstract final class ReceiptShareService {
  /// Converts a phone string to digits-only E.164 format (e.g. 03001234567 -> 923001234567).
  static String formatE164(String phone) {
    var digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.startsWith('00')) {
      digits = digits.substring(2);
    }
    if (digits.startsWith('03') && digits.length == 11) {
      digits = '92${digits.substring(1)}';
    } else if (digits.startsWith('3') && digits.length == 10) {
      digits = '92$digits';
    }
    return digits;
  }

  /// Plain-text receipt (WhatsApp message / clipboard) drawn from the
  /// WhatsApp channel's layout by the same pipeline as the printed receipt.
  static Future<String> buildPlainTextReceipt(
    SaleResponseModel sale, {
    bool allowNetwork = true,
  }) async {
    final prepared = await SaleReceiptService.prepare(sale, channel: ReceiptChannel.whatsapp);
    return ReceiptPlainText.render(prepared.model);
  }

  /// Attempts to obtain an online receipt link from POST /sales/{id}/receipt-link
  /// or POST /sales/receipt-link/lookup. Returns null if offline or not found.
  static Future<String?> getOnlineReceiptLink(SaleResponseModel sale) async {
    final dio = sl<DioClient>().dio;

    // 1. If not offline, try POST /sales/{id}/receipt-link
    if (!sale.offline && sale.id.isNotEmpty) {
      try {
        final res = await dio.post<Map<String, dynamic>>(
          ApiConstants.saleReceiptLink(sale.id),
        );
        final url = res.data?['url'] as String?;
        if (url != null && url.isNotEmpty) return url;
      } catch (_) {}
    }

    // 2. Lookup by client_receipt_no or sale_number for synced offline sales
    String? clientReceiptNo;
    try {
      final row = await sl<SyncStore>().sale(sale.id);
      clientReceiptNo = row?['receipt_no']?.toString();
    } catch (_) {}

    try {
      final body = <String, dynamic>{
        if (clientReceiptNo != null && clientReceiptNo.isNotEmpty)
          'client_receipt_no': clientReceiptNo,
        if (sale.saleNumber != null && sale.saleNumber!.isNotEmpty)
          'sale_number': sale.saleNumber,
      };
      if (body.isNotEmpty) {
        final res = await dio.post<Map<String, dynamic>>(
          ApiConstants.saleReceiptLinkLookup,
          data: body,
        );
        final url = res.data?['url'] as String?;
        if (url != null && url.isNotEmpty) return url;
      }
    } catch (_) {}

    return null;
  }

  /// Sends receipt via WhatsApp. Uses online link if available, silent text fallback otherwise.
  static Future<void> sendOnWhatsApp(
    BuildContext context,
    SaleResponseModel sale, {
    String? phone,
  }) async {
    var rawPhone = phone ?? sale.customer?.phone;
    if (rawPhone == null || rawPhone.trim().isEmpty) {
      rawPhone = await showPhonePickerDialog(context);
      if (rawPhone == null || rawPhone.trim().isEmpty) return;
    }

    final e164 = formatE164(rawPhone.trim());
    if (e164.isEmpty) {
      if (context.mounted) {
        AppAlerts.showErrorMessage(context, 'Please enter a valid phone number');
      }
      return;
    }

    final onlineLink = await getOnlineReceiptLink(sale);
    var messageText = await buildPlainTextReceipt(sale);
    if (onlineLink != null && !messageText.contains(onlineLink)) {
      messageText = '$messageText\n$onlineLink';
    }

    final uri = Uri.parse('https://wa.me/$e164?text=${Uri.encodeComponent(messageText)}');
    final launcher = sl<UrlLauncherService>();
    final ok = await launcher.launch(uri);
    if (!ok && context.mounted) {
      AppAlerts.showErrorMessage(context, 'Could not launch WhatsApp');
    }
  }

  /// Copies public link (or plain text receipt if offline) to clipboard.
  static Future<void> copyReceiptLink(
    BuildContext context,
    SaleResponseModel sale,
  ) async {
    final onlineLink = await getOnlineReceiptLink(sale);
    if (onlineLink != null) {
      await Clipboard.setData(ClipboardData(text: onlineLink));
      if (context.mounted) {
        AppAlerts.showSuccessMessage(context, 'Receipt link copied to clipboard');
      }
    } else {
      final textReceipt = await buildPlainTextReceipt(sale);
      await Clipboard.setData(ClipboardData(text: textReceipt));
      if (context.mounted) {
        AppAlerts.showSuccessMessage(context, 'Receipt text copied to clipboard (offline mode)');
      }
    }
  }

  /// Saves receipt PDF (either downloading from ?format=pdf or generating locally) via FileSaverService.
  static Future<void> savePdf(
    BuildContext context,
    SaleResponseModel sale,
  ) async {
    // Always drawn here by the receipt pipeline: the same layout, the same
    // numbers, online or offline (never a different server-side copy).
    final Uint8List pdfBytes =
        await (await SaleReceiptService.buildPdf(sale, thermal: true)).save();

    final fileName =
        'receipt_${sale.clientReceiptNo ?? sale.saleNumber ?? sale.id.substring(0, 8)}.pdf';
    final savedPath = await sl<FileSaverService>().saveFileWithDialog(
      fileName,
      pdfBytes,
      extensions: ['pdf'],
    );

    if (savedPath != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Receipt saved: $fileName'),
          action: SnackBarAction(
            label: 'Open folder',
            onPressed: () => sl<FileSaverService>().openFolder(savedPath),
          ),
        ),
      );
    }
  }

  /// Dialog prompting cashier for phone number when customer has no phone.
  static Future<String?> showPhonePickerDialog(BuildContext context) async {
    final controller = TextEditingController(text: '03');
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter WhatsApp Number'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter the customer\'s mobile number to send their receipt via WhatsApp:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: '03001234567',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                Navigator.pop(ctx, text);
              }
            },
            icon: const Icon(Icons.send),
            label: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
