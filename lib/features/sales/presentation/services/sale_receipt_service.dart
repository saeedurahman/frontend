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
import 'package:frantend/features/sales/presentation/utils/sale_calculations.dart';
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

  /// Builds printable PDF using pw.MultiPage with roll80/roll57 so long receipts never truncate.
  static Future<pw.Document> buildPdf(
    SaleResponseModel sale, {
    required bool thermal,
    ReceiptDisplaySettings? displaySettings,
    pw.ThemeData? customTheme,
  }) async {
    final display =
        displaySettings ?? await resolveDisplaySettings(branchId: sale.branchId);
    final business = await resolveBusinessProfile();
    final numbers = await numbersLine(sale.id);
    final theme = customTheme ?? await loadFonts();
    final doc = pw.Document(theme: theme);
    final rawFormat = pageFormat(display.paperSize, thermal: thermal);
    final format = rawFormat.height.isInfinite
        ? rawFormat.copyWith(height: 297 * PdfPageFormat.mm)
        : rawFormat;
    final date =
        sale.soldAt ?? sale.createdAt ?? DateTime.now().toIso8601String();
    DateTime? parsedDate;
    try {
      parsedDate = DateTime.parse(date);
    } catch (_) {}
    final dateStr = parsedDate != null
        ? DateFormat.yMMMd().add_jm().format(parsedDate)
        : date;

    doc.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        build: (context) {
          final bizName = business?.name ?? AppBrand.current.appName;
          final bizRtl = hasRtl(bizName);

          return [
            pw.Center(
              child: pw.Text(
                bizName,
                textDirection:
                    bizRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
            ),
            if (business?.addressLine1?.isNotEmpty == true)
              pw.Center(
                child: pw.Text(
                  business!.addressLine1!,
                  textDirection: hasRtl(business.addressLine1)
                      ? pw.TextDirection.rtl
                      : pw.TextDirection.ltr,
                  style: const pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.center,
                ),
              ),
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
            ...sale.lines.map((line) {
              final name = line.productName ?? 'Item';
              final isUrdu = hasRtl(name);
              final qtyStr = line.qty;
              final priceStr =
                  formatPKR(SaleCalculations.lineTotal(line).toDouble());

              return pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 2),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        '$name x $qtyStr',
                        textDirection: isUrdu
                            ? pw.TextDirection.rtl
                            : pw.TextDirection.ltr,
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                    ),
                    pw.SizedBox(width: 4),
                    pw.Text(priceStr, style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
              );
            }),
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
            if (display.footerText.isNotEmpty) ...[
              pw.Divider(thickness: 0.5),
              pw.Center(
                child: pw.Text(
                  display.footerText,
                  textDirection: hasRtl(display.footerText)
                      ? pw.TextDirection.rtl
                      : pw.TextDirection.ltr,
                  style: const pw.TextStyle(fontSize: 8),
                  textAlign: pw.TextAlign.center,
                ),
              ),
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
        },
      ),
    );
    return doc;
  }

  /// Builds a sample receipt to test Urdu font rendering and printer settings.
  static Future<pw.Document> buildTestPdf({
    required String paperSize,
    pw.ThemeData? customTheme,
  }) async {
    final business = await resolveBusinessProfile();
    final theme = customTheme ?? await loadFonts();
    final doc = pw.Document(theme: theme);
    final format =
        paperSize == '58mm' ? PdfPageFormat.roll57 : PdfPageFormat.roll80;

    doc.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        build: (context) => [
          pw.Center(
            child: pw.Text(
              business?.name ?? 'Test Receipt / ٹیسٹ پرنٹ',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Center(
            child: pw.Text(
              'تھرمل پرنٹر ٹیسٹ پیج',
              textDirection: pw.TextDirection.rtl,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Center(
            child: pw.Text(
              DateFormat.yMMMd().add_jm().format(DateTime.now()),
              style: const pw.TextStyle(fontSize: 8),
            ),
          ),
          pw.Divider(thickness: 0.5),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 2),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  child: pw.Text(
                    'چاول باسمتی (Rice) x 1',
                    textDirection: pw.TextDirection.rtl,
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ),
                pw.Text('Rs. 450.00', style: const pw.TextStyle(fontSize: 9)),
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 2),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  child: pw.Text(
                    'چائے کی پتی (Tea) x 2',
                    textDirection: pw.TextDirection.rtl,
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ),
                pw.Text('Rs. 900.00', style: const pw.TextStyle(fontSize: 9)),
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
          pw.Center(
            child: pw.Text(
              'Thank you! شکریہ',
              textDirection: pw.TextDirection.rtl,
              style: const pw.TextStyle(fontSize: 8),
            ),
          ),
        ],
      ),
    );
    return doc;
  }
}
