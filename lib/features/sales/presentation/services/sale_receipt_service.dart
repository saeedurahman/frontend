import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frantend/core/brand/app_brand.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/offline/receipt_branding_source.dart';
import 'package:frantend/core/offline/repos/local_sale_mapper.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/presentation/services/receipt_text_renderer.dart';
import 'package:frantend/features/sales/presentation/utils/sale_calculations.dart';
import 'package:frantend/features/sales/presentation/utils/sale_line_display.dart';
import 'package:frantend/features/settings/data/models/business_profile_model.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

abstract final class SaleReceiptService {
  /// Business name / address for the receipt from device local copy ([ReceiptBrandingSource]).
  static Future<BusinessProfileModel?> resolveBusinessProfile() async {
    if (sl.isRegistered<ReceiptBrandingSource>()) {
      return sl<ReceiptBrandingSource>().businessProfile();
    }
    if (sl.isRegistered<GetBusinessProfileUseCase>()) {
      final useCase = sl<GetBusinessProfileUseCase>();
      final result = await useCase();
      return result.fold((_) => null, (business) => business);
    }
    return null;
  }

  static Future<ReceiptDisplaySettings> resolveDisplaySettings({
    String? branchId,
  }) async {
    if (sl.isRegistered<ReceiptBrandingSource>()) {
      return sl<ReceiptBrandingSource>().displaySettings(branchId: branchId);
    }
    if (sl.isRegistered<GetReceiptDisplaySettingsUseCase>()) {
      final useCase = sl<GetReceiptDisplaySettingsUseCase>();
      final result = await useCase(branchId: branchId);
      return result.fold(
        (_) => ReceiptBrandingSource.defaults,
        (settings) => settings,
      );
    }
    return ReceiptBrandingSource.defaults;
  }

  /// Shows device receipt number and official number when available (works offline).
  static Future<String?> numbersLine(String saleId) async {
    try {
      if (!sl.isRegistered<SyncStore>()) return null;
      final row = await sl<SyncStore>().sale(saleId);
      return row == null ? null : LocalSaleMapper.numbersLine(row);
    } catch (_) {
      return null;
    }
  }

  static PdfPageFormat pageFormat(String paperSize, {required bool thermal}) {
    if (!thermal) return PdfPageFormat.a4;
    return paperSize == '58mm' ? PdfPageFormat.roll57 : PdfPageFormat.roll80;
  }

  /// Detects whether text contains Arabic/Urdu unicode characters.
  static bool hasRtl(String? text) {
    if (text == null || text.isEmpty) return false;
    return RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
    ).hasMatch(text);
  }

  /// Loads bundled Unicode fonts (Noto Sans and Noto Naskh Arabic for Urdu text).
  static Future<pw.ThemeData> loadFonts() async {
    try {
      final sansBytes =
          await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
      final arabicBytes =
          await rootBundle.load('assets/fonts/NotoNaskhArabic-Regular.ttf');
      final sansFont = pw.Font.ttf(sansBytes);
      final arabicFont = pw.Font.ttf(arabicBytes);
      return pw.ThemeData.withFont(
        base: sansFont,
        bold: sansFont,
        italic: sansFont,
        boldItalic: sansFont,
        fontFallback: [arabicFont],
      );
    } catch (_) {
      return pw.ThemeData.base();
    }
  }

  static Future<bool> printReceipt(
    SaleResponseModel sale, {
    BuildContext? context,
  }) async {
    final display = await resolveDisplaySettings(branchId: sale.branchId);
    final doc = await buildPdf(
      sale,
      thermal: true,
      displaySettings: display,
    );
    final bytes = await doc.save();
    final printer = sl<PrinterService>();
    final success = await printer.printPdf(
      bytes,
      jobName: sale.saleNumber ?? 'Receipt',
    );

    if (!success && context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Could not print receipt. Please check printer connection.'),
          action: SnackBarAction(
            label: 'Print again',
            onPressed: () => printReceipt(sale, context: context),
          ),
        ),
      );
    }
    return success;
  }

  static Future<File?> downloadPdf(
    BuildContext context,
    SaleResponseModel sale,
  ) async {
    final display = await resolveDisplaySettings(branchId: sale.branchId);
    final doc = await buildPdf(
      sale,
      thermal: false,
      displaySettings: display,
    );
    final bytes = await doc.save();
    final path = await sl<FileSaverService>().saveBytes(
      'receipt_${sale.saleNumber ?? sale.id}.pdf',
      bytes,
    );
    return File(path);
  }

  /// Safe maximum single page height for thermal roll printers (1,000 mm).
  /// Content taller than this splits into multiple pages via [pw.MultiPage].
  static const double maxThermalPageHeight = 1000 * PdfPageFormat.mm;

  /// Measures the layout height of a list of widgets given a fixed [maxWidth] and [theme].
  static double measureWidgetsHeight({
    required List<pw.Widget> widgets,
    required double maxWidth,
    required pw.ThemeData theme,
  }) {
    final pdfDoc = PdfDocument();
    final pdfPage =
        PdfPage(pdfDoc, pageFormat: PdfPageFormat(maxWidth + 50, 100000));
    final canvas = pdfPage.getGraphics();
    final context = pw.Context(
      document: pdfDoc,
      page: pdfPage,
      canvas: canvas,
    ).inheritFromAll([
      theme,
      pw.InheritedDirectionality(pw.TextDirection.ltr),
    ]);

    final root = pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: widgets,
    );

    root.layout(context, pw.BoxConstraints(maxWidth: maxWidth));
    return root.box?.height ?? 0.0;
  }

  /// Builds printable PDF using exact-height thermal pages on roll80/roll57 so short receipts
  /// do not feed empty blank paper, and long receipts up to 1,000 mm stay on one page without cutting.
  static Future<pw.Document> buildPdf(
    SaleResponseModel sale, {
    required bool thermal,
    ReceiptDisplaySettings? displaySettings,
    pw.ThemeData? customTheme,
    String? urduStyle,
  }) async {
    final display =
        displaySettings ?? await resolveDisplaySettings(branchId: sale.branchId);
    final business = await resolveBusinessProfile();
    final numbers = await numbersLine(sale.id);
    final theme = customTheme ?? await loadFonts();
    final doc = pw.Document(theme: theme);
    final date =
        sale.soldAt ?? sale.createdAt ?? DateTime.now().toIso8601String();
    DateTime? parsedDate;
    try {
      parsedDate = DateTime.parse(date);
    } catch (_) {}
    final dateStr = parsedDate != null
        ? DateFormat.yMMMd().add_jm().format(parsedDate)
        : date;

    UrduReceiptStyle style = UrduReceiptStyle.fromString(urduStyle);
    if (urduStyle == null && sl.isRegistered<PrinterService>()) {
      try {
        final cfg = await sl<PrinterService>().loadConfig();
        style = UrduReceiptStyle.fromString(cfg.urduStyle);
      } catch (_) {}
    }

    const margin = pw.EdgeInsets.symmetric(horizontal: 8, vertical: 8);
    final rollWidth = display.paperSize == '58mm'
        ? (57 * PdfPageFormat.mm)
        : (80 * PdfPageFormat.mm);
    final printableWidth = rollWidth - margin.horizontal;

    final widgets = await _buildSaleWidgets(
      sale: sale,
      display: display,
      business: business,
      numbers: numbers,
      dateStr: dateStr,
      printableWidth: printableWidth,
      urduStyle: style,
    );

    if (thermal) {
      final contentHeight = measureWidgetsHeight(
        widgets: widgets,
        maxWidth: printableWidth,
        theme: theme,
      );
      // Measured content height + vertical margins + small 4mm cutter margin
      final exactHeight =
          contentHeight + margin.vertical + (4 * PdfPageFormat.mm);

      if (exactHeight <= maxThermalPageHeight) {
        doc.addPage(
          pw.Page(
            pageFormat: PdfPageFormat(rollWidth, exactHeight),
            margin: margin,
            build: (_) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: widgets,
            ),
          ),
        );
      } else {
        doc.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat(rollWidth, maxThermalPageHeight),
            margin: margin,
            build: (_) => widgets,
          ),
        );
      }
    } else {
      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          build: (_) => widgets,
        ),
      );
    }
    return doc;
  }

  static Future<List<pw.Widget>> _buildSaleWidgets({
    required SaleResponseModel sale,
    required ReceiptDisplaySettings display,
    required BusinessProfileModel? business,
    required String? numbers,
    required String dateStr,
    required double printableWidth,
    required UrduReceiptStyle urduStyle,
  }) async {
    final bizName = business?.name ?? AppBrand.current.appName;
    pw.Widget bizNameWidget;
    if (ReceiptTextRenderer.hasArabicScript(bizName)) {
      final rendered = await ReceiptTextRenderer.renderText(
        bizName,
        fontSize: 14,
        isBold: true,
        maxWidth: printableWidth,
        style: urduStyle,
        textAlign: TextAlign.center,
      );
      bizNameWidget = rendered != null
          ? pw.Center(
              child: pw.Image(
                rendered.image,
                width: rendered.width,
                height: rendered.height,
              ),
            )
          : pw.Center(
              child: pw.Text(
                bizName,
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
            );
    } else {
      bizNameWidget = pw.Center(
        child: pw.Text(
          bizName,
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
      );
    }

    pw.Widget? addressWidget;
    if (business?.addressLine1?.isNotEmpty == true) {
      final addr = business!.addressLine1!;
      if (ReceiptTextRenderer.hasArabicScript(addr)) {
        final rendered = await ReceiptTextRenderer.renderText(
          addr,
          fontSize: 8.5,
          maxWidth: printableWidth,
          style: urduStyle,
          textAlign: TextAlign.center,
        );
        addressWidget = rendered != null
            ? pw.Center(
                child: pw.Image(
                  rendered.image,
                  width: rendered.width,
                  height: rendered.height,
                ),
              )
            : pw.Center(
                child: pw.Text(addr, style: const pw.TextStyle(fontSize: 8.5)),
              );
      } else {
        addressWidget = pw.Center(
          child: pw.Text(
            addr,
            style: const pw.TextStyle(fontSize: 8),
            textAlign: pw.TextAlign.center,
          ),
        );
      }
    }

    pw.Widget? customerWidget;
    if (sale.customer?.name.isNotEmpty == true) {
      final custName = sale.customer!.name;
      if (ReceiptTextRenderer.hasArabicScript(custName)) {
        final rendered = await ReceiptTextRenderer.renderText(
          'گاہک: $custName',
          fontSize: 8.5,
          maxWidth: printableWidth,
          style: urduStyle,
          textAlign: TextAlign.center,
        );
        customerWidget = rendered != null
            ? pw.Center(
                child: pw.Image(
                  rendered.image,
                  width: rendered.width,
                  height: rendered.height,
                ),
              )
            : pw.Center(
                child: pw.Text('Customer: $custName',
                    style: const pw.TextStyle(fontSize: 8.5)),
              );
      } else {
        customerWidget = pw.Center(
          child: pw.Text('Customer: $custName',
              style: const pw.TextStyle(fontSize: 8.5)),
        );
      }
    }

    final lineFutures = sale.lines.map((line) async {
      final name = line.productName ?? 'Item';
      final isUrdu = ReceiptTextRenderer.hasArabicScript(name);
      final qtyStr = line.qty;
      final unitPrice = double.tryParse(line.unitPrice) ?? 0.0;
      final unitPriceStr = formatPKR(unitPrice);
      final totalAmount = SaleCalculations.lineTotal(line).toDouble();
      final lineTotalStr = formatPKR(totalAmount);

      pw.Widget nameWidget;
      if (isUrdu) {
        final rendered = await ReceiptTextRenderer.renderText(
          name,
          fontSize: 9.5,
          isBold: true,
          maxWidth: printableWidth,
          style: urduStyle,
          textAlign: TextAlign.right,
        );
        nameWidget = rendered != null
            ? pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Image(
                  rendered.image,
                  width: rendered.width,
                  height: rendered.height,
                ),
              )
            : pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  name,
                  style: const pw.TextStyle(fontSize: 9.5),
                ),
              );
      } else {
        nameWidget = pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            name,
            style:
                pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold),
          ),
        );
      }

      final detailsRow = pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            '$qtyStr x $unitPriceStr',
            style: const pw.TextStyle(fontSize: 8.5),
          ),
          pw.Text(
            lineTotalStr,
            style:
                pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
        ],
      );

      // Chosen modifiers (and the kitchen note) print under the item.
      final modifierLabels = SaleLineDisplay.modifierLabels(line);
      final lineNote = SaleLineDisplay.note(line);
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2.0),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            nameWidget,
            for (final label in modifierLabels)
              pw.Padding(
                padding: const pw.EdgeInsets.only(left: 6, top: 0.5),
                child: pw.Text(label, style: const pw.TextStyle(fontSize: 8)),
              ),
            if (lineNote != null && lineNote.isNotEmpty)
              pw.Padding(
                padding: const pw.EdgeInsets.only(left: 6, top: 0.5),
                child: pw.Text(lineNote, style: const pw.TextStyle(fontSize: 8)),
              ),
            pw.SizedBox(height: 1.5),
            detailsRow,
          ],
        ),
      );
    });
    final lineWidgets = await Future.wait(lineFutures);

    pw.Widget? footerWidget;
    if (display.footerText.isNotEmpty) {
      if (ReceiptTextRenderer.hasArabicScript(display.footerText)) {
        final rendered = await ReceiptTextRenderer.renderText(
          display.footerText,
          fontSize: 9.0,
          maxWidth: printableWidth,
          style: urduStyle,
          textAlign: TextAlign.center,
        );
        footerWidget = rendered != null
            ? pw.Center(
                child: pw.Image(
                  rendered.image,
                  width: rendered.width,
                  height: rendered.height,
                ),
              )
            : pw.Center(
                child: pw.Text(display.footerText,
                    style: const pw.TextStyle(fontSize: 8.5)),
              );
      } else {
        footerWidget = pw.Center(
          child: pw.Text(
            display.footerText,
            style: const pw.TextStyle(fontSize: 8),
            textAlign: pw.TextAlign.center,
          ),
        );
      }
    }

    return [
      bizNameWidget,
      if (addressWidget != null) addressWidget,
      if (business?.phone?.isNotEmpty == true)
        pw.Center(
          child: pw.Text('Tel: ${business!.phone}',
              style: const pw.TextStyle(fontSize: 8)),
        ),
      if (business?.taxId?.isNotEmpty == true)
        pw.Center(
          child: pw.Text('NTN: ${business!.taxId}',
              style: const pw.TextStyle(fontSize: 8)),
        ),
      if (customerWidget != null) customerWidget,
      pw.SizedBox(height: 4),
      pw.Center(
        child: pw.Text(dateStr, style: const pw.TextStyle(fontSize: 8)),
      ),
      if (numbers != null && numbers.isNotEmpty)
        pw.Center(
          child: pw.Text(numbers, style: const pw.TextStyle(fontSize: 8)),
        )
      else
        pw.Center(
          child: pw.Text('Sale: ${sale.saleNumber ?? sale.id}',
              style: const pw.TextStyle(fontSize: 8)),
        ),
      pw.Divider(thickness: 0.5),
      ...lineWidgets,
      pw.Divider(thickness: 0.5),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('TOTAL',
              style: pw.TextStyle(
                  fontSize: 11, fontWeight: pw.FontWeight.bold)),
          pw.Text(
            formatPKR(double.tryParse(sale.totalAmount) ?? 0),
            style: pw.TextStyle(
                fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
      if (sale.payments.isNotEmpty) ...[
        pw.SizedBox(height: 4),
        ...sale.payments.map((p) => pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('${p.paymentMethod}:',
                    style: const pw.TextStyle(fontSize: 8)),
                pw.Text(
                  formatPKR(double.tryParse(p.amount) ?? 0),
                  style: const pw.TextStyle(fontSize: 8),
                ),
              ],
            )),
      ],
      if (footerWidget != null) ...[
        pw.Divider(thickness: 0.5),
        footerWidget,
      ],
      pw.SizedBox(height: 4),
      pw.Center(
        child: pw.Text(
          AppBrand.current.receiptPoweredBy,
          style: const pw.TextStyle(fontSize: 7),
          textAlign: pw.TextAlign.center,
        ),
      ),
    ];
  }

  /// Builds a sample receipt to test Urdu font rendering and printer settings using exact-height thermal page.
  static Future<pw.Document> buildTestPdf({
    required String paperSize,
    pw.ThemeData? customTheme,
    String? urduStyle,
  }) async {
    final business = await resolveBusinessProfile();
    final theme = customTheme ?? await loadFonts();
    final doc = pw.Document(theme: theme);
    final rollWidth =
        paperSize == '58mm' ? (57 * PdfPageFormat.mm) : (80 * PdfPageFormat.mm);
    const margin = pw.EdgeInsets.symmetric(horizontal: 8, vertical: 8);
    final printableWidth = rollWidth - margin.horizontal;

    UrduReceiptStyle style = UrduReceiptStyle.fromString(urduStyle);
    if (urduStyle == null && sl.isRegistered<PrinterService>()) {
      try {
        final cfg = await sl<PrinterService>().loadConfig();
        style = UrduReceiptStyle.fromString(cfg.urduStyle);
      } catch (_) {}
    }

    final widgets = await _buildTestWidgets(
      business: business,
      printableWidth: printableWidth,
      urduStyle: style,
    );

    final contentHeight = measureWidgetsHeight(
      widgets: widgets,
      maxWidth: printableWidth,
      theme: theme,
    );
    final exactHeight =
        contentHeight + margin.vertical + (4 * PdfPageFormat.mm);

    if (exactHeight <= maxThermalPageHeight) {
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(rollWidth, exactHeight),
          margin: margin,
          build: (_) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: widgets,
          ),
        ),
      );
    } else {
      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat(rollWidth, maxThermalPageHeight),
          margin: margin,
          build: (_) => widgets,
        ),
      );
    }
    return doc;
  }

  static Future<List<pw.Widget>> _buildTestWidgets({
    required BusinessProfileModel? business,
    required double printableWidth,
    required UrduReceiptStyle urduStyle,
  }) async {
    final bizName = business?.name ?? 'Test Shop 3 / ٹیسٹ پرنٹ';
    pw.Widget headerWidget;
    if (ReceiptTextRenderer.hasArabicScript(bizName)) {
      final rendered = await ReceiptTextRenderer.renderText(
        bizName,
        fontSize: 14,
        isBold: true,
        maxWidth: printableWidth,
        style: urduStyle,
        textAlign: TextAlign.center,
      );
      headerWidget = rendered != null
          ? pw.Center(
              child: pw.Image(
                rendered.image,
                width: rendered.width,
                height: rendered.height,
              ),
            )
          : pw.Center(
              child: pw.Text(
                bizName,
                style: pw.TextStyle(
                    fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
            );
    } else {
      headerWidget = pw.Center(
        child: pw.Text(
          bizName,
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
      );
    }

    final subHeaderRendered = await ReceiptTextRenderer.renderText(
      'تھرمل پرنٹر ٹیسٹ پیج',
      fontSize: 9.5,
      maxWidth: printableWidth,
      style: urduStyle,
      textAlign: TextAlign.center,
    );
    final subHeaderWidget = subHeaderRendered != null
        ? pw.Center(
            child: pw.Image(
              subHeaderRendered.image,
              width: subHeaderRendered.width,
              height: subHeaderRendered.height,
            ),
          )
        : pw.Center(
            child: pw.Text('تھرمل پرنٹر ٹیسٹ پیج',
                style: const pw.TextStyle(fontSize: 9.5)),
          );

    final item1Rendered = await ReceiptTextRenderer.renderText(
      'چاول باسمتی (Rice)',
      fontSize: 9.5,
      isBold: true,
      maxWidth: printableWidth,
      style: urduStyle,
      textAlign: TextAlign.right,
    );
    final item1Name = item1Rendered != null
        ? pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Image(
              item1Rendered.image,
              width: item1Rendered.width,
              height: item1Rendered.height,
            ),
          )
        : pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text('چاول باسمتی (Rice)',
                style: const pw.TextStyle(fontSize: 9.5)),
          );

    final item2Rendered = await ReceiptTextRenderer.renderText(
      'چائے کی پتی (Tea)',
      fontSize: 9.5,
      isBold: true,
      maxWidth: printableWidth,
      style: urduStyle,
      textAlign: TextAlign.right,
    );
    final item2Name = item2Rendered != null
        ? pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Image(
              item2Rendered.image,
              width: item2Rendered.width,
              height: item2Rendered.height,
            ),
          )
        : pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text('چائے کی پتی (Tea)',
                style: const pw.TextStyle(fontSize: 9.5)),
          );

    final footerRendered = await ReceiptTextRenderer.renderText(
      'Thank you! شکریہ',
      fontSize: 9.0,
      maxWidth: printableWidth,
      style: urduStyle,
      textAlign: TextAlign.center,
    );
    final footerWidget = footerRendered != null
        ? pw.Center(
            child: pw.Image(
              footerRendered.image,
              width: footerRendered.width,
              height: footerRendered.height,
            ),
          )
        : pw.Center(
            child: pw.Text('Thank you! شکریہ',
                style: const pw.TextStyle(fontSize: 9.0)),
          );

    return [
      headerWidget,
      subHeaderWidget,
      pw.SizedBox(height: 3),
      pw.Center(
        child: pw.Text(
          DateFormat.yMMMd().add_jm().format(DateTime.now()),
          style: const pw.TextStyle(fontSize: 8),
        ),
      ),
      pw.Divider(thickness: 0.5),
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            item1Name,
            pw.SizedBox(height: 1.5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('1 x Rs. 450.00',
                    style: const pw.TextStyle(fontSize: 8.5)),
                pw.Text('Rs. 450.00',
                    style: pw.TextStyle(
                        fontSize: 9, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            item2Name,
            pw.SizedBox(height: 1.5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('2 x Rs. 450.00',
                    style: const pw.TextStyle(fontSize: 8.5)),
                pw.Text('Rs. 900.00',
                    style: pw.TextStyle(
                        fontSize: 9, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
      pw.Divider(thickness: 0.5),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('TOTAL',
              style: pw.TextStyle(
                  fontSize: 11, fontWeight: pw.FontWeight.bold)),
          pw.Text('Rs. 1,350.00',
              style: pw.TextStyle(
                  fontSize: 11, fontWeight: pw.FontWeight.bold)),
        ],
      ),
      pw.Divider(thickness: 0.5),
      footerWidget,
    ];
  }
}
