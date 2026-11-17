import 'dart:typed_data';

import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/features/receipts/data/receipt_context_loader.dart';
import 'package:frantend/features/receipts/data/receipt_layout_store.dart';
import 'package:frantend/features/receipts/domain/receipt_context.dart';
import 'package:frantend/features/receipts/domain/receipt_layout.dart';
import 'package:frantend/features/receipts/domain/receipt_model.dart';
import 'package:frantend/features/receipts/domain/receipt_model_builder.dart';
import 'package:frantend/features/receipts/domain/receipt_plain_text.dart';
import 'package:frantend/features/receipts/presentation/render/receipt_pdf_renderer.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/presentation/services/receipt_text_renderer.dart';
import 'package:pdf/widgets.dart' as pw;

/// A sale ready to draw: the layout that was chosen, what was loaded around
/// the sale, and the neutral model every renderer consumes.
class PreparedReceipt {
  const PreparedReceipt({
    required this.layout,
    required this.context,
    required this.model,
  });

  final ReceiptLayout layout;
  final ReceiptContext context;
  final ReceiptModel model;
}

/// The one door to receipts: `sale snapshot + layout + channel -> model ->
/// renderer`. Every place a receipt appears (sale complete, auto print,
/// reprint, return, WhatsApp, PDF, printer test) goes through here.
class ReceiptService {
  ReceiptService({
    required ReceiptLayoutStore layouts,
    required ReceiptContextLoader contexts,
    PrinterService? printer,
    this.legacyFooter,
  })  : _layouts = layouts,
        _contexts = contexts,
        _printer = printer;

  /// The footer text from the old "Receipt & Printing" settings. It is only a
  /// fallback: used when the layout has no thank-you text of its own, so
  /// shops that set a footer before layouts existed keep it.
  final Future<String?> Function(String? branchId)? legacyFooter;

  final ReceiptLayoutStore _layouts;
  final ReceiptContextLoader _contexts;
  final PrinterService? _printer;

  ReceiptLayoutStore get layouts => _layouts;

  /// Loads the layout for [channel] (or uses [layout], e.g. while editing),
  /// the receipt context, and builds the model.
  Future<PreparedReceipt> prepare(
    SaleResponseModel sale,
    ReceiptChannel channel, {
    ReceiptLayout? layout,
    ReceiptContext? context,
    bool isReturn = false,
    bool allowNetwork = true,
    DateTime? now,
  }) async {
    var chosen = layout ?? await _layouts.resolve(channel, branchId: sale.branchId);
    if (layout == null) chosen = await _withLegacyFooter(chosen, sale.branchId);
    final ctx = context ??
        await _contexts.load(sale, chosen, isReturn: isReturn, allowNetwork: allowNetwork);
    return PreparedReceipt(
      layout: chosen,
      context: ctx,
      model: ReceiptModelBuilder.build(sale, chosen, channel, context: ctx, now: now),
    );
  }

  Future<ReceiptLayout> _withLegacyFooter(ReceiptLayout layout, String? branchId) async {
    final read = legacyFooter;
    final footer = layout.config.footer;
    if (read == null || footer.textEn.trim().isNotEmpty || footer.textUr.trim().isNotEmpty) {
      return layout;
    }
    try {
      final text = (await read(branchId))?.trim();
      if (text == null || text.isEmpty) return layout;
      return layout.copyWith(config: layout.config.withValue('footer', 'text_en', text));
    } catch (_) {
      return layout;
    }
  }

  Future<UrduReceiptStyle> _urduStyle() async {
    final printer = _printer;
    if (printer == null) return UrduReceiptStyle.nastaliq;
    try {
      return UrduReceiptStyle.fromString((await printer.loadConfig()).urduStyle);
    } catch (_) {
      return UrduReceiptStyle.nastaliq;
    }
  }

  /// The PDF for [receipt] (thermal roll with exact height, or A4).
  Future<pw.Document> renderPdf(
    PreparedReceipt receipt, {
    UrduReceiptStyle? urduStyle,
    pw.ThemeData? theme,
  }) async =>
      ReceiptPdfRenderer.build(
        receipt.model,
        urduStyle: urduStyle ?? await _urduStyle(),
        theme: theme,
      );

  Future<Uint8List> pdfBytes(
    SaleResponseModel sale, {
    ReceiptChannel channel = ReceiptChannel.print,
    ReceiptLayout? layout,
    bool isReturn = false,
    bool allowNetwork = true,
  }) async {
    final prepared = await prepare(
      sale,
      channel,
      layout: layout,
      isReturn: isReturn,
      allowNetwork: allowNetwork,
    );
    return (await renderPdf(prepared)).save();
  }

  /// The WhatsApp / copy text, from the WhatsApp channel's layout.
  Future<String> plainText(
    SaleResponseModel sale, {
    ReceiptChannel channel = ReceiptChannel.whatsapp,
    ReceiptLayout? layout,
    bool allowNetwork = true,
  }) async {
    final prepared =
        await prepare(sale, channel, layout: layout, allowNetwork: allowNetwork);
    return ReceiptPlainText.render(prepared.model);
  }

  /// Sends the receipt to the configured printer. Returns false when the
  /// printer could not take the job.
  Future<bool> print(
    SaleResponseModel sale, {
    ReceiptLayout? layout,
    bool isReturn = false,
    String? jobName,
  }) async {
    final printer = _printer;
    if (printer == null) return false;
    final bytes = await pdfBytes(sale, layout: layout, isReturn: isReturn);
    return printer.printPdf(
      bytes,
      jobName: jobName ?? sale.clientReceiptNo ?? sale.saleNumber ?? 'Receipt',
    );
  }
}
