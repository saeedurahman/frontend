import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/offline/receipt_branding_source.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/receipts/domain/receipt_context.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/domain/receipt_model_builder.dart';
import 'package:frantend/features/receipts/domain/receipt_samples.dart';
import 'package:frantend/features/receipts/presentation/render/receipt_pdf_renderer.dart';
import 'package:frantend/features/receipts/presentation/render/receipt_pdf_support.dart';
import 'package:frantend/features/receipts/presentation/services/receipt_service.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/presentation/services/receipt_text_renderer.dart';
import 'package:frantend/features/settings/data/models/business_profile_model.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Printing and PDFs of a sale. Everything is drawn by the one receipt
/// pipeline (`ReceiptService`: sale snapshot + layout + channel -> model ->
/// renderer); this class only keeps the entry points the screens already use.
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

  static PdfPageFormat pageFormat(String paperSize, {required bool thermal}) {
    if (!thermal) return PdfPageFormat.a4;
    return paperSize == '58mm' ? PdfPageFormat.roll57 : PdfPageFormat.roll80;
  }

  /// Detects whether text contains Arabic/Urdu unicode characters.
  static bool hasRtl(String? text) => ReceiptPdfSupport.hasRtl(text);

  /// Loads bundled Unicode fonts (Noto Sans and Noto Naskh Arabic for Urdu text).
  static Future<pw.ThemeData> loadFonts() => ReceiptPdfSupport.loadFonts();

  /// Safe maximum single page height for thermal roll printers (1,000 mm).
  static const double maxThermalPageHeight = ReceiptPdfSupport.maxThermalPageHeight;

  static double measureWidgetsHeight({
    required List<pw.Widget> widgets,
    required double maxWidth,
    required pw.ThemeData theme,
  }) =>
      ReceiptPdfSupport.measureWidgetsHeight(
        widgets: widgets,
        maxWidth: maxWidth,
        theme: theme,
      );

  static Future<UrduReceiptStyle> _urduStyle(String? override) async {
    if (override != null) return UrduReceiptStyle.fromString(override);
    if (sl.isRegistered<PrinterService>()) {
      try {
        return UrduReceiptStyle.fromString((await sl<PrinterService>().loadConfig()).urduStyle);
      } catch (_) {}
    }
    return UrduReceiptStyle.nastaliq;
  }

  /// Layout + model for [sale]. With the receipt service registered this is
  /// the business's own layout; without it (unit tests, very early start-up)
  /// the built-in classic receipt with the business details found on the device.
  static Future<PreparedReceipt> prepare(
    SaleResponseModel sale, {
    ReceiptChannel channel = ReceiptChannel.print,
    ReceiptLayout? layout,
    ReceiptDisplaySettings? displaySettings,
    bool isReturn = false,
  }) async {
    if (sl.isRegistered<ReceiptService>()) {
      return sl<ReceiptService>().prepare(sale, channel, layout: layout, isReturn: isReturn);
    }
    final display = displaySettings ?? await resolveDisplaySettings(branchId: sale.branchId);
    final chosen = layout ??
        ReceiptLayout.builtIn(
          footerText: display.footerText,
          paper: display.paperSize == '58mm' ? ReceiptPaper.roll58 : ReceiptPaper.roll80,
        );
    final business = await resolveBusinessProfile();
    String? register;
    String? official;
    var synced = !sale.offline;
    try {
      if (sl.isRegistered<SyncStore>() && sale.id.isNotEmpty) {
        final row = await sl<SyncStore>().sale(sale.id);
        if (row != null) {
          register = row['receipt_no'] as String?;
          official = row['official_number'] as String?;
          synced = row['sync_state'] == 'synced';
        }
      }
    } catch (_) {}
    final context = ReceiptContext(
      business: ReceiptBusiness(
        name: business?.name,
        address: business?.addressLine1,
        phone: business?.phone,
        taxId: business?.taxId,
      ),
      registerNumber: register ?? sale.clientReceiptNo,
      officialNumber: official,
      synced: synced,
      isReturn: isReturn,
    );
    return PreparedReceipt(
      layout: chosen,
      context: context,
      model: ReceiptModelBuilder.build(sale, chosen, channel, context: context),
    );
  }

  /// The printable PDF of [sale]: exact-height roll for thermal layouts, A4
  /// pages for the invoice designs. [thermal] false asks for an A4 page (the
  /// business layout is used when it is already an A4 design, otherwise the
  /// tax-invoice design).
  static Future<pw.Document> buildPdf(
    SaleResponseModel sale, {
    required bool thermal,
    ReceiptDisplaySettings? displaySettings,
    pw.ThemeData? customTheme,
    String? urduStyle,
    ReceiptLayout? layout,
    bool isReturn = false,
  }) async {
    var prepared = await prepare(
      sale,
      layout: layout,
      displaySettings: displaySettings,
      isReturn: isReturn,
    );
    if (layout == null && !thermal && prepared.layout.design.isThermal) {
      final a4 = ReceiptLayout(
        id: 'a4-fallback',
        name: 'Tax invoice',
        design: ReceiptDesign.a4TaxInvoice,
        paper: ReceiptPaper.a4,
        config: ReceiptLayoutConfig.defaultsFor(ReceiptDesign.a4TaxInvoice),
      );
      prepared = await prepare(sale, layout: a4, displaySettings: displaySettings, isReturn: isReturn);
    }
    return ReceiptPdfRenderer.build(
      prepared.model,
      urduStyle: await _urduStyle(urduStyle),
      theme: customTheme,
    );
  }

  /// A sample receipt (Urdu names, tax, batch) for the printer settings page.
  static Future<pw.Document> buildTestPdf({
    String? paperSize,
    pw.ThemeData? customTheme,
    String? urduStyle,
  }) async {
    final business = await resolveBusinessProfile();
    final base = ReceiptSamples.context();
    final context = ReceiptContext(
      business: ReceiptBusiness(
        name: business?.name ?? base.business.name,
        address: business?.addressLine1 ?? base.business.address,
        phone: business?.phone ?? base.business.phone,
        taxId: business?.taxId ?? base.business.taxId,
      ),
      registerNumber: base.registerNumber,
      officialNumber: base.officialNumber,
      synced: false,
      cashierName: base.cashierName,
      products: base.products,
    );
    // The default print layout decides paper, language and wording; a paper
    // size is only used for the built-in fallback.
    var layout = ReceiptLayout.builtIn(
      paper: paperSize == '58mm' ? ReceiptPaper.roll58 : ReceiptPaper.roll80,
    );
    if (sl.isRegistered<ReceiptService>()) {
      layout = await sl<ReceiptService>().layouts.resolve(ReceiptChannel.print);
    }
    final model = ReceiptModelBuilder.build(
      ReceiptSamples.sale(synced: false),
      layout,
      ReceiptChannel.print,
      context: context,
    );
    return ReceiptPdfRenderer.build(
      model,
      urduStyle: await _urduStyle(urduStyle),
      theme: customTheme,
    );
  }

  /// Prints the receipt; shows a retry snack bar when the printer fails.
  static Future<bool> printReceipt(
    SaleResponseModel sale, {
    BuildContext? context,
    bool isReturn = false,
  }) async {
    final doc = await buildPdf(sale, thermal: true, isReturn: isReturn);
    final bytes = await doc.save();
    final printer = sl<PrinterService>();
    final success = await printer.printPdf(
      bytes,
      jobName: sale.clientReceiptNo ?? sale.saleNumber ?? 'Receipt',
    );

    if (!success && context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not print receipt. Please check printer connection.'),
          action: SnackBarAction(
            label: 'Print again',
            onPressed: () => printReceipt(sale, context: context, isReturn: isReturn),
          ),
        ),
      );
    }
    return success;
  }

  /// Saves the receipt PDF (drawn by the same pipeline) to a file.
  static Future<File?> downloadPdf(
    BuildContext context,
    SaleResponseModel sale, {
    bool isReturn = false,
  }) async {
    final doc = await buildPdf(sale, thermal: true, isReturn: isReturn);
    final bytes = await doc.save();
    final path = await sl<FileSaverService>().saveBytes(
      'receipt_${sale.clientReceiptNo ?? sale.saleNumber ?? sale.id}.pdf',
      bytes,
    );
    return File(path);
  }
}
