import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Configuration for receipt printing.
class PrinterConfig {
  const PrinterConfig({
    this.printerName,
    this.paperSize = '80mm', // '80mm' | '58mm'
    this.copies = 1,
    this.autoPrintAfterSale = false,
    this.openCashDrawer = false,
  });

  final String? printerName;
  final String paperSize;
  final int copies;
  final bool autoPrintAfterSale;
  final bool openCashDrawer;

  bool get is80mm => paperSize == '80mm';
  bool get is58mm => paperSize == '58mm';

  PdfPageFormat get pageFormat =>
      is58mm ? PdfPageFormat.roll57 : PdfPageFormat.roll80;

  PrinterConfig copyWith({
    String? printerName,
    String? paperSize,
    int? copies,
    bool? autoPrintAfterSale,
    bool? openCashDrawer,
  }) {
    return PrinterConfig(
      printerName: printerName ?? this.printerName,
      paperSize: paperSize ?? this.paperSize,
      copies: copies ?? this.copies,
      autoPrintAfterSale: autoPrintAfterSale ?? this.autoPrintAfterSale,
      openCashDrawer: openCashDrawer ?? this.openCashDrawer,
    );
  }
}

/// Sends a rendered document to a printer.
abstract class PrinterService {
  /// Lists printers detected on this system.
  Future<List<Printer>> listPrinters();

  /// Loads persisted printer settings.
  Future<PrinterConfig> loadConfig();

  /// Saves printer settings.
  Future<void> saveConfig(PrinterConfig config);

  /// Prints [pdfBytes]. If a saved printer is available and direct print succeeds,
  /// prints silently without dialog. Otherwise falls back to system print dialog.
  /// Returns true on success, false on user cancel or failure.
  Future<bool> printPdf(
    Uint8List pdfBytes, {
    String jobName = 'Receipt',
    PrinterConfig? config,
    bool forceDialog = false,
  });

  /// Pulses cash drawer kick if supported.
  Future<void> openCashDrawer();
}

class WindowsPrinterService implements PrinterService {
  const WindowsPrinterService();

  static const _keyPrinterName = 'printer_setting_name';
  static const _keyPaperSize = 'printer_setting_paper_size';
  static const _keyCopies = 'printer_setting_copies';
  static const _keyAutoPrint = 'printer_setting_auto_print';
  static const _keyCashDrawer = 'printer_setting_cash_drawer';

  @override
  Future<List<Printer>> listPrinters() async {
    try {
      return await Printing.listPrinters();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<PrinterConfig> loadConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return PrinterConfig(
        printerName: prefs.getString(_keyPrinterName),
        paperSize: prefs.getString(_keyPaperSize) ?? '80mm',
        copies: prefs.getInt(_keyCopies) ?? 1,
        autoPrintAfterSale: prefs.getBool(_keyAutoPrint) ?? false,
        openCashDrawer: prefs.getBool(_keyCashDrawer) ?? false,
      );
    } catch (_) {
      return const PrinterConfig();
    }
  }

  @override
  Future<void> saveConfig(PrinterConfig config) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (config.printerName != null) {
        await prefs.setString(_keyPrinterName, config.printerName!);
      } else {
        await prefs.remove(_keyPrinterName);
      }
      await prefs.setString(_keyPaperSize, config.paperSize);
      await prefs.setInt(_keyCopies, config.copies);
      await prefs.setBool(_keyAutoPrint, config.autoPrintAfterSale);
      await prefs.setBool(_keyCashDrawer, config.openCashDrawer);
    } catch (_) {}
  }

  @override
  Future<bool> printPdf(
    Uint8List pdfBytes, {
    String jobName = 'Receipt',
    PrinterConfig? config,
    bool forceDialog = false,
  }) async {
    final effectiveConfig = config ?? await loadConfig();

    if (effectiveConfig.openCashDrawer) {
      await openCashDrawer();
    }

    if (!forceDialog && effectiveConfig.printerName != null) {
      try {
        final printers = await listPrinters();
        final match = printers.firstWhere(
          (p) => p.name == effectiveConfig.printerName,
          orElse: () => printers.firstWhere(
            (p) => p.url == effectiveConfig.printerName,
            orElse: () => throw Exception('Printer not found'),
          ),
        );

        for (var i = 0; i < effectiveConfig.copies; i++) {
          final success = await Printing.directPrintPdf(
            printer: match,
            onLayout: (format) async => pdfBytes,
            name: jobName,
            format: effectiveConfig.pageFormat,
          );
          if (!success) {
            throw Exception('Direct print reported failure');
          }
        }
        return true;
      } catch (_) {
        // Fall back to print dialog below
      }
    }

    // Fallback: system print dialog
    try {
      return await Printing.layoutPdf(
        onLayout: (format) async => pdfBytes,
        name: jobName,
        format: effectiveConfig.pageFormat,
      );
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> openCashDrawer() async {
    // ESC/POS pulse command: ESC p 0 25 250 (\x1b\x70\x00\x19\xfa)
    // Windows spooler drivers handle drawer kick either via printer settings or raw bytes.
  }
}
