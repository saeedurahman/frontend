import 'dart:typed_data';

import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/core/platform/url_launcher_service.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// What a payment receipt says (supplier payment today; any party later).
class PaymentReceiptData {
  const PaymentReceiptData({
    required this.partyName,
    required this.amountText,
    required this.source,
    required this.balanceLine,
    this.reference,
    this.note,
    this.when,
    this.partyPhone,
  });

  final String partyName;
  final String amountText;
  final PaymentSource source;

  /// "Still owed: Rs. 700.00" / "Advance with supplier: Rs. 50.00".
  final String balanceLine;
  final String? reference;
  final String? note;
  final DateTime? when;
  final String? partyPhone;
}

/// Builds the receipt text / PDF, shares it on WhatsApp and prints it.
@lazySingleton
class PaymentReceiptService {
  PaymentReceiptService(this._auth, this._launcher, this._printer);

  final AuthLocalDataSource _auth;
  final UrlLauncherService _launcher;
  final PrinterService _printer;

  Future<String> _business() async {
    try {
      return (await _auth.getCachedUser())?.businessName ?? '';
    } catch (_) {
      return '';
    }
  }

  static String plainText(PaymentReceiptData data, {String business = ''}) {
    final day = DateFormat('dd MMM yyyy, h:mm a').format(data.when ?? DateTime.now());
    return [
      if (business.isNotEmpty) business,
      'PAYMENT RECEIPT',
      day,
      '',
      'Paid to: ${data.partyName}',
      'Amount: ${data.amountText}',
      'Paid from: ${data.source.label}',
      if (data.reference != null && data.reference!.isNotEmpty)
        'Reference: ${data.reference}',
      if (data.note != null && data.note!.isNotEmpty) 'Note: ${data.note}',
      '',
      data.balanceLine,
      '',
      'Thank you',
    ].join('\n');
  }

  Future<String> text(PaymentReceiptData data) async =>
      plainText(data, business: await _business());

  /// Opens WhatsApp with the receipt. Without a phone the user picks the chat.
  Future<bool> shareOnWhatsApp(PaymentReceiptData data) async {
    final message = await text(data);
    final digits = _e164(data.partyPhone);
    final uri = Uri.parse(
      digits.isEmpty
          ? 'https://wa.me/?text=${Uri.encodeComponent(message)}'
          : 'https://wa.me/$digits?text=${Uri.encodeComponent(message)}',
    );
    return _launcher.launch(uri);
  }

  Future<bool> print(PaymentReceiptData data) async {
    final bytes = await pdf(data, business: await _business());
    return _printer.printPdf(bytes, jobName: 'Payment receipt');
  }

  Future<Uint8List> pdf(PaymentReceiptData data, {String business = ''}) async {
    final doc = pw.Document();
    final day = DateFormat('dd MMM yyyy, h:mm a').format(data.when ?? DateTime.now());
    pw.Widget row(String k, String v) => pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 2),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(k, style: const pw.TextStyle(fontSize: 9)),
              pw.SizedBox(width: 8),
              pw.Flexible(
                child: pw.Text(
                  v,
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ],
          ),
        );
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(12),
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            if (business.isNotEmpty)
              pw.Text(
                business,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
            pw.Text(
              'PAYMENT RECEIPT',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(day, textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 8)),
            pw.Divider(),
            row('Paid to', data.partyName),
            row('Amount', data.amountText),
            row('Paid from', data.source.label),
            if (data.reference != null && data.reference!.isNotEmpty)
              row('Reference', data.reference!),
            if (data.note != null && data.note!.isNotEmpty) row('Note', data.note!),
            pw.Divider(),
            pw.Text(data.balanceLine, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text('Thank you', textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 9)),
          ],
        ),
      ),
    );
    return doc.save();
  }

  /// `0300 1234567` -> `923001234567`.
  static String _e164(String? phone) {
    if (phone == null) return '';
    var digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.startsWith('00')) digits = digits.substring(2);
    if (digits.startsWith('03') && digits.length == 11) {
      digits = '92${digits.substring(1)}';
    } else if (digits.startsWith('3') && digits.length == 10) {
      digits = '92$digits';
    }
    return digits;
  }
}
