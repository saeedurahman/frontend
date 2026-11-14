import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/core/platform/url_launcher_service.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/presentation/services/sale_receipt_service.dart';
import 'package:frantend/features/sales/presentation/utils/sale_calculations.dart';
import 'package:frantend/utils/app_alerts.dart';
import 'package:intl/intl.dart';

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

  /// Builds a plain-text receipt for offline WhatsApp sharing or clipboard copy.
  static Future<String> buildPlainTextReceipt(SaleResponseModel sale) async {
    final business = await SaleReceiptService.resolveBusinessProfile();
    final numbers = await SaleReceiptService.numbersLine(sale.id);
    final display = await SaleReceiptService.resolveDisplaySettings(branchId: sale.branchId);

    final buffer = StringBuffer();
    final businessName = business?.name ?? 'Receipt';
    buffer.writeln('*$businessName*');
    if (business?.phone != null && business!.phone!.isNotEmpty) {
      buffer.writeln('Tel: ${business.phone}');
    }
    if (business?.taxId != null && business!.taxId!.isNotEmpty) {
      buffer.writeln('NTN: ${business.taxId}');
    }
    if (business?.addressLine1 != null && business!.addressLine1!.isNotEmpty) {
      buffer.writeln('${business.addressLine1}');
    }

    buffer.writeln('--------------------------------');
    final dateStr = sale.soldAt ?? sale.createdAt ?? DateTime.now().toIso8601String();
    try {
      final dt = DateTime.parse(dateStr);
      buffer.writeln('Date: ${DateFormat.yMMMd().add_jm().format(dt)}');
    } catch (_) {
      buffer.writeln('Date: $dateStr');
    }

    if (numbers != null && numbers.isNotEmpty) {
      buffer.writeln(numbers);
    } else {
      buffer.writeln('Receipt: ${sale.saleNumber ?? sale.id}');
    }
    buffer.writeln('--------------------------------');

    for (final line in sale.lines) {
      final name = line.productName ?? 'Item';
      final qty = line.qty;
      final total = formatPKR(SaleCalculations.lineTotal(line).toDouble());
      buffer.writeln('$name x $qty: $total');
    }

    buffer.writeln('--------------------------------');
    final totalAmount = formatPKR(double.tryParse(sale.totalAmount) ?? 0);
    buffer.writeln('*TOTAL: $totalAmount*');

    if (sale.payments.isNotEmpty) {
      for (final p in sale.payments) {
        final amount = formatPKR(double.tryParse(p.amount) ?? 0);
        buffer.writeln('${p.paymentMethod}: $amount');
      }
    }

    if (display.footerText.isNotEmpty) {
      buffer.writeln('--------------------------------');
      buffer.writeln(display.footerText);
    }

    return buffer.toString().trim();
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
    final String messageText;
    if (onlineLink != null) {
      final business = await SaleReceiptService.resolveBusinessProfile();
      final bizName = business?.name ?? 'Receipt';
      messageText = 'Thank you for shopping at $bizName! View your receipt here: $onlineLink';
    } else {
      messageText = await buildPlainTextReceipt(sale);
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
    Uint8List? pdfBytes;

    final onlineLink = await getOnlineReceiptLink(sale);
    if (onlineLink != null) {
      try {
        final dio = sl<DioClient>().dio;
        final res = await dio.get<List<int>>(
          '$onlineLink?format=pdf',
          options: Options(responseType: ResponseType.bytes),
        );
        if (res.data != null) {
          pdfBytes = Uint8List.fromList(res.data!);
        }
      } catch (_) {}
    }

    if (pdfBytes == null) {
      final doc = await SaleReceiptService.buildPdf(sale, thermal: true);
      pdfBytes = await doc.save();
    }

    final fileName = 'receipt_${sale.saleNumber ?? sale.id.substring(0, 8)}.pdf';
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
