import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/core/platform/url_launcher_service.dart';
import 'package:frantend/core/utils/logger.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';
import 'package:frantend/features/purchases/presentation/widgets/purchase_status_chip.dart';
import 'package:frantend/features/receipts/presentation/render/receipt_pdf_support.dart';
import 'package:frantend/features/sales/presentation/services/receipt_share_service.dart';
import 'package:frantend/features/sales/presentation/services/receipt_text_renderer.dart';
import 'package:frantend/features/settings/data/models/business_profile_model.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// One item of a purchase order, with its amount worked out exactly.
class PurchaseOrderDocumentLine {
  PurchaseOrderDocumentLine(PurchaseLineModel line)
      : name = _name(line),
        sku = line.sku,
        ordered = _number(line.orderedQty),
        received = _number(line.receivedQty),
        cost = _number(line.costPerUnit),
        taxRate = _number(line.taxRate);

  final String name;
  final String? sku;
  final Decimal ordered;
  final Decimal received;
  final Decimal cost;
  final Decimal taxRate;

  /// Quantity ordered at cost, before tax.
  Decimal get amount => ordered * cost;

  Decimal get tax =>
      (amount * taxRate / Decimal.fromInt(100)).toDecimal(scaleOnInfinitePrecision: 8);

  static Decimal _number(String value) => Decimal.tryParse(value) ?? Decimal.zero;

  static String _name(PurchaseLineModel line) {
    final product = line.productName?.trim() ?? '';
    final variation = line.variationName?.trim() ?? '';
    final name = product.isNotEmpty ? product : (line.sku ?? 'Item');
    return variation.isEmpty ? name : '$name - $variation';
  }
}

/// Everything the purchase order paper says, ready to draw or to send as text.
class PurchaseOrderDocument {
  PurchaseOrderDocument(this.order, {this.business})
      : lines = [for (final l in order.lines) PurchaseOrderDocumentLine(l)];

  final PurchaseOrderModel order;
  final BusinessProfileModel? business;
  final List<PurchaseOrderDocumentLine> lines;

  Decimal get subtotal =>
      _cents(lines.fold(Decimal.zero, (sum, l) => sum + l.amount));

  /// Rounded once, the same total the order screen shows.
  Decimal get total => _cents(
        lines.fold(Decimal.zero, (sum, l) => sum + l.amount + l.tax),
      );

  /// What is left after the subtotal, so the three figures always add up.
  Decimal get tax => total - subtotal;

  static Decimal _cents(Decimal value) => value.round(scale: 2);

  String get status => PurchaseStatusChip.labelFor(order.status);

  String get fileName {
    final number = order.poNumber.trim();
    final stem = number.toUpperCase().startsWith('PO') ? number : 'PO-$number';
    return '${WindowsFileSaverService.sanitizeFileName(stem)}.pdf';
  }

  /// Name, address, phone and NTN, whatever of them is known.
  List<String> get businessLines {
    final b = business;
    if (b == null) return const [];
    final address = [b.addressLine1, b.city].map(_clean).nonNulls.join(', ');
    final phone = _clean(b.phone);
    final ntn = _clean(b.taxId);
    return [
      if (address.isNotEmpty) address,
      if (phone != null) 'Phone: $phone',
      if (ntn != null) 'NTN: $ntn',
    ];
  }

  List<String> get supplierLines {
    final s = order.supplier;
    if (s == null) return const [];
    final address = [s.addressLine1, s.city].map(_clean).nonNulls.join(', ');
    final contact = _clean(s.contactPerson);
    final phone = _clean(s.phone);
    final email = _clean(s.email);
    return [
      s.name,
      if (contact != null) 'Contact: $contact',
      if (phone != null) 'Phone: $phone',
      ?email,
      if (address.isNotEmpty) address,
    ];
  }

  static String? _clean(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? null : text;
  }

  static String quantity(Decimal value) => value.toString();

  static String day(String? value) {
    final date = value == null ? null : DateTime.tryParse(value);
    return date == null ? '-' : DateFormat('dd MMM yyyy').format(date.toLocal());
  }

  /// A long order does not fit in a chat link; the rest is in the PDF.
  static const _textLines = 30;

  String get plainText {
    final notes = _clean(order.notes);
    return [
      ?_clean(business?.name),
      'PURCHASE ORDER ${order.poNumber}',
      'Date: ${day(order.orderedAt ?? order.createdAt)}',
      if (order.expectedAt != null) 'Needed by: ${day(order.expectedAt)}',
      'Status: $status',
      if (order.supplier != null) 'To: ${order.supplier!.name}',
      '',
      for (var i = 0; i < lines.length && i < _textLines; i++)
        '${i + 1}. ${lines[i].name}: ${quantity(lines[i].ordered)} x '
            '${formatMoneyNumber(lines[i].cost)} = '
            '${formatMoneyNumber(lines[i].amount)}',
      if (lines.length > _textLines)
        '... and ${lines.length - _textLines} more items',
      '',
      if (tax != Decimal.zero) 'Tax: ${formatPKR(tax)}',
      'Total: ${formatPKR(total)}',
      if (notes != null) 'Notes: $notes',
    ].join('\n');
  }
}

/// Draws a purchase order and saves, prints or shares it. Everything comes from
/// the device (the order on screen, the saved business details and logo), so it
/// works offline.
class PurchaseOrderPdfService {
  PurchaseOrderPdfService({
    required this.business,
    required this.logo,
    required FileSaverService files,
    required PrinterService printer,
    required UrlLauncherService launcher,
  })  : _files = files,
        _printer = printer,
        _launcher = launcher;

  /// The saved business details and logo picture.
  final Future<BusinessProfileModel?> Function() business;
  final Future<List<int>?> Function() logo;

  final FileSaverService _files;
  final PrinterService _printer;
  final UrlLauncherService _launcher;

  Future<PurchaseOrderDocument> document(PurchaseOrderModel order) async =>
      PurchaseOrderDocument(order, business: await _optional(business));

  /// A missing header or logo never stops the paper.
  static Future<T?> _optional<T>(Future<T?> Function() read) async {
    try {
      return await read();
    } catch (e) {
      AppLogger.warning('Purchase order header not available: $e');
      return null;
    }
  }

  Future<Uint8List> pdfBytes(PurchaseOrderModel order) async =>
      render(await document(order), logo: await _optional(logo));

  /// Returns the path written, or null when the user cancelled.
  Future<String?> save(PurchaseOrderModel order) async {
    final doc = await document(order);
    final bytes = await render(doc, logo: await _optional(logo));
    return _files.saveFileWithDialog(doc.fileName, bytes, extensions: ['pdf']);
  }

  Future<void> openFolder(String path) => _files.openFolder(path);

  /// False when the user cancelled or the printer refused.
  Future<bool> print(PurchaseOrderModel order) async => _printer.printPdf(
        await pdfBytes(order),
        jobName: 'Purchase order ${order.poNumber}',
        // The saved printer is the receipt roll; this is a full page.
        forceDialog: true,
      );

  /// Opens WhatsApp with the order written out, to the supplier's number when
  /// there is one. A link cannot carry a file: attach the saved PDF in the chat.
  Future<bool> shareOnWhatsApp(PurchaseOrderModel order) async {
    final doc = await document(order);
    final phone = ReceiptShareService.formatE164(order.supplier?.phone ?? '');
    return _launcher.launch(
      Uri.parse(
        'https://wa.me/$phone?text=${Uri.encodeComponent(doc.plainText)}',
      ),
    );
  }

  /// A damaged logo picture is only found out while drawing; the paper is then
  /// drawn again without it.
  static Future<Uint8List> render(
    PurchaseOrderDocument doc, {
    List<int>? logo,
  }) async {
    final picture = _picture(logo);
    if (picture != null) {
      try {
        return await _draw(doc, picture);
      } catch (e) {
        AppLogger.warning('Purchase order logo could not be drawn: $e');
      }
    }
    return _draw(doc, null);
  }

  static Future<Uint8List> _draw(
    PurchaseOrderDocument doc,
    pw.ImageProvider? picture,
  ) async {
    final theme = await ReceiptPdfSupport.loadA4Fonts();
    final pdf = pw.Document();

    // Urdu is drawn as a picture, like on the receipts: the PDF library does
    // not join its letters. [width] is the room an Urdu line may use.
    Future<pw.Widget> text(
      String value, {
      double size = 9,
      bool bold = false,
      PdfColor? color,
      pw.TextAlign? align,
      double width = 220,
    }) async {
      if (ReceiptTextRenderer.hasArabicScript(value)) {
        final drawn = await ReceiptTextRenderer.renderText(
          value,
          fontSize: size,
          isBold: bold,
          maxWidth: width,
          style: UrduReceiptStyle.naskh,
        );
        if (drawn != null) {
          return pw.Image(drawn.image, width: drawn.width, height: drawn.height);
        }
      }
      return pw.Text(
        value,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: size,
          fontWeight: bold ? pw.FontWeight.bold : null,
          color: color,
        ),
      );
    }

    Future<pw.Widget> cell(
      String value, {
      bool right = false,
      bool bold = false,
      String? under,
    }) async {
      final align = right ? pw.TextAlign.right : pw.TextAlign.left;
      final first = await text(value, bold: bold, align: align, width: 170);
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        child: under == null || under.isEmpty
            ? first
            : pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [first, await text(under, align: align, width: 170)],
              ),
      );
    }

    Future<pw.Widget> figure(String label, Decimal value, {bool strong = false}) async =>
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            await text(label, size: strong ? 11 : 9, bold: strong),
            await text(formatPKR(value), size: strong ? 11 : 9, bold: strong),
          ],
        );

    const grey = PdfColors.grey700;
    final notes = doc.order.notes?.trim() ?? '';
    final content = <pw.Widget>[
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (picture != null) ...[
            pw.Container(
              width: 70,
              height: 56,
              alignment: pw.Alignment.topLeft,
              child: pw.Image(picture, fit: pw.BoxFit.contain),
            ),
            pw.SizedBox(width: 10),
          ],
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (doc.business != null)
                  await text(doc.business!.name, size: 15, bold: true),
                for (final line in doc.businessLines)
                  await text(line, color: grey),
              ],
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              await text('PURCHASE ORDER', size: 15, bold: true),
              await text(doc.order.poNumber, size: 11, bold: true),
              await text('Status: ${doc.status}'),
              await text(
                'Order date: ${PurchaseOrderDocument.day(doc.order.orderedAt ?? doc.order.createdAt)}',
              ),
              await text('Expected: ${PurchaseOrderDocument.day(doc.order.expectedAt)}'),
            ],
          ),
        ],
      ),
      pw.SizedBox(height: 10),
      pw.Divider(thickness: 0.7, color: PdfColors.grey400),
      await text('Supplier', size: 8, color: grey),
      if (doc.supplierLines.isEmpty) await text('-'),
      for (var i = 0; i < doc.supplierLines.length; i++)
        await text(doc.supplierLines[i], bold: i == 0, size: i == 0 ? 11 : 9),
      pw.SizedBox(height: 12),
      pw.Table(
        border: const pw.TableBorder(
          horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
          bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.7),
        ),
        columnWidths: const {
          0: pw.FixedColumnWidth(24),
          1: pw.FlexColumnWidth(),
          2: pw.FixedColumnWidth(46),
          3: pw.FixedColumnWidth(54),
          4: pw.FixedColumnWidth(64),
          5: pw.FixedColumnWidth(44),
          6: pw.FixedColumnWidth(74),
        },
        children: [
          pw.TableRow(
            repeat: true,
            decoration: const pw.BoxDecoration(color: PdfColors.grey200),
            children: [
              await cell('#', bold: true),
              await cell('Item', bold: true),
              await cell('Qty', bold: true, right: true),
              await cell('Received', bold: true, right: true),
              await cell('Unit cost', bold: true, right: true),
              await cell('Tax %', bold: true, right: true),
              await cell('Amount', bold: true, right: true),
            ],
          ),
          for (var i = 0; i < doc.lines.length; i++)
            pw.TableRow(
              children: [
                await cell('${i + 1}'),
                await cell(doc.lines[i].name, under: doc.lines[i].sku),
                await cell(PurchaseOrderDocument.quantity(doc.lines[i].ordered), right: true),
                await cell(PurchaseOrderDocument.quantity(doc.lines[i].received), right: true),
                await cell(formatMoneyNumber(doc.lines[i].cost), right: true),
                await cell(PurchaseOrderDocument.quantity(doc.lines[i].taxRate), right: true),
                await cell(formatMoneyNumber(doc.lines[i].amount), right: true),
              ],
            ),
        ],
      ),
      pw.SizedBox(height: 8),
      pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.SizedBox(
          width: 220,
          child: pw.Column(
            children: [
              await figure('Subtotal', doc.subtotal),
              await figure('Tax', doc.tax),
              pw.Divider(thickness: 0.7, color: PdfColors.grey500),
              await figure('Total', doc.total, strong: true),
            ],
          ),
        ),
      ),
      if (notes.isNotEmpty) ...[
        pw.SizedBox(height: 14),
        await text('Notes', size: 8, color: grey),
        await text(notes, width: 500),
      ],
    ];

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        margin: const pw.EdgeInsets.all(36),
        maxPages: 200,
        footer: (context) => pw.Padding(
          padding: const pw.EdgeInsets.only(top: 8),
          child: pw.Text(
            '${doc.order.poNumber}  |  Page ${context.pageNumber} of ${context.pagesCount}',
            textAlign: pw.TextAlign.right,
            style: const pw.TextStyle(fontSize: 8, color: grey),
          ),
        ),
        build: (_) => content,
      ),
    );
    return pdf.save();
  }

  static pw.ImageProvider? _picture(List<int>? bytes) {
    if (bytes == null || bytes.isEmpty) return null;
    try {
      return pw.MemoryImage(Uint8List.fromList(bytes));
    } catch (_) {
      return null;
    }
  }
}
